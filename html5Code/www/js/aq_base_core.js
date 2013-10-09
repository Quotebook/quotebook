
var Event = function()
{
    return {
        callbacks: [],
        
        addCallback: function(callbackFunctionArg, callbackObjectArg)
        {
            var callback =
           {
               callbackObject: callbackObjectArg,
               callbackFunction: callbackFunctionArg,

               execute: function(eventData)
               {
                   this.callbackFunction(eventData);
               }
            };
           
            this.callbacks.push(callback);
        },
        
        executeCallbacks: function(eventData)
        {
            for (var i = 0; i < this.callbacks.length; ++i)
            {
                this.callbacks[i].execute(eventData);
            }
        },
        
        removeCallbacksForObject: function(object)
        {
            for (var i = this.callbacks.length - 1; i >= 0; --i)
            {    
                if (this.callbacks[i].callbackObject == object)
                {
                    this.callbacks.splice(i, 1);
                }
            }
        }
    };
};

var Core = function()
{
    // -----------------------
    // CORE DATA
    // -----------------------
    var coreData = {
        registeredModuleIds: [],
        moduleInstances: {},
    
        registeredServiceIds: [],
        serviceInstances: {},
    
        boundEventsByEventType: {},
        factory: new Factory()
    };

    return {
        
        // -----------------------
        // EVENTS
        // -----------------------
        
        // eventData = {
        //      type = "eventType"
        // }
        postEvent: function(eventData)
        {
            logEvent("CORE", "Post Event", "----- ----- ----- " + eventData.type + " vvvvv");
            logEvent("CORE", "", "");
            
            var currentLogPrefix = "";
            
            if (coreData.boundEventsByEventType[eventData.type] != null)
            {
                currentLogPrefix += "----- ";
                coreData.boundEventsByEventType[eventData.type].executeCallbacks(eventData);
                logEvent("CORE", "", "");
                logEvent("CORE", "Event Received", currentLogPrefix + " " + eventData.type + " ^^^^^");
            }
        },
        
        bindEventForListener: function(eventType, eventCallback, listener)
        {
            logEvent("CORE", "Bind Event", eventType);
            
            var event = coreData.boundEventsByEventType[eventType];

            if (event == null)
            {
                event = new Event();

                coreData.boundEventsByEventType[eventType] = event;
            }
            
            event.addCallback(eventCallback, listener);
        },
        
        bindEventsForListener: function(eventTypeList, eventCallback, listener)
        {
            for (eventType in eventTypeList)
            {
                this.bindEventForListener(eventTypeList, eventCallback, listener);
            }
        },
        
        unbindAllEventsForListener: function(listener)
        {
            for (eventType in coreData.boundEventsByEventType)
            {
                var event = coreData.boundEventsByEventType[eventType];

                event.removeCallbacksForObject(listener);
            }
        },
        
        unbindEventsForListener: function(eventTypeList, listener)
        {
            for (eventType in eventTypeList)
            {
                coreData.boundEventCallbacksByEventType[eventType].removeCallbacksForObject(listener);
            }
        },
        
        // -----------------------
        // SERVICES
        // -----------------------
        registerService: function(serviceId, creatorFunction)
        {
            coreData.registeredServiceIds.push(serviceId);
            coreData.factory.registerClassByName(serviceId, creatorFunction);
        },
        
        startAllRegisteredServices: function()
        {
            for (var i = 0; i < coreData.registeredServiceIds.length; ++i)
            {
                var serviceId = coreData.registeredServiceIds[i];
                
                if (coreData.serviceInstances[serviceId] != null)
                {
                    // Assert
                    return;
                }
                
                logEvent("CORE", "StartingService", serviceId);
                
                var serviceInstance = coreData.factory.createClassInstanceWithParameter(serviceId, this);
                
                serviceInstance.init();
                
                coreData.serviceInstances[serviceId] = serviceInstance;
            }
        },
        
        getServiceById: function(serviceId)
        {
            return coreData.serviceInstances[serviceId];
        },
        
        // -----------------------
        // MODULE
        // -----------------------
        registerModule: function(moduleId, creatorFunction)
        {
            coreData.registeredModuleIds.push(moduleId);
            coreData.factory.registerClassByName(moduleId, creatorFunction);
        },
        
        startModule: function(moduleId)
        {
            if (coreData.moduleInstances[moduleId] != null)
            {
                // Assert.
                return;
            }
            
            logEvent("CORE", "Starting Module", moduleId);
            
            var moduleInstance = coreData.factory.createClassInstanceWithParameter(moduleId, new Sandbox(this));
            
            moduleInstance.init();
            
            coreData.moduleInstances[moduleId] = moduleInstance;
        },
        
        stopModule: function(moduleId)
        {
            logEvent("CORE", "Stopping Module", moduleId);
            
            var moduleInstance = coreData.moduleInstances[moduleId];
            
            if (moduleInstance == null)
            {
                // Assert.
                return;
            }
            
            this.unbindAllEventsForListener(moduleInstance);
            
            moduleInstance.destroy();
            
            coreData.moduleInstances[moduleId] = null;
        },
        
        stopAllModules: function()
        {
            for (var moduleId in coreData.moduleInstances)
            {
                if (moduleId != "length")
                {
                logEvent("CORE", "StoppingModule", moduleId);
                this.unbindAllEventsForListener(coreData.moduleInstances[moduleId]);
                
                coreData.moduleInstances[moduleId].destroy();
                }
            }
            
            coreData.moduleInstances.length = 0;
        },
        
        // -----------------------
        // DATA
        // -----------------------
        registerClassByName: function(dataClassName, creatorFunction)
        {
            coreData.factory.registerClassByName(dataClassName, creatorFunction);
        },
        
        logAllRegisteredClasses: function()
        {
            coreData.factory.logAllRegisteredClasses();
        }
    };
};
