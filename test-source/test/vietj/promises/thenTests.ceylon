import vietj.promises { ... }
import ceylon.test { ... }
import ceylon.collection { ... }

class Thrower() {
  shared LinkedList<Exception> thrown = LinkedList<Exception>();
  shared String m(Integer i) {
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
  Thrower doneThrower = Thrower();
  Thrower failedThrower = Thrower();
  LinkedList<String> done = LinkedList<String>();
  LinkedList<Exception> failed = LinkedList<Exception>();
  Deferred<Integer, Integer> deferred = Deferred<Integer, Integer>();
  deferred.promise.then_(doneThrower.m, failedThrower.m).then_(done.add, failed.add);
  deferred.resolve(3);
  assertEquals { expected = 0; actual = done.size; };
  assertEquals { expected = 1; actual = doneThrower.thrown.size; };
  assertEquals { expected = 1; actual = failed.size; };
  assertEquals { expected = doneThrower.thrown[0]; actual = failed[0]; };
  assertEquals { expected = 0; actual = failedThrower.thrown.size; };
}

void testReturnedPromiseMustBeRejectWithSameReasonWhenOnRejectedThrowsAnException() {
  Thrower doneThrower = Thrower();
  Thrower failedThrower = Thrower();
  LinkedList<String> done = LinkedList<String>();
  LinkedList<Exception> failed = LinkedList<Exception>();
  Deferred<Integer, Integer> deferred = Deferred<Integer, Integer>();
  deferred.promise.then_(doneThrower.m, failedThrower.m).then_(done.add, failed.add);
  deferred.reject(3);
  assertEquals { expected = 0; actual = done.size; };
  assertEquals { expected = 0; actual = doneThrower.thrown.size; };
  assertEquals { expected = 1; actual = failedThrower.thrown.size; };
  assertEquals { expected = 1; actual = failed.size; };
  assertEquals { expected = failedThrower.thrown[0]; actual = failed[0]; };
}

void testReturnedPromiseMustBeFulfilledWithSameValueWhenOnFulfilledIsNotAFunction() {
  LinkedList<String> a = LinkedList<String>();
  Deferred<String, String> d = Deferred<String, String>();
  d.promise.then_<String, String>().then_(a.add);
  d.resolve("a");
  assertEquals { expected = {"a"}; actual = a; };
}

void testReturnedPromiseMustBeRejectedWithSameValueWhenOnRejectedIsNotAFunction() {
  LinkedList<Exception> a = LinkedList<Exception>();
  Deferred<String, Exception> d = Deferred<String, Exception>();
  d.promise.then_<String, Exception>().then_{ onRejected = a.add; };
  Exception e = Exception();
  d.reject(e);
  assertEquals { expected = {e}; actual = a; };
}