#import "ContentItem_button.h"
#import "ContentItem_scrollView.h"
#import "ContentViewConfig.h"

@implementation ContentItem_button

- (void)dealloc
{
    self.onTapBlock = nil;
    [ContentItem_button releaseRetainedPropertiesOfObject:self];
    [super dealloc];
}

+ (ContentItem_button*)createButtonWithContentButtonConfig:(ContentButtonConfig*)config
                                               viewManager:(ViewManager*)viewManager
                                                    parent:(id)parent
{
    ContentItem_button* buttonItem = [viewManager createManagedViewOfClass:ContentItem_button.class
                                                                    parent:parent];
    
    [buttonItem.button setTitle:config.buttonTitle
                       forState:UIControlStateNormal];
    
    buttonItem.onTapBlock = config.onTapBlock;
    
    buttonItem.additionalViewHeight = config.additionalViewHeight;
    
    return buttonItem;
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
    ContentItem_scrollView* parent = self.parent;
    [parent cancelTextEntry];
}

@end
