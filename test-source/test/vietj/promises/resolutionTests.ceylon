import vietj.promises { ... }
import ceylon.test { ... }
import ceylon.collection { ... }

@doc "Testing The Promise Resolution Procedure"
shared void resolutionTests() {

  testOnFulfilledAdoptPromiseThatResolves();
  testOnFulfilledAdoptPromiseThatRejects();
  testOnRejectedAdoptPromiseThatResolves();
  testOnRejectedAdoptPromiseThatRejects();

}

class Test() {
  shared LinkedList<Integer> d1Values = LinkedList<Integer>();
  shared LinkedList<Integer> d1Reasons = LinkedList<Integer>();
  shared LinkedList<String> d2Values = LinkedList<String>();
  shared LinkedList<Exception> d2Reasons = LinkedList<Exception>();
  shared Deferred<Integer, Integer> d1 = Deferred<Integer, Integer>();
  shared Deferred<String, Exception> d2 = Deferred<String, Exception>();
  shared void check({Integer*} expectedD1Values, {Integer*} expectedD1Reasons, {String*} expectedD2Values, {Exception*} expectedD2Reasons) {
    assertEquals { expected = expectedD1Values; actual = d1Values; };
    assertEquals { expected = expectedD1Reasons; actual = d1Reasons; };
    assertEquals { expected = expectedD2Values; actual = d2Values; };
    assertEquals { expected = expectedD2Reasons; actual = d2Reasons; };
  }
}

void testOnFulfilledAdoptPromiseThatResolves() {
  Test test = Test();
  Promise<String, Exception> f(Integer val) {
    test.d1Values.add(val);
    return test.d2.promise;
  }
  Promise<String, Exception> g(Integer reason) {
    test.d1Reasons.add(reason);
    return test.d2.promise;
  }
  test.d1.promise.then_<String, String>(f, g).then_(test.d2Values.add, test.d2Reasons.add);
  test.check({},{},{},{});
  test.d1.resolve(3);
  test.check({3},{},{},{});
  test.d2.resolve("foo");
  test.check({3},{},{"foo"},{});
}

void testOnFulfilledAdoptPromiseThatRejects() {
  Test test = Test();
  Promise<String, Exception> f(Integer val) {
    test.d1Values.add(val);
    return test.d2.promise;
  }
  Promise<String, Exception> g(Integer reason) {
    test.d1Reasons.add(reason);
    return test.d2.promise;
  }
  test.d1.promise.then_<String, String>(f, g).then_(test.d2Values.add, test.d2Reasons.add);
  test.check({},{},{},{});
  test.d1.resolve(3);
  test.check({3},{},{},{});
  Exception e = Exception();
  test.d2.reject(e);
  test.check({3},{},{},{e});
}

void testOnRejectedAdoptPromiseThatResolves() {
  Test test = Test();
  Promise<String, Exception> f(Integer val) {
    test.d1Values.add(val);
    return test.d2.promise;
  }
  Promise<String, Exception> g(Integer reason) {
    test.d1Reasons.add(reason);
    return test.d2.promise;
  }
  test.d1.promise.then_<String, String>(f, g).then_(test.d2Values.add, test.d2Reasons.add);
  test.check({},{},{},{});
  test.d1.reject(3);
  test.check({},{3},{},{});
  test.d2.resolve("foo");
  test.check({},{3},{"foo"},{});
}

void testOnRejectedAdoptPromiseThatRejects() {
  Test test = Test();
  Promise<String, Exception> f(Integer val) {
    test.d1Values.add(val);
    return test.d2.promise;
  }
  Promise<String, Exception> g(Integer reason) {
    test.d1Reasons.add(reason);
    return test.d2.promise;
  }
  test.d1.promise.then_<String, String>(f, g).then_(test.d2Values.add, test.d2Reasons.add);
  test.check({},{},{},{});
  test.d1.reject(3);
  test.check({},{3},{},{});
  Exception e = Exception();
  test.d2.reject(e);
  test.check({},{3},{},{e});
}
