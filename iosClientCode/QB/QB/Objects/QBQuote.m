#import "QBQuote.h"
#import "QBUser.h"

@implementation QBQuoteWho

- (NSString*)formatDisplayName
{
    if (_userQuoted != nil)
    {
        return [_userQuoted formatDisplayName];
    }
    else
    {
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

- (NSString*)formatOnelineDisplay
{
    return Format(@"\"%@\"", _text);
}

- (NSString*)formatMultilineDisplay
{
    return Format(@"%@: \"%@\"", [_who formatDisplayName], _text);
}

@end

@implementation QBQuote

+ (void)setupSerialization
{
    [super setupSerialization];
    
    [self registerClass:QBQuoteLine.class
           forContainer:@"quoteLines"];
}

- (NSString*)formatDisplayName
{
    if (_quoteLines.count == 0)
    {
        return @"no quote lines";
    }
    
    return [[_quoteLines objectAtIndex:0] formatOnelineDisplay];
}

- (NSString*)formatContext
{
    if (_quoteContext == nil)
        return nil;
    return Format(@"Re: %@", _quoteContext);
}

@end
