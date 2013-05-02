#import "QB.h"

@class ContentButtonConfig;

@interface ContentItem_button : ManagedView

@property (nonatomic, assign) IBOutlet UIButton* button;
@property (nonatomic, copy) VoidBlock onTapBlock;

@property (nonatomic, assign) int additionalViewHeight;

+ (ContentItem_button*)createButtonWithContentButtonConfig:(ContentButtonConfig*)config
                                               viewManager:(ViewManager*)viewManager
                                                    parent:(id)parent;

- (IBAction)onTap;

- (IBAction)cancelTextEntry;

@end
