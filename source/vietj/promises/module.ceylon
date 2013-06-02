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
doc "A module that provides Promises/A+ semantics adapted to the Ceylon language.

      This implementation conforms to the [Promises/A+](https://github.com/promises-aplus/promises-tests) specification although
      it is not a formal implementation due to the adaptation to the Ceylon language and type system. However it attempts
      to respect the meaning of the specification and the same terminology.

      The modules provides:

      - the [[Promise]] interface conforming to the specification.
      - a [[Deferred]] type as implementation of the [[Promise]] interface.
      - the [[Status]] enumerated instance with the  [[pending]], [[fulfilled]] and [[rejected]] instances.
      - the [[And]] conjonction for combining promises into a conjonctive promise.

      Differences with the original specification:

      - the *then must return before onFulfilled or onRejected is called* is not implemented, therefore the invocation
      occurs inside the invocation of then.
      - the *Promise Resolution Procedure* is implemented for objects or promises but not for *thenable* as it requires
      a language with dynamic typing."
by "Julien Viet"
license "ASL2"
module vietj.promises '0.2.0' {
}
