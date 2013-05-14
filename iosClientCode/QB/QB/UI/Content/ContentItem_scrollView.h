#import "QB.h"

@class ContentViewConfig;
@class ContentScrollViewConfig;
@class ContentItem_textField;

@interface ContentItem_scrollView : ManagedView

@property (nonatomic, assign) IBOutlet ManagedScrollView* scrollView;

- (ContentItem_scrollView*)activeScrollViewItem;

- (ContentItem_scrollView*)scrollViewItemAtIndex:(int)index;

- (void)configureAsScrollView:(ContentScrollViewConfig*)config;

- (void)configureAsContentView:(ContentViewConfig*)config;

- (void)addContentItemConfigs:(NSArray*)contentItemConfigsToAdd;

- (void)keepContentTextFieldVisibleWithAcitveOSK:(ContentItem_textField*)textField;

- (BOOL)notifyContentTextFieldDidReturn:(ContentItem_textField*)contentItemTextField;

- (void)cancelTextEntry;

- (void)scrollToOffset:(CGPoint)point
         withAnimation:(BOOL)animate;

- (void)scrollToBottomWithAnimation:(BOOL)animate;

@end
