#import "QB.h"

@class QBUser;

@interface QBQuoteWho : ManagedPropertiesObject <SerializeByDefault>
@property (nonatomic, retain) QBUser* userQuoted;
@property (nonatomic, retain) NSString* nonuserQuoted;

- (NSString*)displayName;

@end

@interface QBQuoteLine : ManagedPropertiesObject <SerializeByDefault>
@property (nonatomic, retain) QBQuoteWho* who;
@property (nonatomic, retain) NSString* text;

- (NSString*)oneLineDisplayName;

@end

@interface QBQuote : ManagedPropertiesObject <SerializeByDefault>
@property (nonatomic, assign) int uuid;
@property (nonatomic, retain) NSMutableArray* quoteLines;
@property (nonatomic, retain) NSDate* creationDate;
@property (nonatomic, retain) NSString* quoteContext;

- (NSString*)displayName;

@end
