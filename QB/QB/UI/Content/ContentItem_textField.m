#import "ContentItem_textField.h"
#import "ContentView.h"

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

- (ContentView*)internal_parent
{
    return self.parent;
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
