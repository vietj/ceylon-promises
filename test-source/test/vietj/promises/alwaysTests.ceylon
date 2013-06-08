import vietj.promises { ... }
import ceylon.test { ... }
import ceylon.collection { ... }

shared void alwaysTests() {
  testResolveWithArg();
  testRejectWithArg();
  testResolveWithEmptyArg();
  testRejectWithEmptyArg();	
}

void testResolveWithArg() {
  Deferred<String> d = Deferred<String>();
  LinkedList<String|Exception> done = LinkedList<String|Exception>();
  d.promise.always(done.add);
  d.resolve("abc");
  assertEquals({"abc"}, done);
}

void testRejectWithArg() {
  Deferred<String> d = Deferred<String>();
  LinkedList<String|Exception> done = LinkedList<String|Exception>();
  d.promise.always(done.add);
  Exception e = Exception();
  d.reject(e);
  assertEquals({e}, done);
}

void testResolveWithEmptyArg() {
  Deferred<String> d = Deferred<String>();
  LinkedList<String|Exception> done = LinkedList<String|Exception>();
  d.promise.always(() => done.add("done"));
  d.resolve("abc");
  assertEquals({"done"}, done);
}

void testRejectWithEmptyArg() {
  Deferred<String> d = Deferred<String>();
  LinkedList<String|Exception> done = LinkedList<String|Exception>();
  d.promise.always(() => done.add("done"));
  d.reject(Exception());
  assertEquals({"done"}, done);
}
