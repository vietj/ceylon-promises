shared interface Promise<Value, Reason> {

  shared formal Promise<Result, Exception> then_<Result>(Result(Value) onFulfilled, Result(Reason) onRejected);

}