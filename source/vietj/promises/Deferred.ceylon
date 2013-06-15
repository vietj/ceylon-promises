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

shared class Deferred<Value, Progress = Anything>() satisfies Transitionnable<Value> & Promised<Value> {
  
  abstract class State() of PromiseState | PendingState {
  }
  
  class PromiseState(shared Promise<Value> promise) extends State() {
  }

  abstract class PendingState() of InitialState | ListenerState | ProgressState extends State() {
	shared formal void update(Promise<Value> promise);
	shared formal void notifyWith(Promise<Progress> progress);
	shared formal void notifyTo(Anything(Progress) onProgress);
  }

  class InitialState() extends PendingState() {
	shared actual void update(Promise<Value> promise) { }
	shared actual void notifyWith(Promise<Progress> progress) { }
	shared actual void notifyTo(Anything(Progress) onProgress) { }
  }
  
  object initialState extends InitialState() {}

  class ListenerState(
    Anything(Value) onFulfilled,
    Anything(Exception) onRejected,
    Anything(Progress) onProgress,
    PendingState previous) extends PendingState() {
	shared actual void update(Promise<Value> promise) {
      previous.update(promise);
	  promise.then_(onFulfilled, onRejected);
	}
	shared actual void notifyWith(Promise<Progress> progress) {
	  progress.then_(onProgress);
	  previous.notifyWith(progress);
	}
	shared actual void notifyTo(Anything(Progress) onProgress) {
	  previous.notifyTo(onProgress);
	}
  }
  
  class ProgressState(shared Promise<Progress> progress, PendingState previous) extends PendingState() {
	shared actual void update(Promise<Value> promise) {
	  previous.update(promise);
	}
	shared actual void notifyWith(Promise<Progress> progress) {
	  previous.notifyWith(progress);
	}
	shared actual void notifyTo(Anything(Progress) onProgress) {
	  progress.then_(onProgress);
	  previous.notifyTo(onProgress);
	}
  }

  doc "The current state"
  AtomicReference<State> state = AtomicReference<State>(initialState);
  
  doc "The promise of this deferred."
  shared actual object promise extends Promise<Value, Progress>() {

    shared actual Promise<Result> then__<Result>(
      <Promise<Result>(Value)> onFulfilled, 
      <Promise<Result>(Exception)> onRejected) {
	  Promise<Anything> foo(Anything a) { return adaptValue(a); }
	  Promise<Result> a = then____<Result, Anything>(onFulfilled, onRejected, foo);
      return a;
    }

    shared actual Promise<ResultValue, ResultProgress> then____<ResultValue, ResultProgress>(
      <Callable<Promise<ResultValue>, [Value]>> onFulfilled,
      Promise<ResultValue>(Exception) onRejected,
      Promise<ResultProgress>(Progress) onProgress) {

      Deferred<ResultValue, ResultProgress> deferred = Deferred<ResultValue, ResultProgress>();
      void callback<T>(<Promise<ResultValue>(T)> on, T val) {
        try {
          Promise<ResultValue> result = on(val);
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
	    State current = state.get();
	    switch (current)
        case (is PromiseState) {
	      current.promise.then_(onFulfilledCallback, onRejectedCallback);
	      break;
	    }
	    case (is PendingState) {
	      State next = ListenerState(onFulfilledCallback, onRejectedCallback, onProgress, current);
	      if (state.compareAndSet(current, next)) {
	        current.notifyTo(onProgress);
            break;
	      }
	    }
      }
      
      //
      return deferred.promise;
    }
  }

  void update(Promise<Value> promise) {
    while (true) {
	  State current = state.get();    
	  switch (current) 
	  case (is PromiseState) {
	    break;
	  }
	  case (is PendingState) {
        PromiseState next = PromiseState(promise);	
        if (state.compareAndSet(current, next)) {
          current.update(promise);
          break;  	
        }
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
  
  shared void progress(Progress|Promise<Progress> progress) {
    Promise<Progress> adapted = adaptValue(progress);
    while (true) {
	  State current = state.get();    
	  switch (current) 
	  case (is PromiseState) {
	    break;
	  }
	  case (is PendingState) {
        ProgressState next = ProgressState(adapted, current);	
        if (state.compareAndSet(current, next)) {
          current.notifyWith(adapted);
          break;  	
        }
	  }
	}
  }
}