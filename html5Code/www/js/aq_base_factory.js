
var Factory = function()
{
    // -----------------------
    // DATA
    // -----------------------
    var classCreatorFunctionsByClassName = {};
    
    return {
        registerClassByName: function(className, creatorFunctionArg)
        {   
            if (classCreatorFunctionsByClassName[className] != null)
            {
                // Assert.
                return;
            }
            
            classCreatorFunctionsByClassName[className] = creatorFunctionArg;
        },
    
        createClassInstanceWithParameter: function(className, parameter)
        {
            var creatorFunction = classCreatorFunctionsByClassName[className];

            if (creatorFunction == null)
            {
                // Assert.
                return null;
            }
            
            var classInstance = null;
            
            if (parameter == null)
            {
                classInstance = creatorFunction();
            }
            else
            {
                classInstance = creatorFunction(parameter);
            }
            
            return classInstance;
        },
        
        logAllRegisteredClasses: function()
        {
            for (var className in classCreatorFunctionsByClassName)
            {
                logEvent("FACTORY", "RegisteredClass", className);
            }
        }
    };
};
