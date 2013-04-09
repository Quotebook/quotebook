#import "QB.h"

@class QBUser;

@interface QBBook : ManagedPropertiesObject <SerializeByDefault>

@property (nonatomic, assign) int uuid;
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSMutableArray* quotes;
@property (nonatomic, retain) NSMutableArray* memberUsers;
@property (nonatomic, retain) NSMutableArray* invitedUsers;

- (BOOL)hasMemberUser:(QBUser*)user;

- (BOOL)hasInvitedUser:(QBUser*)user;

@end
