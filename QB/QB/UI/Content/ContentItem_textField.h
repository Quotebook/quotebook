#import "QB.h"
#import "ContentViewConfig.h"

@interface ContentTextFieldConfig : ContentItemConfig
@property (nonatomic, retain) NSString* labelText;
@property (nonatomic, retain) NSString* overrideFieldText;
@property (nonatomic, retain) NSString* defaultFieldText;
@property (nonatomic, assign) BOOL secureTextEntry;
@property (nonatomic, assign) BOOL shouldUseTextView;
@property (nonatomic, copy) void(^textBlock)(NSString*);
@end

@interface ContentItem_textField : ManagedView<UITextFieldDelegate, UITextFieldDelegate>

@property (nonatomic, assign) IBOutlet UILabel* titleLabel;
@property (nonatomic, assign) IBOutlet UIButton* cancelTextEntryButton;
@property (nonatomic, assign) IBOutlet UITextField* textField;
@property (nonatomic, assign) IBOutlet UITextField* textFieldWithlabel;
@property (nonatomic, assign) IBOutlet UITextView* textView;
@property (nonatomic, assign) IBOutlet UITextView* textViewWithlabel;

+ (ContentItem_textField*)createTextFieldWithContentTextFieldConfig:(ContentTextFieldConfig*)config
                                                        viewManager:(ViewManager*)viewManager
                                                             parent:(id)parent;

- (void)activateTextField;

- (void)deactivateTextField;

- (IBAction)cancelTextEntry;

@end
