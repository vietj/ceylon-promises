import ceylon.test { ... }

void testBasic() {
  assertEquals { expected = 0; actual = 1; };
}

shared void promisesTests() {
    testBasic();
}