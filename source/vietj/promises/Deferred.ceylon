shared class Deferred<Value, Reason>() satisfies Handler<Value, Reason> {

  variable Status status = pending;
  variable {Handler<Value, Reason>*} listeners = {};
  variable Value? val = null;
  variable Reason? reason = null;

  shared actual Deferred<Value, Reason> resolve(Value val) {
    if (status == pending) {
      status = fulfilled;
      this.val = val;
      for (listener in listeners) {
        listener.resolve(val);
      }
    }
    return this;
  }

  shared actual Deferred<Value, Reason> reject(Reason reason) {
    if (status == pending) {
      status = rejected;
      this.reason = reason;
      for (listener in listeners) {
        listener.reject(reason);
      }
    }
    return this;
  }

  void addListener(Handler<Value, Reason> listener) {
    switch (status)
       case (pending) {
         listeners = { listener, *listeners};
       }
       case (fulfilled) {
         if (exists x = val) { listener.resolve(x); } else { throw Exception("Should not happen"); }
       }
       case (rejected) {
         if (exists x = reason) { listener.reject(x); } else { throw Exception("Should not happen"); }
       }
  }

  shared object promise satisfies Promise<Value, Reason> {

    shared actual Promise<Result, Exception> then_<Result>(Result(Value) onFulfilled, Result(Reason) onRejected) {
      Deferred<Result, Exception> then_ = Deferred<Result, Exception>();
      object adapter satisfies Handler<Value, Reason> {
        shared actual void resolve(Value val) {
          try {
            Result result = onFulfilled(val);
            then_.resolve(result);
          } catch (Exception e) {
            then_.reject(e);
          }
        }
        shared actual void reject(Reason failed) {
          try {
            Result result = onRejected(failed);
            then_.resolve(result);
          } catch (Exception e) {
            then_.reject(e);
          }
        }
      }
      addListener(adapter);
      return then_.promise;
    }
  }
}