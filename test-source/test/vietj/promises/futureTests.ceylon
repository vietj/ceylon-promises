import vietj.promises { ... }
import ceylon.test { ... }

shared void futureTests() {
  testPromisePeekValue();
  testPromisePeekReason();
  testPromiseGetValue();
  testPromiseGetReason();
  testPromiseTimeOut();
  testThenable();
}

void testPromisePeekValue() {
  Deferred<String> d = Deferred<String>();
  Promise<String> p = d.promise;
  value f = p.future;
  assertNull(f.peek());
  d.resolve("abc");
  assertEquals("abc", f.peek());	
}

void testPromisePeekReason() {
  Deferred<String> d = Deferred<String>();
  Promise<String> p = d.promise;
  value f = p.future;
  assertNull(f.peek());
  Exception r = Exception();
  d.reject(r);
  assertEquals(r, f.peek());	
}

void testPromiseGetValue() {
  Deferred<String> d = Deferred<String>();
  Promise<String> p = d.promise;
  value f = p.future;
  d.resolve("abc");
  assertEquals("abc", f.get());	
}

void testPromiseGetReason() {
  Deferred<String> d = Deferred<String>();
  Promise<String> p = d.promise;
  value f = p.future;
  Exception r = Exception();
  d.reject(r);
  assertEquals(r, f.get());	
}

void testPromiseTimeOut() {
  Deferred<String> d = Deferred<String>();
  Promise<String> p = d.promise;
  value f = p.future;
  try {
  	f.get(20);
  	fail("Was expecting an exception");
  } catch (Exception e) {
  	// Ok
  }
}

void testThenable() {
  Deferred<String> d = Deferred<String>();
  Thenable<[String]> t = d.promise;
  Promise<[String]> p = t.promise;
  value f = p.future;
  d.resolve("abc");
  assertEquals(["abc"], f.get());	
}

