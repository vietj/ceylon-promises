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
doc "A promise represents a value that may not be available yet. The primary method for
      interacting with a promise is its `then` method. A promise is a [[Thenable]] element
     restricted to a single value."
by "Julien Viet"
license "ASL2"
shared abstract class Promise<out Value, out Progress = Anything>() satisfies Term<Value, [Value]> {

  // todo optimize that and instead implement a Promise
  variable Conjonction<Value, Value, []>? c = null;
  
  Conjonction<Value, Value, []> conj() {
  	if (exists tmp = c) {
  		return tmp;
  	} else {
        value d = Deferred<[]>();
        d.resolve([]);
        return c = Conjonction<Value, Value, []>(this, d.promise);
  	}
  }

  shared actual Term<Value|Other, Tuple<Value|Other, Other, [Value]>> and<Other>(Promise<Other> other) {
    return conj().and(other);
  }
  
  shared Promise<ResultValue, ResultProgress> then___<ResultValue, ResultProgress>(
      <Callable<ResultValue, [Value]>> onFulfilled,
      ResultValue(Exception) onRejected,
      ResultProgress(Progress) onProgress) {
	<Callable<Promise<ResultValue>, [Value]>> onFulfilled2 = adaptResult<ResultValue, [Value]>(onFulfilled);
	Promise<ResultValue>(Exception) onRejected2 = adaptResult<ResultValue, [Exception]>(onRejected);
	Promise<ResultProgress>(Progress) onProgress2 = adaptResult<ResultProgress, [Progress]>(onProgress);
	return then____(onFulfilled2, onRejected2, onProgress2);
  }

  shared formal Promise<ResultValue, ResultProgress> then____<ResultValue, ResultProgress>(
      <Callable<Promise<ResultValue>, [Value]>> onFulfilled,
      Promise<ResultValue>(Exception) onRejected,
      Promise<ResultProgress>(Progress) onProgress);

  shared actual Promise<[Value]> promise {
    return conj().promise;
  }
}
