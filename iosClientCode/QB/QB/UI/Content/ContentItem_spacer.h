#import "QB.h"

@interface ContentItem_spacer : ManagedView
@property (nonatomic, assign) int additionalViewHeight;

+ (ContentItem_spacer*)createSpacerWithHieght:(int)spacerHeight
                                  viewManager:(ViewManager*)viewManager
                                       parent:(id)parent;

-(IBAction)cancelTextEntry;

@end
