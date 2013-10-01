
var registerUserMenu = function()
{
    var moduleName = "module-userMenu";
    
    var moduleFunction = function(sandbox)
    {
        var module = new Module(moduleName, sandbox);
        
        module.init = function()
        {
            module.build();
        };
        
        module.destroy = function()
        {
        };
        
        module.build = function()
        {
            var appBody = sandbox.getAppBody();
            
            var page_break = document.createElement("br");
            
            var button_login = document.createElement("button");
            button_login.onclick = module.login;
            button_login.appendChild(document.createTextNode("Add new Quote!"));
            
            var button_createNewLogin = document.createElement("button");
            button_createNewLogin.appendChild(document.createTextNode("Invite a friend!"));
            button_createNewLogin.onclick = module.createNewLogin;
            
            appBody.appendChild(button_login);
            appBody.appendChild(page_break);
            appBody.appendChild(button_createNewLogin);
        };
        
        return module;
    };
    
    app.core.registerModule(moduleName, moduleFunction);
};
