#import "ContentItem_textField.h"
#import "ContentItem_scrollView.h"

@implementation ContentTextFieldConfig
@end

@interface ContentItem_textField ()
{
    
}
@property (nonatomic, copy) void(^textBlock)(NSString*);
@property (nonatomic, assign) int additionalViewHeight;
@property (nonatomic, retain) NSString* labelText;
@property (nonatomic, retain) NSString* overrideText;
@property (nonatomic, retain) NSString* defaultText;

@property (nonatomic, assign) bool textChangeOccurred;
@property (nonatomic, assign) bool textFieldDeactivated;
@property (nonatomic, assign) bool shouldRestoreDefaultText;
@end

@implementation ContentItem_textField

- (void)dealloc
{
    [ContentItem_textField releaseRetainedPropertiesOfObject:self];
    [super dealloc];
}

- (ContentItem_scrollView*)internal_parent
{
    return self.parent;
}

- (NSArray*)allTextViews
{
    return @[_textField, _textFieldWithlabel, _textView, _textViewWithlabel];
}

+ (ContentItem_textField*)createTextFieldWithContentTextFieldConfig:(ContentTextFieldConfig*)config
                                                        viewManager:(ViewManager*)viewManager
                                                             parent:(id)parent
{
    ContentItem_textField* textFieldItem = [viewManager createManagedViewOfClass:ContentItem_textField.class
                                                                          parent:parent];
    
    if (config.labelText == nil)
    {
        textFieldItem.titleLabel.hidden = YES;
        textFieldItem.textFieldWithlabel.hidden = YES;
        textFieldItem.textViewWithlabel.hidden = YES;
        textFieldItem.textField.secureTextEntry = config.secureTextEntry;
        textFieldItem.textField.hidden = config.shouldUseTextView;
        textFieldItem.textView.hidden = !config.shouldUseTextView;
        
        textFieldItem.textViewWithlabel.hidden = YES;
        textFieldItem.textView.secureTextEntry = config.secureTextEntry;
        
        if (config.defaultFieldText != nil)
        {
            textFieldItem.textField.text = config.defaultFieldText;
            textFieldItem.textView.text = config.defaultFieldText;
            textFieldItem.defaultText = config.defaultFieldText;
        }
        if (config.overrideFieldText != nil)
        {
            textFieldItem.textField.text = config.overrideFieldText;
            textFieldItem.textView.text = config.overrideFieldText;
            textFieldItem.overrideText = config.overrideFieldText;
        }
    }
    else
    {
        textFieldItem.titleLabel.text = config.labelText;
        textFieldItem.textField.hidden = YES;
        textFieldItem.textView.hidden = YES;
        textFieldItem.textFieldWithlabel.secureTextEntry = config.secureTextEntry;
        textFieldItem.textFieldWithlabel.hidden = config.shouldUseTextView;
        textFieldItem.textViewWithlabel.hidden = !config.shouldUseTextView;
        
        if (config.defaultFieldText != nil)
        {
            textFieldItem.textFieldWithlabel.text = config.defaultFieldText;
            textFieldItem.textViewWithlabel.text = config.defaultFieldText;
            textFieldItem.defaultText = config.defaultFieldText;
        }
        if (config.overrideFieldText != nil)
        {
            textFieldItem.textFieldWithlabel.text = config.overrideFieldText;
            textFieldItem.textViewWithlabel.text = config.overrideFieldText;
            textFieldItem.overrideText = config.overrideFieldText;
        }
    }
    
    if (config.shouldUseTextView)
    {
        textFieldItem.managedUIView.frame = CGRectMake(textFieldItem.managedUIView.frame.origin.x,
                                                       textFieldItem.managedUIView.frame.origin.y,
                                                       textFieldItem.managedUIView.frame.size.width,
                                                       textFieldItem.textView.frame.size.height);
    }
    
    textFieldItem.additionalViewHeight = config.additionalViewHeight;
    textFieldItem.textBlock = config.textBlock;
    
    return textFieldItem;
}

- (void)viewWillShow
{
    for (UIView* view in self.allTextViews)
    {
        if (!view.hidden)
        {
            [view addObserver:self
                   forKeyPath:@"text"
                      options:nil
                      context:nil];
        }
    }
    
    _shouldRestoreDefaultText = _overrideText == nil;// || [_overrideText isEqualToString:@""];
    _textChangeOccurred = _overrideText != nil;
    
    if (!_textChangeOccurred)
    {
        [_textField setTextColor:[UIColor grayColor]];
        [_textFieldWithlabel setTextColor:[UIColor grayColor]];
        [_textView setTextColor:[UIColor grayColor]];
        [_textViewWithlabel setTextColor:[UIColor grayColor]];
    }
    
    int viewHeight = self.managedUIView.frame.size.height + _additionalViewHeight;
    self.managedUIView.frame = CGRectMake(self.managedUIView.frame.origin.x,
                                          self.managedUIView.frame.origin.y,
                                          self.managedUIView.frame.size.width,
                                          viewHeight);
    _cancelTextEntryButton.frame = CGRectMake(_cancelTextEntryButton.frame.origin.x,
                                              _cancelTextEntryButton.frame.origin.y,
                                              _cancelTextEntryButton.frame.size.width,
                                              self.managedUIView.frame.size.height);
}

