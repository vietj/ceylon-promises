shared interface Ref<T> {
  shared formal T tuple();
  shared formal void setup(Callback callback);
}

shared object noRef satisfies Ref<[]> {
  shared actual [] tuple() {
    return [];
  }
  shared actual void setup(Callback callback) {
  }
}

shared class Callback(Integer count, Anything() f) {
  shared variable Integer size = count;
  shared void invoke() {
    print("INVOKING");
    f();
    print("INVOKED");
  }
}

shared class All<Element, First, Rest>(Promise<First> first, Ref<Rest> ref, Integer size) satisfies Ref<Tuple<First|Element, First, Rest>>
 given First satisfies Element
 given Rest satisfies Sequential<Element> {

  variable First? theFirst = null;
  shared Integer count = size + 1;

  shared actual Tuple<First|Element, First, Rest> tuple() {
    if (exists tmp = theFirst) {
      Rest rest = ref.tuple();
      return Tuple(tmp, rest);
    } else {
      throw Exception("Illegal state");
    }
  }

  shared actual void setup(Callback callback) {
    ref.setup(callback);
    void update(First val) {
      theFirst = val;
      print("Completed with count");
      if (--callback.size == 0) {
        print("SHOULD MAKE CALLBACK");
        callback.invoke();
      }
      theFirst = val;
    }
    first.then_(update);
  }

  shared All<NewFirst|Element, NewFirst, Tuple<First|Element, First, Rest>> and<NewFirst>(Promise<NewFirst> newFirst) {
    return All(newFirst, this, count);
  }

  // void f(Tuple<First|Element, First, Rest> params)
  shared Promise<Tuple<First|Element, First, Rest>> all() {

    print("SIZE is " + count.string);
    Deferred<Tuple<First|Element, First, Rest>> deferred = Deferred<Tuple<First|Element, First, Rest>>();

    void fg() {
      value t = tuple();
      deferred.resolve(t);
    }
    Callback callback = Callback(count, fg);


    // Iterate all the promises
    setup(callback);


    return deferred.promise;
  }
}
