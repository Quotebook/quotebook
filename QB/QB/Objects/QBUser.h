#import "QB.h"

@interface QBUser : ManagedPropertiesObject <SerializeByDefault>
@property (nonatomic, assign) int64_t uuid;
@property (nonatomic, retain) NSString* email;
@property (nonatomic, retain) NSString* firstName;
@property (nonatomic, retain) NSString* lastName;
@property (nonatomic, retain) NSMutableArray* bookIds;

- (NSString*)formattedDisplayName;

@end
