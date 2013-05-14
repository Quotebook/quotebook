#import "QB.h"

@class QBQuote;
@class QBBook;

@interface QuoteManager : Manager

- (void)addQuote:(QBQuote*)quote
          toBook:(QBBook*)book
    successBlock:(void(^)(QBQuote*))successBlock
    failureBlock:(VoidBlock)failureBlock;

@end
