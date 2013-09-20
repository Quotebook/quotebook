
var registerAppSplashMenu = function()
{
    var moduleName = "module-appSplashMenu";
    
    app.core.registerModule(moduleName, function(sandbox)
    {
        var module = new Module(moduleName, sandbox);
                        
        module.init = function()
        {
        };

        module.destroy = function()
        {
        };

        return module;
    });
};
