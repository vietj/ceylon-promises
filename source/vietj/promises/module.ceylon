/*
 * Copyright 2013 Julien Viet
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
doc "A module that provides Promises/A+ semantics adapted to the Ceylon language.

     This implementation conforms to the [Promises/A+](https://github.com/promises-aplus/promises-tests) specification although
     it is not a formal implementation due to the adaptation to the Ceylon language and type system. However it attempts
     to respect the meaning of the specification and the same terminology.

     The modules provides:

     - the [[Thenable]] interface forming the ground of promises, implemented primarily by the [[Promise]] interface.
     - the [[Promise]] interface conforming to the specification, a promise is a [[Thenable]] for a single value.
     - the [[Deferred]] type providing support for the [[Promise]] interface.
     - the [[Status]] enumerated instance with the  [[pending]], [[fulfilled]] and [[rejected]] instances.
     - the [[Term]] interface for combining promises into a conjonction promise.

     # Goal
     
     If a function cannot return a value or throw an exception without blocking, it can return a promise instead. A promise is
     an object that represents the return value or the thrown exception that the function may eventually provide. A promise
     can also be used as a proxy for a remote object to overcome latency.
     
     # Usage
     
     ## Promise
     
     The [[Promise]] interface expose the `then_` method allowing interested parties to be notified when the promise makes
     a transition to the *fulfilled* or the *rejected* status:
     
         Promise<String> promise = getPromise();
         promise.then_(
             (String s) => print(\"The promise is resolved with \" + s),
             (Exception e) => print(\"The promise is rejected with \" + e.message));
     
     The first function is called the `onFulfilled` callback and the second function is called the `onRejected` callback. The 
     `onRejected` function is optional. 
     
     ## Deferred
     
     A [[Deferred]] object provides an implementation of the [[Promise]] interface and can be transitionned to a fulfillment
     or a reject resolution. It should remain private to the part of the code using it and only its promise should be visible.

     The [[Promise]] of a deferred can be retrieved with its `promise` field.
     
         value deferred = Deferred<String>();
         return deferred.promise;
     
     The [[Deferred]] object implements the [[Transitionnable]] interface which provides two methods for resolving the promise:
     
     - `resolve`: resolves the promise with a *value*
     - `reject`: rejects the promise with an *reason* of type `Exception`
     
     For example:
     
         value deferred = Deferred<String>();
         void doOperation() {
           try {
             String val = getValue();
             deferred.resolve(val);
           }
           catch(Exception e) {
             deferred.reject(e);
           }
         }
     
     ## Chaining promises
     
     When invoking the `then_` method the *onFulfilled* and *onRejected* callbacks can return a value. The `then_` method
     returns a new promise that will resolve with the value of the callback. This promise will be rejected if the callback
     invocation fails.
     
         Promise<Integer> promiseOfInteger = getPromiseOfInteger();
         Promise<String> promiseOfString = promiseOfInteger.then_((Integer i) => i.string);
         promiseOfString.then_((String s) => print(\"Completed with \" + s));
     
     or shorter
     
         getPromiseOfInteger().then_((Integer i) => i.string).then_((String s) => print(\"Completed with \" + s));
     
     ## Combining promises
     
     Promises can be combined into a single promise that is resolved when all the combined promises are resolved. If one
     of the promise is rejected then the combined promise is rejected.
     
         Promise<String> promiseOfInteger = getPromiseOfString();
         Promise<Integer> promiseOfString = getPromiseOfInteger();
         promiseOfInteger.and(promiseOfString).then_(
             (Integer i, String s) => print(\"All resolved\"),
             (Exception e) => print(\"One failed\"));
     
     There are two things to note here:
     - the order of the arguments in the callback is in reverse order of the chaining.
     - the return type of combined promise is not [[Promise]] but [[Thenable]].
     
     ## Callbacks
     
     Callbacks can have the type of the promise value or the `Exception` type, but they can also be a zero argument function
     when the value of the reason is not meaningful:
     
         promise.then_(() => print(\"fulfilled\"), () => print(\"rejected\"));
     
     ## Always
     
     The `always` method of a promise allows to be notified when the promise is fulfilled or rejected, it takes as argument
     of the callback an alternative of the promise value type and reason type:
     
         promise.always((String|Integer) p => print(\"done!\");
     
     Always is useful for implementing a finally clause in a chain of promise. The callback can also have zero parameter.
     
     ## Feeding with a promise
     
     Deferred can be transitionned with promises instead of a value:
     
         Deferred<String> deferred1 = getDeferred1();
         Deferred<String> deferred2 = getDeferred2();
         deferred1.resolve(deferred2);
     
     Similarly the callback can return a promise instead of a value:
     
         Deferred<String> deferred = Deferred<String>();
         promise.then__((String s) => deferred.promise);
     
     ## Thread safety
     
     The implementation is thread safe and use non blocking algorithm for maintaining the state of
     a deferred object.
     
     # Differences with the original specification:

     - the *then must return before onFulfilled or onRejected is called* is not implemented, therefore the invocation
     occurs inside the invocation of then.
     - the *Promise Resolution Procedure* is implemented for objects or promises but not for *thenable* as it requires
     a language with dynamic typing."
by "Julien Viet"
license "ASL2"
module vietj.promises '0.3.2' {
  import java.base '7';
}
