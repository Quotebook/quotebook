#import "QB.h"

@interface DebugPanel : ManagedView

@property (nonatomic, retain) IBOutlet UIView* openPanel;

- (IBAction)toggleOpen;

- (IBAction)resetOfflineDatabase;

@end
