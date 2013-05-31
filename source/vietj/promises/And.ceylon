@doc "Combines two promises into a new promise.
      
      The new promise
      - is resolved when both promises are resolved
      - is rejected when any of the two promise is rejected
      "
shared class And<Element, First, Rest>(Promise<First> first, Promise<Rest> rest)
 given First satisfies Element
 given Rest satisfies Sequential<Element> {

  Deferred<Tuple<First|Element, First, Rest>> deferred = Deferred<Tuple<First|Element, First, Rest>>();
  shared Promise<Tuple<First|Element, First, Rest>> promise = deferred.promise;
  variable First? firstVal = null;
  variable Rest? restVal = null;

  void check() {
    if (exists tmp = firstVal) {
      if (exists foo = restVal) {
        Tuple<First|Element, First, Rest> toto = Tuple(tmp, foo);
        deferred.resolve(toto);
      }
    }
  }

  void onReject(Exception e) {
    deferred.reject(e);
  }

  void onRestFulfilled(Rest val) {
    restVal = val;
    check();
  }
  rest.then_(onRestFulfilled, onReject);

  void onFirstFulfilled(First val) {
    firstVal = val;
    check();
  }
  first.then_(onFirstFulfilled, onReject);

  @doc "Combine the current conjonction with a new promise."
  shared And<NewFirst|Element, NewFirst, Tuple<First|Element, First, Rest>> and<NewFirst>(Promise<NewFirst> newFirst) {
    return And(newFirst, promise);
  }
}
