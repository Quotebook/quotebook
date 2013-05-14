#import "QuoteService.h"
#import "OfflineManager.h"
#import "QBQuote.h"


@implementation QuoteService

ServiceName(QuoteService)

QBServiceCommand(createNewQuote, CreateNewQuoteRequest, QBQuote, ^(CreateNewQuoteRequest* request) {
    return [[OfflineManager sharedInstance] createNewQuoteWithBookUuid:request.bookUuid
                                                            quoteLines:request.quoteLines
                                                          creationData:request.creationDate
                                                          quoteContext:request.quoteContext];
})

QBServiceCommand(retrieveQuote, RetrieveQuoteRequest, QBQuote, ^(RetrieveQuoteRequest* request) {
    return [[OfflineManager sharedInstance] retrieveQuoteWithQuoteUuid:request.quoteUuid];
})

@end

@implementation CreateNewQuoteRequest

+ (void)setupSerialization
{
    [super setupSerialization];
    
    [self registerClass:QBQuoteLine.class
           forContainer:@"quoteLines"];
}

@end

@implementation RetrieveQuoteRequest
@end
