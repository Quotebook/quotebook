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
            var data = createNewQuoteRequest.buildDataForNewQuoteAtIndex(i);

            var quoteId = manager.createNextQuoteIdForBookView(bookView);

            var quoteDataHolder = core.getLocalDataStore().createDataHolderForDataAndTypeAndId(data, kDataType_quote, quoteId);

            var quoteView = new QuoteView(quoteDataHolder);

            if (previousQuoteView != null)
            {
                quoteView.setParentQuoteId(previousQuoteView.dataId);

                previousQuoteView.setChildQuoteId(quoteId);
            }
            else
            {
                bookView.addQuoteId(quoteId);
            }
            
            if (firstQuoteView == null)
            {
                firstQuoteView = quoteView;
            }

            previousQuoteView = quoteView;
        }

        if (firstQuoteView == null)
        {
            createNewQuoteRequest.failureFunction("No quotes created");
        }
        
        createNewQuoteRequest.successFunction(firstQuoteView);
    };
    
    manager.createNextQuoteIdForBookView = function(bookView)
    {
        temp_quoteIdGenerator++;

        var quoteId = "q_" + temp_quoteIdGenerator + "_" + bookView.getDataId();

        logEvent("QUOTE", "CreateNextQuoteId", quoteId);

        return quoteId;
    };
    
    return manager;
};

app.core.registerManager(kQuoteManagerName, createQuoteManagerFunction);
