#import "QB.h"

@class QBQuote;
@class QBBook;

@interface CreateNewQuoteRequest : ManagedPropertiesObject <SerializeByDefault>
@property (nonatomic, assign) int bookUuid;
@property (nonatomic, retain) NSArray* quoteLines;
@property (nonatomic, retain) NSDate* creationDate;
@property (nonatomic, retain) NSString* quoteContext;
@end

@interface RetrieveQuoteRequest : ManagedPropertiesObject <SerializeByDefault>
@property (nonatomic, assign) int quoteUuid;
@end

@interface QuoteService : Service

DeclareServiceCommand(createNewQuote, CreateNewQuoteRequest, QBQuote)

DeclareServiceCommand(retrieveQuote, RetrieveQuoteRequest, QBQuote)

@end

