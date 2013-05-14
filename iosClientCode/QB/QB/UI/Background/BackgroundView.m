#import "BackgroundView.h"

@implementation BackgroundView

- (void)dealloc
{
    [BackgroundView releaseRetainedPropertiesOfObject:self];
    [super dealloc];
}

@end
