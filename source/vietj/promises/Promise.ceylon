object bilto {
  shared Deferred<[]> deferred = Deferred<[]>().resolve([]);
}

@doc "A promise represents a value that may not be available yet. The primary method for
      interacting with a promise is its `then` method."
shared interface Promise<Value> {

  M rethrow<M>(Exception e) {
    throw e;
  }

  M safeCast<M, N>(N n) {
    if (is M n) {
      return n;
    } else {
      // todo : this could be done better by returning null instead of changing the control flow of the promise
      throw Exception("Could not convert type");
    }
  }
  
  @doc "The then method from the Promise/A+ specification."
  shared formal Promise<Result> then_<Result>(<Result|Promise<Result>>(Value) onFulfilled = safeCast<Result, Value>, <Result|Promise<Result>>(Exception) onRejected = rethrow<Result>);

  @doc "Combine the current promise with a provided promise and return an [[And]] object that
        provides a promise that:
        - resolves when both the current and the other promise are resolved
        - rejects when the current or the other promise is rejected
        
        The [[And] promise will be
        - resolved with a tuple of values of the original promises. It is important to notice that
          tuple elements are in reverse order of the and chain
        - rejected with the reason of the rejected promise
        
        The returned [[And]] object allows for promise chaining as a fluent API:
            Promise<String> p1 = ...
            Promise<Integer> p2 = ...
            Promise<Boolean> p3 = ...
            p1.and(p2, p3).then_(([Boolean, Integer, String] args) => print(args));
        "
  shared And<Other|Value,Other,[Value]> and<Other>(Promise<Other> other) {
    Promise<[]> p = bilto.deferred.promise;
    return And(this, p).and(other);
  }

}