var kQuoteManagerName = "manager-quote";

var createQuoteManagerFunction = function(core)
{
    var manager = new Manager(kQuoteManagerName, core);
    
    // example
//    manager.addQuoteToBook = function(quoteView, bookView)
//    {
//        // get userDataHolder
//        // mutate data
//        // mark for update
//        var quoteDataHolder = quoteView.createDataHolder(core, bookView);
//        
//        var bookDataHolder = bookView.getDataHolder(core);
//    };
    
    return manager;
};

app.core.registerManager(kQuoteManagerName, createQuoteManagerFunction);
