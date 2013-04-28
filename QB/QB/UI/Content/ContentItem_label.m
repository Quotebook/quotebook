#import "ContentItem_label.h"
#import "ContentView.h"

@implementation ContentItem_label

- (void)dealloc
{
    [ContentItem_label releaseRetainedPropertiesOfObject:self];
    [super dealloc];
}

- (void)viewWillShow
{
    int viewHeight = _label.frame.size.height + _additionalViewHeight;
    self.managedUIView.frame = CGRectMake(self.managedUIView.frame.origin.x,
                                          self.managedUIView.frame.origin.y,
                                          self.managedUIView.frame.size.width,
                                          viewHeight);
}

- (IBAction)cancelTextEntry
{
    ContentView* contentView = self.parent;
    [contentView cancelTextEntry];
}

@end
