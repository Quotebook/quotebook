
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
