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

- (void)load
{
#if DEBUG
    [menuManager showDebugPanel];
#endif
    
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
