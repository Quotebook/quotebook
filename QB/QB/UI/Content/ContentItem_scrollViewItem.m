#import "ContentItem_scrollViewItem.h"
#import "ContentItem_spacer.h"
#import "ContentItem_button.h"
#import "ContentItem_label.h"
#import "ContentItem_textField.h"
#import "ContentItem_datePicker.h"
#import "ContentViewConfig.h"
#import "ContentItem_scrollView.h"
#import "ContentView.h"

@interface ContentItem_scrollViewItem ()
{
    ViewManager* viewManager;
    int textFieldCount;
}

@end


@implementation ContentItem_scrollViewItem

- (void)dealloc
{
	[ContentItem_scrollViewItem releaseRetainedPropertiesOfObject:self];
	[super dealloc];
}

- (void)configure:(ContentViewConfig*)config
{
    for (ContentItemConfig* contentItemConfig in config.contentItemConfigs)
    {
        
    }
    
    
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
    int textFieldHeight = 30;
    int textFieldCurrentTop = frame.origin.y + _scrollView.frame.origin.y;
    int textFieldCurrentBottom = frame.origin.y + textFieldHeight + _scrollView.frame.origin.y;
    
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
    ContentItem_scrollView* contentView_scrollView = self.parent;
    ContentView* contentView = contentView_scrollView.parent;
    
    [contentView.managedUIView endEditing:YES];
    [self internal_animateViewsForTextEditingDown];
}

- (BOOL)notifyContentTextFieldDidReturn:(ContentItem_textField*)contentItemTextField
{
    NSLog(@"%s", __FUNCTION__);
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
