#import "DebugPanel.h"
#import "OfflineManager.h"
#import "UserManager.h"

@interface DebugPanel ()
{
    OfflineManager* offlineManager;
    UserManager* userManager;
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
    [userManager clearUserDefaults];
    [offlineManager resetOfflineDatabase];
    [self.director reload];
}

- (IBAction)clearUserDefaults
{
    [userManager clearUserDefaults];
}

@end
