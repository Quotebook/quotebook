#import "QB.h"
#import "ContentViewConfig.h"

@interface ContentLabelConfig : ContentItemConfig
@property (nonatomic, retain) NSString* labelText;
@property (nonatomic, assign) BOOL wordWrap;
@property (nonatomic, assign) ContentConfigAlignment alignment;
@property (nonatomic, assign) ContentConfigFont font;
@end

@interface ContentItem_label : ManagedView

@property (nonatomic, assign) IBOutlet UILabel* label;

@property (nonatomic, assign) int additionalViewHeight;

- (IBAction)cancelTextEntry;

+ (ContentItem_label*)createWithConfig:(ContentLabelConfig*)config
                           viewManager:(ViewManager*)viewManager
                                parent:(id)parent;

@end
