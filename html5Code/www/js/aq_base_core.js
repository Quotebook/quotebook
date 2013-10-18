
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
                if (this.callbacks[i].callbackObject.getHashKey() == object.getHashKey())
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
    
        registeredManagerIds: [],
        managerInstances: {},
    
        boundEventsByEventType: {},
        factory: new Factory(),
        localDataStore: new LocalDataStore(),
    };
    
    var core = new Object();
    
    
    
    // -----------------------
    // EVENTS
    // -----------------------
    
    // eventData = {
    //      type = "eventType"
    // }
    core.postEvent = function(eventData)
    {
        logEvent("CORE", "Post Event", "----- ----- ----- " + eventData.type + " vvvvv");
        logEvent("CORE", "", "");
        
        var currentLogPrefix = "";
        
        if (coreData.boundEventsByEventType[eventData.type] != null)
        {
            currentLogPrefix += "----- ";
            coreData.boundEventsByEventType[eventData.type].executeCallbacks(eventData);
            logEvent("CORE", "", "");
            logEvent("CORE", "Event Received", currentLogPrefix + eventData.type + " ^^^^^");
        }
    };
    
    core.bindEventForListener = function(eventType, eventCallback, listener)
    {
        logEvent("CORE", "Bind Event", eventType);
        
        var event = coreData.boundEventsByEventType[eventType];
        
        if (event == null)
        {
            event = new Event();
            
            coreData.boundEventsByEventType[eventType] = event;
        }
        
        event.addCallback(eventCallback, listener);
    };
    
    core.bindEventsForListener = function(eventTypeList, eventCallback, listener)
    {
        for (eventType in eventTypeList)
        {
            this.bindEventForListener(eventTypeList, eventCallback, listener);
        }
    };
    
    core.unbindAllEventsForListener = function(listener)
    {
        for (eventType in coreData.boundEventsByEventType)
        {
            var event = coreData.boundEventsByEventType[eventType];
            
            event.removeCallbacksForObject(listener);
        }
    };
    
    core.unbindEventsForListener = function(eventTypeList, listener)
    {
        for (eventType in eventTypeList)
        {
            coreData.boundEventCallbacksByEventType[eventType].removeCallbacksForObject(listener);
        }
    };
    
    // -----------------------
    // Managers
    // -----------------------
    core.registerManager = function(managerId, creatorFunction)
    {
        coreData.registeredManagerIds.push(managerId);
        coreData.factory.registerClassByName(managerId, creatorFunction);
    };
    
    core.startAllRegisteredManagers = function()
    {
        for (var i = 0; i < coreData.registeredManagerIds.length; ++i)
        {
            var managerId = coreData.registeredManagerIds[i];
            
            if (coreData.managerInstances[managerId] != null)
            {
                // Assert
                return;
            }
            
            logEvent("CORE", "StartingManager", managerId);
            
            var managerInstance = coreData.factory.createClassInstanceWithParameter(managerId, this);
            
            managerInstance.init();
            
            coreData.managerInstances[managerId] = managerInstance;
        }
    };
    
    core.getManagerById = function(managerId)
    {
        return coreData.managerInstances[managerId];
    };
    
    // -----------------------
    // MODULE
    // -----------------------
    core.registerModule = function(moduleId, creatorFunction)
    {
        coreData.registeredModuleIds.push(moduleId);
        coreData.factory.registerClassByName(moduleId, creatorFunction);
    };
    
    core.startModule = function(moduleId)
    {
        if (coreData.moduleInstances[moduleId] != null)
        {
            logAssert("core.startModule: module for moduleId=" + moduleId + " already exists");
            return;
        }
        
        logEvent("CORE", "Starting Module", moduleId);
        
        var moduleInstance = coreData.factory.createClassInstanceWithParameter(moduleId, new Sandbox(this));
        
        moduleInstance.init();
        
        coreData.moduleInstances[moduleId] = moduleInstance;
    };
    
    core.stopModule = function(moduleId)
    {
        logEvent("CORE", "Stopping Module", moduleId);
        
        var moduleInstance = coreData.moduleInstances[moduleId];
        
        if (moduleInstance == null)
        {
            logAssert("core.stopModule: module for moduleId=" + moduleId + " doesn't exists");
            return;
        }
        
        this.unbindAllEventsForListener(moduleInstance);
        
        moduleInstance.destroy();
        
        coreData.moduleInstances[moduleId] = null;
    }
    
    core.stopAllModules = function()
    {
        for (var moduleId in coreData.moduleInstances)
        {
            if (moduleId != "length" &&
                coreData.moduleInstances[moduleId] != null)
            {
                logEvent("CORE", "StoppingModule", moduleId);
                this.unbindAllEventsForListener(coreData.moduleInstances[moduleId]);
                
                coreData.moduleInstances[moduleId].destroy();
                delete coreData.moduleInstances[moduleId];
                coreData.moduleInstances[moduleId] = null;
                logEvent("CORE", "ModuleStopped", moduleId);
            }
        }
        
        coreData.moduleInstances.length = 0;
    };
    
    core.registerClassByName = function(dataClassName, creatorFunction)
    {
        coreData.factory.registerClassByName(dataClassName, creatorFunction);
    };
    
    core.logAllRegisteredClasses = function()
    {
        coreData.factory.logAllRegisteredClasses();
    };
    
    core.getLocalDataStore = function()
    {
        return coreData.localDataStore;
    };
    
    return core;
};
