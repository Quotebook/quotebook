#import "ContentItem_datePicker.h"
#import "ContentView.h"

@implementation ContentItem_datePicker

- (void)viewWillShow
{
    [_datePicker addTarget:self
                    action:@selector(dateChanged:)
          forControlEvents:UIControlEventValueChanged];
}

- (void)dealloc
{
    self.dateBlock = nil;
	[ContentItem_datePicker releaseRetainedPropertiesOfObject:self];
	[super dealloc];
}

- (ContentView*)internal_parent
{
    return self.parent;
}

- (void)dateChanged:(id)sender
{
    _dateBlock(_datePicker.date);
}

@end
