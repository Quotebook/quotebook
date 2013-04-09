#import "QB.h"
#import "QBUser.h"
#import "QBBook.h"

@interface OfflineUserContainer : ManagedPropertiesObject <SerializeByDefault>

- (void)addUser:(QBUser*)user
       password:(NSString*)password;

- (BOOL)doesPairExistEmail:(NSString*)email
                  password:(NSString*)password;

- (QBUser*)getUserByEmail:(NSString*)email;

- (QBUser*)getUserByUuid:(int64_t)uuid;

- (id)serializedRepresentationForOfflineDatabase;

@end


@interface OfflineBookContainer : ManagedPropertiesObject <SerializeByDefault>
@property (nonatomic, retain) NSMutableArray* books;

- (id)serializedRepresentationForOfflineDatabase;

- (void)addBook:(QBBook*)book;

- (QBBook*)getBookByUuid:(int)uuid;

- (NSArray*)allBooksForUser:(QBUser*)user;

@end