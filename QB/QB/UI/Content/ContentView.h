#import "QB.h"

@class ContentViewConfig;
@class ContentItem_textField;

@interface ContentView : ManagedView

@property (nonatomic, copy) VoidBlock actionBlock;

@property (nonatomic, assign) IBOutlet UIButton* actionButton;

@property (nonatomic, assign) IBOutlet ManagedScrollView* scrollViewForBottomBar;
@property (nonatomic, assign) IBOutlet ManagedScrollView* scrollViewForScrollControls;

- (void)configureWithContentViewConfig:(ContentViewConfig*)contentViewConfig;

- (void)addContentItemConfigs:(NSArray*)contentItemConfigs;

- (IBAction)cancelTextEntry;

- (void)keepContentTextFieldVisibleWithAcitveOSK:(ContentItem_textField*)contentItemTextField;

- (BOOL)notifyContentTextFieldDidReturn:(ContentItem_textField*)contentItemTextField;

- (IBAction)executeActionBlock;

@end
