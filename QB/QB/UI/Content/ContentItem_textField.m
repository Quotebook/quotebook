#import "ContentItem_textField.h"
#import "ContentView.h"

@implementation ContentItem_textField

- (void)dealloc
{
    self.textBlock = nil;
    [ContentItem_textField releaseRetainedPropertiesOfObject:self];
    [super dealloc];
}

- (ContentView*)internal_parent
{
    return self.parent;
}

- (void)viewWillShow
{
    int viewHeight = self.managedUIView.frame.size.height + _additionalViewHeight;
    self.managedUIView.frame = CGRectMake(self.managedUIView.frame.origin.x,
                                          self.managedUIView.frame.origin.y,
                                          self.managedUIView.frame.size.width,
                                          viewHeight);
}

// UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField*)textField
{
    textField.backgroundColor = [UIColor colorWithRed:180.0f/255.0f
                                                green:180.0f/255.0f
                                                 blue:245.0f/255.0f
                                                alpha:1.0f];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField*)textField
{
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
