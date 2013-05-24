shared class Deferred<Value, Reason>() {

  variable Status status = pending;
  variable Value|Reason|Null state = null;
  variable {Handler<Value, Reason>*} listeners = {};

  shared Deferred<Value, Reason> resolve(Value val) {
    if (status == pending) {
      status = fulfilled;
      state = val;
      for (listener in listeners) {
        listener.resolve(val);
      }
    }
    return this;
  }

  shared Deferred<Value, Reason> reject(Reason reason) {
    if (status == pending) {
      status = rejected;
      state = reason;
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
         Value|Reason|Null state = this.state;
         if (is Value state) { listener.resolve(state); } else { throw Exception("Should not happen"); }
       }
       case (rejected) {
         Value|Reason|Null state = this.state;
         if (is Reason state) { listener.reject(state); } else { throw Exception("Should not happen"); }
       }
  }

  shared object promise satisfies Promise<Value, Reason> {

    shared actual Promise<Result, Exception> then_<Result>(
        Callable<Result|Promise<Result, Exception>,[Value]>? onFulfilled,
        Callable<Result|Promise<Result,Exception>,[Reason]>? onRejected) {

      Deferred<Result, Exception> then_ = Deferred<Result, Exception>();

      object adapter satisfies Handler<Value, Reason> {

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

        shared actual void resolve(Value val) {
          if (exists onFulfilled) {
            handle(val, onFulfilled);
          }
        }

        shared actual void reject(Reason reason) {
          if (exists onRejected) {
            handle(reason, onRejected);
          }
        }
      }

      addListener(adapter);
      return then_.promise;
    }
  }
}