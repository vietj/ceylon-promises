@doc "The deferred class is the primary implementation of the [[Promise] interface.
      
      The promise is accessible using the `promise` attribute of the deferred.
      
      The deferred can either be resolved or rejected via the `resolve` or `reject` methods. Both
      methods accept an argument or a promise to the argument, allowing the deferred to react
      on a promise."
shared class Deferred<Value>() {

  variable Promise<Value>? state = null;
  variable Status current = pending;
  variable [Anything(Value),Anything(Exception)][] listeners = {};
  
  listeners = listeners.withTrailing([(Value v) => current = fulfilled, (Exception e) => current = rejected]);

  Promise<T> adaptValue<T>(T|Promise<T> arg) {
    if (is T arg) {
      object adapter satisfies Promise<T> {
        shared actual Promise<Result> then_<Result>(<Result|Promise<Result>>(T) onFulfilled, <Result|Promise<Result>>(Exception) onRejected) {
          try {
            Result|Promise<Result> result = onFulfilled(arg);
            return adaptValue(result);
          } catch(Exception e) {
            return adaptReason<Result>(e);
          }
        }
      }
      return adapter;
    } else if (is Promise<T> arg) {
      return arg;
    } else {
      throw Exception("not possible");
    }
  }

  Promise<T> adaptReason<T>(Exception e) {
    object adapted satisfies Promise<T> {
      shared actual Promise<Result> then_<Result>(<Result|Promise<Result>>(T) onFulfilled, <Result|Promise<Result>>(Exception) onRejected) {
        try {
          <Result|Promise<Result>> result = onRejected(e);
          return adaptValue<Result>(result);
        } catch(Exception e) {
          return adaptReason<Result>(e);
        }
      }
    }
    return adapted;
  }

  @doc "Resolve the promise with a value or a promise to the value."
  shared Deferred<Value> resolve(Value|Promise<Value> val) {
    Promise<Value> adapted = adaptValue(val);
    set(adapted);
    return this;
  }

  @doc "Reject the promise with a reason or a promise to the reason."
  shared Deferred<Value> reject(Exception reason) {
    Promise<Value> adapted = adaptReason<Value>(reason);
    set(adapted);
    return this;
  }

  void set(Promise<Value> state) {
    if (exists tmp = this.state) {
    } else {
      this.state = state;
      for (listener in listeners) {
        state.then_(listener[0], listener[1]);
      }
    }
  }

  @doc "Return the current deferred status."
  shared Status status => current;

  @doc "Return true if the current promise is fulfilled."
  shared Boolean isFulfilled => status == fulfilled;

  @doc "Return true if the current promise is rejected."
  shared Boolean isRejected => status == rejected;

  @doc "Return true if the current promise is fulfilled."
  shared Boolean isPending => status == pending;

  @doc "The promise of this deferred."
  shared object promise satisfies Promise<Value> {

    shared actual Promise<Result> then_<Result>(<Result|Promise<Result>>(Value) onFulfilled, <Result|Promise<Result>>(Exception) onRejected) {
      Deferred<Result> deferred = Deferred<Result>();

      void callback<T>(<Result|Promise<Result>>(T) on, T val) {
        try {
          Result|Promise<Result> result = on(val);
          deferred.resolve(result);
        } catch(Exception e) {
          deferred.reject(e);
        }
      }

      void onFulfilledCallback(Value val) {
        callback(onFulfilled, val);
      }
      void onRejectedCallback(Exception reason) {
        callback(onRejected, reason);
      }

      if (exists tmp = state) {
        tmp.then_(onFulfilledCallback, onRejectedCallback);
      } else {
        listeners = listeners.withTrailing([onFulfilledCallback, onRejectedCallback]);
      }

      return deferred.promise;
    }
  }
}