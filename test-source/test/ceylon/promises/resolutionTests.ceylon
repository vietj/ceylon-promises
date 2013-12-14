import ceylon.promises { ... }
import ceylon.test { ... }
import ceylon.collection { ... }

class Test() {
    shared LinkedList<Integer> d1Values = LinkedList<Integer>();
    shared LinkedList<Exception> d1Reasons = LinkedList<Exception>();
    shared LinkedList<String> d2Values = LinkedList<String>();
    shared LinkedList<Exception> d2Reasons = LinkedList<Exception>();
    shared Deferred<Integer> d1 = Deferred<Integer>();
    shared Deferred<String> d2 = Deferred<String>();
    
    shared void check({Integer*} expectedD1Values, {Exception*} expectedD1Reasons, {String*} expectedD2Values, {Exception*} expectedD2Reasons) {
        assertEquals { expected = expectedD1Values; actual = d1Values; };
        assertEquals { expected = expectedD1Reasons; actual = d1Reasons; };
        assertEquals { expected = expectedD2Values; actual = d2Values; };
        assertEquals { expected = expectedD2Reasons; actual = d2Reasons; };
    }
}

test void testOnFulfilledAdoptPromiseThatResolves() {
    Test test = Test();
    Promise<String> f(Integer val) {
        test.d1Values.add(val);
        return test.d2.promise;
    }
    Promise<String> g(Exception reason) {
        test.d1Reasons.add(reason);
        return test.d2.promise;
    }
    Promise<Integer> promise = test.d1.promise;
    promise.then__(f, g).then_(test.d2Values.add, test.d2Reasons.add);
    test.check({},{},{},{});
    test.d1.resolve(3);
    test.check({3},{},{},{});
    test.d2.resolve("foo");
    test.check({3},{},{"foo"},{});
}

test void testOnFulfilledAdoptPromiseThatRejects() {
    Test test = Test();
    Promise<String> f(Integer val) {
        test.d1Values.add(val);
        return test.d2.promise;
    }
    Promise<String> g(Exception reason) {
        test.d1Reasons.add(reason);
        return test.d2.promise;
    }
    Promise<Integer> promise = test.d1.promise;
    promise.then__(f, g).then_(test.d2Values.add, test.d2Reasons.add);
    test.check({},{},{},{});
    test.d1.resolve(3);
    test.check({3},{},{},{});
    Exception e = Exception();
    test.d2.reject(e);
    test.check({3},{},{},{e});
}

test void testOnRejectedAdoptPromiseThatResolves() {
    Test test = Test();
    Promise<String> f(Integer val) {
        test.d1Values.add(val);
        return test.d2.promise;
    }
    Promise<String> g(Exception reason) {
        test.d1Reasons.add(reason);
        return test.d2.promise;
    }
    Promise<Integer> promise = test.d1.promise;
    promise.then__(f, g).then_(test.d2Values.add, test.d2Reasons.add);
    test.check({},{},{},{});
    Exception e = Exception();
    test.d1.reject(e);
    test.check({},{e},{},{});
    test.d2.resolve("foo");
    test.check({},{e},{"foo"},{});
}

test void testOnRejectedAdoptPromiseThatRejects() {
    Test test = Test();
    Promise<String> f(Integer val) {
        test.d1Values.add(val);
        return test.d2.promise;
    }
    Promise<String> g(Exception reason) {
        test.d1Reasons.add(reason);
        return test.d2.promise;
    }
    Promise<Integer> promise = test.d1.promise;
    promise.then__(f, g).then_(test.d2Values.add, test.d2Reasons.add);
    test.check({},{},{},{});
    Exception e1 = Exception();
    test.d1.reject(e1);
    test.check({},{e1},{},{});
    Exception e2 = Exception();
    test.d2.reject(e2);
    test.check({},{e1},{},{e2});
}
