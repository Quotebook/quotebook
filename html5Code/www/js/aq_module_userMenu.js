var getUserMenuModuleName = function()
{
    return "module-userMenu";
};

var createUserMenuModuleFunction = function(sandbox)
{
    var module = new Module(getUserMenuModuleName(), sandbox);
    
    module.init = function()
    {
        module.buildDefault();
    };
    
    module.destroy = function()
    {
    };
    
    module.buildDefault = function()
    {
        var logoutFunction = function()
        {
            module.postEvent("LogoutSuccessful", "");
        };
        
        module.clearAppBodyOnBuild();
        
        var appBody = module.getAppBody();
        
        appBody.addButton("Add new Quote!", module.buildForAddNewQuote);
        appBody.addLineBreak();
        appBody.addButton("Invite a friend!", module.buildForInviteAFriend);
        
        var appHeader = module.getAppHeader();
        appHeader.clearConfiguration();
        appHeader.configureTitle("Quotebooks");
        appHeader.configureLeftButton("Menu", sandbox.menuButtonAction);
        appHeader.configureRightButton("Logout", logoutFunction);
    };
    
    module.buildForAddNewQuote = function()
    {
        var backFunction = function()
        {
            module.buildDefault();
        };
        
        var previewFunction = function()
        {
            module.buildForPreviewNewQuote();
        };
        
        module.clearAppBodyOnEvent("content change");
        
        var appBody = module.getAppBody();
        
        appBody.addDiv("Add new Quote:");
        appBody.addLineBreak();
        appBody.addTextInput("Who");
        appBody.addLineBreak();
        appBody.addTextInput("Quote");
        appBody.addLineBreak();
        appBody.addButton("Add Line", logNotYetImplemented);
        appBody.addLineBreak();
        appBody.addTextInput("Context");
        appBody.addLineBreak();
        appBody.addDiv("Oct 8, 2013 - 9:03am");
        appBody.addLineBreak();
        appBody.addButton("Preview", previewFunction);
        appBody.addLineBreak();
        
        var appHeader = module.getAppHeader();
        appHeader.clearConfiguration();
        appHeader.configureTitle("Add New Quote");
        appHeader.configureLeftButton("Menu", sandbox.menuButtonAction);
        appHeader.configureRightButton("Back", backFunction);
    };
    
    module.buildForPreviewNewQuote = function()
    {
        var backFunction = function()
        {
            module.buildForAddNewQuote(); // pass the data back
        };
        
        var addTheQuoteFunction = function()
        {
            module.buildForViewingQuoteBook();
        };
        
        module.clearAppBodyOnEvent("content change");
        
        var appBody = module.getAppBody();
        
        appBody.addDiv("\"I said something funny!\"");
        appBody.addLineBreak();
        appBody.addLineBreak();
        appBody.addDiv("Caleb Fisher");
        appBody.addLineBreak();
        appBody.addLineBreak();
        appBody.addDiv("Oct 10, 2013 - 10:08am");
        appBody.addLineBreak();
        appBody.addLineBreak();
        appBody.addDiv("Re: true facts");
        appBody.addLineBreak();
        appBody.addLineBreak();
        appBody.addButton("Add The Quote", addTheQuoteFunction);
        
        var appHeader = module.getAppHeader();
        appHeader.clearConfiguration();
        appHeader.configureTitle("Preview Quote");
        appHeader.configureLeftButton("Menu", sandbox.menuButtonAction);
        appHeader.configureRightButton("Back", backFunction);
    };
    
    module.buildForViewingQuoteBook = function()
    {
        
    };
    
    module.buildForInviteAFriend = function()
    {
        var backFunction = function()
        {
            module.buildDefault();
        };
        
        module.clearAppBodyOnEvent("content change");
        
        var appBody = module.getAppBody();
        
        appBody.addDiv("Invite a friend:");
        appBody.addLineBreak();
        appBody.addTextInput("Who");
        appBody.addLineBreak();
        appBody.addButton("Invite", logNotYetImplemented);
        appBody.addLineBreak();
        
        var appHeader = module.getAppHeader();
        appHeader.clearConfiguration();
        appHeader.configureTitle("Invite A Friend");
        appHeader.configureLeftButton("Menu", sandbox.menuButtonAction);
        appHeader.configureRightButton("Back", backFunction);
    };
    
    return module;
};

app.core.registerModule(getUserMenuModuleName(), createUserMenuModuleFunction);
