#import "ContentItem_scrollView.h"
#import "ContentItem_spacer.h"
#import "ContentItem_button.h"
#import "ContentItem_label.h"
#import "ContentItem_textField.h"
#import "ContentItem_datePicker.h"
#import "ContentViewConfig.h"
#import "ContentItem_scrollView.h"
#import "ContentView.h"

@interface ContentItem_scrollView ()
{
    ViewManager* viewManager;
    int textFieldCount;
}
@property (nonatomic, retain) ContentScrollViewConfig* configAsScrollView;
@property (nonatomic, retain) ContentViewConfig* configAsContentView;

@end


@implementation ContentItem_scrollView

- (void)dealloc
{
	[ContentItem_scrollView releaseRetainedPropertiesOfObject:self];
	[super dealloc];
}

- (void)configureAsScrollView:(ContentScrollViewConfig*)config
{
    self.configAsScrollView = config;
    
    NSMutableArray* views = [NSMutableArray object];
    for (ContentViewConfig* contentViewConfig in config.contentViewConfigs)
    {
        ContentItem_scrollView* scrollViewItem = [viewManager createManagedViewOfClass:ContentItem_scrollView.class
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

- (ContentItem_scrollView*)scrollViewItemAtIndex:(int)index
{
    return [_scrollView.managedViews objectAtIndex:index];
}

- (ContentItem_scrollView*)activeScrollViewItem
{
    int activeIndex = 0;
    return [self scrollViewItemAtIndex:activeIndex];
}

- (void)internal_configureViewAtIndex:(int)index
{
    for (ContentItem_scrollView* view in _scrollView.managedViews)
    {
        [view configureAsContentView:[_configAsScrollView.contentViewConfigs objectAtIndex:[_scrollView.managedViews indexOfObject:view]]];
    }
    return; // Remove when this is being called properly. Properly = when the view is dragged into focus.
    
    [[self scrollViewItemAtIndex:index] configureAsContentView:[_configAsScrollView.contentViewConfigs objectAtIndex:index]];
}

- (void)configureAsContentView:(ContentViewConfig*)config
{
    self.configAsContentView = config;
    
    NSMutableArray* views = [NSMutableArray object];
    
    if (config.initialSpacerHeight > 0)
    {
        [views addObject:[ContentItem_spacer createSpacerWithHieght:config.initialSpacerHeight
                                                        viewManager:viewManager
                                                             parent:self]];
    }
    
    for (ContentItemConfig* viewItemConfig in config.contentItemConfigs)
    {
        [views addObject:[self internal_createManagedViewForContentItemConfig:viewItemConfig]];
    }
    
    [_scrollView addManagedViews:views];
    
    [self internal_enumerateTextFields];
}

- (void)addContentItemConfigs:(NSArray*)contentItemConfigsToAdd
{
    for (ContentItemConfigToAdd* contentItemConfigToAdd in contentItemConfigsToAdd)
    {
        ManagedView* managedView = [self internal_createManagedViewForContentItemConfig:contentItemConfigToAdd.contentItemConfig];
        [_scrollView addManagedView:managedView
                            atIndex:contentItemConfigToAdd.index
                           refreshViewPlacement:NO];
        
    }
    [_scrollView refreshViewPlacement];
    [self internal_enumerateTextFields];
}

- (void)internal_animateViewsForTextEditingDown
{
    [UIView animateWithDuration:.3f
                     animations:^{
                         _scrollView.transform = CGAffineTransformMakeTranslation(0, 0);
                     }];
}

- (void)keepContentTextFieldVisibleWithAcitveOSK:(ContentItem_textField*)textField
{
    int bottomOfTitleBarHeight = 62;
    int topOfKeyboardHeight = 265;
    
    CGRect frame = textField.managedUIView.frame;
    frame.origin = textField.locationInHighestParentView;
    int textFieldHeight = 30;
    int textFieldCurrentTop = frame.origin.y;
    int textFieldCurrentBottom = frame.origin.y + textFieldHeight;
    
    int newTopOfTextField = bottomOfTitleBarHeight + (topOfKeyboardHeight - bottomOfTitleBarHeight) * 0.5f;
    
    int diffToAnimate = 0;
    
    if (textFieldCurrentTop < bottomOfTitleBarHeight)
    {
        diffToAnimate = newTopOfTextField - textFieldCurrentTop;
    }
    
    if (textFieldCurrentBottom > topOfKeyboardHeight)
    {
        diffToAnimate = textFieldCurrentTop - newTopOfTextField;
    }
    
    if (diffToAnimate != 0)
    {
        [UIView animateWithDuration:.3f
                         animations:^{
                             _scrollView.transform = CGAffineTransformMakeTranslation(0, -diffToAnimate);
                         }];
    }
}

- (ManagedView*)internal_createManagedViewForContentItemConfig:(ContentItemConfig*)contentItemConfig
{
    if (contentItemConfig.class == ContentButtonConfig.class)
    {
        return [ContentItem_button createButtonWithContentButtonConfig:(ContentButtonConfig*)contentItemConfig
                                                           viewManager:viewManager
                                                                parent:self];
    }
    else if (contentItemConfig.class == ContentLabelConfig.class)
    {
        return [ContentItem_label createWithConfig:(ContentLabelConfig*)contentItemConfig
                                       viewManager:viewManager
                                            parent:self];
    }
    else if (contentItemConfig.class == ContentTextFieldConfig.class)
    {
        return [ContentItem_textField createTextFieldWithContentTextFieldConfig:(ContentTextFieldConfig*)contentItemConfig
                                                                    viewManager:viewManager
                                                                         parent:self];
    }
    else if (contentItemConfig.class == ContentDatePickerConfig.class)
    {
        return [ContentItem_datePicker createDataPickerWithContentDatePickerConfig:(ContentDatePickerConfig*)contentItemConfig
                                                                       viewManager:viewManager
                                                                            parent:self];
    }
    AssertNow();
    return nil;
}


- (void)internal_enumerateTextFields
{
    textFieldCount = 0;
    for (ManagedView* scrollViewItem in _scrollView.managedViews)
    {
        if (scrollViewItem.class == ContentItem_textField.class)
        {
            scrollViewItem.managedUIView.tag = ++textFieldCount;
        }
    }
}

- (void)cancelTextEntry
{
    ManagedView* parentView = self.parent;
    id grandParentView = parentView.parent;
    
    if ([grandParentView respondsToSelector:@selector(managedUIView)])
    {
        UIView* managedUIView = [grandParentView managedUIView];
        [managedUIView endEditing:YES];
    }
    else if ([parentView respondsToSelector:@selector(managedUIView)])
    {
        [parentView.managedUIView endEditing:YES];
    }
    
    [self internal_animateViewsForTextEditingDown];
}

- (BOOL)notifyContentTextFieldDidReturn:(ContentItem_textField*)contentItemTextField
{
    void (^activateViewWithTag)(int) = ^(int tag) {
        for (ManagedView* managedView in _scrollView.managedViews)
        {
            if ([managedView isKindOfClass:ContentItem_textField.class] &&
                managedView.managedUIView.tag == tag)
            {
                ContentItem_textField* contentItem = (ContentItem_textField*)managedView;
                [contentItem activateTextField];
                return;
            }
        }
        
        AssertNow();
    };
    
    int activeTag = contentItemTextField.managedUIView.tag;
    
    if (activeTag == textFieldCount)
    {
        [contentItemTextField deactivateTextField];
        [self internal_animateViewsForTextEditingDown];
        [self cancelTextEntry];
        return YES;
    }
    else
    {
        [contentItemTextField deactivateTextField];
        activateViewWithTag(activeTag + 1);
        return YES;
    }
    return NO;
}

@end
