#import "OfflineSupport.h"
#import "OfflineManager.h"
#import "QBUser.h"
#import "QBBook.h"

@interface UserActor : ManagedPropertiesObject <SerializeByDefault>
@property (nonatomic, retain) QBUser* user;
@property (nonatomic, retain) NSString* password;
@end

@implementation UserActor
@end

@interface OfflineUserContainer ()
@property (nonatomic, retain) NSMutableArray* userActors;
@end

@implementation OfflineUserContainer

- (id)init
{
    if (self = [super init])
    {
        _userActors = [NSMutableArray new];
    }
    return self;
}

+ (void)setupSerialization
{
    [self registerClass:UserActor.class
           forContainer:@"userActors"];
    
    [super setupSerialization];
}

- (void)addUser:(QBUser*)user
       password:(NSString*)password
{
    CheckTrue(![self doesPairExistEmail:user.email
                               password:password])
    
    UserActor* userActor = [UserActor object];
    userActor.user = user;
    userActor.password = password;
    [_userActors addObject:userActor];
}

- (BOOL)doesPairExistEmail:(NSString*)email
                  password:(NSString*)password
{
    for (UserActor* userActor in _userActors)
    {
        if ([userActor.password isEqualToString:password] &&
            [userActor.user.email isEqualToString:email])
            return YES;
    }
    return NO;
}

- (QBUser*)getUserByEmail:(NSString*)email
{
    for (UserActor* userActor in _userActors)
    {
        if ([userActor.user.email isEqualToString:email])
        {
            return userActor.user;
        }
    }
    return nil;
}

- (QBUser*)getUserByUuid:(int64_t)uuid
{
    for (UserActor* userActor in _userActors)
    {
        if (userActor.user.uuid == uuid)
        {
            return userActor.user;
        }
    }
    return nil;
}

- (id)serializedRepresentationForOfflineDatabase
{
    NSMutableDictionary* serializedRepresentation = [NSMutableDictionary object];
    NSMutableArray* userActors = [NSMutableArray object];
    for (UserActor* userActor in _userActors)
    {
        [userActors addObject:userActor.serializedRepresentation];
    }
    [serializedRepresentation setObject:userActors
                                 forKey:@"userActors"];
    
    return serializedRepresentation;
}

@end

@implementation OfflineBookContainer

- (id)init
{
    if (self = [super init])
    {
        _books = [NSMutableArray new];
    }
    return self;
}

+ (void)setupSerialization
{
    [self registerClass:QBBook.class
           forContainer:@"books"];
    
    [super setupSerialization];
}

- (id)serializedRepresentationForOfflineDatabase
{
    NSMutableDictionary* serializedRepresentation = [NSMutableDictionary object];
    NSMutableArray* books = [NSMutableArray object];
    for (QBBook* book in _books)
    {
        [books addObject:book.serializedRepresentation];
    }
    [serializedRepresentation setObject:books
                                 forKey:@"books"];
    
    return serializedRepresentation;
}

- (void)addBook:(QBBook*)book
{
    [_books addObject:book];
}

- (QBBook*)getBookByUuid:(int)uuid
{
    for (QBBook* book in _books)
    {
        if (book.uuid == uuid)
            return book;
    }
    return nil;
}

- (NSArray*)allBooksForUser:(QBUser*)user
{
    NSMutableArray* books = [NSMutableArray object];
    for (NSNumber* bookId in user.bookIds)
    {
        for (QBBook* book in _books)
        {
            if (book.uuid == bookId.intValue)
            {
                [books addObject:book];
            }
        }
    }
    return books;
}

@end
