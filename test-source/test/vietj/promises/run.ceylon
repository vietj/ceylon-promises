import ceylon.test { ... }

void run() {

  suite("vietj.promises", "Deferred" -> deferredTests);
  suite("vietj.promises", "Promise" -> promiseTests);
  suite("vietj.then", "Then method" -> thenTests);
  suite("vietj.resolution", "Resolution Procedure" -> resolutionTests);

}
