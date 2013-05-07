#import "ContentItem_spacer.h"
#import "ContentItem_scrollView.h"

@implementation ContentItem_spacer

- (void)dealloc
{
    [ContentItem_spacer releaseRetainedPropertiesOfObject:self];
    [super dealloc];
}

+ (ContentItem_spacer*)createSpacerWithHieght:(int)spacerHeight
                                  viewManager:(ViewManager*)viewManager
                                       parent:(id)parent
{
    ContentItem_spacer* spacerItem = [viewManager createManagedViewOfClass:ContentItem_spacer.class
                                                                    parent:parent];
    
    spacerItem.additionalViewHeight = spacerHeight;
    
    return spacerItem;
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
    ContentItem_scrollView* parent = self.parent;
    [parent cancelTextEntry];
}

@end
