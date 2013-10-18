
var LocalDataStore = function()
{
    var dataHolderGroupsByType = new Object();
    
    dataHolderGroupsByType.groups = {};
    
    dataHolderGroupsByType.doesDataHolderExistForTypeAndId = function(dataType, dataId)
    {
        var dataHolderGroup = dataHolderGroupsByType.groups[dataType];

        if (dataHolderGroup == null)
        {
            return false;
        }

        return dataHolderGroup[dataId] != null;
    };
    
    dataHolderGroupsByType.getDataHolderForTypeAndId = function(dataType, dataId)
    {
        var dataHolderGroup = dataHolderGroupsByType.groups[dataType];
        
        if (dataHolderGroup == null)
        {
            logAssert("DataHolderGroup does not exist for type: " + dataType);
            return null;
        }
        
        var dataHolder = dataHolderGroup[dataId];
        
        if (dataHolder == null)
        {
            logAssert("DataHolder does not exist for id : " + dataId + "  and type: " + dataType);
            return null;
        }
        
        return dataHolder;
    };
    
    dataHolderGroupsByType.addDataHolder = function(dataHolder, dataType, dataId)
    {
        var dataHolderGroup = dataHolderGroupsByType.groups[dataType];
        
        if (dataHolderGroup == null)
        {
            dataHolderGroup = {}
            dataHolderGroupsByType.groups[dataType] = dataHolderGroup;
        }
        
        if (dataHolderGroup[dataId] != null)
        {
            logAssert("DataHolder already exists for id: " + dataId + " and type: " + dataType);
            logMessage("DataHolder not created");
            return;
        }
        
        dataHolderGroup[dataId] = dataHolder;
    };
    
    dataHolderGroupsByType.getDataIdsForTypeAndFilter = function(dataType, dataViewFilter)
    {
        var filteredDataIds = [];
        
        var dataHolderGroup = dataHolderGroupsByType.groups[dataType];
        
        if (dataHolderGroup != null)
        {
            for (var dataId in dataHolderGroup)
            {
                dataHolder = dataHolderGroup[dataId];
                
                if (dataViewFilter(dataHolder) == true)
                {
                    filteredDataIds.push(dataHolder.dataId);
                }
            }
        }
        
        return filteredDataIds;
    };
    
    // This store will hold all data objects by an ID
    // Will write and read serialized data objects
    // Views will get marked for update - which will cause a write at certain intervals.
    // This local data store will then get marked for update and send all data to the sql database

    var localDataStore = new Object();
    
    localDataStore.getDataHolderForTypeAndId = function(dataType, dataId)
    {
        return dataHolderGroupsByType.getDataHolderForTypeAndId(dataType, dataId);
    };
    
    localDataStore.writeAllData = function()
    {
        for (var dataType in dataHolderGroupsByType)
        {
            if (dataType != "length" &&
                dataHolderGroupsByType[dataType] != null)
            {
                var dataHolderGroup = dataHolderGroupsByType[dataType];
                for (var dataId in dataHolderGroup)
                {
                    if (dataId != "length" &&
                        dataHolderGroup[dataId] != null)
                    {
                        var dataHolder = dataHolderGroup[dataId];
                        
                        if (dataHolder.needsUpdate == true)
                        {
                            dataHolder.needsUpdate = false;
                            
                            logMessage("NotYetImplemented - localDataStore.writeAllData - for data with id " + dataId);
                        }
                    }
                }
            }
        }
    };
    
    localDataStore.createDataHolderForDataAndTypeAndId = function(data, dataType, dataId)
    {
        if (dataHolderGroupsByType.doesDataHolderExistForTypeAndId(dataType, dataId))
        {
            logAssert("DataHolder already exists for id: " + dataId + " and type: " + dataType);
            logMessage("DataHolder not created");
            return;
        }
        
        var dataHolder = new DataHolder(data, dataId);
        
        dataHolderGroupsByType.addDataHolder(dataHolder, dataType, dataId);
        
        return dataHolder;
    };
    
    localDataStore.getDataIdsForTypeAndFilter = function(dataType, dataViewFilter)
    {
        return dataHolderGroupsByType.getDataIdsForTypeAndFilter(dataType, dataViewFilter);
    };
    
    return localDataStore;
};
