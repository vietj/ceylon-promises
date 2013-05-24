import vietj.promises { ... }
import ceylon.test { ... }
import ceylon.collection { ... }

String toString(Integer i) { return i.string; }

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

shared void promiseTests() {
  testFulfilledFulfillmentHandlerReturnsValue();
  testRejectedRejectionHandlerReturnsAValue();
}