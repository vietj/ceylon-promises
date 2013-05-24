shared interface Promise<Value, Reason> {

  shared formal Promise<Result, Exception> then_<Result>(Callable<Result|Promise<Result, Exception>,[Value]> onFulfilled, Callable<Result|Promise<Result,Exception>,[Reason]> onRejected);

}