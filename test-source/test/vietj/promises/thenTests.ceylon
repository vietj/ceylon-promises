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

@doc "Test the then method but not the Promise Resolution Procedure"
shared void thenTests() {

  testReturnedPromiseMustBeRejectWithSameReasonWhenOnFulfilledThrowsAnException();
  testReturnedPromiseMustBeRejectWithSameReasonWhenOnRejectedThrowsAnException();
  testReturnedPromiseMustBeFulfilledWithSameValueWhenOnFulfilledIsNotAFunction();
  testReturnedPromiseMustBeRejectedWithSameValueWhenOnRejectedIsNotAFunction();

}

void testReturnedPromiseMustBeRejectWithSameReasonWhenOnFulfilledThrowsAnException() {
  Thrower<Integer> doneThrower = Thrower<Integer>();
  LinkedList<String> done = LinkedList<String>();
  Thrower<Exception> failedThrower = Thrower<Exception>();
  LinkedList<Exception> failed = LinkedList<Exception>();
  Deferred<Integer> deferred = Deferred<Integer>();
  deferred.promise.then_(doneThrower.m, failedThrower.m).then_(done.add, failed.add);
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
  deferred.promise.then_(doneThrower.m, failedThrower.m).then_(done.add, failed.add);
  deferred.reject(Exception());
  assertEquals { expected = {}; actual = done; };
  assertEquals { expected = {}; actual = doneThrower.thrown; };
  assertEquals { expected = failed; actual = failedThrower.thrown; };
}

void testReturnedPromiseMustBeFulfilledWithSameValueWhenOnFulfilledIsNotAFunction() {
  LinkedList<String> a = LinkedList<String>();
  Deferred<String> d = Deferred<String>();
  d.promise.then_<String>().then_(a.add);
  d.resolve("a");
  assertEquals { expected = {"a"}; actual = a; };
}

void testReturnedPromiseMustBeRejectedWithSameValueWhenOnRejectedIsNotAFunction() {
  LinkedList<Exception> a = LinkedList<Exception>();
  Deferred<String> d = Deferred<String>();
  d.promise.then_((String s) => s).then_{ onRejected = a.add; };
  Exception e = Exception();
  d.reject(e);
  assertEquals { expected = {e}; actual = a; };
}
