
var Core = function()
{
    // -----------------------
    // CORE DATA
    // -----------------------
    var moduleData = {};
    var factory = new Factory();
    
    return
    {
        // -----------------------
        // MODULE
        // -----------------------
        
        registerModule: function(moduleId, creatorFunction)
        {
            factory.registerClassByName(moduleId, creatorFunction);
        },
        
        startModule: function(moduleId)
        {
            var moduleInstance = factory.createNamedInstanceWithParameter(moduleId, "instance", new Sandbox(this));
            
            moduleInstance.init();
            
            moduleData[moduleId] = moduleInstance;
        },
        
        stopModule: function(moduleId)
        {
            var moduleDataInstance = moduleData[moduleId];
            
            if (moduleDataInstance == null)
            {
                // Assert.
                return;
            }
            if (moduleDataInstance.instance == null)
            {
                // Assert.
                return;
            }
            moduleDataInstance.instance.destroy();
            
            moduleDataInstance.instance = null;
        },
        
        // -----------------------
        // DATA
        // -----------------------
        
        registerClassByName: function(dataClassName, creatorFunction)
        {
            factory.registerClassByName(dataClassName, creatorFunction);
        },
        
        createNamedInstance: function(dataClassName, instanceName)
        {
            return factory.createNamedInstance(dataClassName, instanceName);
        },
        
        getInstanceByName: function(dataClassName, instanceName)
        {
            return factory.getInstanceByName(dataClassName, instanceName);
        }
    };
};
