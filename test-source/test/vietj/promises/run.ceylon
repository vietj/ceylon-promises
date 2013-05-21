import ceylon.test { ... }

void run() {

  suite("vietj.promises", "Deferred" -> deferredTests);
  suite("vietj.promises", "Promise" -> promiseTests);

}
