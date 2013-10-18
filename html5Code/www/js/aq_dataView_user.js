var kDataType_user = "t_user";
var kDataKey_user_firstName = "u_ftn";
var kDataKey_user_lastName = "u_ltn";
var kDataKey_user_email = "u_eml";
var kDataKey_user_bookIds = "u_bki";
var kDataKey_user_password = "u_psw";

var CreateNewUserRequest = function(emailArg, firstNameArg, lastNameArg, passwordArg, confirmArg, successFunctionArg, failureFunctionArg)
{
    var request = new Request();
    
    request.email = emailArg;
    request.firstName = firstNameArg;
    request.lastName = lastNameArg;
    request.password = passwordArg;
    request.confirm = confirmArg;
    request.successFunction = successFunctionArg;
    request.failureFunction = failureFunctionArg;
    
    request.validate = function()
    {
        if (request.email == null ||
            //            request.email rangeOfString:@"@"].location == NSNotFound ||
            //            [email rangeOfString:@"."].location == NSNotFound ||
            request.firstName == null ||
            request.password != request.confirm)
        {
            return false;
        }
        return true;
    };
    
    request.buildDataForNewUser = function()
    {
        var data = {};
        
        data[kDataKey_user_firstName] = request.firstName;
        data[kDataKey_user_lastName] = request.lastName;
        data[kDataKey_user_email] = request.email;
        data[kDataKey_user_bookIds] = [];
        data[kDataKey_user_password] = request.password;
        
        return data;
    };
    
    return request;
};


var UserView = function(userDataHolder)
{
    var userView = new DataView(userDataHolder);
    
    userView.firstName = userDataHolder.valueForKey(kDataKey_user_firstName);
    userView.lastName = userDataHolder.valueForKey(kDataKey_user_lastName);
    userView.email = userDataHolder.valueForKey(kDataKey_user_email);
    userView.bookIds = userDataHolder.valueForKey(kDataKey_user_bookIds);
    
    return userView;
};
