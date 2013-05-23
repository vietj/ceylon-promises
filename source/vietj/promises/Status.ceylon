@doc "The state of a promises, a promise may be in one of the three states pending, fulfilled and rejected."
shared abstract class Status(String name) of pending | fulfilled | rejected { }

@doc "The pending promise state"
shared object pending extends Status("pending") {}

@doc "The fulfilled promise state"
shared object fulfilled extends Status("done") {}

@doc "The rejected promise state"
shared object rejected extends Status("rejected") {}

