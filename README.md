# Promises/A+ for Ceylon

A module that provides Promises/A+ semantics adapted to the Ceylon language.

This implementation conforms to the [Promises/A+](https://github.com/promises-aplus/promises-tests) specification although
it is not a formal implementation due to the adaptation to the Ceylon language and type system. However it attempts
to respect the meaning of the specification and the same terminology.

The modules provides:

- the Promise interface conforming to the specification.
- a Deferred type as implementation of the Promise interface.
- the Status enumerated instance with the pending, fulfilled and rejected instances.
- the [[And]] conjonction for combining promises into a conjonctive promise.

Differences with the original specification:

- the *then must return before onFulfilled or onRejected is called* is not implemented, therefore the invocation
occurs inside the invocation of then.
- the *Promise Resolution Procedure* is implemented for objects or promises but not for *thenable* as it requires
a language with dynamic typing.

# Overview

## Created a promise and resolving it

    value deferred = Deferred<String>();
    deferred.promise.then_((String s) => print("Resolved with ``s``"));
    deferred.resolve("foo");

## Created a promise and rejecting it

    value deferred = Deferred<String>();
    deferred.promise.then_((String s) => print("Resolved with ``s``"), (Exception reason) => print("Failed));
    deferred.reject(Exception());

## Chaining promises

    value deferred = Deferred<Integer>();
    deferred.promise.then_((Integer i) => i.string).then_((String s) => print("Resolved with ``s``"));
    deferred.resolve(5);

## Combining promises in a conjonction

    value d1 = Deferred<String>();
    value d2 = Deferred<Integer>();
    d1.and(d2).promise.then_(([Integer, String] arg) => print("Resolved with ``arg``"));
    d1.resolve("foo");
    d2.resolve(5);

## Returning a promise from an handler

    value d1 = Deferred<Integer>();
    value d2 = Deferred<String>();
    Promise<String> f(Integer i) {
      return d2;
    }
    d1.promise.then_(d2).then_((String s) => print("Resolved with ``s``"));
    d1.resolve(5);
    d2.resolve("foo");

## Resolving a deferred with a promise

    value d1 = Deferred<String>();
    value d2 = Deferred<String>();
    d1.promise.then_((String s) => print("Resolved with ``s``"));
    d1.resolve(d2);
    d2.resove("foo");
