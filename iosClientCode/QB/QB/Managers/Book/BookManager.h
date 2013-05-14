#import "QB.h"
#import "QBBook.h"

@class QBUser;

@interface BookManager : Manager

- (QBBook*)bookForBookId:(int)bookId;

- (void)addBooksToKnownBooks:(NSArray*)books;

- (void)createNewBookWithBookName:(NSString*)bookName
                     successBlock:(void(^)(QBBook*))successBlock
                     failureBlock:(VoidBlock)failureBlock;

- (void)retrieveBookWithUuid:(int)bookUuid
                successBlock:(void(^)(QBBook*))successBlock
                failureBlock:(VoidBlock)failureBlock;

- (void)sendInvitesToUsers:(NSArray*)users
                   forBook:(QBBook*)book;

@end
