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

//- (id)serializedRepresentationForOfflineDatabase
//{
//    NSMutableDictionary* serializedRepresentation = [NSMutableDictionary object];
//    
//    [serializedRepresentation setObject:@(_uuid)
//                                 forKey:@"uuid"];
//    
//    [serializedRepresentation setObject:_title
//                                 forKey:@"title"];
//
//    NSMutableArray* quotes = [NSMutableArray object];
//    for (QBQuote* quote in _quotes)
//    {
//        [quotes addObject:quote.serializedRepresentationForOfflineDatabase];
//    }
//    [serializedRepresentation setObject:quotes
//                                 forKey:@"quotes"];
//    
//    return serializedRepresentation;
//}

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
