#import <UIKit/UIKit.h>

@interface PassthroughView : UIView

- (UIView*)hitTest:(CGPoint)point
         withEvent:(UIEvent*)event;

@end
