
@doc "Dispatch to the function the provided argument and return the result"
Return dispatch<Return, Argument>(Return(Argument)|Return() f, Argument arg) {
  if (is Return(Argument) f) {
  	return f(arg);
  } else if (is Return() f) {
    return f();  	
  } else {
  	throw Exception("Should not be called");
  }
}