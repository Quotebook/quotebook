#import "TitleBarView.h"

@implementation SideMenuConfig
@end

@interface TitleBarView ()

@property (nonatomic, assign) BOOL sideMenuIsOpen;
@property (nonatomic, copy) VoidBlock rightButtonActionBlock;
@property (nonatomic, retain) NSArray* sideMenuConfigs;

@end

@implementation TitleBarView

- (void)dealloc
{
    [TitleBarView releaseRetainedPropertiesOfObject:self];
    [super dealloc];
}

- (void)sideMenuButtonAction:(id)sender
{
    int index = [_sideMenuButtons indexOfObject:sender];
    SideMenuConfig* sideMenuConfig = [_sideMenuConfigs objectAtIndex:index];
    sideMenuConfig.buttonAction();
}

- (void)viewWillShow
{
    _rightButton.hidden = _rightButtonActionBlock == nil;
    _toggleSideMenuButton.hidden = _sideMenuConfigs == nil || _sideMenuConfigs.count == 0;
}

- (void)internal_closeSideMenu
{
    [UIView animateWithDuration:0.3f
                     animations:^{
                         _sideMenuLipBackgroundView.alpha = 0;
                         _sideMenuView.transform = CGAffineTransformMakeTranslation(0, 0);
                     }];
}

- (void)internal_openSideMenu
{
    [UIView animateWithDuration:0.3f
                     animations:^{
                         _sideMenuLipBackgroundView.alpha = 0.5f;
                         _sideMenuView.transform = CGAffineTransformMakeTranslation(_sideMenuButtonBackgroundView.frame.size.width, 0);
                     }];
}

- (IBAction)toggleSideMenu
{
    if (_sideMenuIsOpen)
    {
        _sideMenuIsOpen = NO;
        [self internal_closeSideMenu];
    }
    else
    {
        _sideMenuIsOpen = YES;
        [self internal_openSideMenu];
    }
}

- (IBAction)rightAction
{
    _rightButtonActionBlock();
}

- (void)reconfigureAndAnimateTransitionWithTitle:(NSString*)title
                               rightButtonAction:(VoidBlock)rightButtonActionBlock
                                   sideMenuTitle:(NSString*)sideMenuTitle
                                 sideMenuConfigs:(NSArray*)sideMenuConfigs
                                shouldAnimateOut:(BOOL)animateOut;
{
    [self internal_closeSideMenu];
    
    self.titleLabel.text = title;
    self.sideMenuTitleLabel.text = sideMenuTitle;
    self.sideMenuConfigs = sideMenuConfigs;
    self.rightButtonActionBlock = rightButtonActionBlock;
    self.sideMenuIsOpen = NO;
    
    _rightButton.hidden = _rightButtonActionBlock == nil;
    _toggleSideMenuButton.hidden = _sideMenuConfigs == nil || _sideMenuConfigs.count == 0;
    
    int sideMenuConfigCount = MIN(_sideMenuConfigs.count, _sideMenuButtons.count);
    for (int index = 0; index < sideMenuConfigCount; ++index)
    {
        UIButton* sideMenuButton = [_sideMenuButtons objectAtIndex:index];
        sideMenuButton.hidden = NO;
        
        SideMenuConfig* sideMenuConfig = [_sideMenuConfigs objectAtIndex:index];
        
        [sideMenuButton setTitle:sideMenuConfig.buttonTitleText
                        forState:UIControlStateNormal];
        
        [sideMenuButton addTarget:self
                           action:@selector(sideMenuButtonAction:)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    
    for (int index = sideMenuConfigCount; index < _sideMenuButtons.count; ++index)
    {
        UIButton* sideMenuButton = [_sideMenuButtons objectAtIndex:index];
        sideMenuButton.hidden = YES;
    }
    
    // TODO - fade title out, fade buttons out or in if need be.
    
    [self bringSubviewToFront];
}

@end
