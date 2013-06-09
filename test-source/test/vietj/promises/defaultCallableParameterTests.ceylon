import vietj.promises { ... }
import ceylon.test { ... }
import ceylon.collection { ... }

shared void defaultCallableParameterTests() {
  testDefaultValue();
  testDefaultReason();
}

void testDefaultValue() {
  Deferred<String> d = Deferred<String>();
  LinkedList<String> done = LinkedList<String>();
  void foo(String arg = "default") {
  	done.add(arg);
  }
  d.promise.then_(foo);
  d.resolve("the_value");
  assertEquals({"the_value"}, done);
}

void testDefaultReason() {
  Deferred<String> d = Deferred<String>();
  LinkedList<Exception> done = LinkedList<Exception>();
  void foo(Exception arg = Exception()) {
  	done.add(arg);
  }
  Promise<String> p = d.promise;
  p.then_((String s) => print(s), foo);
  Exception reason = Exception();
  d.reject(reason);
  assertEquals({reason}, done);
}