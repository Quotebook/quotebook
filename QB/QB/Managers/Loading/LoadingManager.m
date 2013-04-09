#import "LoadingManager.h"

@implementation LoadingManager

- (void)dealloc
{
	[LoadingManager releaseRetainedPropertiesOfObject:self];
	[super dealloc];
}

@end
