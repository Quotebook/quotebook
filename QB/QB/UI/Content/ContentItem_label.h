#import "QB.h"

@interface ContentItem_label : ManagedView

@property (nonatomic, retain) IBOutlet UILabel* label;

@property (nonatomic, assign) int additionalViewHeight;

- (IBAction)cancelTextEntry;

@end
