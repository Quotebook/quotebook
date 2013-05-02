#import "ContentItem_scrollView.h"
#import "ContentItem_scrollViewItem.h"
#import "ContentViewConfig.h"
#import "QBBook.h"
#import "QBQuote.h"

@interface ContentItem_scrollView ()
{
    ViewManager* viewManager;
}
@property (nonatomic, retain) ContentScrollViewConfig* config;
@end


@implementation ContentItem_scrollView

- (void)dealloc
{
	[ContentItem_scrollView releaseRetainedPropertiesOfObject:self];
	[super dealloc];
}

- (void)viewWillShow
{
    
}

// Lots of changes to the configuration of scroll views
// contentView has an empty view that well fill with a scrollView.
// configure that scrollview in the same way we used to configure the contentView.
// move all those helper functions over
- (void)configure:(ContentScrollViewConfig*)config
{
    self.config = config;
    
    NSMutableArray* views = [NSMutableArray object];
    for (ContentViewConfig* contentViewConfig in config.contentViewConfigs)
    {
        ContentItem_scrollViewItem* scrollViewItem = [viewManager createManagedViewOfClass:ContentItem_scrollViewItem.class
                                                                                    parent:self];
        
        [views addObject:scrollViewItem];
    }
    [_scrollView addManagedViews:views];
    
    
    [_scrollView setShouldScrollVertical:config.enableVerticalScrolling];
    _scrollView.scrollEnabled = config.contentViewConfigs.count > 1;
    _scrollView.directionalLockEnabled = YES;
    _scrollView.alwaysBounceHorizontal = !config.enableVerticalScrolling;
    _scrollView.alwaysBounceVertical = config.enableVerticalScrolling;
    _scrollView.pagingEnabled = config.enablePaging;
    
    [self internal_configureViewAtIndex:config.indexToFocus];
}

- (ContentItem_scrollViewItem*)scrollViewItemAtIndex:(int)index
{
    return [_scrollView.managedViews objectAtIndex:index];
}

- (ContentItem_scrollViewItem*)activeScrollViewItem
{
    int activeIndex = 0;
    return [self scrollViewItemAtIndex:activeIndex];
}

- (void)internal_configureViewAtIndex:(int)index
{
    for (ContentItem_scrollViewItem* view in _scrollView.managedViews)
    {
        [view configure:[_config.contentViewConfigs objectAtIndex:[_scrollView.managedViews indexOfObject:view]]];
    }
    return;
    
    [[self scrollViewItemAtIndex:index] configure:[_config.contentViewConfigs objectAtIndex:index]];
}

@end
