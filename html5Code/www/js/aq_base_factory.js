
var Factory = function()
{
    // -----------------------
    // DATA
    // -----------------------
    var classCreatorFunctionsByClassName = {};
    
    return {
    simpleFunction: function() {
        console.log("factory simple");
    },
        registerClassByName: function(className, creatorFunctionArg)
        {   
            if (classCreatorFunctionsByClassName[className] != null)
            {
                // Assert.
                return;
            }
            
            classCreatorFunctionsByClassName[className] = creatorFunctionArg;
        },

        createClassInstance: function(className)
        {
            return this.createNamedInstanceWithParameter(className, null);
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
        }
    };
};
