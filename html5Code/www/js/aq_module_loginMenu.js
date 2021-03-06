var kLoginMenuId_moduleName = "module-loginMenu";

var kLoginMenuId_textInput_email = "loginMenuId_textInput_email";
var kLoginMenuId_textInput_firstName = "loginMenuId_textInput_firstName";
var kLoginMenuId_textInput_lastName = "loginMenuId_textInput_lastName";
var kLoginMenuId_textInput_password = "loginMenuId_textInput_password";
var kLoginMenuId_textInput_confirm = "loginMenuId_textInput_confirm";

var createLoginMenuModuleFunction = function(sandbox)
{
    var module = new Module(kLoginMenuId_moduleName, sandbox);
    
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
        
        // DEBUG
        var DEBUG_useDefaultUser = function()
        {
            module.attemptCreateNewUser("defaultUser@test.com", "default", "user", "pass", "pass");
        }
        // !DEBUG
        
        module.clearAppBodyOnBuild();

        var appBody = module.getAppBody();

        appBody.addTextInput("E-mail", kLoginMenuId_textInput_email);
        appBody.addLineBreak();
        appBody.addPasswordInput("Password", kLoginMenuId_textInput_password);
        appBody.addLineBreak();
        appBody.addButton("Login", doneFunction);
        appBody.addButton("Create New Login", module.buildCreateNewLogin);
        
        // DEBUG
        appBody.addLineBreak();
        appBody.addLineBreak();
        appBody.addButton("(DEBUG)Use default user", DEBUG_useDefaultUser);
        // !DEBUG
        
        var appHeader = module.getAppHeader();
        appHeader.clearConfiguration();
        appHeader.configureTitle("Login");
        appHeader.configureLeftButton("Menu", sandbox.menuButtonAction);
    };
    
    module.buildCreateNewLogin = function()
    {
        var doneFunction = function()
        {
            var appBody = module.getAppBody();
            
            var email = appBody.getElementForId(kLoginMenuId_textInput_email).value;
            var firstName = appBody.getElementForId(kLoginMenuId_textInput_firstName).value;
            var lastName = appBody.getElementForId(kLoginMenuId_textInput_lastName).value;
            var password = appBody.getElementForId(kLoginMenuId_textInput_password).value;
            var confirm = appBody.getElementForId(kLoginMenuId_textInput_confirm).value;
            
            module.attemptCreateNewUser(email, firstName, lastName, password, confirm);
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
            module.postEvent("LoginSuccessful", userId);
        };
        
        var failureFunction = function(failureReason)
        {
            logAssert("Login failed. Reason: " + failureReason);
        };
        
        var loginRequest = new LoginRequest(name, password, successFunction, failureFunction);
        
        sandbox.getUserManager().attemptLogin(loginRequest);
    };
    
    module.attemptCreateNewUser = function(email, firstName, lastName, password, confirm)
    {
        var successFunction = function(userId)
        {
            logMessage("Create New User Successful");
            
            module.attemptLoginWithEmailAndPassword(email, password);
        };
        
        var failureFunction = function(failureReason)
        {
            logAssert("Create New User Failed. Reason: " + failureReason);
        };
        
        var request = new CreateNewUserRequest(email, firstName, lastName, password, confirm, successFunction, failureFunction);
        
        sandbox.getUserManager().createNewUser(request);
    };
    
    module.destroy = function()
    {
        module.clearAppBodyOnDestroy();
    };
    
    return module;
};

app.core.registerModule(kLoginMenuId_moduleName, createLoginMenuModuleFunction);
