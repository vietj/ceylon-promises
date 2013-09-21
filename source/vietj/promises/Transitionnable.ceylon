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

"Something that can through a transition and is meant to be be resolved or rejected"
by("Julien Viet")
shared interface Transitionnable<in Value> {

    "Resolves the promise with a value or a promise to the value."
    shared formal void resolve(<Value|Promise<Value>> val);
    
    "Rejects the promise with a reason."
    shared formal void reject(Exception reason);

}