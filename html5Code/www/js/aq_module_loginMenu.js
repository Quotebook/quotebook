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
        module.clearAppBodyOnBuild();

        var appBody = module.getAppBody();

        appBody.addTextInput("E-mail");
        appBody.addLineBreak();
        appBody.addPasswordInput("Password");
        appBody.addLineBreak();
        appBody.addButton("Login", module.attemptLogin);
        appBody.addButton("Create New Login", module.buildCreateNewLogin);
        
        var appHeader = module.getAppHeader();
        appHeader.clearConfiguration();
        appHeader.configureTitle("Login");
        appHeader.configureLeftButton("Menu", sandbox.menuButtonAction);
    };
    
    module.buildCreateNewLogin = function()
    {
        var doneFunction = function()
        {
            module.attemptLogin();
        };
        
        var backFunction = function()
        {
            module.buildDefaultLogin();
        };
        
        module.clearAppBodyOnBuild();
        
        var appBody = module.getAppBody();
        
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
        appBody.addButton("Done", doneFunction);
        
        var appHeader = module.getAppHeader();
        appHeader.clearConfiguration();
        appHeader.configureTitle("Login");
        appHeader.configureLeftButton("Menu", sandbox.menuButtonAction);
        appHeader.configureRightButton("Back", backFunction);
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
        
        sandbox.getUserManager().attemptLogin(new LoginRequest("caleb", "password", successFunction, failureFunction)); // send data
    };
    
    module.destroy = function()
    {
        module.clearAppBodyOnDestroy();
    };
    
    return module;
};

app.core.registerModule(getLoginMenuModuleName(), createLoginMenuModuleFunction);
