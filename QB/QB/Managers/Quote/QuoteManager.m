#import "QuoteManager.h"
#import "QBQuote.h"
#import "QBBook.h"
#import "QuoteService.h"

@implementation QuoteManager

- (BOOL)validateNewQuote:(QBQuote*)quote
{
    return YES;
}

- (BOOL)internal_validateNewQuote:(QBQuote*)unvalidatedQuote
                           toBook:(QBBook*)book
{
    if (unvalidatedQuote.quoteLines == nil ||
        unvalidatedQuote.quoteLines.count == 0 ||
        unvalidatedQuote.creationDate == nil ||
        unvalidatedQuote.quoteContext == nil ||
        unvalidatedQuote.uuid != 0)
        return NO;
    return YES;
}

- (void)addQuote:(QBQuote*)unvalidatedQuote
          toBook:(QBBook*)book
    successBlock:(void(^)(QBQuote*))successBlock
    failureBlock:(VoidBlock)failureBlock;
{
    CheckTrue([self validateNewQuote:unvalidatedQuote])
    
    CreateNewQuoteRequest* request = [CreateNewQuoteRequest object];
    request.bookUuid = book.uuid;
    request.quoteLines = unvalidatedQuote.quoteLines;
    request.creationDate = unvalidatedQuote.creationDate;
    request.quoteContext = unvalidatedQuote.quoteContext;
    
    if ([self internal_validateNewQuote:unvalidatedQuote
                                 toBook:book])
    {
        [QuoteService createNewQuote:request
                     responseHandler:^(QBQuote* quote) {
                         if (quote == nil)
                         {
                             failureBlock();
                         }
                         else
                         {
                             if (book.quotes == nil)
                             {
                                 book.quotes = [NSMutableArray object];
                             }
                             
                             if (![book.quotes containsObject:quote])
                             {
                                 [book.quotes addObject:quote];
                             }
                             successBlock(quote);
                         }
                     }];
    }
    else
    {
        failureBlock();
    }
}

@end
