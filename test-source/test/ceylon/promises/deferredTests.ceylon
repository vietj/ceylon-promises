import ceylon.promises { ... }
import ceylon.test { ... }
import ceylon.collection { ... }

test void testResolve() {
    
    void perform(<String|Exception>* actions) {
        LinkedList<String> done = LinkedList<String>();
        ExceptionCollector failed = ExceptionCollector();
        Deferred<String> deferred = Deferred<String>();
        Promise<String> promise = deferred.promise;
        promise.then_(done.add, failed.add);
        assertEquals { expected = {}; actual = done; };
        assertEquals { expected = {}; actual = failed.collected; };
        for (action in actions) {
            switch (action)
            case (is String) {
                deferred.resolve(action);
            }
            case (is Exception) {
                deferred.reject(action);
            }
        }
        assertEquals { expected = {"value"}; actual = done; };
        assertEquals { expected = {}; actual = failed.collected; };
    }
    
    perform("value");
    perform("value", "done");
    perform("value", Exception());
}

test void testReject() {
    Exception reason = Exception();
    
    void perform(<String|Exception>* actions) {
        LinkedList<String> done = LinkedList<String>();
        ExceptionCollector failed = ExceptionCollector();
        Deferred<String> deferred = Deferred<String>();
        Promise<String> promise = deferred.promise;
        promise.then_(done.add, failed.add);
        assertEquals { expected = {}; actual = done; };
        assertEquals { expected = {}; actual = failed.collected; };
        for (action in actions) {
            switch (action)
            case (is String) {
                deferred.resolve(action);
            }
            case (is Exception) {
                deferred.reject(action);
            }
        }
        assertEquals { expected = {}; actual = done; };
        assertEquals { expected = {reason}; actual = failed.collected; };
    }
    perform(reason);
    perform(reason, "done");
    perform(reason, Exception());
}

test void testThenAfterResolve() {
    LinkedList<String> done = LinkedList<String>();
    ExceptionCollector failed = ExceptionCollector();
    
    value deferred = Deferred<String>();
    deferred.resolve("value");
    Promise<String> promise = deferred.promise;
    promise.then_(done.add, failed.add);
    
    assertEquals { expected = {"value"}; actual = done; };
    assertEquals { expected = {}; actual = failed.collected; };
}

test void testThenAfterReject() {
    LinkedList<String> done = LinkedList<String>();
    ExceptionCollector failed = ExceptionCollector();
    Exception reason = Exception();
    
    value deferred = Deferred<String>();
    deferred.reject(reason);
    Promise<String> promise = deferred.promise;
    promise.then_(done.add, failed.add);
    
    assertEquals { expected = {}; actual = done; };
    assertEquals { expected = {reason}; actual = failed.collected; };
}

test shared void deferredTests() {
    testResolve();
    testReject();
    testThenAfterResolve();
    testThenAfterReject();
}