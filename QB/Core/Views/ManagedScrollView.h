#import "ManagedView.h"

@interface ManagedScrollView : UIScrollView

- (NSArray*)managedViews;

- (void)addManagedView:(ManagedView*)managedView
  refreshViewPlacement:(BOOL)refreshViewPlacement;

- (void)addManagedView:(ManagedView*)managedView
               atIndex:(int)index
  refreshViewPlacement:(BOOL)refreshViewPlacement;

- (void)addManagedViews:(NSArray*)managedViews;

- (void)removeAllManagedViews;

- (void)setHorizontalSpacing:(int)horizontalSpacing;

- (void)setVerticalSpacing:(int)verticalSpacing;

- (void)refreshViewPlacement;

@end

@interface ManagedPassthroughScrollView : ManagedScrollView

- (UIView*)hitTest:(CGPoint)point
         withEvent:(UIEvent*)event;

@end