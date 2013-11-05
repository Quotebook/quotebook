var nextHashKey = 1;

var Object = function()
{
    var object =
    {
        hashKey: 0,
    
        getHashKey: function()
        {
            if (this.hashKey == 0)
            {
                this.hashKey = nextHashKey;
                nextHashKey = nextHashKey + 1;
            }
            
            return this.hashKey;
        },
        
        removeAllKeys: function()
        {
            for (var propertyName in this)
            {
                if (this.hasOwnProperty(propertyName))
                {
                    delete this[propertyName];
                    
                    this[propertyName] = null;
                }
            }
        }
    };
    
    return object;
};
