#import "ConfirmActionView.h"

@implementation ConfirmActionView

- (void)viewWillShow
{
    _confirmButton.hidden = _confirmBlock == nil;
    _cancelButton.hidden = _cancelBlock == nil;
    _failureButton.hidden = _failureBlock == nil;
}

- (void)dealloc
{
    self.confirmBlock = nil;
    self.cancelBlock = nil;
    self.failureBlock = nil;
    [ConfirmActionView releaseRetainedPropertiesOfObject:self];
    [super dealloc];
}

- (void)fadeIn
{
    [self fadeInSlideUp];
}

- (void)fadeOut
{
    [self fadeOutSlideDown];
}

- (IBAction)confirm
{
    _confirmBlock();
    [self dismiss];
}

- (IBAction)cancel
{
    _cancelBlock();
    [self dismiss];
}

- (IBAction)okay
{
    _failureBlock();
    [self dismiss];
}

@end
