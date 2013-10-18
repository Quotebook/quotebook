var kDataType_quote = "t_quote";
var kDataKey_quote_creationDate = "q_cnd";
var kDataKey_quote_context = "q_cxt";
var kDataKey_quote_text = "q_txt";
var kDataKey_quote_who = "q_who";
var kDataKey_quote_parentQuoteId = "q_pqi";
var kDataKey_quote_childQuoteId = "q_cqi";

var QuoteView = function(quoteDataHolder)
{
    var quoteView = new DataView(quoteDataHolder);

    quoteView.creationDate = quoteDataHolder.valueForKey(kDataKey_quote_creationDate);
    quoteView.context = quoteDataHolder.valueForKey(kDataKey_quote_context);
    quoteView.text = quoteDataHolder.valueForKey(kDataKey_quote_text);
    quoteView.who = quoteDataHolder.valueForKey(kDataKey_quote_who);
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
