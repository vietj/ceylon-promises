shared interface Promise<Value, Reason> {

  shared formal Promise<FulfilledResult|RejectedResult, Exception> then_<FulfilledResult,RejectedResult>(
    <FulfilledResult|Promise<FulfilledResult,Exception>>(Value)? onFulfilled = null,
    <RejectedResult|Promise<RejectedResult,Exception>>(Reason)? onRejected = null);

}