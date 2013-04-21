#import "DebugPanel.h"
#import "OfflineManager.h"

@interface DebugPanel ()
{
    OfflineManager* offlineManager;
}

@end

@implementation DebugPanel

- (void)dealloc
{
	[DebugPanel releaseRetainedPropertiesOfObject:self];
	[super dealloc];
}

- (IBAction)toggleOpen;
{
    if (_openPanel.hidden)
    {
        _openPanel.hidden = NO;
        [UIView animateWithDuration:.3
                         animations:^{
                             _openPanel.alpha = 1;
                         }];
    }
    else
    {
        [UIView animateWithDuration:.3
                         animations:^{
                             _openPanel.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             _openPanel.hidden = YES;
                         }];
    }
}

- (IBAction)resetOfflineDatabase
{
    [offlineManager resetOfflineDatabase];
}

@end
