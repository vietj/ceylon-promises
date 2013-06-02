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

doc "Thenable provides the base support for promises."
by "Julien Viet"
license "ASL2"
shared interface Thenable<Value> given Value satisfies Anything[] {
	
  M rethrow<M>(Exception e) {
    throw e;
  }

  doc "The then method from the Promise/A+ specification."
  shared formal Promise<Result> then_<Result>(
      Callable<<Result|Promise<Result>>, Value> onFulfilled,
      <Result|Promise<Result>>(Exception) onRejected = rethrow<Result>);

  doc "Returns a promise for this thenable, this should be used when a promise is needed instead
       of a thenable."
  shared formal Promise<Value> promise;
	
}