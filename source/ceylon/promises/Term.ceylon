"A term allows a [[Thenable]] to be combined with a promise to form a new term."
by("Julien Viet")
shared interface Term<out Element, out T>
        satisfies Thenable<T>
            given T satisfies Element[] {
	
	"Combine the current thenable with a provided promise and return an [[Term]] object that
        - resolves when both the current thenable and the other promise are resolved
        - rejects when the current thenable or the other promise is rejected
    
    The [[Term]] promise will be
        - resolved with a tuple of values of the original promises. It is important to notice that
          tuple elements are in reverse order of the and chain
        - rejected with the reason of the rejected promise
    
    The returned [[Term]] object allows for promise chaining as a fluent API:
        
        Promise<String> p1 = ...
        Promise<Integer> p2 = ...
        Promise<Boolean> p3 = ...
        p1.and(p2, p3).then_((Boolean b, Integer i, String s) => doSomething(b, i, s));"
    shared formal Term<Element|Other, Tuple<Element|Other, Other, T>> and<Other>(Promise<Other> other);

}