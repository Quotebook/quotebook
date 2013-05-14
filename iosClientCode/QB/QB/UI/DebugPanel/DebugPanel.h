#import "QB.h"

@interface DebugPanel : ManagedView

@property (nonatomic, assign) IBOutlet UIView* openPanel;

- (IBAction)toggleOpen;

- (IBAction)resetOfflineDatabase;

@end
