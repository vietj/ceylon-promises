import ceylon.promises { ... }
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

test void testAllRespectiveFulfilledCallbacksMustExecuteInTheOrderOfTheirOriginatingCallsToThen() {
    value calls = LinkedList<Integer>();
    value d = Deferred<String>();	
    Promise<String> promise = d.promise;
    promise.then_((String s) => calls.add(1));
    promise.then_((String s) => calls.add(2));
    d.resolve("");
    
    assertEquals { expected = {1,2}; actual = calls; };
}

test void testAllRespectiveRejectedCallbacksMustExecuteInTheOrderOfTheirOriginatingCallsToThen() {
    value calls = LinkedList<Integer>();
    value d = Deferred<String>();	
    Promise<String> promise = d.promise;
    promise.then_((String s) => print(s),(Exception e) => calls.add(1));
    promise.then_((String s) => print(s),(Exception e) => calls.add(2));
    d.reject(Exception());
    
    assertEquals { expected = {1,2}; actual = calls; };
}

test void testReturnedPromiseMustBeRejectWithSameReasonWhenOnFulfilledThrowsAnException() {
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

test void testReturnedPromiseMustBeRejectWithSameReasonWhenOnRejectedThrowsAnException() {
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

test void testReturnedPromiseMustBeRejectedWithSameValueWhenOnRejectedIsNotAFunction() {
    LinkedList<Exception> a = LinkedList<Exception>();
    Deferred<String> d = Deferred<String>();
    Promise<String> promise = d.promise;
    promise.then_((String s) => s).then_((String s) => print(s),a.add);
    Exception e = Exception();
    d.reject(e);

    assertEquals { expected = {e}; actual = a; };
}
