shared interface Promise<Value, Reason> {

  shared formal Promise<Result, Exception> then_<Result>(
    <Result|Promise<Result,Exception>>(Value)? onFulfilled = null,
    <Result|Promise<Result,Exception>>(Reason)? onRejected = null);

}