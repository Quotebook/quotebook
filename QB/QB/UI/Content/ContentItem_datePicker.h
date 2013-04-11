#import "QB.h"

@interface ContentItem_datePicker : ManagedView

@property (nonatomic, retain) IBOutlet UIDatePicker* datePicker;
@property (nonatomic, copy) void(^dateBlock)(NSDate*);

@end
