#import "ContentViewConfig.h"

@implementation ContentViewConfig

- (id)init
{
    if (self = [super init])
    {
        _contentItemConfigs = [NSMutableArray new];
    }
    return self;
}

@end

@implementation ContentScrollViewConfig

- (id)init
{
    if (self = [super init])
    {
        _contentViewConfigs = [NSMutableArray new];
    }
    return self;
}

@end

@implementation ContentItemConfig
@end

@implementation ContentItemConfigToAdd
@end