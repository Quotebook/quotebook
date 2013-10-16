
var LocalDataStore = function (core)
{
    var dataHolderById = {};
    
    var localDataStore = new Object();
    
    // This store will hold all data objects by an ID
    // Will write and read serialized data objects
    // Views will get marked for update - which will cause a write at certain intervals.
    // This local data store will then get marked for update and send all data to the sql database
    
    localDataStore.writeAllData = function()
    {
        for (var dataId in dataHolderById)
        {
            if (dataId != "length" &&
                dataHolderById[dataId] != null)
            {
                var dataHolder = dataHolderById[dataId];
                
                if (dataHolder.needsUpdate == true)
                {
                    dataHolder.needsUpdate = false;
                    
                    logMessage("NotYetImplemented - localDataStore.writeAllData - for data with id " + dataId);
                }
            }
        }
    };
    
    localDataStore.createDataHolderForDataAndId = function(data, dataId)
    {
        if (dataHolderById[dataId] != null)
        {
            logAssert("DataHolder already exists for id: " + dataId);
        }
        
        var dataHolder = new Object();
        
        dataHolder.data = data;
        
        dataHolder.markForUpdate = function()
        {
            dataHolder.needsUpdate = true;
        };
        
        dataHolderById[dataId] = dataHolder;
    };
    
    localDataStore.getDataHolderById = function(dataId)
    {
        var dataHolder = dataHolderById[dataId];
        if (dataHolder == null)
        {
            logAssert("DataHolder for id does not exist: " + dataId);
        }
        return dataHolder;
    };
    
    return localDataStore;
};
