
var Sandbox = function (core)
{
    var sandbox = new Object();
    
    // -----------------------
    // EVENTS
    // -----------------------
    sandbox.postEvent = function(eventData)
    {
        core.postEvent(eventData);
    };
    
    sandbox.bindEventsForListener = function(eventTypeList, eventCallback, listener)
    {
        core.bindEventsForListener(eventTypeList, eventCallback, listener);
    };
    
    sandbox.unbindAllEventsForListener = function(listener)
    {
        core.unbindAllEventsForListener(listener);
    };
    
    sandbox.unbindEventsForListener = function(eventTypeList, listener)
    {
        core.unbindEventsForListener(eventTypeList, listener);
    };
    
    // -----------------------
    // MANAGERS
    // -----------------------
    sandbox.getDocumentManager = function()
    {
        return core.getManagerById(kDocumentManagerName);
    };
    
    sandbox.getUserManager = function()
    {
        return core.getManagerById(kUserManagerName);
    };
    
    sandbox.getBookManager = function ()
    {
        return core.getManagerById(kBookManagerName);
    };
    
    sandbox.getQuoteManager = function()
    {
        return core.getManagerById(kQuoteManagerName);
    };
    
    sandbox.menuButtonAction = function()
    {
        logNotYetImplemented();
    };
    
    return sandbox;
};
