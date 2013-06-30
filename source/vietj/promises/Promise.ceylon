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
 
doc "A promise represents a value that may not be available yet. The primary method for
      interacting with a promise is its `then` method. A promise is a [[Thenable]] element
     restricted to a single value."
by "Julien Viet"
license "ASL2"
shared abstract class Promise<out Value>() satisfies Term<Value, [Value]> {

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
  
  shared actual Promise<[Value]> promise {
    return conj().promise;
  }

  doc "Create and return a future for this promise. The future allows to follow the resolution of the
       promise in a *blocking* fashion:
       
       - if this promise is fulfilled then the future will return the value
       - if this promise is rejected then the future will return the reason
       
       This class should be used when a thread needs to block until this promise is resolved only, i.e
       it defeats the purpose of the promise programming model."
  shared Future<Value> future {
	object f satisfies Future<Value> {
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
      outer.then_(reportValue, reportReason);
      shared actual <Value|Exception>? peek() => ref.get();
      shared actual Value|Exception get(Integer timeOut) {
        if (timeOut < 0) {
          latch.await();
        } else {
          if (!latch.await(timeOut, seconds)) {
            throw Exception("Timed out waiting for :" + outer.string);
          }
        }
        return ref.get();
      }
	}
  	return f;
  }
}
