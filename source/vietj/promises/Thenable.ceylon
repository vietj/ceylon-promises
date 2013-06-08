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

doc "Thenable provides the base support for promises. This interface satisfies the [[Promised]] interface, to be used
     when a promise is needed instead of a thenable"
by "Julien Viet"
license "ASL2"
shared interface Thenable<out Value> satisfies Promised<Value> given Value satisfies Anything[] {
	
  M rethrow<M>(Exception e) {
    throw e;
  }

  Promise<M> rethrow2<M>(Exception e) {
    Deferred<M> deferred = Deferred<M>();
    deferred.reject(e);
    return deferred.promise;
  }

    doc "The then method from the Promise/A+ specification."
  shared Promise<Result> then_<Result>(
      <Callable<<Result>,Value>|Callable<<Result>, []>> onFulfilled,
      <Result(Exception)|Result()> onRejected = rethrow<Result>) {
	return then___(onFulfilled, onRejected);
  }

  doc "The then method from the Promise/A+ specification."
  shared Promise<Result> then__<Result>(
      <Callable<Promise<Result>, Value>|Callable<Promise<Result>, []>> onFulfilled,
      <Promise<Result>(Exception)|Promise<Result>()> onRejected = rethrow2<Result>) {
	return then___<Result>(onFulfilled, onRejected);
  }

  doc "The then method from the Promise/A+ specification."
  shared formal Promise<Result> then___<Result>(
      <Callable<<Result|Promise<Result>>, Value>|Callable<<Result|Promise<Result>>, []>> onFulfilled,
      <<Result|Promise<Result>>(Exception)|<Result|Promise<Result>>()> onRejected = rethrow<Result>);

  doc "Analog to Q finally (except that it does not consider the callback might return a promise"
  shared void always(Callable<Anything, Value|[Exception]>|Callable<Anything, []> callback) {
	if (is Callable<Anything, Value|[Exception]> callback) {
	  then_(callback, callback);
	} else if (is Callable<Anything, []> callback) {
	  then_(callback, callback);
	}
  }
}