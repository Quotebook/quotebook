#import "QB.h"

@interface ContentItem_textField : ManagedView<UITextFieldDelegate>

@property (nonatomic, assign) IBOutlet UITextField* textField;
@property (nonatomic, assign) IBOutlet UILabel* titleLabel;
@property (nonatomic, assign) IBOutlet UITextField* textFieldWithlabel;

@property (nonatomic, copy) void(^textBlock)(NSString*);

@property (nonatomic, assign) int additionalViewHeight;

@property (nonatomic, retain) NSString* labelText;
@property (nonatomic, retain) NSString* overrideText;
@property (nonatomic, retain) NSString* defaultText;

- (void)activateTextField;

- (void)deactivateTextField;

- (IBAction)cancelTextEntry;

@end
