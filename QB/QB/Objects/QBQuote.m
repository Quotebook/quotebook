#import "QBQuote.h"
#import "QBUser.h"

@implementation QBQuoteWho

- (id)init
{
    if (self = [super init])
    {
        _nonuserQuoted = @"not initialized";
    }
    return self;
}

- (NSString*)displayName
{
    if (_userQuoted != nil)
    {
        return _userQuoted.formattedDisplayName;
    }
    else
    {
        CheckNotNull(_nonuserQuoted);
        return _nonuserQuoted;
    }
}

@end

@implementation QBQuoteLine

- (id)init
{
    if (self = [super init])
    {
        _who = [QBQuoteWho new];
    }
    return self;
}

- (NSString*)oneLineDisplayName
{
    return Format(@"%@: %@", _who.displayName, _text);
}

@end

@implementation QBQuote

+ (void)setupSerialization
{
    [super setupSerialization];
    
    [self registerClass:QBQuoteLine.class
           forContainer:@"quoteLines"];
}

//- (id)serializedRepresentationForOfflineDatabase -- wtf is going on with our database. books are beingn entered twice, users need to reference books, not hve the actual instance. rework that setup. books should hold the actual quote object, though.
//{
//    NSMutableDictionary* serializedRepresentation = [NSMutableDictionary object];
//    
//    [serializedRepresentation setObject:@(_uuid)
//                                 forKey:@"uuid"];
//    
//    [serializedRepresentation setObject:_creationDate
//                                 forKey:@"creationDate"];
//
//    [serializedRepresentation setObject:_quoteContext
//                                 forKey:@"quoteContext"];
//    
//    NSMutableArray* quoteLines = [NSMutableArray object];
//    for (QBQuoteLine* quoteLine in _quoteLines)
//    {
//        [quoteLines addObject:quoteLines.serializedRepresentation];
//    }
//    [serializedRepresentation setObject:quoteLines
//                                 forKey:@"quoteLines"];
//    
//    return serializedRepresentation;
//}

- (NSString*)displayName
{
    if (_quoteLines.count == 0)
    {
        return @"no quote lines";
    }
    
    return [[_quoteLines objectAtIndex:0] oneLineDisplayName];
}

@end
