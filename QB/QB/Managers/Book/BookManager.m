#import "BookManager.h"
#import "QBQuote.h"
#import "BookService.h"
#import "UserManager.h"
#import "QBUser.h"

@interface BookManager ()
{
    UserManager* userManager;
}

@property (nonatomic, retain) NSMutableDictionary* booksById;

@end

@implementation BookManager

- (id)init
{
    if (self = [super init])
    {
        _booksById = [NSMutableDictionary new];
    }
    return self;
}

- (QBBook*)bookForBookId:(int)bookId
{
    return [_booksById objectForKey:@(bookId)];
}

- (void)addBooksToKnownBooks:(NSArray*)books
{
    for (QBBook* book in books)
    {
        [_booksById setObject:book
                       forKey:@(book.uuid)];
    }
}

- (BOOL)internal_validateNewBookWithBookName:(NSString*)bookName
                                inviteEmails:(NSArray*)inviteEmails
                                 inviteUsers:(NSArray*)inviteUsers
{
    if (bookName == nil)
        return NO;
    return YES;
}

- (void)createNewBookWithBookName:(NSString*)bookName
                     inviteEmails:(NSArray*)inviteEmails
                      inviteUsers:(NSArray*)inviteUsers
                     successBlock:(void(^)(QBBook*))successBlock
                     failureBlock:(VoidBlock)failureBlock
{
    CreateNewBookRequest* request = [CreateNewBookRequest object];
    request.bookTitle = bookName;
    
    if ([self internal_validateNewBookWithBookName:bookName
                                      inviteEmails:inviteEmails
                                       inviteUsers:inviteUsers])
    {
        [BookService createNewBook:request
                   responseHandler:^(QBBook* book) {
                       if (book != nil)
                       {
                           [_booksById setObject:book
                                          forKey:@(book.uuid)];
                           [userManager.getActiveUser.bookIds addObject:@(book.uuid)];
                           successBlock(book);
                       }
                       else
                       {
                           failureBlock();
                       }
                   }];
    }
    else
    {
        failureBlock();
    }
}

- (void)retrieveBookWithUuid:(int)bookUuid
                successBlock:(void(^)(QBBook*))successBlock
                failureBlock:(VoidBlock)failureBlock
{
    RetrieveBookRequest* request = [RetrieveBookRequest object];
    request.bookUuid = bookUuid;
    [BookService retrieveBook:request
              responseHandler:^(QBBook* book) {
                   book != nil ? successBlock(book) : failureBlock;
               }];
}

- (void)sendInvitesToUsers:(NSArray*)users
                   forBook:(QBBook*)book
{
    for (QBUser* user in users)
    {
        if (![book hasMemberUser:user] &&
            [book hasInvitedUser:user])
        {
            [book.memberUsers addObject:user];
        }
    }
}

@end
