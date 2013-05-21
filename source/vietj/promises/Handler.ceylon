shared interface Handler<D, F> {

  shared formal void resolve(D done);

  shared formal void reject(F failed);

}
