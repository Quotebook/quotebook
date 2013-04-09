#import "ContentItem_button.h"
#import "ContentView.h"

@implementation ContentItem_button

- (void)dealloc
{
    self.onTapBlock = nil;
    [ContentItem_button releaseRetainedPropertiesOfObject:self];
    [super dealloc];
}

- (void)viewWillShow
{
    int viewHeight = _button.frame.size.height + _additionalViewHeight;
    self.managedUIView.frame = CGRectMake(self.managedUIView.frame.origin.x,
                                          self.managedUIView.frame.origin.y,
                                          self.managedUIView.frame.size.width,
                                          viewHeight);
}

- (IBAction)onTap
{
    if (_onTapBlock != nil)
        _onTapBlock();
}

- (IBAction)cancelTextEntry
{
    ContentView* contentView = self.parent;
    [contentView cancelTextEntry];
}

@end
