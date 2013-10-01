var splashMenuHTML = " \
<div class=\"splashBackground\"> \
</div> \
";


var registerAppSplashMenu = function()
{
    var moduleName = "module-appSplashMenu";
    
    var moduleFunction = function(sandbox)
    {
        var module = new Module(moduleName, sandbox);
        
        module.init = function()
        {
            var appBody = document.getElementById("appBody");
            appBody.innerHTML = "<div class=\"splashBackground\"></div>";
        };
        
        module.destroy = function()
        {
        };
        
        return module;
    };
    
    app.core.registerModule(moduleName, moduleFunction);
};
