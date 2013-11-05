var kDataType_quote = "t_quote";

var kDataKey_quote_creationDate = "q_cnd";
var kDataKey_quote_context = "q_cxt";
var kDataKey_quote_text = "q_txt";
var kDataKey_quote_who = "q_who";
var kDataKey_quote_bookId = "q_bid";
var kDataKey_quote_parentQuoteId = "q_pid";
var kDataKey_quote_childQuoteId = "q_cid";

var QuoteView = function(quoteDataHolder)
{
    var quoteView = new DataView(quoteDataHolder);

    quoteView.creationDate = quoteDataHolder.valueForKey(kDataKey_quote_creationDate);
    quoteView.context = quoteDataHolder.valueForKey(kDataKey_quote_context);
    quoteView.quoteText = quoteDataHolder.valueForKey(kDataKey_quote_text);
    quoteView.who = quoteDataHolder.valueForKey(kDataKey_quote_who);
    quoteView.bookId = quoteDataHolder.valueForKey(kDataKey_quote_bookId);
    quoteView.parentQuoteId = quoteDataHolder.valueForKey(kDataKey_quote_parentQuoteId);
    quoteView.childQuoteId = quoteDataHolder.valueForKey(kDataKey_quote_childQuoteId);
    
    quoteView.setParentQuoteId = function(quoteId)
    {
        quoteView.parentQuoteId = quoteId;
        quoteView.markForUpdate();
    };
    
    quoteView.setChildQuoteId = function(quoteId)
    {
        quoteView.childQuoteId = quoteId;
        quoteView.markForUpdate();
    };
    
    return quoteView;
};

var CreateNewQuoteRequest = function(quoteLinesArg, dateArg, contextArg, bookViewArg, successFunctionArg, failureFunctionArg)
{
    var request = new Request();
    
    request.bookView = bookViewArg;
    request.quoteLines = quoteLinesArg;
    request.date = dateArg;
    request.context = contextArg;
    request.successFunction = successFunctionArg;
    request.failureFunction = failureFunctionArg;
    
    request.validate = function()
    {
        return request.quoteLines != null &&
               request.quoteLines.length > 0 &&
               request.date != null;
    };
    
    request.quoteLineCount = function()
    {
        return request.quoteLines.length;
    };
    
    request.buildDataForNewQuoteAtIndex = function(index)
    {
        if (index >= request.quoteLines.length)
        {
            logAssert("QuoteLine index is out of bounds. Index: " + index);
            return null;
        }
        
        var quoteLine = request.quoteLines[index];
        
        var data = {};
        
        data[kDataKey_quote_creationDate] = request.date;
        data[kDataKey_quote_context] = request.context;
        data[kDataKey_quote_text] = quoteLine.quoteText;
        data[kDataKey_quote_who] = quoteLine.who;
        data[kDataKey_quote_bookId] = null;
        data[kDataKey_quote_parentQuoteId] = null;
        data[kDataKey_quote_childQuoteId] = null;
        
        return data;
    };
    
    return request;
}
