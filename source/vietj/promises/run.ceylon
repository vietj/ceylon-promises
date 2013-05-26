void run() {

  Deferred<Boolean> d1 = Deferred<Boolean>();
  Deferred<String> d2 = Deferred<String>();
  Deferred<Integer> d3 = Deferred<Integer>();
  Promise<Boolean> b1 = d1.promise;
  Promise<String> b2 = d2.promise;
  Promise<Integer> b3 = d3.promise;
  b1.and(b2).and(b3).all().then_(([Integer, String, Boolean] args) => print(args));
  d1.resolve(true);
  d2.resolve("abc");
  d3.resolve(4);

//  [String, Boolean] result = step.tuple();
//  print("-> ``result``");


  // Foo<Boolean, Boolean, []> a = first;

/*
  Deferred<Integer, Integer> deferred = Deferred<Integer, Integer>();
  Deferred<String, Exception> o = Deferred<String, Exception>();
  Promise<String, Exception> f1(Integer i) {
    return o.promise;
  }
  Promise<String, Exception> f2(Integer i) {
    throw Exception();
  }

  Promise<String, Exception> p2 = deferred.promise.then_<String>(f1, f2);

  void g1(String s) {
    print("Got result " + s);
  }
  void g2(Exception e) {
    print("Got failure");
  }

  p2.then_(g1, g2);

  print("Resolve");
  deferred.resolve(3);
  print("Resolved");
  o.resolve("bilto");
*/

}
