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

import java.util.concurrent.locks { ReentrantLock }

doc "The deferred class is the primary implementation of the [[Promise]] interface.
      
      The promise is accessible using the `promise` attribute of the deferred.
      
      The deferred can either be resolved or rejected via the `resolve` or `reject` methods. Both
      methods accept an argument or a promise to the argument, allowing the deferred to react
      on a promise."
by "Julien Viet"
license "ASL2"
shared class Deferred<Value>() satisfies Transitionnable<Value> & Promised<Value> {

  ReentrantLock lock = ReentrantLock();
  variable Promise<Value>? state = null;
  variable Status current = pending;
  variable [Anything(Value),Anything(Exception)][] listeners = {};
  
  listeners = listeners.withTrailing([(Value v) => current = fulfilled, (Exception e) => current = rejected]);

  doc "Return the current deferred status."
  shared Status status => current;

  doc "Return true if the current promise is fulfilled."
  shared Boolean isFulfilled => status == fulfilled;

  doc "Return true if the current promise is rejected."
  shared Boolean isRejected => status == rejected;

  doc "Return true if the current promise is fulfilled."
  shared Boolean isPending => status == pending;

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

      // Update under lock
      Promise<Value> p;
      lock.lock();
      try {
        if (exists tmp = state) {
          p = tmp;
        } else {
          listeners = listeners.withTrailing([onFulfilledCallback, onRejectedCallback]);
          return deferred.promise;
        }
      } finally {
        lock.unlock();
      }
      p.then_(onFulfilledCallback, onRejectedCallback);
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

  void set(Promise<Value> state) {
    // Update under lock
	lock.lock();
	try {
      if (exists tmp = this.state) {
        return;
      } else {
        this.state = state;
      }
	} finally {
	  lock.unlock();
	}
    for (listener in listeners) {
      state.then_(listener[0], listener[1]);
    }
  }

  shared actual void resolve(Value|Promise<Value> val) {
    Promise<Value> adapted = adaptValue(val);
    set(adapted);
  }

  shared actual void reject(Exception reason) {
    Promise<Value> adapted = adaptReason<Value>(reason);
    set(adapted);
  }
}