shared class Deferred<D, F>() satisfies Handler<D, F> {

  variable Status status = pending;
  variable {Handler<D, F>*} listeners = {};
  variable D? doneValue = null;
  variable F? failedValue = null;

  shared actual Deferred<D, F> resolve(D val) {
    if (status == pending) {
      status = done;
      doneValue = val;
      for (listener in listeners) {
        listener.resolve(val);
      }
    }
    return this;
  }

  shared actual Deferred<D, F> reject(F val) {
    if (status == pending) {
      status = failed;
      failedValue = val;
      for (listener in listeners) {
        listener.reject(val);
      }
    }
    return this;
  }

  void addListener(Handler<D, F> listener) {
    switch (status)
       case (pending) {
         listeners = { listener, *listeners};
       }
       case (done) {
         if (exists val = doneValue) { listener.resolve(val); } else { throw Exception("Should not happen"); }
       }
       case (failed) {
         if (exists val = failedValue) { listener.reject(val); } else { throw Exception("Should not happen"); }
       }
  }

  shared object promise satisfies Promise<D, F> {

    shared actual Promise<R, Exception> then_<R>(R(D) onDone, R(F) onFailed) {
      Deferred<R, Exception> then_ = Deferred<R, Exception>();
      object adapter satisfies Handler<D, F> {
        shared actual void resolve(D done) {
          try {
            R result = onDone(done);
            then_.resolve(result);
          } catch (Exception e) {
            then_.reject(e);
          }
        }
        shared actual void reject(F failed) {
          try {
            R result = onFailed(failed);
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