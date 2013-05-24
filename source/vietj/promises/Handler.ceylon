interface Handler<Value, Reason> {

  shared formal void resolve(Value val);

  shared formal void reject(Reason reason);

}
