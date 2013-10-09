
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

var logEvent = function(eventGroup, eventType, eventData)
{
    var eventGroupOutput = makeStringWithMinimumStringLength(eventGroup, 10);
    var eventTypeOutput = makeStringWithMinimumStringLength(eventType, 15);
    
    console.log(eventGroupOutput + " - " + eventTypeOutput + " : " + eventData);
}