void run() {


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

}
