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
by "Julien Viet"
license "ASL2"
void run() {
	
	Deferred<String> d1 = Deferred<String>();
	Deferred<Integer> d2 = Deferred<Integer>();
	Deferred<Boolean> d3 = Deferred<Boolean>();
	Deferred<Float> d4 = Deferred<Float>();
	Promise<String> p1 = d1.promise;
	Promise<Integer> p2 = d2.promise;
	Promise<Boolean> p3 = d3.promise;
	Promise<Float> p4 = d4.promise;
	
	void g(Boolean b, Integer i, String s) {
		print("Got " + b.string + " " + i.string + " " + s);
	}
	Thenable<[Boolean,Integer,String]> s = p1.and(p2).and(p3);
	s.then_(g);
	
	d1.resolve("a");
	d2.resolve(3);
	d3.resolve(true);
	
	value s1 = p1.and(p2);
	value s2 = p3.and(p4);
	value s3 = s1.and(s2.promise);
	
	void h([Float, Boolean] a1, Integer a2, String a3) {
		
	}
	s3.then_(h);
	
}
