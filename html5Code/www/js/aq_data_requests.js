
var Request = function(requestDataArg)
{
    var request = {
        requestData: requestDataArg
    };
    
    return request;
};

var LoginRequest = function(emailArg, passwordArg, successFunctionArg, failureFunctionArg)
{
    var requestData = {
        email: emailArg,
        password: passwordArg,
        successFunction: successFunctionArg,
        failureFunction: failureFunctionArg,
    };
    
    var request = new Request(requestData);
    
    request.executeSuccess = function()
    {
        requestData.successFunction();
    };

    request.executeFailure = function()
    {
        request.requestData.failureFunction();
    };
    
    return request;
};