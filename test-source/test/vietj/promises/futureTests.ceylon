import vietj.promises { ... }
import ceylon.test { ... }
import java.lang { Thread { sleep, currentThread } , Runnable }

shared void futureTests() {
  testPromisePeekValue();
  testPromisePeekReason();
  testPromiseGetValue();
  testPromiseGetReason();
  testPromiseTimeOut();
  testPromiseInterrupted();
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

void testPromiseInterrupted() {
  Deferred<String> d = Deferred<String>();
  Promise<String> p = d.promise;
  value f = p.future;
  Thread current = currentThread();
  object t extends Thread() {
  	shared actual void run() {
      // Sleep 500ms should be more than enough for making the test pass
  	  sleep(500);
      current.interrupt();
  	}
  }
  t.start();
  try {
  	f.get();
  	fail("Was expecting an interrupt");
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

