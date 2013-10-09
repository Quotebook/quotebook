
var Module = function(moduleName, sandbox)
{
    return {
        init: function() {},
        
        destroy: function() {},
        
        postEvent: function(eventTypeArg, eventDataArg)
        {
            var eventData = {
                type: eventTypeArg,
                eventData: eventDataArg
            };
            
            sandbox.postEvent(eventData);
        },
        
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
        },
        
        clearAppContentOnBuild: function()
        {
            sandbox.getAppBody().clearContent(moduleName + " on build");
        },
        
        clearAppContentOnDestroy: function()
        {
            sandbox.getAppBody().clearContent(moduleName + " on destroy");
        }
    };
};
