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

doc "A term allows a [[Thenable]] to be combined with a promise to form a new term."
by "Julien Viet"
license "ASL2"
shared interface Term<Element, T>
  satisfies Thenable<T>
  given T satisfies Element[] {
	
  doc "Combine the current thenable with a provided promise and return an [[Term]] object that
        - resolves when both the current thenable and the other promise are resolved
        - rejects when the current thenable or the other promise is rejected
        
        The [[Term] promise will be
        - resolved with a tuple of values of the original promises. It is important to notice that
          tuple elements are in reverse order of the and chain
        - rejected with the reason of the rejected promise
        
        The returned [[Term]] object allows for promise chaining as a fluent API:
            Promise<String> p1 = ...
            Promise<Integer> p2 = ...
            Promise<Boolean> p3 = ...
            p1.and(p2, p3).then_((Boolean b, Integer i, String s) => doSomething(b, i, s));
        "
  shared formal Term<Element|Other, Tuple<Element|Other, Other, T>> and<Other>(Promise<Other> other);

}