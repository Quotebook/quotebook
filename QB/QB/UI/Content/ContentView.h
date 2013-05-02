#import "QB.h"

@class ContentViewConfig;
@class ContentScrollViewConfig;
@class ContentItem_textField;

@interface ContentView : ManagedView

@property (nonatomic, copy) VoidBlock actionBlock;

@property (nonatomic, assign) IBOutlet UIButton* actionButton;

@property (nonatomic, assign) IBOutlet UIView* scrollViewContainer;

- (void)configureWithContentViewConfig:(ContentViewConfig*)contentViewConfig;

- (void)configureWithContentScrollViewConfig:(ContentScrollViewConfig*)contentScrollViewConfig;

- (void)addContentItemConfigs:(NSArray*)contentItemConfigs;

- (IBAction)cancelTextEntry;

- (IBAction)executeActionBlock;

@end
