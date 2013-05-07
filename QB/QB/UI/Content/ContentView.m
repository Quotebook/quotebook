#import "ContentView.h"
#import "ContentViewConfig.h"
#import "ContentItem_scrollView.h"

@interface ContentView ()
{
    ViewManager* viewManager;
}

@property (nonatomic, retain) ContentItem_scrollView* scrollView;

@end

@implementation ContentView

- (void)dealloc
{
    [self.scrollView dismiss];
    [ContentView releaseRetainedPropertiesOfObject:self];
    [super dealloc];
}

- (void)dismiss
{
    [self cancelTextEntry];
    [super dismiss];
}

- (void)viewWillShow
{
    [_scrollViewContainer addSubview:_scrollView.managedUIView];
    
    _actionButton.hidden = _actionBlock == nil;
    _actionButton.userInteractionEnabled = _actionBlock != nil;
}

- (void)internal_createScrollView
{
    if (_scrollView == nil)
    {
        self.scrollView =  [viewManager createManagedViewOfClass:ContentItem_scrollView.class
                                                          parent:self];
    }
}

- (IBAction)executeActionBlock
{
    CheckNotNull(_actionBlock);
    
    _actionBlock();
}

- (void)configureWithContentViewConfig:(ContentViewConfig*)contentViewConfig
{
    [self internal_createScrollView];
    
//    ContentScrollViewConfig* scrollViewConfig = [ContentScrollViewConfig object];
//    [scrollViewConfig.contentViewConfigs addObject:contentViewConfig];
    [_scrollView configureAsContentView:contentViewConfig];
}

- (void)configureWithContentScrollViewConfig:(ContentScrollViewConfig*)scrollViewConfig
{
    [self internal_createScrollView];
    
    [_scrollView configureAsScrollView:scrollViewConfig];
}

- (void)addContentItemConfigs:(NSArray*)contentItemConfigsToAdd
{
    CheckNotNull(_scrollView)
    
    [[_scrollView activeScrollViewItem] addContentItemConfigs:contentItemConfigsToAdd];   
}

- (IBAction)cancelTextEntry
{
    CheckNotNull(_scrollView)
    
    [self.managedUIView endEditing:YES];
    [[_scrollView activeScrollViewItem] cancelTextEntry];
}

@end
