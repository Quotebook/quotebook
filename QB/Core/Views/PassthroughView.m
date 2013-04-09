#import "PassthroughView.h"
#import "NSObject+Object.h"

@implementation PassthroughView

- (void)dealloc
{
    [PassthroughView releaseRetainedPropertiesOfObject:self];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (UIView*)hitTest:(CGPoint)point
         withEvent:(UIEvent*)event
{
	UIView* hit = [super hitTest:point
                       withEvent:event];
	
    return hit == self ? nil : hit;
}

@end
