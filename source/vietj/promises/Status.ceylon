@doc "A promise must be in one of three states: pending, fulfilled, or rejected." 
shared abstract class Status(shared String name) of pending | fulfilled | rejected {}

@doc "When pending, a promise may transition to either the fulfilled or rejected state."
shared object pending extends Status("Pending") {}

@doc "When fulfilled, a promise must not transition to any other state and must have a value, which must not change."
shared object fulfilled extends Status("Fulfilled") {}

@doc "When rejected, a promise must not transition to any other state and must have a reason, which must not change."
shared object rejected extends Status("Rejected") {}

