#import "ContentViewConfig.h"

@implementation ContentViewConfig

- (id)init
{
    if (self = [super init])
    {
        _viewConfigs = [NSMutableArray new];
    }
    return self;
}

@end

@implementation ContentItemConfig
@end

@implementation ContentButtonConfig

- (void)dealloc
{
    self.onTapBlock = nil;
    [super dealloc];
}

@end

@implementation ContentLabelConfig
@end

@implementation ContentTextFieldConfig

- (void)dealloc
{
    self.textBlock = nil;
    self.fieldText = nil;
    [super dealloc];
}

@end

@implementation ContentItemConfigToAdd
@end