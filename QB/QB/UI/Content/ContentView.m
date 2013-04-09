#import "ContentView.h"
#import "ContentViewConfig.h"
#import "ContentItem_spacer.h"
#import "ContentItem_button.h"
#import "ContentItem_label.h"
#import "ContentItem_textField.h"

@implementation ContentView
{
    ViewManager* viewManager;
    int textFieldCount;
}

- (void)dealloc
{
    self.mainMenuBlock = nil;
    self.actionBlock = nil;
    [ContentView releaseRetainedPropertiesOfObject:self];
    [super dealloc];
}

- (void)dismiss
{
    [_scrollViewForBottomBar removeAllManagedViews];
    [_scrollViewForScrollControls removeAllManagedViews];
    [self cancelTextEntry];
    [super dismiss];
}

- (void)viewWillShow
{
    _mainMenuButton.hidden = _mainMenuBlock == nil;
    _mainMenuButton.userInteractionEnabled = _mainMenuBlock != nil;
    
    _actionButton.hidden = _actionBlock == nil;
    _actionButton.userInteractionEnabled = _actionBlock != nil;
}

- (IBAction)executeMainMenuBlock
{
    CheckNotNull(_mainMenuBlock);
    
    _mainMenuBlock();
}

- (IBAction)executeActionBlock
{
    CheckNotNull(_actionBlock);
    
    _actionBlock();
}

- (ContentItem_spacer*)internal_createSpacerWithHieght:(int)spacerHeight
{
    ContentItem_spacer* spacerItem = [viewManager createManagedViewOfClass:ContentItem_spacer.class
                                                                    parent:self];
    spacerItem.additionalViewHeight = spacerHeight;
    
    return spacerItem;
}

- (ContentItem_button*)internal_createButtonWithContentButtonConfig:(ContentButtonConfig*)contentButtonConfig
{
    ContentItem_button* buttonItem = [viewManager createManagedViewOfClass:ContentItem_button.class
                                                                    parent:self];
    [buttonItem.button setTitle:contentButtonConfig.buttonTitle
                       forState:UIControlStateNormal];
    
    buttonItem.onTapBlock = contentButtonConfig.onTapBlock;
    
    buttonItem.additionalViewHeight = contentButtonConfig.additionalViewHeight;
    
    return buttonItem;
}

- (ContentItem_label*)internal_createLabelWithContentLabelConfig:(ContentLabelConfig*)contentLabelConfig
{
    ContentItem_label* labelItem = [viewManager createManagedViewOfClass:ContentItem_label.class
                                                                  parent:self];
    [labelItem.label setText:contentLabelConfig.labelText];
    
    labelItem.additionalViewHeight = contentLabelConfig.additionalViewHeight;
    
    return labelItem;
}

- (ContentItem_textField*)internal_createTextFieldWithContentTextFieldConfig:(ContentTextFieldConfig*)contentTextFieldConfig
{
    ContentItem_textField* textFieldItem = [viewManager createManagedViewOfClass:ContentItem_textField.class
                                                                          parent:self];
    
    if (contentTextFieldConfig.labelText == nil)
    {
        textFieldItem.titleLabel.hidden = YES;
        textFieldItem.textFieldWithlabel.hidden = YES;
        textFieldItem.textField.secureTextEntry = contentTextFieldConfig.secureTextEntry;
        textFieldItem.textField.text = contentTextFieldConfig.fieldText;
    }
    else
    {
        textFieldItem.titleLabel.text = contentTextFieldConfig.labelText;
        textFieldItem.textField.hidden = YES;
        textFieldItem.textFieldWithlabel.secureTextEntry = contentTextFieldConfig.secureTextEntry;
        textFieldItem.textFieldWithlabel.text = contentTextFieldConfig.fieldText;   
    }

    textFieldItem.additionalViewHeight = contentTextFieldConfig.additionalViewHeight;
    
    textFieldItem.textBlock = contentTextFieldConfig.textBlock;
    return textFieldItem;
}
    
