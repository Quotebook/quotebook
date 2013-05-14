#import "ContentItem_datePicker.h"
#import "ContentView.h"
#import "ContentItem_scrollView.h"

@implementation ContentDatePickerConfig
@end

@interface ContentItem_datePicker()
{
    
}
@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, assign) BOOL hasCompletedTransitionBetweenEditState;
@end

@implementation ContentItem_datePicker

- (void)viewWillShow
{
    [_datePicker addTarget:self
                    action:@selector(dateChanged:)
          forControlEvents:UIControlEventValueChanged];
    
    [self dateChanged:self];
    [self refreshEditStateWithAnimation:NO];
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
    _selectedDateLabel.text = [Util formatDate:_datePicker.date];
    _dateBlock(_datePicker.date);
}

- (IBAction)edit
{
    _isEditing = !_isEditing;
    [self refreshEditStateWithAnimation:YES];
}

- (void)refreshEditStateWithAnimation:(BOOL)animate
{
    _datePicker.enabled = _isEditing;
    
    CGAffineTransform openTransform = CGAffineTransformMakeTranslation(0, 0);
    CGAffineTransform closedTransform = CGAffineTransformMakeTranslation(0, -_bodyView.frame.size.height);
    
    if (animate)
    {
        if (!_isEditing && [self.parent isKindOfClass:ContentItem_scrollView.class])
        {
            ContentItem_scrollView* parentScrollView = self.parent;
            [parentScrollView scrollToOffset:CGPointMake(0, MAX(0, parentScrollView.scrollView.contentheight - _bodyView.frame.size.height - parentScrollView.managedUIView.frame.size.height))
                               withAnimation:YES];
        }
        
        [UIView animateWithDuration:0.3f
                         animations:^{
                             _datePicker.transform = _isEditing ? openTransform : closedTransform;
                         }
                         completion:^(BOOL finished) {
                             if (finished)
                             {
                                 [_editButton setTitle:_isEditing ? @"Done" : @"Edit"
                                              forState:UIControlStateNormal];
                                 if (!_isEditing && [self.parent isKindOfClass:ContentItem_scrollView.class])
                                 {
                                     ContentItem_scrollView* parentScrollView = self.parent;
                                     
                                     self.managedUIView.frame = CGRectMake(self.managedUIView.frame.origin.x,
                                                                           self.managedUIView.frame.origin.y,
                                                                           self.managedUIView.frame.size.width,
                                                                           _headerView.frame.size.height);
                                     [parentScrollView.scrollView refreshViewPlacement];
//                                     [parentScrollView scrollToBottomWithAnimation:YES];
                                     //[parentScrollView.scrollView refreshViewPlacement];
//                                     [parentScrollView scrollToBottomWithAnimation:YES];
                                 }
                             }
                         }];
        
        if ([self.parent isKindOfClass:ContentItem_scrollView.class])
        {
            ContentItem_scrollView* parentScrollView = self.parent;
            if (_isEditing)
            {
                self.managedUIView.frame = CGRectMake(self.managedUIView.frame.origin.x,
                                                      self.managedUIView.frame.origin.x,
                                                      self.managedUIView.frame.size.width,
                                                      _bodyView.frame.size.height + _headerView.frame.size.height);
                [parentScrollView.scrollView refreshViewPlacement];
                [parentScrollView scrollToBottomWithAnimation:YES];
            }
            else
            {
//                self.managedUIView.frame = CGRectMake(self.managedUIView.frame.origin.x,
//                                                      self.managedUIView.frame.origin.y,
//                                                      self.managedUIView.frame.size.width,
//                                                      _headerView.frame.size.height);
//                [parentScrollView.scrollView refreshViewPlacement];
//                [parentScrollView scrollToBottomWithAnimation:YES];
            }
        }
        
    }
    else
    {
        _datePicker.transform = _isEditing ? openTransform : closedTransform;
    }
}

@end
