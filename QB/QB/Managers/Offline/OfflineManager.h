#import "QB.h"

@class QBUser;
@class QBBook;
@class QBQuote;
@class LoginResponse;

@interface OfflineManager : Manager

+ (OfflineManager*)sharedInstance;

- (void)loadDatabase;

- (void)saveDatabase;

// =============
//   COMMANDS
// =============

// === USERS ===
- (QBUser*)createNewUserWithEmail:(NSString*)email
                        firstName:(NSString*)firstName
                         lastName:(NSString*)lastName
                         password:(NSString*)password;

- (QBUser*)retrieveUserWithEmail:(NSString*)email
                          orUuid:(int64_t)uuid;

- (LoginResponse*)loginWithEmail:(NSString*)email
                        password:(NSString*)password;

- (void)logout;

// === BOOKS ===
- (QBBook*)createNewBookWithBookTitle:(NSString*)bookTitle;

- (QBBook*)retrieveBookWithBookUuid:(int)uuid;

// === QUOTES ===
- (QBQuote*)createNewQuoteWithBookUuid:(int)bookUuid
                            quoteLines:(NSArray*)quoteLines
                          creationData:(NSDate*)creationDate
                          quoteContext:(NSString*)quoteContext;

- (QBQuote*)retrieveQuoteWithQuoteUuid:(int)quoteUuid;

@end
