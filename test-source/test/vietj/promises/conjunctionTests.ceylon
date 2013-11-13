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
import vietj.promises { ... }
import ceylon.test { ... }
import ceylon.collection { ... }

test void testResolveConjonction() {
    value d1 = Deferred<String>();
    value d2 = Deferred<Integer>();
    value d3 = Deferred<Boolean>();
    value a = LinkedList<[Boolean, Integer, String]>();
    value b = LinkedList<Exception>();
    
    value and = d1.promise.and<Integer>(d2.promise).and<Boolean>(d3.promise);
    and.then_((Boolean b, Integer i, String s) => a.add([b,i,s]), b.add);
    assertEquals { expected = {}; actual = a; };
    assertEquals { expected = {}; actual = b; };
    
    d2.resolve(3);
    assertEquals { expected = {}; actual = a; };
    assertEquals { expected = {}; actual = b; };
    
    d3.resolve(true);
    assertEquals { expected = {}; actual = a; };
    assertEquals { expected = {}; actual = b; };
    
    d1.resolve("foo");
    assertEquals { expected = {[true, 3, "foo"]}; actual = a; };
    assertEquals { expected = {}; actual = b; };
}

test void testRejectConjonction() {
    
    class Test() {
        
        shared Deferred<String> d1 = Deferred<String>();
        shared Deferred<Integer> d2 = Deferred<Integer>();
        shared Deferred<Boolean> d3 = Deferred<Boolean>();
        shared LinkedList<[Boolean, Integer, String]> a = LinkedList<[Boolean, Integer, String]>();
        shared LinkedList<Exception> b = LinkedList<Exception>();
        
        value and = d1.promise.and<Integer>(d2.promise).and<Boolean>(d3.promise);
        and.then_((Boolean b, Integer i, String s) => a.add([b, i, s]), b.add);
    }

    value e = Exception();
    
    value t1 = Test();  
    assertEquals { expected = {}; actual = t1.a; };
    assertEquals { expected = {}; actual = t1.b; };
    t1.d1.reject(e);
    assertEquals { expected = {}; actual = t1.a; };
    assertEquals { expected = {e}; actual = t1.b; };
    
    value t2 = Test();  
    assertEquals { expected = {}; actual = t2.a; };
    assertEquals { expected = {}; actual = t2.b; };
    t2.d2.reject(e);
    assertEquals { expected = {}; actual = t2.a; };
    assertEquals { expected = {e}; actual = t2.b; };
    
    value t3 = Test();  
    assertEquals { expected = {}; actual = t3.a; };
    assertEquals { expected = {}; actual = t3.b; };
    t3.d3.reject(e);
    assertEquals { expected = {}; actual = t3.a; };
    assertEquals { expected = {e}; actual = t3.b; };
}

test void testNestedConjonctions() {

    value d1 = Deferred<String>();
    value d2 = Deferred<Integer>();
    value d3 = Deferred<Boolean>();
    value d4 = Deferred<Float>();

    Promise<String> p1 = d1.promise;
    Promise<Integer> p2 = d2.promise;
    Promise<Boolean> p3 = d3.promise;
    Promise<Float> p4 = d4.promise;
    
    value s1 = p1.and(p2);
    value s2 = p3.and(p4);
    value s3 = s1.and(s2.promise);

    value results = LinkedList<[[Float, Boolean], Integer, String]>();
    void h([Float, Boolean] a1, Integer a2, String a3) {
        results.add([a1, a2, a3]);
    }
    s3.then_(h);

    //
    d1.resolve("a");
    assertEquals({}, results);

    //
    d2.resolve(4);
    assertEquals({}, results);

    //
    d3.resolve(false);
    assertEquals({}, results);

    //
    d4.resolve(0.4);
    assertEquals({[[0.4, false], 4, "a"]}, results);

}
