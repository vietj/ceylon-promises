shared class Deferred<Value, Reason = Exception>() {

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

    shared actual Promise<FulfilledResult|RejectedResult, Exception> then_<FulfilledResult,RejectedResult>(
        <FulfilledResult|Promise<FulfilledResult,Exception>>(Value)? onFulfilled,
        <RejectedResult|Promise<RejectedResult,Exception>>(Reason)? onRejected) {

      Deferred<FulfilledResult|RejectedResult, Exception> then_ = Deferred<FulfilledResult|RejectedResult, Exception>();

      object adapter satisfies Handler<Value, Reason> {

        shared actual void resolve(Value val) {
          if (exists onFulfilled) {
            try {
              FulfilledResult|Promise<FulfilledResult, Exception> result = onFulfilled(val);
              if (is FulfilledResult result) {
                then_.resolve(result);
              } else if (is Promise<FulfilledResult, Exception> result) {
                result.then_((FulfilledResult result) => then_.resolve(result), (Exception exception) => then_.reject(exception));
              }
            } catch(Exception e) {
              then_.reject(e);
            }
          }
        }

        shared actual void reject(Reason reason) {
          if (exists onRejected) {
            try {
              RejectedResult|Promise<RejectedResult, Exception> result = onRejected(reason);
              if (is RejectedResult result) {
                then_.resolve(result);
              } else if (is Promise<RejectedResult, Exception> result) {
                result.then_((RejectedResult result) => then_.resolve(result), (Exception exception) => then_.reject(exception));
              }
            } catch(Exception e) {
              then_.reject(e);
            }
          }
        }
      }

      addListener(adapter);
      return then_.promise;
    }
  }
}