@doc "The state of a promises, a promise may be in one of the three states unfulfilled, fulfilled and failed."
shared abstract class Status(String name) of pending | done | failed { }

@doc "The pending promise state"
shared object pending extends Status("pending") {}

@doc "The done promise state"
shared object done extends Status("done") {}

@doc "The failed promise state"
shared object failed extends Status("failed") {}

