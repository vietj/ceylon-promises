import java.util.concurrent.atomic { AtomicReference }

"The deferred class is the primary implementation of the [[Promise]] interface.
  
 The promise is accessible using the `promise` attribute of the deferred.
  
 The deferred can either be resolved or rejected via the `resolve` or `reject` methods. Both
 methods accept an argument or a promise to the argument, allowing the deferred to react
 on a promise."
by("Julien Viet")
shared class Deferred<Value>() satisfies Transitionnable<Value> & Promised<Value> {
    
    abstract class State() of ListenerState | PromiseState {
    }
    
    class ListenerState(Anything(Value) onFulfilled,
            Anything(Exception) onRejected,
            ListenerState? previous = null)
        extends State() {

        shared void update(Promise<Value> promise) {
            if (exists previous) {
                previous.update(promise);
            }
            promise.then_(onFulfilled, onRejected);
        }
    }
    
    class PromiseState(shared Promise<Value> promise) extends State() {
    }
    
    "The current state"
    AtomicReference<State?> state = AtomicReference<State?>(null);
    
    "The promise of this deferred."
    shared actual object promise extends Promise<Value>() {
        
        shared actual Promise<Result> then__<Result>(
                <Promise<Result>(Value)> onFulfilled, 
                <Promise<Result>(Exception)> onRejected) {
                
            Deferred<Result> deferred = Deferred<Result>();
            void callback<T>(<Promise<Result>(T)> on, T val) {
                try {
                    Promise<Result> result = on(val);
                    deferred.resolve(result);
                } catch(Exception e) {
                    deferred.reject(e);
                }
            }
            
            void onFulfilledCallback(Value val) {
                callback(onFulfilled, val);
            }
            void onRejectedCallback(Exception reason) {
                callback(onRejected, reason);
            }
            
            // 
            while (true) {
                State? current = state.get();
                switch (current)
                case (is Null) {
                    State next = ListenerState(onFulfilledCallback, onRejectedCallback);
                    if (state.compareAndSet(current, next)) {
                        break;
                    }
                }
                case (is ListenerState) {
                    State next = ListenerState(onFulfilledCallback,
                        onRejectedCallback, current);
                    if (state.compareAndSet(current, next)) {
                        break;
                    }
                }
                case (is PromiseState) {
                    current.promise.then_(onFulfilledCallback, onRejectedCallback);
                    break;
                }
            }
            return deferred.promise;
        }
    }
        
    void update(Promise<Value> promise) {
        while (true) {
            State? current = state.get();    
            switch (current) 
            case (is Null) {
                PromiseState next = PromiseState(promise);	
                if (state.compareAndSet(current, next)) {
                    break;  	
                }
            }
            case (is ListenerState) {
                PromiseState next = PromiseState(promise);	
                if (state.compareAndSet(current, next)) {
                    current.update(promise);
                    break;  	
                }
            }
            case (is PromiseState) {
                break;
            }
        }
    }

    shared actual void resolve(Value|Promise<Value> val) {
        Promise<Value> adapted = adaptValue<Value>(val);
        update(adapted);
    }

    shared actual void reject(Exception reason) {
        Promise<Value> adapted = adaptReason<Value>(reason);
        update(adapted);
    }

}