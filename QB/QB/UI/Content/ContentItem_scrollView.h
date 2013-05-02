#import "QB.h"

@class ContentScrollViewConfig;
@class ContentItem_scrollViewItem;

@interface ContentItem_scrollView : ManagedView

@property (nonatomic, assign) IBOutlet ManagedPassthroughScrollView* scrollView;

- (void)configure:(ContentScrollViewConfig*)config;

- (ContentItem_scrollViewItem*)activeScrollViewItem;

- (ContentItem_scrollViewItem*)scrollViewItemAtIndex:(int)index;

@end
