#import "QB.h"

@interface ConfirmActionView : ManagedView

@property (nonatomic, retain) IBOutlet UILabel* titleLabel;
@property (nonatomic, retain) IBOutlet UIButton* confirmButton;
@property (nonatomic, retain) IBOutlet UIButton* cancelButton;
@property (nonatomic, retain) IBOutlet UIButton* failureButton;
@property (nonatomic, copy) VoidBlock confirmBlock;
@property (nonatomic, copy) VoidBlock cancelBlock;
@property (nonatomic, copy) VoidBlock failureBlock;


- (IBAction)confirm;
- (IBAction)cancel;
- (IBAction)okay;

@end
