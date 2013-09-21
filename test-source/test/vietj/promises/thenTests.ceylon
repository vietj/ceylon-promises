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
import vietj.promises { ... }
import ceylon.test { ... }
import ceylon.collection { ... }

class Thrower<T>() {
    shared LinkedList<Exception> thrown = LinkedList<Exception>();
    shared String m(T t) {
        Exception e = Exception();
        thrown.add(e);
        throw e;
    }
}

"Test the then method but not the Promise Resolution Procedure"
shared void thenTests() {
    
    testAllRespectiveFulfilledCallbacksMustExecuteInTheOrderOfTheirOriginatingCallsToThen();
    testAllRespectiveRejectedCallbacksMustExecuteInTheOrderOfTheirOriginatingCallsToThen();
    testReturnedPromiseMustBeRejectWithSameReasonWhenOnFulfilledThrowsAnException();
    testReturnedPromiseMustBeRejectWithSameReasonWhenOnRejectedThrowsAnException();
    //testReturnedPromiseMustBeFulfilledWithSameValueWhenOnFulfilledIsNotAFunction();
    testReturnedPromiseMustBeRejectedWithSameValueWhenOnRejectedIsNotAFunction();
    
}

void testAllRespectiveFulfilledCallbacksMustExecuteInTheOrderOfTheirOriginatingCallsToThen() {
    value calls = LinkedList<Integer>();
    value d = Deferred<String>();	
    Promise<String> promise = d.promise;
    promise.then_((String s) => calls.add(1));
    promise.then_((String s) => calls.add(2));
    d.resolve("");
    
    assertEquals { expected = {1,2}; actual = calls; };
}

void testAllRespectiveRejectedCallbacksMustExecuteInTheOrderOfTheirOriginatingCallsToThen() {
    value calls = LinkedList<Integer>();
    value d = Deferred<String>();	
    Promise<String> promise = d.promise;
    promise.then_((String s) => print(s),(Exception e) => calls.add(1));
    promise.then_((String s) => print(s),(Exception e) => calls.add(2));
    d.reject(Exception());
    
    assertEquals { expected = {1,2}; actual = calls; };
}

void testReturnedPromiseMustBeRejectWithSameReasonWhenOnFulfilledThrowsAnException() {
    Thrower<Integer> doneThrower = Thrower<Integer>();
    LinkedList<String> done = LinkedList<String>();
    Thrower<Exception> failedThrower = Thrower<Exception>();
    LinkedList<Exception> failed = LinkedList<Exception>();
    Deferred<Integer> deferred = Deferred<Integer>();
    Promise<Integer> promise = deferred.promise;
    promise.then_(doneThrower.m, failedThrower.m).then_(done.add, failed.add);
    deferred.resolve(3);
    
    assertEquals { expected = {}; actual = done; };
    assertEquals { expected = failed; actual = doneThrower.thrown; };
    assertEquals { expected = {}; actual = failedThrower.thrown; };
}

void testReturnedPromiseMustBeRejectWithSameReasonWhenOnRejectedThrowsAnException() {
    Thrower<Integer> doneThrower = Thrower<Integer>();
    Thrower<Exception> failedThrower = Thrower<Exception>();
    LinkedList<String> done = LinkedList<String>();
    LinkedList<Exception> failed = LinkedList<Exception>();
    Deferred<Integer> deferred = Deferred<Integer>();
    Promise<Integer> promise = deferred.promise;
    promise.then_(doneThrower.m, failedThrower.m).then_(done.add, failed.add);
    deferred.reject(Exception());
    
    assertEquals { expected = {}; actual = done; };
    assertEquals { expected = {}; actual = doneThrower.thrown; };
    assertEquals { expected = failed; actual = failedThrower.thrown; };
}

// Disabled until we cane make onFulfilled optional again
/*
void testReturnedPromiseMustBeFulfilledWithSameValueWhenOnFulfilledIsNotAFunction() {
  LinkedList<String> a = LinkedList<String>();
  Deferred<String> d = Deferred<String>();
  d.promise.then_<String>().then_(a.add);
  d.resolve("a");
  assertEquals { expected = {"a"}; actual = a; };
}
*/

void testReturnedPromiseMustBeRejectedWithSameValueWhenOnRejectedIsNotAFunction() {
    LinkedList<Exception> a = LinkedList<Exception>();
    Deferred<String> d = Deferred<String>();
    Promise<String> promise = d.promise;
    promise.then_((String s) => s).then_((String s) => print(s),a.add);
    Exception e = Exception();
    d.reject(e);

    assertEquals { expected = {e}; actual = a; };
}
