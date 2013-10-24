
var DataHolder = function(data, dataId)
{
    var dataHolder = new Object();
    
    dataHolder.dataId = dataId;
    dataHolder.data = data;
    dataHolder.needsUpdate = true;
    
    dataHolder.valueForKey = function(key)
    {
        var value = data[key];
        if (value == null)
        {
            logAssert("Value for key not found. Key: " + key + ". DataId: " + dataId + ". Data: " + data);
        }
        
        return value;
    };
    
    dataHolder.markForUpdate = function()
    {
        dataHolder.needsUpdate = true;
    };
    
    return dataHolder;
};

var DataView = function(dataHolder)
{
    var dataView = new Object();
    
    dataView.dataHolder = dataHolder;
    
    dataView.getDataId = function()
    {
        return dataHolder.dataId;
    };
    
    dataView.markForUpdate = function()
    {
        dataHolder.markForUpdate();
    }

    return dataView;
};
