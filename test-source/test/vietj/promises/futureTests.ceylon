import vietj.promises { ... }
import ceylon.test { ... }

shared void futureTests() {
  testPeekValue();
  testPeekReason();
  testGetValue();
  testGetReason();
  testTimeOut();
}

void testPeekValue() {
  Deferred<String> d = Deferred<String>();
  Thenable<[String]> p = d.promise;
  value f = p.future;
  assertNull(f.peek());
  d.resolve("abc");
  assertEquals(["abc"], f.peek());	
}

void testPeekReason() {
  Deferred<String> d = Deferred<String>();
  Thenable<[String]> p = d.promise;
  value f = p.future;
  assertNull(f.peek());
  Exception r = Exception();
  d.reject(r);
  assertEquals(r, f.peek());	
}

void testGetValue() {
  Deferred<String> d = Deferred<String>();
  Thenable<[String]> p = d.promise;
  value f = p.future;
  d.resolve("abc");
  assertEquals(["abc"], f.get());	
}

void testGetReason() {
  Deferred<String> d = Deferred<String>();
  Thenable<[String]> p = d.promise;
  value f = p.future;
  Exception r = Exception();
  d.reject(r);
  assertEquals(r, f.get());	
}

void testTimeOut() {
  Deferred<String> d = Deferred<String>();
  Thenable<[String]> p = d.promise;
  value f = p.future;
  try {
  	f.get(20);
  	fail("Was expecting an exception");
  } catch (Exception e) {
  	// Ok
  }
}
