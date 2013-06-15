import vietj.promises { Deferred, Promise }
import ceylon.collection { LinkedList }
import ceylon.test { ... }

void progressTests() {

  testProgressAfterThen();
  testProgressBeforeThen();
  testThenAfterFulfilledAfterProgress();
  testProgressAfterFulfilled();

}

void testProgressAfterThen() {
  LinkedList<String> progresses = LinkedList<String>();
  Deferred<String, String> d = Deferred<String, String>();
  Promise<String, String> p = d.promise;
  p.then___((String s) => s, (Exception e) => "", (String p) => progresses.add(p));
  assertEquals({}, progresses);
  d.progress("abc");
  assertEquals({"abc"}, progresses);
}

void testProgressBeforeThen() {
  LinkedList<String> progresses = LinkedList<String>();
  Deferred<String, String> d = Deferred<String, String>();
  Promise<String, String> p = d.promise;
  p.then___((String s) => s, (Exception e) => "", (String p) => progresses.add(p));
  d.progress("abc");
  assertEquals({"abc"}, progresses);
}

void testProgressAfterFulfilled() {
  LinkedList<String> progresses = LinkedList<String>();
  Deferred<String, String> d = Deferred<String, String>();
  Promise<String, String> p = d.promise;
  d.resolve("def");
  p.then___((String s) => s, (Exception e) => "", (String p) => progresses.add(p));
  d.progress("abc");
  assertEquals({}, progresses);
}

void testThenAfterFulfilledAfterProgress() {
  LinkedList<String> progresses = LinkedList<String>();
  Deferred<String, String> d = Deferred<String, String>();
  Promise<String, String> p = d.promise;
  d.progress("abc");
  d.resolve("def");
  p.then___((String s) => s, (Exception e) => "", (String p) => progresses.add(p));
  assertEquals({}, progresses);
}