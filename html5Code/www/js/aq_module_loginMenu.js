var getLoginMenuModuleName = function()
{
    return "module-loginMenu";
};

var createLoginMenuModuleFunction = function(sandbox)
{
    var module = new Module(getLoginMenuModuleName(), sandbox);
    
    module.init = function()
    {
        module.buildDefaultLogin();
    };
    
    module.buildDefaultLogin = function()
    {
        var appBody = sandbox.getAppBody();
        
        module.clearAppContentOnBuild();
        
        appBody.addTextInput("E-mail");
        appBody.addLineBreak();
        appBody.addPasswordInput("Password");
        appBody.addLineBreak();
        appBody.addButton("Login", module.attemptLogin);
        appBody.addButton("Create New Login", module.buildCreateNewLogin);
    };
    
    module.buildCreateNewLogin = function()
    {
        var appBody = sandbox.getAppBody();
        
        module.clearAppContentOnBuild();
        
        appBody.addDiv("Basic info:");
        appBody.addTextInput("E-mail");
        appBody.addLineBreak();
        appBody.addTextInput("First name");
        appBody.addLineBreak();
        appBody.addTextInput("Last name");
        appBody.addLineBreak();
        appBody.addLineBreak();
        appBody.addDiv("Create password:");
        appBody.addPasswordInput("Password");
        appBody.addLineBreak();
        appBody.addPasswordInput("Confirm");
        appBody.addLineBreak();
        
        var doneFunction = function()
        {
            
        };
        
        appBody.addButton("Done", doneFunction);
    };
    
    module.attemptLogin = function()
    {
        var successFunction = function()
        {
            module.postEvent("LoginSuccessful", "");
        };
        
        var failureFunction = function()
        {
            module.postEvent("LoginFailed", "");            
        };
        
        sandbox.getUserService().attemptLogin(new LoginRequest("caleb", "password", successFunction, failureFunction)); // send data
    };
    
    module.destroy = function()
    {
        module.clearAppContentOnDestroy();
    };
    
    return module;
};

app.core.registerModule(getLoginMenuModuleName(), createLoginMenuModuleFunction);
