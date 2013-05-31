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
doc "A promise must be in one of three states: pending, fulfilled, or rejected." 
by "Julien Viet"
license "ASL2"
shared abstract class Status(shared String name) of pending | fulfilled | rejected {}

doc "When pending, a promise may transition to either the fulfilled or rejected state."
by "Julien Viet"
license "ASL2"
shared object pending extends Status("Pending") {}

doc "When fulfilled, a promise must not transition to any other state and must have a value, which must not change."
by "Julien Viet"
license "ASL2"
shared object fulfilled extends Status("Fulfilled") {}

doc "When rejected, a promise must not transition to any other state and must have a reason, which must not change."
by "Julien Viet"
license "ASL2"
shared object rejected extends Status("Rejected") {}

