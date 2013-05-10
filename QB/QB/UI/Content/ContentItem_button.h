#import "QB.h"
#import "ContentViewConfig.h"

@interface ContentButtonConfig : ContentItemConfig
@property (nonatomic, retain) NSString* buttonTitle;
@property (nonatomic, copy) VoidBlock onTapBlock;
@end

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
