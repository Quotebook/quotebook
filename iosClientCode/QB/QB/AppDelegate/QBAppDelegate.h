#import "Base.h"

@class AppDirector;
@class QBViewDirector;

@interface QBAppDelegate : UIResponder <UIApplicationDelegate>

- (void)reload;

+ (QBAppDelegate*)sharedApplicationDelegate;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, assign) IBOutlet QBViewDirector* viewDirector;
@property (nonatomic, readonly) AppDirector* director;

@end
