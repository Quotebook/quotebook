#import "QB.h"

@interface ConfirmActionView : ManagedView

@property (nonatomic, assign) IBOutlet UILabel* titleLabel;
@property (nonatomic, assign) IBOutlet UIButton* confirmButton;
@property (nonatomic, assign) IBOutlet UIButton* cancelButton;
@property (nonatomic, assign) IBOutlet UIButton* failureButton;
@property (nonatomic, copy) VoidBlock confirmBlock;
@property (nonatomic, copy) VoidBlock cancelBlock;
@property (nonatomic, copy) VoidBlock failureBlock;


- (IBAction)confirm;
- (IBAction)cancel;
- (IBAction)okay;

@end
