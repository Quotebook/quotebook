
var Core = function()
{
    // -----------------------
    // CORE DATA
    // -----------------------
    var moduleInstances = {};

    var factory = new Factory();

    return {
        // -----------------------
        // MODULE
        // -----------------------
        simpleFunction: function() {},
        registerModule: function(moduleId, creatorFunction)
        {
            factory.registerClassByName(moduleId, creatorFunction);
        },
        
        startModule: function(moduleId)
        {
            var moduleInstance = factory.createClassInstanceWithParameter(moduleId, new Sandbox(this));
            
            moduleInstance.init();
            
            moduleInstances[moduleId] = moduleInstance;
        },
        
        stopModule: function(moduleId)
        {
            var moduleInstance = moduleInstances[moduleId];
            
            if (moduleInstance == null)
            {
                // Assert.
                return;
            }
            
            moduleInstance.destroy();
            
            moduleInstances[moduleId] = null;
        },
        
        // -----------------------
        // DATA
        // -----------------------
        
        registerClassByName: function(dataClassName, creatorFunction)
        {
            factory.registerClassByName(dataClassName, creatorFunction);
        },
        
        createNamedInstance: function(dataClassName)
        {
            return factory.createClassInstance(dataClassName);
        }
    };
};
