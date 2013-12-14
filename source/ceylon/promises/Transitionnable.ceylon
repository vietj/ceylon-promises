"Something that can through a transition and is meant to be be resolved or rejected"
by("Julien Viet")
shared interface Transitionnable<in Value> {

    "Resolves the promise with a value or a promise to the value."
    shared formal void resolve(<Value|Promise<Value>> val);
    
    "Rejects the promise with a reason."
    shared formal void reject(Exception reason);

}