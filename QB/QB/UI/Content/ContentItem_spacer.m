#import "ContentItem_spacer.h"
#import "ContentView.h"

@implementation ContentItem_spacer

- (void)dealloc
{
    [ContentItem_spacer releaseRetainedPropertiesOfObject:self];
    [super dealloc];
}

- (void)viewWillShow
{
    self.managedUIView.frame = CGRectMake(self.managedUIView.frame.origin.x,
                                          self.managedUIView.frame.origin.y,
                                          self.managedUIView.frame.size.width,
                                          self.managedUIView.frame.size.height + _additionalViewHeight);
}

- (IBAction)cancelTextEntry
{
    ContentView* contentView = self.parent;
    [contentView cancelTextEntry];
}

@end
