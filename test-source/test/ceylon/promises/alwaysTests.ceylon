import ceylon.promises { ... }
import ceylon.test { ... }
import ceylon.collection { ... }

test void testResolveWithArg() {
    Deferred<String> d = Deferred<String>();
    LinkedList<String|Exception> done = LinkedList<String|Exception>();
    d.promise.always(done.add);
    d.resolve("abc");
    assertEquals({"abc"}, done);
}

test void testRejectWithArg() {
    Deferred<String> d = Deferred<String>();
    LinkedList<String|Exception> done = LinkedList<String|Exception>();
    d.promise.always(done.add);
    Exception e = Exception();
    d.reject(e);
    assertEquals({e}, done);
}

test void testResolveWithEmptyArg() {
    Deferred<String> d = Deferred<String>();
    LinkedList<String|Exception> done = LinkedList<String|Exception>();
    d.promise.always((String|Exception a) => done.add("done"));
    d.resolve("abc");
    assertEquals({"done"}, done);
}

test void testRejectWithEmptyArg() {
    Deferred<String> d = Deferred<String>();
    LinkedList<String|Exception> done = LinkedList<String|Exception>();
    d.promise.always((String|Exception a) => done.add("done"));
    d.reject(Exception());
    assertEquals({"done"}, done);
}
