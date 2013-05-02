#import "ContentItem_textField.h"
#import "ContentItem_scrollViewItem.h"
#import "ContentViewConfig.h"

@interface ContentItem_textField ()
{
    
}
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

- (ContentItem_scrollViewItem*)internal_parent
{
    return self.parent;
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
        textFieldItem.textField.secureTextEntry = config.secureTextEntry;
        if (config.defaultFieldText != nil)
        {
            textFieldItem.textField.text = config.defaultFieldText;
            textFieldItem.defaultText = config.defaultFieldText;
        }
        if (config.overrideFieldText != nil)
        {
            textFieldItem.textField.text = config.overrideFieldText;
            textFieldItem.overrideText = config.overrideFieldText;
        }
    }
    else
    {
        textFieldItem.titleLabel.text = config.labelText;
        textFieldItem.textField.hidden = YES;
        textFieldItem.textFieldWithlabel.secureTextEntry = config.secureTextEntry;
        if (config.defaultFieldText != nil)
        {
            textFieldItem.textFieldWithlabel.text = config.defaultFieldText;
            textFieldItem.defaultText = config.defaultFieldText;
        }
        if (config.overrideFieldText != nil)
        {
            textFieldItem.textFieldWithlabel.text = config.overrideFieldText;
            textFieldItem.overrideText = config.overrideFieldText;
        }
    }
    
    if (config.defaultFieldText != nil)
    {
        textFieldItem.textFieldWithlabel.text = config.defaultFieldText;
        textFieldItem.defaultText = config.defaultFieldText;
    }
    if (config.overrideFieldText != nil)
    {
        textFieldItem.textFieldWithlabel.text = config.overrideFieldText;
    }
    
    textFieldItem.additionalViewHeight = config.additionalViewHeight;
    textFieldItem.textBlock = config.textBlock;
    
    return textFieldItem;
}

- (void)viewWillShow
{
    [_textField addObserver:self
                 forKeyPath:@"text"
                    options:nil
                    context:nil];
    
    [_textFieldWithlabel addObserver:self
                          forKeyPath:@"text"
                             options:nil
                             context:nil];
    
    
    _shouldRestoreDefaultText = _overrideText == nil;// || [_overrideText isEqualToString:@""];
    _textChangeOccurred = _overrideText != nil;
    
    if (!_textChangeOccurred)
    {
        [_textField setTextColor:[UIColor grayColor]];
        [_textFieldWithlabel setTextColor:[UIColor grayColor]];
    }
    
    int viewHeight = self.managedUIView.frame.size.height + _additionalViewHeight;
    self.managedUIView.frame = CGRectMake(self.managedUIView.frame.origin.x,
                                          self.managedUIView.frame.origin.y,
                                          self.managedUIView.frame.size.width,
                                          viewHeight);
}

- (void)viewWillFadeOut
{
    [_textField removeObserver:self
                    forKeyPath:@"text"];
    [_textFieldWithlabel removeObserver:self
                             forKeyPath:@"text"];
}

- (void)observeValueForKeyPath:(NSString*)keyPath
                      ofObject:(id)object
                        change:(NSDictionary*)change
                       context:(void*)contex
{
    UITextField* textField = (UITextField*)object;
    if ([textField.text isEqualToString:@""])
    {
        self.shouldRestoreDefaultText = YES;
    }
    else
    {
        self.textChangeOccurred = YES;
        self.shouldRestoreDefaultText = NO;
    }
}

// UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField*)textField
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField*)textField
{
    self.shouldRestoreDefaultText = NO;
    
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
    if (_shouldRestoreDefaultText && _overrideText == nil)
    {
        textField.text = _defaultText;
        self.textChangeOccurred = NO;
        [_textField setTextColor:[UIColor grayColor]];
        [_textFieldWithlabel setTextColor:[UIColor grayColor]];
    }
    self.textBlock(textField.text);
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    return [self.internal_parent notifyContentTextFieldDidReturn:self];
}

- (void)activateTextField
{
    if (!_textField.hidden) [_textField becomeFirstResponder];
    if (!_textFieldWithlabel.hidden) [_textFieldWithlabel becomeFirstResponder];
}

- (void)deactivateTextField
{
    if (!_textField.hidden) [_textField resignFirstResponder];
    if (!_textFieldWithlabel.hidden) [_textFieldWithlabel resignFirstResponder];
}

- (IBAction)cancelTextEntry
{
    [self.internal_parent cancelTextEntry];
}

@end
