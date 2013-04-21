#import "OfflineManager.h"
#import "ResourceManager.h"
#import "QBUser.h"
#import "QBBook.h"
#import "QBQuote.h"
#import "UserService.h"
#import "OfflineSupport.h"
#import "QBAppDelegate.h"

@interface OfflineManager ()
{
	
}
@property (nonatomic, assign) int userUuidGenerator;
@property (nonatomic, assign) int bookUuidGenerator;
@property (nonatomic, assign) int quoteUuidGenerator;

@property (nonatomic, retain) OfflineBookContainer* bookData;
@property (nonatomic, retain) OfflineUserContainer* userData;

@property (nonatomic, retain) QBUser* activeUser;
@end

@implementation OfflineManager

+ (OfflineManager*)sharedInstance
{
    QBAppDelegate* appDelegate = (QBAppDelegate*)[[UIApplication sharedApplication] delegate];
    return (OfflineManager*)[appDelegate.director managerForClass:OfflineManager.class];
}

- (id)init
{
    if (self = [super init])
    {
        _bookData = [OfflineBookContainer new];
        _userData = [OfflineUserContainer new];
    }
    return self;
}

- (void)dealloc
{
	[OfflineManager releaseRetainedPropertiesOfObject:self];
	[super dealloc];
}

- (NSString*)internal_offlineDatabasePathForFile:(NSString*)filename
{
    return Format(@"/data/quotebook/QB/Resources/OfflineDatabase/%@", filename);
}

- (void)load
{
    [self loadDatabase];
}

- (void)resetOfflineDatabase
{
    NSMutableDictionary* offlineDatabaseTemplate = [ResourceManager configurationForResource:@"offlineDatabaseTemplate.json"];
    
    NSString* outputString = [offlineDatabaseTemplate JSONStringWithOptions:JKSerializeOptionPretty
                                                                      error:nil];
    
    [outputString writeToFile:[self internal_offlineDatabasePathForFile:@"offlineDatabase.json"]
                   atomically:YES
                     encoding:NSUTF8StringEncoding
                        error:nil];
}

- (void)loadDatabase
{
    [self injectConfig:@"offlineDatabase.json"];
}

- (void)saveDatabase
{
    NSMutableDictionary* offlineDatabaseTemplate = [ResourceManager configurationForResource:@"offlineDatabaseTemplate.json"];
    
    [offlineDatabaseTemplate setValue:Integer(_userUuidGenerator)
                           forKeyPath:@"userUuidGenerator"];

    [offlineDatabaseTemplate setValue:Integer(_bookUuidGenerator)
                           forKeyPath:@"bookUuidGenerator"];
    
    [offlineDatabaseTemplate setValue:Integer(_quoteUuidGenerator)
                           forKeyPath:@"quoteUuidGenerator"];
    
    [offlineDatabaseTemplate setValue:_bookData.serializedRepresentationForOfflineDatabase
                           forKeyPath:@"bookData"];
    
    [offlineDatabaseTemplate setValue:_userData.serializedRepresentationForOfflineDatabase
                           forKeyPath:@"userData"];
    
    NSString* outputString = [offlineDatabaseTemplate JSONStringWithOptions:JKSerializeOptionPretty
                                                                      error:nil];
    
    [outputString writeToFile:[self internal_offlineDatabasePathForFile:@"offlineDatabase.json"]
                   atomically:YES
                     encoding:NSUTF8StringEncoding
                        error:nil];
}

// =============
//   COMMANDS
//
// === USERS ===

- (QBUser*)createNewUserWithEmail:(NSString*)email
                        firstName:(NSString*)firstName
                         lastName:(NSString*)lastName
                         password:(NSString*)password
{
    if (![_userData doesPairExistEmail:email
                              password:password])
    {
        QBUser* newUser = [QBUser object];
        newUser.email = email;
        newUser.firstName = firstName;
        newUser.lastName = lastName;
        newUser.uuid = ++_userUuidGenerator;
        newUser.bookIds = [NSMutableArray object];
        [_userData addUser:newUser
                  password:password];
        
        [self saveDatabase];
        
        return newUser;
    }
    return nil;
}

- (QBUser*)retrieveUserWithEmail:(NSString*)email
                          orUuid:(int64_t)uuid
{
    if (email != nil)
    {
        return [_userData getUserByEmail:email];
    }
    return [_userData getUserByUuid:uuid];
}

- (LoginResponse*)loginWithEmail:(NSString*)email
                        password:(NSString*)password
{
    LoginResponse* response = [LoginResponse object];
    
    if ([_userData doesPairExistEmail:email
                             password:password])
    {
        response.user = [_userData getUserByEmail:email];
        response.books = [_bookData allBooksForUser:response.user];
        CheckTrue(_activeUser == nil);
        self.activeUser = response.user;
    }
    
    return response;
}

- (void)logout
{
    self.activeUser = nil;
}

// === BOOKS ===
- (QBBook*)createNewBookWithBookTitle:(NSString*)bookTitle
{
    CheckTrue(_activeUser != nil);
    
    QBBook* book = [QBBook object];
    book.title = bookTitle;
    book.uuid = ++_bookUuidGenerator;
    
    [_activeUser.bookIds addObject:@(book.uuid)];
    [_bookData addBook:book];
        
    [self saveDatabase];
    
    return book;
}

- (QBBook*)retrieveBookWithBookUuid:(int)uuid
{
    return [_bookData getBookByUuid:uuid];
}

// === QUOTES ===
- (QBQuote*)createNewQuoteWithBookUuid:(int)bookUuid
                            quoteLines:(NSArray*)quoteLines
                          creationData:(NSDate*)creationDate
                          quoteContext:(NSString*)quoteContext
{
    QBBook* book = [_bookData getBookByUuid:bookUuid];
    CheckTrue(book);
    
    QBQuote* quote = [QBQuote object];
    quote.uuid = ++_quoteUuidGenerator;
    quote.quoteLines = [[[NSMutableArray alloc] initWithArray:quoteLines] autorelease];
    quote.creationDate = creationDate;
    quote.quoteContext = quoteContext;
    
    if (book.quotes == nil)
    {
        book.quotes = [NSMutableArray object];
    }
    [book.quotes addObject:quote];
 
    [self saveDatabase];
    
    return quote;
}

- (QBQuote*)retrieveQuoteWithQuoteUuid:(int)quoteUuid
{
    for (QBBook* book in _bookData.books)
    {
        for (QBQuote* quote in book.quotes)
        {
            if (quote.uuid == quoteUuid)
                return quote;
        }
    }
    return nil;
}

@end

