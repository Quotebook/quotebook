#import "Base.h"

@class AppDirector;
@class QBViewDirector;

@interface QBAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet QBViewDirector* viewDirector;
@property (nonatomic, readonly) AppDirector* director;

@end
