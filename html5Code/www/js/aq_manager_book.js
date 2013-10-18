var kBookManagerName = "manager-book";

var createBookManagerFunction = function(core)
{
    var manager = new Manager(kBookManagerName, core);
    
    return manager;
};

app.core.registerManager(kBookManagerName, createBookManagerFunction);
