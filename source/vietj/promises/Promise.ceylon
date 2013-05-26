object bilto {
  shared Deferred<[]> deferred = Deferred<[]>().resolve([]);
}

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

  shared formal Promise<Result> then_<Result>(<Result|Promise<Result>>(Value) onFulfilled = safeCast<Result, Value>, <Result|Promise<Result>>(Exception) onRejected = rethrow<Result>);

  shared And<Other|Value,Other,[Value]> and<Other>(Promise<Other> other) {
    Promise<[]> p = bilto.deferred.promise;
    return And(this, p).and(other);
  }

}