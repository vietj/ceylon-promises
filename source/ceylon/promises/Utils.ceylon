"Adapt a Callable<Result, Value> to Callable<Promise<Result>, Value>"
by("Julien Viet")
Callable<Promise<Result>, Value> adaptResult<Result, Value>(Callable<Result, Value> a) given Value satisfies Anything[] {
  Result(Value) b = unflatten(a);
  Promise<Result> c(Value d) {
    Result r = b(d);
    Deferred<Result> deferred = Deferred<Result>();
    deferred.resolve(r);
    return deferred.promise;	
  }
  return flatten(c);
}

by("Julien Viet")
Promise<T> adaptValue<T>(T|Promise<T> val) {
  if (is T val) {
    object adapter extends Promise<T>() {
      shared actual Promise<Result> then__<Result>(
        <Promise<Result>(T)> onFulfilled,
        <Promise<Result>(Exception)> onRejected) {
        try {
          return onFulfilled(val);
        } catch(Exception e) {
          return adaptReason<Result>(e);
        }
      }
    }
    return adapter;
  } else if (is Promise<T> val) {
    return val;
  } else {
    throw Exception("not possible");
  }
}

by("Julien Viet")
Promise<T> adaptReason<T>(Exception reason) {
  object adapted extends Promise<T>() {
    shared actual Promise<Result> then__<Result>(
      <Promise<Result>(T)> onFulfilled,
      <Promise<Result>(Exception)> onRejected) {
      try {
        return onRejected(reason);
      } catch(Exception e) {
        return adaptReason<Result>(e);
      }
    }
  }
  return adapted;
}

