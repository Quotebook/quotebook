#import "QB.h"

@class ContentDatePickerConfig;

@interface ContentItem_datePicker : ManagedView

@property (nonatomic, assign) IBOutlet UIDatePicker* datePicker;
@property (nonatomic, copy) void(^dateBlock)(NSDate*);

+ (ContentItem_datePicker*)createDataPickerWithContentDatePickerConfig:(ContentDatePickerConfig*)config
                                                           viewManager:(ViewManager*)viewManager
                                                                parent:(id)parent;

@end
