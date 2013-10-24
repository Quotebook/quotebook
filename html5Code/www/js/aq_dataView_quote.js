var kDataType_quote = "t_quote";
var kDataKey_quote_creationDate = "q_cnd";
var kDataKey_quote_context = "q_cxt";
var kDataKey_quote_text = "q_txt";
var kDataKey_quote_who = "q_who";
var kDataKey_quote_bookId = "q_bid";
var kDataKey_quote_parentQuoteId = "q_pid";
var kDataKey_quote_childQuoteId = "q_cid";

var QuoteView = function(quoteDataHolder, bookView)
{
    var quoteView = new DataView(quoteDataHolder);

    quoteView.creationDate = quoteDataHolder.valueForKey(kDataKey_quote_creationDate);
    quoteView.context = quoteDataHolder.valueForKey(kDataKey_quote_context);
    quoteView.text = quoteDataHolder.valueForKey(kDataKey_quote_text);
    quoteView.who = quoteDataHolder.valueForKey(kDataKey_quote_who);
    quoteView.bookId = quoteDataHolder.valueForKey(kDataKey_quote_bookId);
    quoteView.parentQuoteId = quoteDataHolder.valueForKey(kDataKey_quote_parentQuoteId);
    quoteView.childQuoteId = quoteDataHolder.valueForKey(kDataKey_quote_childQuoteId);

    // THis function geneartes a dataHolder - intresting this shouldnt be on a view - this should be on a manager. nice try though.
//    quoteView.createDataHolder = function(core, bookView)
//    {
//        var quoteData = {};
//        
//        core.getLocalDataStore().createDataHolderForDataAndId(quoteData, bookView.getThenIncrementNextQuoteId());
//    }
    
    return quoteView;
};

var CreateNewQuoteRequest = function(quoteLinesArg, dateArg, contextArg, successFunctionArg, failureFunctionArg)
{
    var request = new Request();
    
    request.quoteLines = quoteLinesArg;
    request.date = dateArg;
    request.context = contextArg;
    request.successFunction = successFunctionArg;
    request.failureFunction = failureFunctionArg;
    
    request.validate = function()
    {
        return quoteLinesArg != null &&
               quoteLinesArg.length > 0 &&
               dateArg != null;
    }
}
