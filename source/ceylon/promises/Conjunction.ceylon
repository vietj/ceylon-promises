"Combines two promises into a new promise.
  
  The new promise
  - is resolved when both promises are resolved
  - is rejected when any of the two promise is rejected
  "
by("Julien Viet")
class Conjunction<out Element, out First, Rest>(Promise<First> first, Promise<Rest> rest)
    satisfies Term<Element, Tuple<First|Element, First, Rest>>
        given First satisfies Element
        given Rest satisfies Sequential<Element> {

    Deferred<Tuple<First|Element, First, Rest>> deferred = Deferred<Tuple<First|Element, First, Rest>>();
    shared actual Promise<Tuple<First|Element, First, Rest>> promise = deferred.promise;
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

    shared actual Term<Element|Other, Tuple<Element|Other, Other, Tuple<First|Element, First, Rest>>> and<Other>(Promise<Other> other) {
        return Conjunction(other, promise);
    }

    shared actual Promise<Result> then__<Result>(
            <Callable<Promise<Result>, Tuple<First|Element, First, Rest>>> onFulfilled,
            <Promise<Result>(Exception)> onRejected) {
        
        Promise<Result> adapter(Tuple<First|Element, First, Rest> args) {
            value unflattened = unflatten(onFulfilled);
            return unflattened(args);
        }
        return promise.then__(adapter, onRejected);
    }
}
