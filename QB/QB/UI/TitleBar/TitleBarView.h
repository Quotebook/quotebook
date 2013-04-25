#import "QB.h"

@interface SideMenuConfig : ManagedPropertiesObject
@property (nonatomic, retain) NSString* buttonTitleText;
@property (nonatomic, copy) VoidBlock buttonAction;
@end


@interface TitleBarView : ManagedView

@property (nonatomic, assign) IBOutlet UIView* mainView;
@property (nonatomic, assign) IBOutlet UILabel* titleLabel;
@property (nonatomic, assign) IBOutlet UIButton* toggleSideMenuButton;
@property (nonatomic, assign) IBOutlet UIButton* rightButton;

- (IBAction)toggleSideMenu;
- (IBAction)rightAction;

- (void)reconfigureAndAnimateTransitionWithTitle:(NSString*)title
                               rightButtonAction:(VoidBlock)rightButtonActionBlock
                                   sideMenuTitle:(NSString*)sideMenuTitle
                                 sideMenuConfigs:(NSArray*)sideMenuConfigs
                                shouldAnimateOut:(BOOL)animateOut;

// === SIDE MENU ===

@property (nonatomic, assign) IBOutlet UIView* sideMenuView;
@property (nonatomic, assign) IBOutlet UIView* sideMenuLipBackgroundView;
@property (nonatomic, assign) IBOutlet UIView* sideMenuButtonBackgroundView;
@property (nonatomic, assign) IBOutlet UILabel* sideMenuTitleLabel;
@property (nonatomic, retain) IBOutletCollection(UIView) NSArray* sideMenuButtons;


@end
