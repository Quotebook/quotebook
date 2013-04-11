#import "LoadingManager.h"
#import "MenuManager.h"
#import "UserManager.h"

@interface LoadingManager ()
{
    MenuManager* menuManager;
    UserManager* userManager;
}
@end

@implementation LoadingManager

- (void)dealloc
{
	[LoadingManager releaseRetainedPropertiesOfObject:self];
	[super dealloc];
}

- (void)load
{
    if ([userManager shouldLoginImplicitly])
    {
        [userManager attemptImplicitLogin];
    }
    else
    {
        [menuManager showLoginMenu];
    }
}


@end
