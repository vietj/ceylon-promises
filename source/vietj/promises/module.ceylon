@doc "A module that provides Promises/A+ semantics adapted to the Ceylon language.

      This implementation conforms to the [Promises/A+](https://github.com/promises-aplus/promises-tests) specification although
      it is not a formal implementation due to the adaptation to the Ceylon language and type system. However it attempts
      to respect the meaning of the specification and the same terminology.

      The modules provides:

      - the [[Promise]] interface conforming to the specification.
      - a [[Deferred]] type as implementation of the [[Promise]] interface.
      - the [[Status]] enumerated instance with the  [[pending]], [[fulfilled]] and [[rejected]] instances.

      Differences with the original specification:

      - the *then must return before onFulfilled or onRejected is called* is not implemented, therefore the invocation
      occurs inside the invocation of then.
      - the *Promise Resolution Procedure* is implemented for objects or promises but not for *thenable* as it requires
      a language with dynamic typing.

      For more

"
module vietj.promises '0.1.0' {
}
