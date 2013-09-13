
var Factory = function()
{
    // -----------------------
    // DATA
    // -----------------------
    var classCreatorFunctionsByClassName = {};
    var classBucketsByClassName = {};
    
    return
    {
        registerClassByName: function(className, creatorFunctionArg)
        {
            this.registerClassByNameWithMaxInstanceCount(className, creatorFunctionArg, -1);
        },
        
        registerClassByNameWithMaxInstanceCount: function(className, creatorFunctionArg, maxInstanceCountArg)
        {
            if (maxInstanceCountArg == 0 || maxInstanceCountArg < -1)
            {
                // Assert.
                return;
            }
            
            if (classCreatorFunctionsByClassName[className] != null)
            {
                // Assert.
                return;
            }
            
            classCreatorFunctionsByClassName[className] =
            {
                creatorFunction: creatorFunctionArg,
                maxInstanceCount: maxInstanceCountArg
            };
        },

        createNamedInstance: function(className, instanceName)
        {
            return this.createNamedInstanceWithParameter(className, instanceName, null);
        },
    
        createNamedInstanceWithParameter: function(className, instanceName, paramter)
        {
            var creatorFunction = classCreatorFunctionsByClassName[className];
            
            if (creatorFunction == null)
            {
                // Assert.
                return null;
            }
            
            var classBucket = classBucketsByClassName[className];
            
            if (classBucket == null)
            {
                classBucket =
                {
                    size: function()
                    {
                        var count = 0;
                        for (var key in this)
                        {
                            if (this.hasOwnProperty(key))
                            {
                                count++;
                            }
                        }
                        return count;
                    }
                }
                classBucketsByClassName[className] = classBucket;
            }
            else
            {
                if (classBucket.size() >= creatorFunction.maxInstanceCount &&
                    creatorFunction.maxInstanceCount != -1)
                {
                    // Assert.
                    return null;
                }
                
                if (classBucket[instanceName] != null)
                {
                    // Assert.
                    return null;
                }
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

            classBucket[instanceName] = classInstance;
            
            return classInstance;
        },
        
        getInstanceByName: function(className, instanceName)
        {
            var classBucket = classBucketsByClassName[className];
            
            if (classBucket == null)
            {
                // Assert.
                return null;
            }
            
            var classInstance = classBucket[instanceName];
            
            if (classInstance == null)
            {
                // Assert.
                return null;
            }
            
            return classInstance;
        }
    };
};
