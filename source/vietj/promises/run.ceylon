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

  Deferred<String, Integer> d = Deferred<String, Integer>();
  Promise<String, Integer> p = d.promise;
  p.then___((String s) => print("done"), (Exception e) => print("failed"), (Integer p) => print("progress " + p.string));
  d.progress(1);
  Promise<String, String> p2 = p.then___((String s) => s, (Exception e) => "failed", (Integer p) => "->" + p.string);
  p2.then___((String s) => print("done 2"), (Exception e) => print("failed 2"), (String p) => print("progress 2 " + p.string));
  d.progress(2);
  d.reject(Exception());
  d.progress(3);
	
}
