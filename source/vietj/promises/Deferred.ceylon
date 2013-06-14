/*
 * Copyright 2013 Julien Viet
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import java.util.concurrent.atomic { AtomicReference }

doc "The deferred class is the primary implementation of the [[Promise]] interface.
      
     The promise is accessible using the `promise` attribute of the deferred.
      
     The deferred can either be resolved or rejected via the `resolve` or `reject` methods. Both
     methods accept an argument or a promise to the argument, allowing the deferred to react
     on a promise."
by "Julien Viet"
license "ASL2"

shared class Deferred<Value>() satisfies Transitionnable<Value> & Promised<Value> {
  
  abstract class State() of ListenerState | PromiseState {
  }

  class ListenerState(Anything(Value) onFulfilled, Anything(Exception) onRejected, ListenerState? previous = null) extends State() {
	shared void update(Promise<Value> promise) {
	  if (exists previous) {
	  	previous.update(promise);
	  }
	  promise.then_(onFulfilled, onRejected);
	}
  }
   
  class PromiseState(shared Promise<Value> promise) extends State() {
  }

  doc "The current state"
  AtomicReference<State?> state = AtomicReference<State?>(null);
  
  doc "The promise of this deferred."
  shared actual object promise extends Promise<Value>() {

    shared actual Promise<Result> then___<Result>(
      <<Result|Promise<Result>>(Value)|<Result|Promise<Result>>()> onFulfilled, 
      <<Result|Promise<Result>>(Exception)|<Result|Promise<Result>>()> onRejected) {

      Deferred<Result> deferred = Deferred<Result>();
      void callback<T>(<<Result|Promise<Result>>(T)|<Result|Promise<Result>>()> on, T val) {
        try {
          Result|Promise<Result> result = dispatch(on, val);
          deferred.resolve(result);
        } catch(Exception e) {
          deferred.reject(e);
        }
      }

      void onFulfilledCallback(Value val) {
        callback(onFulfilled, val);
      }
      void onRejectedCallback(Exception reason) {
        callback(onRejected, reason);
      }

      // 
      while (true) {
	    State? current = state.get();
	    switch (current)
	      case (is Null) {
	        State next = ListenerState(onFulfilledCallback, onRejectedCallback);
	        if (state.compareAndSet(current, next)) {
	          break;
	        }
	      }
	      case (is ListenerState) {
	        State next = ListenerState(onFulfilledCallback, onRejectedCallback, current);
	        if (state.compareAndSet(current, next)) {
	          break;
	        }
	      }
	      case (is PromiseState) {
	        current.promise.then_(onFulfilledCallback, onRejectedCallback);
	        break;
	      }
      }
      return deferred.promise;
    }
  }

  Promise<T> adaptValue<T>(T|Promise<T> val) {
    if (is T val) {
      object adapter extends Promise<T>() {
        shared actual Promise<Result> then___<Result>(
          <<Result|Promise<Result>>(T)|<Result|Promise<Result>>()> onFulfilled,
          <<Result|Promise<Result>>(Exception)|<Result|Promise<Result>>()> onRejected) {
          try {
            Result|Promise<Result> result = dispatch(onFulfilled, val);
            return adaptValue(result);
          } catch(Exception e) {
            return adaptReason<Result>(e);
          }
        }
      }
      return adapter;
    } else if (is Promise<T> val) {
      return val;
    } else {
      throw Exception("not possible");
    }
  }

  Promise<T> adaptReason<T>(Exception reason) {
    object adapted extends Promise<T>() {
      shared actual Promise<Result> then___<Result>(
        <<Result|Promise<Result>>(T)|<Result|Promise<Result>>()> onFulfilled,
        <<Result|Promise<Result>>(Exception)|<Result|Promise<Result>>()> onRejected) {
        try {
          <Result|Promise<Result>> result = dispatch(onRejected, reason);
          return adaptValue<Result>(result);
        } catch(Exception e) {
          return adaptReason<Result>(e);
        }
      }
    }
    return adapted;
  }

  void update(Promise<Value> promise) {
    while (true) {
	  State? current = state.get();    
	  switch (current) 
	    case (is Null) {
          PromiseState next = PromiseState(promise);	
          if (state.compareAndSet(current, next)) {
            break;  	
          }
	    }
	    case (is ListenerState) {
          PromiseState next = PromiseState(promise);	
          if (state.compareAndSet(current, next)) {
            current.update(promise);
            break;  	
          }
	    }
	    case (is PromiseState) {
	      break;
	    }
    }
  }

  shared actual void resolve(Value|Promise<Value> val) {
    Promise<Value> adapted = adaptValue(val);
    update(adapted);
  }

  shared actual void reject(Exception reason) {
    Promise<Value> adapted = adaptReason<Value>(reason);
    update(adapted);
  }
}