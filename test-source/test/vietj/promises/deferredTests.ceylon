import vietj.promises { ... }
import ceylon.test { ... }
import ceylon.collection { ... }

void testResolve() {
  void perform(Anything(Deferred<String, String>) action) {
    LinkedList<String> done = LinkedList<String>();
    LinkedList<String> failed = LinkedList<String>();
    Deferred<String, String> deferred = Deferred<String, String>();
    deferred.promise.then_(done.add, failed.add);
    assertEquals { expected = 0; actual = done.size; };
    assertEquals { expected = 0; actual = failed.size; };
    action(deferred);
    assertEquals { expected = 1; actual = done.size; };
    assertEquals { expected = "value"; actual = done[0]; };
    assertEquals { expected = 0; actual = failed.size; };
  }
  perform((Deferred<String, String> deferred) => deferred.resolve("value"));
  perform((Deferred<String, String> deferred) => deferred.resolve("value").resolve("done"));
  perform((Deferred<String, String> deferred) => deferred.resolve("value").reject("failed"));
}

void testReject() {
  void perform(Anything(Deferred<String, String>) action) {
    LinkedList<String> done = LinkedList<String>();
    LinkedList<String> failed = LinkedList<String>();
    Deferred<String, String> deferred = Deferred<String, String>();
    deferred.promise.then_(done.add, failed.add);
    assertEquals { expected = 0; actual = done.size; };
    assertEquals { expected = 0; actual = failed.size; };
    action(deferred);
    assertEquals { expected = 0; actual = done.size; };
    assertEquals { expected = 1; actual = failed.size; };
    assertEquals { expected = "value"; actual = failed[0]; };
  }
  perform((Deferred<String, String> deferred) => deferred.reject("value"));
  perform((Deferred<String, String> deferred) => deferred.reject("value").resolve("done"));
  perform((Deferred<String, String> deferred) => deferred.reject("value").reject("failed"));
}

void testThenAfterResolve() {
  LinkedList<String> done = LinkedList<String>();
  LinkedList<String> failed = LinkedList<String>();
  Deferred<String, String> deferred = Deferred<String, String>().resolve("value");
  deferred.promise.then_(done.add, failed.add);
  assertEquals { expected = 1; actual = done.size; };
  assertEquals { expected = "value"; actual = done[0]; };
  assertEquals { expected = 0; actual = failed.size; };
}

void testThenAfterReject() {
  LinkedList<String> done = LinkedList<String>();
  LinkedList<String> failed = LinkedList<String>();
  Deferred<String, String> deferred = Deferred<String, String>().reject("value");
  deferred.promise.then_(done.add, failed.add);
  assertEquals { expected = 0; actual = done.size; };
  assertEquals { expected = 1; actual = failed.size; };
  assertEquals { expected = "value"; actual = failed[0]; };
}

shared void deferredTests() {
    testResolve();
    testReject();
    testThenAfterResolve();
    testThenAfterReject();
}