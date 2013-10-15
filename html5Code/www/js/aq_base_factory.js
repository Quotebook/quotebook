
var Factory = function()
{
    // -----------------------
    // DATA
    // -----------------------
    var classCreatorFunctionsByClassName = {};
    
    var factory = new Object();
    
    factory.registerClassByName = function(className, creatorFunctionArg)
    {
        if (classCreatorFunctionsByClassName[className] != null)
        {
            logAssert("factory.registerClassByName: for className=" + className + " creator function already registered");
            return;
        }
        
        classCreatorFunctionsByClassName[className] = creatorFunctionArg;
    };
    
    factory.createClassInstanceWithParameter = function(className, parameter)
    {
        var creatorFunction = classCreatorFunctionsByClassName[className];
        
        if (creatorFunction == null)
        {
            logAssert("core.createClassInstanceWithParameter: for className=" + className + " creator function doesn't exist");
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
    };
    
    factory.logAllRegisteredClasses = function()
    {
        for (var className in classCreatorFunctionsByClassName)
        {
            logEvent("FACTORY", "RegisteredClass", className);
        }
    };
    
    return factory;
};
