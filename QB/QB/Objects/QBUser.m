#import "QBUser.h"
#import "QBBook.h"

@interface QBUser ()
@end

@implementation QBUser

+ (void)setupSerialization
{
    [self registerClass:BasicSerializedClassesPlaceholder.class
           forContainer:@"bookIds"];
}

- (NSString*)formatDisplayName
{
    return Format(@"%@ %@", _firstName, _lastName);
}

@end

