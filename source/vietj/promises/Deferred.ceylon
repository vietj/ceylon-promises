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

    shared actual Promise<Result, Exception> then_<Result>(Callable<Result|Promise<Result, Exception>,[Value]> onFulfilled, Callable<Result|Promise<Result,Exception>,[Reason]> onRejected) {
      Deferred<Result, Exception> then_ = Deferred<Result, Exception>();

      void handle<Arg>(Arg arg, Callable<Result|Promise<Result, Exception>,[Arg]> onEvent) {
        try {
          Result|Promise<Result, Exception> result = onEvent(arg);
          if (is Result result) {
            then_.resolve(result);
          } else if (is Promise<Result, Exception> result) {
            result.then_((Result result) => then_.resolve(result), (Exception exception) => then_.reject(exception));
          }
        } catch(Exception e) {
          then_.reject(e);
        }
      }

      object adapter satisfies Handler<Value, Reason> {
        shared actual void resolve(Value val) {
          handle(val, onFulfilled);
        }
        shared actual void reject(Reason reason) {
          handle(reason, onRejected);
        }
      }

      addListener(adapter);
      return then_.promise;
    }
  }
}