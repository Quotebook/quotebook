#import "QB.h"

@class QBBook;
@class QBQuote;
@class QBUser;

@interface MenuManager : Manager

- (void)showDebugPanel;

- (void)showLoginMenu;

- (void)showMenuForUser:(QBUser*)user;

@end
