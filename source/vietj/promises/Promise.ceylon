shared interface Promise<D, F> {

  shared formal Promise<R, Exception> then_<R>(R(D) onDone, R(F) onFailed);

}