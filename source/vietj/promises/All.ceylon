shared class All<Element, First, Rest>(Bar<First> first, Rest rest)
 given First satisfies Element
 given Rest satisfies Sequential<Element> {

  Tuple<First|Element, First, Rest> tuple = Tuple(first.element, rest);

  shared All<NewFirst|Element, NewFirst, Tuple<First|Element, First, Rest>> with<NewFirst>(Bar<NewFirst> newFirst) {
    return All(newFirst, tuple);
  }

  shared void juu(void f(Tuple<First|Element, First, Rest> params)) {
    f(tuple);
  }
}
