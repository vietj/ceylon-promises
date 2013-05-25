import vietj.promises { ... }
import ceylon.test { ... }
import ceylon.collection { ... }

void testResolve() {
  void perform(Anything(Deferred<String>) action) {
    LinkedList<String> done = LinkedList<String>();
    ExceptionCollector failed = ExceptionCollector();
    Deferred<String> deferred = Deferred<String>();
    deferred.promise.then_(done.add, failed.add);
    assertEquals { expected = {}; actual = done; };
    assertEquals { expected = {}; actual = failed.collected; };
    action(deferred);
    assertEquals { expected = {"value"}; actual = done; };
    assertEquals { expected = {}; actual = failed.collected; };
  }
  perform((Deferred<String> deferred) => deferred.resolve("value"));
  perform((Deferred<String> deferred) => deferred.resolve("value").resolve("done"));
  perform((Deferred<String> deferred) => deferred.resolve("value").reject(Exception()));
}

void testReject() {
  Exception reason = Exception();
  void perform(Anything(Deferred<String>) action) {
    LinkedList<String> done = LinkedList<String>();
    ExceptionCollector failed = ExceptionCollector();
    Deferred<String> deferred = Deferred<String>();
    deferred.promise.then_(done.add, failed.add);
    assertEquals { expected = {}; actual = done; };
    assertEquals { expected = {}; actual = failed.collected; };
    action(deferred);
    assertEquals { expected = {}; actual = done; };
    assertEquals { expected = {reason}; actual = failed.collected; };
  }
  perform((Deferred<String> deferred) => deferred.reject(reason));
  perform((Deferred<String> deferred) => deferred.reject(reason).resolve("done"));
  perform((Deferred<String> deferred) => deferred.reject(reason).reject(Exception()));
}

void testThenAfterResolve() {
  LinkedList<String> done = LinkedList<String>();
  ExceptionCollector failed = ExceptionCollector();
  Deferred<String> deferred = Deferred<String>().resolve("value");
  deferred.promise.then_(done.add, failed.add);
  assertEquals { expected = {"value"}; actual = done; };
  assertEquals { expected = {}; actual = failed.collected; };
}

void testThenAfterReject() {
  LinkedList<String> done = LinkedList<String>();
  ExceptionCollector failed = ExceptionCollector();
  Exception reason = Exception();
  Deferred<String> deferred = Deferred<String>().reject(reason);
  deferred.promise.then_(done.add, failed.add);
  assertEquals { expected = {}; actual = done; };
  assertEquals { expected = {reason}; actual = failed.collected; };
}

shared void deferredTests() {
    testResolve();
    testReject();
    testThenAfterResolve();
    testThenAfterReject();
}