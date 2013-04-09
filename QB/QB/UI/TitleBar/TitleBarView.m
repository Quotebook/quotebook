#import "TitleBarView.h"

@implementation TitleBarView

- (void)dealloc
{
    [TitleBarView releaseRetainedPropertiesOfObject:self];
    [super dealloc];
}

@end
