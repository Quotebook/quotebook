#import "QB.h"

@class ContentDatePickerConfig;

@interface ContentItem_datePicker : ManagedView

@property (nonatomic, assign) IBOutlet UIDatePicker* datePicker;
@property (nonatomic, assign) IBOutlet UILabel* selectedDateLabel;
@property (nonatomic, assign) IBOutlet UIButton* editButton;
@property (nonatomic, assign) IBOutlet UIView* headerView;
@property (nonatomic, assign) IBOutlet UIView* bodyView;
@property (nonatomic, copy) void(^dateBlock)(NSDate*);

+ (ContentItem_datePicker*)createDataPickerWithContentDatePickerConfig:(ContentDatePickerConfig*)config
                                                           viewManager:(ViewManager*)viewManager
                                                                parent:(id)parent;

- (IBAction)edit;

@end
