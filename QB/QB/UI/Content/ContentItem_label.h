#import "QB.h"

@class ContentLabelConfig;

@interface ContentItem_label : ManagedView

@property (nonatomic, assign) IBOutlet UILabel* label;

@property (nonatomic, assign) int additionalViewHeight;

- (IBAction)cancelTextEntry;

+ (ContentItem_label*)createWithConfig:(ContentLabelConfig*)config
                           viewManager:(ViewManager*)viewManager
                                parent:(id)parent;

@end
