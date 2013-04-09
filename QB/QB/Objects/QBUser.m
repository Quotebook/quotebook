#import "QBUser.h"
#import "QBBook.h"

@interface QBUser ()
@end

@implementation QBUser

- (id)init
{
    if (self = [super init])
    {
    }
    return self;
}

+ (void)setupSerialization
{
    [self registerClass:BasicSerializedClassesPlaceholder.class
           forContainer:@"bookIds"];
}

- (NSString*)formattedDisplayName
{
    return Format(@"%@ %@", _firstName, _lastName);
}

@end

