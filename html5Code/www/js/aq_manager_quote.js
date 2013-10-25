var kQuoteManagerName = "manager-quote";

var temp_quoteIdGenerator = 0;

var createQuoteManagerFunction = function(core)
{
    var manager = new Manager(kQuoteManagerName, core);
    
    manager.createNewQuote = function(createNewQuoteRequest)
    {
        var bookView = createNewQuoteRequest.bookView;

        if (createNewQuoteRequest.validate() == false)
        {
            createNewQuoteRequest.failureFunction("Request did not validate");
            return;
        }
        
        var firstQuoteView = null;
        var previousQuoteView = null;

        for (var i = 0; i < createNewQuoteRequest.quoteLineCount(); ++i)
        {
                   logMessage("34");
            var data = createNewQuoteRequest.buildDataForNewQuoteAtIndex(i);
                   logMessage("33");
            var quoteId = manager.createNextQuoteIdForBookView(bookView);
                   logMessage("32");
            var quoteDataHolder = core.getLocalDataStore().createDataHolderForDataAndTypeAndId(data, kDataType_quote, quoteId);
                   logMessage("31");
            var quoteView = new QuoteView(quoteDataHolder);
            
            if (previousQuoteView != null)
            {
        logMessage("4");
                quoteView.setParentQuoteId(previousQuoteView.dataId);
                
                previousQuoteView.setChildQuoteId(quoteId);
            }
            else
            {
        logMessage("5");
                bookView.addQuoteId(quoteId);
            }
            
            if (firstQuoteView == null)
            {
        logMessage("6");
                firstQuoteView = quoteView;
            }
        logMessage("7");
            previousQuoteView = quoteView;
        }
                logMessage("8");
        if (firstQuoteView == null)
        {
            createNewQuoteRequest.failureFunction("No quotes created");
        }
        
        createNewQuoteRequest.successFunction(firstQuoteView);
    };
    
    manager.createNextQuoteIdForBookView = function(bookView)
    {
        temp_quoteIdGenerator++;
        
        var quoteId = "q_" + temp_quoteIdGenerator + "_" + bookView.dataId;
        
        logEvent("QUOTE", "CreateNextQuoteId", quoteId);
        
        return quoteId;
    };
    
    return manager;
};

app.core.registerManager(kQuoteManagerName, createQuoteManagerFunction);
