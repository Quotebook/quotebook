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

- (id)init
{
    if (self = [super init])
    {
        _alignment = ContentConfigAlignmentNone;
    }
    return self;
}

@end

@implementation ContentTextFieldConfig

- (void)dealloc
{
    self.textBlock = nil;
    self.overrideFieldText = nil;
    self.defaultFieldText = nil;
    [super dealloc];
}

@end

@implementation ContentDatePickerConfig

- (void)dealloc
{
    self.dateBlock = nil;
    [super dealloc];
}

@end

@implementation ContentItemConfigToAdd
@end