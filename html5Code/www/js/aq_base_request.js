
var Request = function()
{
    var request = new Object();
    
    return request;
};

var LoginRequest = function(emailArg, passwordArg, successFunctionArg, failureFunctionArg)
{
    var request = new Request();

    request.email = emailArg;
    request.password = passwordArg;
    request.successFunction = successFunctionArg;
    request.failureFunction = failureFunctionArg;
    
    return request;
};