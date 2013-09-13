//
//console.log("Factory");
//
//var Factory = function()
//{
//    // -----------------------
//    // DATA
//    // -----------------------
//    var classCreatorFunctionsByClassName = {};
//    
//    return
//    {
//        registerClassByName: function(className, creatorFunctionArg)
//        {   
//            if (classCreatorFunctionsByClassName[className] != null)
//            {
//                // Assert.
//                return;
//            }
//            
//            classCreatorFunctionsByClassName[className] = creatorFunctionArg;
//        },
//
//        createClassInstance: function(className)
//        {
//            return this.createNamedInstanceWithParameter(className, null);
//        },
//    
//        createClassInstanceWithParameter: function(className, paramter)
//        {
//            var creatorFunction = classCreatorFunctionsByClassName[className];
//            
//            if (creatorFunction == null)
//            {
//                // Assert.
//                return null;
//            }
//            
//            var classInstance = null;
//            
//            if (parameter == null)
//            {
//                classInstance = creatorFunction();
//            }
//            else
//            {
//                classInstance = creatorFunction(parameter);
//            }
//            
//            return classInstance;
//        }
//    };
//};
