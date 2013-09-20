
var Module = function(moduleName, sandbox)
{
    logEvent("MODULE", "Creation", moduleName);
    
    return {
        init: function() {},
        
        destroy: function() {},
        
        bindEvent: function(eventTypes, eventCallback)
        {
            sandbox.bindEventsForListener(eventTypes, eventCallback, this);
        },
        
        unbindEvent: function(eventTypes)
        {
            sandbox.unbindEventForListener(eventTypes, this);
        },
        
        unbindAllEvents: function()
        {
            sandbox.unbindAllEventsForListener(this);
        }
    };
};
