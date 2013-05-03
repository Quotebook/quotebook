#import "ContentItem_label.h"
#import "ContentItem_scrollViewItem.h"
#import "ContentViewConfig.h"

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
    ContentItem_scrollViewItem* parent = self.parent;
    [parent cancelTextEntry];
}

+ (ContentItem_label*)createWithConfig:(ContentLabelConfig*)config
                           viewManager:(ViewManager*)viewManager
                                parent:(id)parent
{
    ContentItem_label* labelItem = [viewManager createManagedViewOfClass:ContentItem_label.class
                                                                  parent:parent];
    
    [labelItem.label setText:config.labelText];
    
    if (config.wordWrap)
    {
        CGRect originalFrame = labelItem.label.frame;
        
        [labelItem.label setLineBreakMode:NSLineBreakByWordWrapping];
        labelItem.label.numberOfLines = (originalFrame.size.height + config.additionalViewHeight) / 22;
        labelItem.label.frame = CGRectMake(originalFrame.origin.x, originalFrame.origin.y,
                                           originalFrame.size.width, originalFrame.size.height + config.additionalViewHeight);
    }
    
    if (config.alignment != ContentConfigAlignmentNone)
    {
        labelItem.label.textAlignment = config.alignment;
    }
    
    switch (config.font)
    {
        case ContentConfigFontNormal:
            break;
        case ContentConfigFontBold:
            labelItem.label.font = [UIFont fontWithName:@"GillSans-Bold"
                                                   size:17];
            break;
        case ContentConfigFontItalic:
            labelItem.label.font = [UIFont fontWithName:@"GillSans-Italic"
                                                   size:17];
            break;
        case ContentConfigFontBoldItalic:
            labelItem.label.font = [UIFont fontWithName:@"GillSans-BoldItalic"
                                                   size:17];
            break;
    }
    
    labelItem.additionalViewHeight = config.additionalViewHeight;
    
    return labelItem;
}

@end
