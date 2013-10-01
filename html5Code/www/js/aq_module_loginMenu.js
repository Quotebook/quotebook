var loginHTML = " \
<div> \
<form> \
E-mail: <input type=\"text\" name=\"firstname\"><br> \
Password: <input type=\"password\" name=\"lastname\"> \
</form> \
<button type=\"button\" onclick=\"\">Login</button> \
<button type=\"button\" onclick=\"\">Create New Login</button> \
</div> \
";

var registerLoginMenu = function()
{
    var moduleName = "module-loginMenu";
    
    var moduleFunction = function(sandbox)
    {
        var module = new Module(moduleName, sandbox);
        
        module.init = function()
        {
            module.build();
                    };
        
        module.build = function()
        {
            var appBody = sandbox.getAppBody();
            
            var pageBreak1 = document.createElement("br");
            var pageBreak2 = document.createElement("br");
            
            var input_form = document.createElement("FORM");

            var input_form_email = document.createElement("INPUT");
            input_form_email.setAttribute('type', 'TEXT');
            input_form_email.name = 'myInput';
            input_form.appendChild(input_form_email);
            
            input_form.appendChild(pageBreak1);
            
            var input_form_password = document.createElement("INPUT");
            input_form_password.type = 'PASSWORD';
            input_form_password.name = 'myPassword';
            input_form.appendChild(input_form_password);
            
            var button_login = document.createElement("button");
            button_login.onclick = module.login;
            button_login.appendChild(document.createTextNode("Login"));
            
            var button_createNewLogin = document.createElement("button");
            button_createNewLogin.appendChild(document.createTextNode("Create New Login"));
            button_createNewLogin.onclick = module.createNewLogin;
            
            appBody.appendChild(input_form);
            appBody.appendChild(pageBreak2);
            appBody.appendChild(button_login);
            appBody.appendChild(button_createNewLogin);
        };
        
        module.login = function()
        {
            //module.postEvent("login");
            
            app.startUserMenu();
        };
        
        module.createNewLogin = function()
        {
           // module.postEvent("createNewLogin");
        };
        
        module.destroy = function()
        {
            logEvent("module", "asdf", "sdfds");
            var appBody = sandbox.getAppBody();
            appBody.innerHTML = "";
        };
        
        return module;
    };
    
    app.core.registerModule(moduleName, moduleFunction);
};
