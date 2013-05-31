import vietj.promises { ... }
import ceylon.test { ... }
import ceylon.collection { ... }

String toString(Integer i) { return i.string; }

void testFulfilledFulfillmentHandlerReturnsValue() {
  LinkedList<String> done = LinkedList<String>();
  ExceptionCollector failed = ExceptionCollector();
  Deferred<Integer> deferred = Deferred<Integer>();
  deferred.promise.then_(toString).then_(done.add, failed.add);
  deferred.resolve(3);
  assertEquals { expected = {"3"}; actual = done; };
  assertEquals { expected = {}; actual = failed.collected; };
}

void testRejectedRejectionHandlerReturnsAValue() {
  LinkedList<String> done = LinkedList<String>();
  ExceptionCollector failed = ExceptionCollector();
  Deferred<Integer> deferred = Deferred<Integer>();
  deferred.promise.then_(toString, (Exception e) => "3").then_(done.add, failed.add);
  deferred.reject(Exception());
  assertEquals { expected = {"3"}; actual = done; };
  assertEquals { expected = {}; actual = failed.collected; };
}

void testFulfillementState() {
  Deferred<Integer> deferred = Deferred<Integer>();
  assertEquals { expected = pending; actual = deferred.status; };
  deferred.resolve(3);
  assertEquals { expected = fulfilled; actual = deferred.status; };
}

void testRejectedState() {
  Deferred<Integer> deferred = Deferred<Integer>();
  Exception e = Exception();
  assertEquals { expected = pending; actual = deferred.status; };
  deferred.reject(e);
  assertEquals { expected = rejected; actual = deferred.status; };
}

shared void promiseTests() {
  testFulfillementState();
  testRejectedState();
  testFulfilledFulfillmentHandlerReturnsValue();
  testRejectedRejectionHandlerReturnsAValue();
}