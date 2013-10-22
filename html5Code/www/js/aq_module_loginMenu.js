var kLoginMenuId_textInput_email = "loginMenuId_textInput_email";
var kLoginMenuId_textInput_firstName = "loginMenuId_textInput_firstName";
var kLoginMenuId_textInput_lastName = "loginMenuId_textInput_lastName";
var kLoginMenuId_textInput_password = "loginMenuId_textInput_password";
var kLoginMenuId_textInput_confirm = "loginMenuId_textInput_confirm";

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
        var doneFunction = function()
        {
            var appBody = module.getAppBody();
            var email = appBody.getElementForId(kLoginMenuId_textInput_email).value;
            var password = appBody.getElementForId(kLoginMenuId_textInput_password).value;
            module.attemptLoginWithEmailAndPassword(email, password);
        };
        
        module.clearAppBodyOnBuild();

        var appBody = module.getAppBody();

        appBody.addTextInput("E-mail", kLoginMenuId_textInput_email);
        appBody.addLineBreak();
        appBody.addPasswordInput("Password", kLoginMenuId_textInput_password);
        appBody.addLineBreak();
        appBody.addButton("Login", doneFunction);
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
            module.attemptLoginWithEmailAndPassword("caleb_fisher@yahoo.com", "pass");
        };
        
        var backFunction = function()
        {
            module.buildDefaultLogin();
        };
        
        module.clearAppBodyOnBuild();
        
        var appBody = module.getAppBody();
        
        appBody.addDiv("Basic info:");
        appBody.addTextInput("E-mail", kLoginMenuId_textInput_email);
        appBody.addLineBreak();
        appBody.addTextInput("First name", kLoginMenuId_textInput_firstName);
        appBody.addLineBreak();
        appBody.addTextInput("Last name", kLoginMenuId_textInput_lastName);
        appBody.addLineBreak();
        appBody.addLineBreak();
        appBody.addDiv("Create password:");
        appBody.addPasswordInput("Password", kLoginMenuId_textInput_password);
        appBody.addLineBreak();
        appBody.addPasswordInput("Confirm", kLoginMenuId_textInput_confirm);
        appBody.addLineBreak();
        appBody.addButton("Done", doneFunction);
        
        var appHeader = module.getAppHeader();
        appHeader.clearConfiguration();
        appHeader.configureTitle("Login");
        appHeader.configureLeftButton("Menu", sandbox.menuButtonAction);
        appHeader.configureRightButton("Back", backFunction);
    };
    
    module.attemptLoginWithEmailAndPassword = function(name, password)
    {
        var successFunction = function(userId)
        {
            module.postEvent("LoginSuccessful", "");
        };
        
        var failureFunction = function(failureReason)
        {
            logAssert("Login failed. Reason: " + failureReason);
        };
        
        sandbox.getUserManager().attemptLogin(new LoginRequest(name, password, successFunction, failureFunction));
    };
    
    module.destroy = function()
    {
        module.clearAppBodyOnDestroy();
    };
    
    return module;
};

app.core.registerModule(getLoginMenuModuleName(), createLoginMenuModuleFunction);
