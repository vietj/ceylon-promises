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

"A future value."
by("Julien Viet")
shared interface Future<out Value> {

	"Returns the value if it is present otherwise it returns null.
	 This call does not block."
	shared formal <Value|Exception>? peek();

	"Block until:
       - the value is available
       - the thread is interrupted
       - an optional timeout occurs
     When the timeout occurs an exception is thrown."
	shared formal Value|Exception get(
		doc("The timeout in milliseconds, a negative value means no timeout")
		Integer timeOut = -1);

}
