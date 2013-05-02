#import "ContentItem_datePicker.h"
#import "ContentView.h"
#import "ContentViewConfig.h"

@implementation ContentItem_datePicker

- (void)viewWillShow
{
    [_datePicker addTarget:self
                    action:@selector(dateChanged:)
          forControlEvents:UIControlEventValueChanged];
    
    [self dateChanged:self];
}

+ (ContentItem_datePicker*)createDataPickerWithContentDatePickerConfig:(ContentDatePickerConfig*)config
                                                           viewManager:(ViewManager*)viewManager
                                                                parent:(id)parent
{
    ContentItem_datePicker* datePickerItem = [viewManager createManagedViewOfClass:ContentItem_datePicker.class
                                                                            parent:parent];
    
    if (config.defaultDate != nil)
    {
        datePickerItem.datePicker.date = config.defaultDate;
    }
    datePickerItem.dateBlock = config.dateBlock;
    
    return datePickerItem;
}

- (void)dealloc
{
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
