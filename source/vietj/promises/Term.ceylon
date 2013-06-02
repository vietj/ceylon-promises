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
  satisfies Thenable<Element, T>
  given T satisfies Element[] {
	
  shared formal Term<Element|Other, Tuple<Element|Other, Other, T>> and<Other>(Promise<Other> other);

}