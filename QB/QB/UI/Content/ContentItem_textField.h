#import "QB.h"

@interface ContentItem_textField : ManagedView<UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UITextField* textField;
@property (nonatomic, retain) IBOutlet UILabel* titleLabel;
@property (nonatomic, retain) IBOutlet UITextField* textFieldWithlabel;
@property (nonatomic, copy) void(^textBlock)(NSString*);

@property (nonatomic, assign) int additionalViewHeight;

@property (nonatomic, retain) NSString* labelText;

- (void)activateTextField;

- (void)deactivateTextField;

- (IBAction)cancelTextEntry;

@end