- (void)viewWillFadeOut
{
    for (UIView* view in self.allTextViews)
    {
        [view removeObserver:self
                  forKeyPath:@"text"];
    }
}

- (void)observeValueForKeyPath:(NSString*)keyPath
                      ofObject:(id)object
                        change:(NSDictionary*)change
                       context:(void*)contex
{
    NSString* text = nil;
    {
        if ([object isKindOfClass:UITextField.class])
        {
            UITextField* textField = (UITextField*)object;
            text = textField.text;
        }
        else if ([object isKindOfClass:UITextView.class])
        {
//            UITextView* textView = (UITextView*)object;
            return;
        }
    };

    if ([text isEqualToString:@""])
    {
        _shouldRestoreDefaultText = YES;
    }
    else
    {
        _textChangeOccurred = YES;
        _shouldRestoreDefaultText = NO;
    }
}

// UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField*)textField
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField*)textField
{
    _shouldRestoreDefaultText = NO;
    
    if (!_textChangeOccurred)
    {
        textField.text = @"";
    }
    
    [textField setTextColor:[UIColor blackColor]];
    textField.backgroundColor = [UIColor colorWithRed:180.0f/255.0f
                                                green:180.0f/255.0f
                                                 blue:245.0f/255.0f
                                                alpha:1.0f];
    if (self.managedUIView.tag != 1)
    {
        [self.internal_parent keepContentTextFieldVisibleWithAcitveOSK:self];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField*)textField
{
    textField.backgroundColor = [UIColor whiteColor];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField*)textField
{
    textField.text = textField.text;
    
    if (_shouldRestoreDefaultText && _overrideText == nil)
    {
        textField.text = _defaultText;
        _textChangeOccurred = NO;
        [_textField setTextColor:[UIColor grayColor]];
        [_textFieldWithlabel setTextColor:[UIColor grayColor]];
    }
    else
    {
        self.textBlock(textField.text);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    return [self.internal_parent notifyContentTextFieldDidReturn:self];
}

- (void)activateTextField
{
    for (UIView* view in self.allTextViews)
    {
        if (!view.hidden)
        {
            [view becomeFirstResponder];
        }
    }
}

- (void)deactivateTextField
{
    for (UIView* view in self.allTextViews)
    {
        if (!view.hidden)
        {
            [view resignFirstResponder];
        }
    }
}

// UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView*)textView
{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView*)textView
{
    _shouldRestoreDefaultText = NO;
    
    if (!_textChangeOccurred)
    {
        textView.text = @"";
    }
    
    [textView setTextColor:[UIColor blackColor]];
    textView.backgroundColor = [UIColor colorWithRed:180.0f/255.0f
                                                green:180.0f/255.0f
                                                 blue:245.0f/255.0f
                                                alpha:1.0f];
    if (self.managedUIView.tag != 1)
    {
        [self.internal_parent keepContentTextFieldVisibleWithAcitveOSK:self];
    }
}

- (BOOL)textViewShouldEndEditing:(UITextView*)textView
{
    textView.backgroundColor = [UIColor whiteColor];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView*)textView
{
    if (_shouldRestoreDefaultText && _overrideText == nil)
    {
        textView.text = _defaultText;
        _textChangeOccurred = NO;
        [_textView setTextColor:[UIColor grayColor]];
        [_textViewWithlabel setTextColor:[UIColor grayColor]];
    }
    else
    {
        self.textBlock(textView.text);
    }
}

- (BOOL)textViewShouldReturn:(UITextView*)textView
{
    return [self.internal_parent notifyContentTextFieldDidReturn:self];
}

- (IBAction)cancelTextEntry
{
    [self.internal_parent cancelTextEntry];
}

- (void)textViewDidChange:(UITextView*)textView
{
    if ([textView.text isEqualToString:@""] ||
        [textView.text isEqualToString:_defaultText])
    {
        _shouldRestoreDefaultText = YES;
    }
    else
    {
        _textChangeOccurred = YES;
        _shouldRestoreDefaultText = NO;
    }
}


@end
