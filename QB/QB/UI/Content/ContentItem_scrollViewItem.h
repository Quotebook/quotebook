#import "QB.h"

@class ContentViewConfig;
@class ContentItem_textField;

@interface ContentItem_scrollViewItem : ManagedView

@property (nonatomic, assign) IBOutlet ManagedScrollView* scrollView;

- (void)configure:(ContentViewConfig*)config;

- (void)addContentItemConfigs:(NSArray*)contentItemConfigsToAdd;

- (void)keepContentTextFieldVisibleWithAcitveOSK:(ContentItem_textField*)textField;

- (BOOL)notifyContentTextFieldDidReturn:(ContentItem_textField*)contentItemTextField;

- (void)cancelTextEntry;

@end
