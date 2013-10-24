var kBookManagerName = "manager-book";

var temp_bookIdGenerator = 0;

var createBookManagerFunction = function(core)
{
    var manager = new Manager(kBookManagerName, core);
    
    // TODO! - reimplement all these functions
    
    manager.createNewBookForUserView = function(createNewBookRequest)
    {
        var userView = createNewBookRequest.userView;
        
        if (createNewBookRequest.validate() == false)
        {
            createNewBookRequest.failureFunction("Request did not validate.");
            return;
        }
        
        var data = createNewBookRequest.buildDataForNewBook();
        
        var bookId = manager.createNextBookId();
        
        var bookDataHolder = core.getLocalDataStore().createDataHolderForDataAndTypeAndId(data, kDataType_book, bookId);

        userView.addBookId(bookId);
        
        createNewBookRequest.successFunction(new BookView(bookDataHolder, createNewBookRequest.userView));
    };
    
    manager.createNextBookId = function()
    {
        temp_bookIdGenerator++;
        
        var bookId = "b_" + temp_bookIdGenerator;
        
        logEvent("BOOK", "CreateNextBookId", bookId);
        
        return bookId;
    };
    
    return manager;
};

app.core.registerManager(kBookManagerName, createBookManagerFunction);
