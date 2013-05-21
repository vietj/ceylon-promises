import vietj.promises { ... }
import ceylon.test { ... }
import ceylon.collection { ... }

String toString(Integer i) { return i.string; }

class Thrower() {
  shared LinkedList<Exception> thrown = LinkedList<Exception>();
  shared String m(Integer i) {
    Exception e = Exception();
    thrown.add(e);
    throw e;
  }
}

void testFulfilledFulfillmentHandlerReturnsValue() {
  LinkedList<String> done = LinkedList<String>();
  LinkedList<Exception> failed = LinkedList<Exception>();
  Deferred<Integer, Integer> deferred = Deferred<Integer, Integer>();
  deferred.promise.then_(toString, toString).then_(done.add, failed.add);
  deferred.resolve(3);
  assertEquals { expected = 1; actual = done.size; };
  assertEquals { expected = "3"; actual = done[0]; };
  assertEquals { expected = 0; actual = failed.size; };
}

void testRejectedRejectionHandlerReturnsAValue() {
  LinkedList<String> done = LinkedList<String>();
  LinkedList<Exception> failed = LinkedList<Exception>();
  Deferred<Integer, Integer> deferred = Deferred<Integer, Integer>();
  deferred.promise.then_(toString, toString).then_(done.add, failed.add);
  deferred.reject(3);
  assertEquals { expected = 1; actual = done.size; };
  assertEquals { expected = "3"; actual = done[0]; };
  assertEquals { expected = 0; actual = failed.size; };
}

void testFulfilledFulfillmentHandlerThrowsAnException() {
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

void testRejectedRejectionHandlerThrowsAnException() {
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

shared void promiseTests() {
  testFulfilledFulfillmentHandlerReturnsValue();
  testRejectedRejectionHandlerReturnsAValue();
  testFulfilledFulfillmentHandlerThrowsAnException();
  testRejectedRejectionHandlerThrowsAnException();
}