- (ManagedView*)internal_createManagedViewForContentItemConfig:(ContentItemConfig*)contentItemConfig
{
    if (contentItemConfig.class == ContentButtonConfig.class)
    {
        ContentButtonConfig* contentButtonConfig = (ContentButtonConfig*)contentItemConfig;
        return [self internal_createButtonWithContentButtonConfig:contentButtonConfig];
    }
    else if (contentItemConfig.class == ContentLabelConfig.class)
    {
        ContentLabelConfig* contentLabelConfig = (ContentLabelConfig*)contentItemConfig;
        return [self internal_createLabelWithContentLabelConfig:contentLabelConfig];
    }
    else if (contentItemConfig.class == ContentTextFieldConfig.class)
    {
        ContentTextFieldConfig* contentTextFieldConfig = (ContentTextFieldConfig*)contentItemConfig;
        return [self internal_createTextFieldWithContentTextFieldConfig:contentTextFieldConfig];
    }
    AssertNow();
    return nil;
}

- (void)internal_enumerateTextFields
{
    textFieldCount = 0;
    for (ManagedView* scrollViewItem in _scrollViewForBottomBar.managedViews)
    {
        if (scrollViewItem.class == ContentItem_textField.class)
        {
            scrollViewItem.managedUIView.tag = ++textFieldCount;
        }
    }
}

- (void)configureWithContentViewConfig:(ContentViewConfig*)contentViewConfig
{
    NSMutableArray* views = [NSMutableArray object];
    
    if (contentViewConfig.initialSpacerHeight > 0)
    {
        [views addObject:[self internal_createSpacerWithHieght:contentViewConfig.initialSpacerHeight]];
    }
    
    for (ContentItemConfig* viewItemConfig in contentViewConfig.viewConfigs)
    {
        [views addObject:[self internal_createManagedViewForContentItemConfig:viewItemConfig]];
    }
    
    [_scrollViewForBottomBar addManagedViews:views];
    
    [self internal_enumerateTextFields];
}

- (void)addContentItemConfigs:(NSArray*)contentItemConfigsToAdd
{
    for (ContentItemConfigToAdd* contentItemConfigToAdd in contentItemConfigsToAdd)
    {
        ManagedView* managedView = [self internal_createManagedViewForContentItemConfig:contentItemConfigToAdd.contentItemConfig];
        [_scrollViewForBottomBar addManagedView:managedView
                                        atIndex:contentItemConfigToAdd.index
                           refreshViewPlacement:NO];
        
    }
    [_scrollViewForBottomBar refreshViewPlacement];
    [self internal_enumerateTextFields];
}

- (void)internal_animateViewsForTextEditingUp
{
    
}

- (void)internal_animateViewsForTextEditingDown
{
    [UIView animateWithDuration:.3f
                     animations:^{
                         self.scrollViewForBottomBar.transform = CGAffineTransformMakeTranslation(0, 0);
                     }];
}

- (IBAction)cancelTextEntry
{
    [self.managedUIView endEditing:YES];
    [self internal_animateViewsForTextEditingDown];
}

- (void)keepContentTextFieldVisibleWithAcitveOSK:(ContentItem_textField*)contentItemTextField
{
    int bottomOfTitleBarHeight = 62;
    int topOfKeyboardHeight = 265;

    CGRect frame = contentItemTextField.managedUIView.frame;
    int textFieldHeight = 30;
    int textFieldCurrentTop = frame.origin.y + _scrollViewForBottomBar.frame.origin.y;
    int textFieldCurrentBottom = frame.origin.y + textFieldHeight + _scrollViewForBottomBar.frame.origin.y;
    
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
                             self.scrollViewForBottomBar.transform = CGAffineTransformMakeTranslation(0, -diffToAnimate);
                         }];
    }
}

- (BOOL)notifyContentTextFieldDidReturn:(ContentItem_textField*)contentItemTextField
{
    void (^activateViewWithTag)(int) = ^(int tag) {
        for (ManagedView* managedView in _scrollViewForBottomBar.managedViews)
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
        [contentItemTextField.textField resignFirstResponder];
        [contentItemTextField.textFieldWithlabel resignFirstResponder];
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
