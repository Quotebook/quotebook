
var Sandbox = function (core)
{
    var sandbox = new Object();
    
    // -----------------------
    // EVENTS
    // -----------------------
    sandbox.postEvent = function(eventData)
    {
        core.postEvent(eventData);
    };
    
    sandbox.bindEventsForListener = function(eventTypeList, eventCallback, listener)
    {
        core.bindEventsForListener(eventTypeList, eventCallback, listener);
    };
    
    sandbox.unbindAllEventsForListener = function(listener)
    {
        core.unbindAllEventsForListener(listener);
    };
    
    sandbox.unbindEventsForListener = function(eventTypeList, listener)
    {
        core.unbindEventsForListener(eventTypeList, listener);
    };
    
    // -----------------------
    // MANAGERS
    // -----------------------
    sandbox.getDocumentManager = function()
    {
        return core.getManagerById(kDocumentManagerName);
    };
    
    sandbox.getUserManager = function()
    {
        return core.getManagerById(kUserManagerName);
    };
    
    sandbox.getBookManager = function ()
    {
        return core.getManagerById(kBookManagerName);
    };
    
    sandbox.getQuoteManager = function()
    {
        return core.getManagerById(kQuoteManagerName);
    };
    
    sandbox.menuButtonAction = function()
    {
        logNotYetImplemented();
    };
    
    // -----------------------
    // DATA VIEWS
    // -----------------------
    var getUserViewByUserId = function(userId)
    {
        var userDataHolder = core.getLocalDataStore().getDataHolderForTypeAndId(kDataType_user, userId);
        
        return new UserView(userDataHolder, userId);
    };
    
    var getBookViewByUserViewAndBookId = function(userView, bookId)
    {
        var bookDataHolder = core.getLocalDataStore().getDataHolderForTypeAndId(kDataType_book, bookId);
        
        return new BookView(bookDataHolder, bookId, userView);
    };
    
    var getQuoteViewByBookViewAndQuoteId = function(bookView, quoteId)
    {
        var quoteDataHolder = core.getLocalDataStore().getDataHolderForTypeAndId(kDataType_quote, quoteId);
        
        return new QuoteView(quoteDataHolder, quoteId, bookView);
    };
    
    return sandbox;
};
