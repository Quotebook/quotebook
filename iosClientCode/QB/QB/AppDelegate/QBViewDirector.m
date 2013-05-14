#import "QBViewDirector.h"
#import "NSObject+Object.h"

@implementation QBViewDirector

- (void)dealloc
{
    [QBViewDirector releaseRetainedPropertiesOfObject:self];
    [super dealloc];
}

@end
