
var Module = function(moduleName, sandbox)
{
    var module = new Object();
    
    module.init = function() {};
    
    module.destroy = function() {};
    
    // -----------------------
    // EVENTS
    // -----------------------
    module.postEvent = function(eventTypeArg, eventDataArg)
    {
        var eventData = {
        type: eventTypeArg,
        eventData: eventDataArg
        };
        
        sandbox.postEvent(eventData);
    };
    
    module.bindEvent = function(eventTypes, eventCallback)
    {
        sandbox.bindEventsForListener(eventTypes, eventCallback, this);
    };
    
    module.unbindEvent = function(eventTypes)
    {
        sandbox.unbindEventForListener(eventTypes, this);
    };
    
    module.unbindAllEvents = function()
    {
        sandbox.unbindAllEventsForListener(this);
    };
    
    // -----------------------
    // APP HEADER
    // -----------------------
    module.getAppHeader = function()
    {
        return sandbox.getDocumentManager().getAppHeader();
    };
    
    // -----------------------
    // APP CONTENT
    // -----------------------
    module.getAppBody = function()
    {
        return sandbox.getDocumentManager().getAppBody();
    };
    
    module.clearAppBodyOnBuild = function()
    {
        this.clearAppBodyOnEvent("build");
    };
    
    module.clearAppBodyOnEvent = function(eventName)
    {
        this.getAppBody().clearContent(moduleName + " on " + eventName);
    };
    
    module.clearAppBodyOnDestroy = function()
    {
        this.clearAppBodyOnEvent("destroy");
    };
    
    return module;
};
