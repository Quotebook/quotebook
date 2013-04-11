#import "QBBook.h"
#import "QBUser.h"
#import "QBQuote.h"

@interface QBBook ()
@end

@implementation QBBook

+ (void)setupSerialization
{
    [self registerClass:QBQuote.class
           forContainer:@"quotes"];

    [self registerClass:QBUser.class
           forContainer:@"memberUsers"];
    
    [self registerClass:QBUser.class
           forContainer:@"invitedUsers"];
}

- (BOOL)isEmpty
{
    return _quotes == nil || _quotes.count == 0;
}

- (BOOL)hasMemberUser:(QBUser*)userArg
{
    for (QBUser* user in _memberUsers)
    {
        if (user.uuid == userArg.uuid)
        {
            return YES;
        }
    }
    return NO;
}

- (BOOL)hasInvitedUser:(QBUser*)userArg
{
    for (QBUser* user in _invitedUsers)
    {
        if (user.uuid == userArg.uuid)
        {
            return YES;
        }
    }
    return NO;
}

@end
