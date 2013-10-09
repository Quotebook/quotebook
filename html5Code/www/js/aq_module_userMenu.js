var getUserMenuModuleName = function()
{
    return "module-userMenu";
};

var createUserMenuModuleFunction = function(sandbox)
{
    var module = new Module(getUserMenuModuleName(), sandbox);
    
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
        
        appBody.clearContent(getUserMenuModuleName() + " build");
        
        appBody.addButton("Add new Quote!", module.buildForAddNewQuote);
        appBody.addLineBreak();
        appBody.addButton("Invite a friend!", null);
    };
    
    module.buildForAddNewQuote = function()
    {
        var appBody = sandbox.getAppBody();
        
        appBody.clearContent(getUserMenuModuleName() + " build");
        
        appBody.addDiv("Add new Quote:");
                appBody.addLineBreak();
        appBody.addTextInput("Who");
                appBody.addLineBreak();
        appBody.addTextInput("Quote");
                appBody.addLineBreak();
                appBody.addButton("Add Line", null);
                appBody.addLineBreak();
               appBody.addTextInput("Context");
                appBody.addLineBreak();
        appBody.addDiv("Oct 8, 2013 - 9:03am");
                appBody.addLineBreak();
                appBody.addButton("Preview", null);
                appBody.addLineBreak();
    }
    
    return module;
};

app.core.registerModule(getUserMenuModuleName(), createUserMenuModuleFunction);
