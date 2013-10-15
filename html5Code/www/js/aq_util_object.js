
var makeStringWithMinimumStringLength = function(stringData, stringLength)
{
    var stringDataOutput = stringData;
    var stringLengthDifference = stringLength - stringDataOutput.length;
    
    if (stringLengthDifference > 0)
    {
        for (var i = stringLengthDifference; i > 0; --i)
        {
            stringDataOutput = stringDataOutput + " ";
        }
    }
    return stringDataOutput;
}

var removeAllKeysFromObject = function(targetObject)
{
    for (var propertyName in targetObject)
    {
        if (targetObject.hasOwnProperty(propertyName))
        {
            logMessage("about to delete " + propertyName);
            delete targetObject[propertyName];
            
            targetObject[propertyName] = null;
            
            if (targetObject[propertyName] != null)
            {
                logMessage("wtf?");                
            }
        }
    }

}
