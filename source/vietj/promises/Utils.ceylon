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
 
doc "Adapt a Callable<Result, Value> to Callable<Promise<Result>, Value>"
Callable<Promise<Result>, Value> adaptResult<Result, Value>(Callable<Result, Value> a) given Value satisfies Anything[] {
  Result(Value) b = unflatten(a);
  Promise<Result> c(Value d) {
    Result r = b(d);
    Deferred<Result> deferred = Deferred<Result>();
    deferred.resolve(r);
    return deferred.promise;	
  }
  return flatten(c);
}

Promise<T> adaptValue<T>(T|Promise<T> val) {
  if (is T val) {
    object adapter extends Promise<T>() {
      shared actual Promise<Result> then__<Result>(
        <Promise<Result>(T)> onFulfilled,
        <Promise<Result>(Exception)> onRejected) {
        try {
          return onFulfilled(val);
        } catch(Exception e) {
          return adaptReason<Result>(e);
        }
      }
      shared actual Promise<ResultValue, ResultProgress> then____<ResultValue, ResultProgress>(
        <Callable<Promise<ResultValue>, [T]>> onFulfilled,
        Promise<ResultValue>(Exception) onRejected,
        Promise<ResultProgress>(Anything) onProgress) {
	    throw Exception();
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
    shared actual Promise<Result> then__<Result>(
      <Promise<Result>(T)> onFulfilled,
      <Promise<Result>(Exception)> onRejected) {
      try {
        return onRejected(reason);
      } catch(Exception e) {
        return adaptReason<Result>(e);
      }
    }
    shared actual Promise<ResultValue, ResultProgress> then____<ResultValue, ResultProgress>(
      <Callable<Promise<ResultValue>, [T]>> onFulfilled,
      Promise<ResultValue>(Exception) onRejected,
      Promise<ResultProgress>(Anything) onProgress) {
	  throw Exception();
    }
  }
  return adapted;
}

M rethrow<M>(Exception e) {
  throw e;
}

Promise<M> rethrow2<M>(Exception e) {
  Deferred<M> deferred = Deferred<M>();
  deferred.reject(e);
  return deferred.promise;
}


