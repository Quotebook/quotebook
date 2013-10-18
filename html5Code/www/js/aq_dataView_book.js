var kDataType_book = "t_book";
var kDataKey_book_title = "b_ttl";
var kDataKey_book_quoteIds = "b_qti";
var kDataKey_book_memberUserIds = "b_mui";
var kDataKey_book_invitedUserIds = "b_iui";

var BookView = function(bookDataHolder)
{
    var bookView = new DataView(bookDataHolder);
    
    bookView.title = bookDataHolder.valueForKey(kDataKey_book_title);
    bookView.quoteIds = bookDataHolder.valueForKey(kDataKey_book_quoteIds);
    bookView.memberUserIds = bookDataHolder.valueForKey(kDataKey_book_memberUserIds);
    bookView.invitedUserIds = bookDataHolder.valueForKey(kDataKey_book_invitedUserIds);
    
    return bookView;
};
