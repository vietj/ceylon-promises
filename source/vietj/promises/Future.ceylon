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

import java.util.concurrent { CountDownLatch, TimeUnit { seconds = \iMILLISECONDS } }
import java.util.concurrent.atomic { AtomicReference }

doc "A future value."
by "Julien Viet"
license "ASL2"
shared interface Future<out Value> {
	
  doc "Returns the value if it is present otherwise it returns null. This call
       does not block."
  shared formal <Value|Exception>? peek();

  doc "Block until the value is available or until a timeout occurs. When the times out occuts 
       a timeout exception is thrown."
  shared formal Value|Exception get(doc "The timeout in milliseconds" Integer timeOut = 20000);
}

class FutureImpl<out Value>(Thenable<Value> thenable)
  satisfies Future<Value>
  given Value satisfies Anything[] {

  CountDownLatch latch = CountDownLatch(1);
  AtomicReference<Value|Exception> ref = AtomicReference<Value|Exception>();

  void reportReason(Exception e) {
  	ref.set(e);
    latch.countDown(); 
  }
  
  void reportValue(Value t) {
  	ref.set(t);
    latch.countDown();
  }
  
  thenable.then_(flatten(reportValue), reportReason);

  shared actual <Value|Exception>? peek() {
	return ref.get();
  }

  shared actual Value|Exception get(doc "The timeout in milliseconds" Integer timeOut) {
    if (latch.await(timeOut, seconds)) {
      return ref.get();
    } else {
      throw Exception("Timed out waiting for :" + thenable.string);
    }
  }
}