
var logAssert = function(assertMessage)
{
    console.log("************************************************************")
    console.log("ASSERT - " + assertMessage);
    console.log("************************************************************")
}

var logMessage = function(message)
{
    console.log("MESSAGE - " + message);
}

var logEvent = function(eventGroup, eventType, eventData)
{
    var eventGroupOutput = makeStringWithMinimumStringLength(eventGroup, 10);
    var eventTypeOutput = makeStringWithMinimumStringLength(eventType, 15);
    
    console.log(eventGroupOutput + " - " + eventTypeOutput + " : " + eventData);
}

var logNotYetImplemented = function()
{
    logMessage("Not Yet Implemented");
}