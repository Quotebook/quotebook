#import "QB.h"

@interface SideMenuConfig : ManagedPropertiesObject
@property (nonatomic, retain) NSString* buttonTitleText;
@property (nonatomic, copy) VoidBlock buttonAction;
@end


@interface TitleBarView : ManagedView

@property (nonatomic, retain) IBOutlet UIView* mainView;
@property (nonatomic, retain) IBOutlet UILabel* titleLabel;
@property (nonatomic, retain) IBOutlet UIButton* toggleSideMenuButton;
@property (nonatomic, retain) IBOutlet UIButton* rightButton;

- (IBAction)toggleSideMenu;
- (IBAction)rightAction;

- (void)reconfigureAndAnimateTransitionWithTitle:(NSString*)title
                               rightButtonAction:(VoidBlock)rightButtonActionBlock
                                   sideMenuTitle:(NSString*)sideMenuTitle
                                 sideMenuConfigs:(NSArray*)sideMenuConfigs
                                shouldAnimateOut:(BOOL)animateOut;

// === SIDE MENU ===

@property (nonatomic, retain) IBOutlet UIView* sideMenuView;
@property (nonatomic, retain) IBOutlet UIView* sideMenuLipBackgroundView;
@property (nonatomic, retain) IBOutlet UIView* sideMenuButtonBackgroundView;
@property (nonatomic, retain) IBOutlet UILabel* sideMenuTitleLabel;
@property (nonatomic, retain) IBOutletCollection(UIView) NSArray* sideMenuButtons;


@end
