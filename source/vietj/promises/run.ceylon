




Tuple<First|RestElement,First,Rest> compose<First,Rest,RestElement>(First t, Rest rest) given Rest satisfies RestElement[] {
  return Tuple(t, rest);
}

shared class Bar<Element>(element){
    shared Element element;
}

shared class Foo<Element,First,Rest>(Bar<First> first, Rest rest)
 given First satisfies Element
 given Rest satisfies Element[]{

 //shared alias TupleType => Tuple<First|Element,First,Rest>;

 shared Tuple<First|Element,First,Rest> tuple = Tuple(first.element, rest);

 shared Foo<NewFirst|Element,NewFirst,Tuple<First|Element,First,Rest>> withLeading<NewFirst>(Bar<NewFirst> newFirst) => Foo(newFirst, tuple);

 shared void juu(void f(Tuple<First|Element,First,Rest> params)) => f(tuple);
}
void run() {


//  Tuple<String, String> t1 = ["a"];
//  Tuple<Integer|String, Integer, Tuple<String, String>> t2 = [4,"a"];
//  Tuple<Boolean|Integer|String, Boolean, Tuple<Integer|String, Integer, Tuple<String, String>>> t3 =[true,4,"a"];

//  Tuple<Boolean|Integer|String, Boolean, Tuple<Integer|String, Integer, Tuple<String, String>>> t = compose(true, t2);
//  print(t);

  //
  Bar<Boolean> b1 = Bar(true);
  Bar<String> b2 = Bar("hello");
  value first = Foo(b1, []);
  value step = first.withLeading(b2);
  value t = step.tuple;
  print(t);
  step.juu(([String, Boolean] params) => print(params));

  Foo<Boolean, Boolean, []> a = first;

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
