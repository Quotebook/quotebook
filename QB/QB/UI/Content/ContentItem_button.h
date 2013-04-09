#import "QB.h"

@interface ContentItem_button : ManagedView

@property (nonatomic, retain) IBOutlet UIButton* button;
@property (nonatomic, copy) VoidBlock onTapBlock;

@property (nonatomic, assign) int additionalViewHeight;

- (IBAction)onTap;
- (IBAction)cancelTextEntry;

@end
