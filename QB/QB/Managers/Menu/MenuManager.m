#import "MenuManager.h"
#import "BackgroundView.h"
#import "ContentView.h"
#import "ContentViewConfig.h"
#import "TitleBarView.h"
#import "BookManager.h"
#import "UserManager.h"
#import "ConfirmActionView.h"
#import "QB.h"
#import "QBUser.h"
#import "QBQuote.h"
#import "UserService.h"
#import "QuoteManager.h"
#import "DebugPanel.h"

@interface MenuManager ()

@property (nonatomic, retain) BackgroundView* backgroundView;
@property (nonatomic, retain) ContentView* contentView;
@property (nonatomic, retain) TitleBarView* titleBarView;
@end

@implementation MenuManager
{
    ViewManager* viewManager;
    UserManager* userManager;
    BookManager* bookManager;
    QuoteManager* quoteManager;
}

#define kDefaultAdditionalHeight 20

#define ContentButtonConfig(additionalViewHeightArg, buttonTitleArg, onTapBlockArg) ^ContentButtonConfig*{ \
ContentButtonConfig* contentButtonConfig = [ContentButtonConfig object]; \
contentButtonConfig.additionalViewHeight = additionalViewHeightArg; \
contentButtonConfig.buttonTitle = buttonTitleArg; \
contentButtonConfig.onTapBlock = onTapBlockArg; \
return contentButtonConfig; \
}()

#define ContentLabelConfig(additionalViewHeightArg, wordWrapArg, labelTextArg) ^ContentLabelConfig*{ \
ContentLabelConfig* contentLabelConfig = [ContentLabelConfig object]; \
contentLabelConfig.additionalViewHeight = additionalViewHeightArg; \
contentLabelConfig.labelText = labelTextArg; \
contentLabelConfig.wordWrap = wordWrapArg; \
return contentLabelConfig; \
}()

#define ContentTextFieldConfig(additionalViewHeightArg, textBlockArg) ^ContentTextFieldConfig*{ \
ContentTextFieldConfig* contentTextFieldConfig = [ContentTextFieldConfig object]; \
contentTextFieldConfig.additionalViewHeight = additionalViewHeightArg; \
contentTextFieldConfig.textBlock = textBlockArg; \
return contentTextFieldConfig; \
}()

#define ContentTextFieldConfig_label(additionalViewHeightArg, labelTextArg, textBlockArg) ^ContentTextFieldConfig*{ \
ContentTextFieldConfig* contentTextFieldConfig = [ContentTextFieldConfig object]; \
contentTextFieldConfig.additionalViewHeight = additionalViewHeightArg; \
contentTextFieldConfig.textBlock = textBlockArg; \
contentTextFieldConfig.labelText = labelTextArg; \
return contentTextFieldConfig; \
}()

#define ContentDatePickerConfig(additionalViewHeightArg, dateBlockArg) ^ContentDatePickerConfig*{ \
ContentDatePickerConfig* contentDatePickerConfig = [ContentDatePickerConfig object]; \
contentDatePickerConfig.additionalViewHeight = additionalViewHeightArg; \
contentDatePickerConfig.dateBlock = dateBlockArg; \
return contentDatePickerConfig; \
}()

#define ConfigureContentViewWithAction(contentViewArg, actionButtonTitleArg, actionBlockArg) { \
contentViewArg.actionBlock = actionBlockArg; \
[contentViewArg.actionButton setTitle:actionButtonTitleArg \
forState:UIControlStateNormal]; \
}

- (void)showDebugPanel
{
    [viewManager showManagedViewOfClassOnLayer:DebugPanel.class
                                     layerName:kDebugViewLayer
                                    setupBlock:^(DebugPanel* debugPanel) {
                                    }];
}

- (void)showDefaultBackground
{
    if (_backgroundView == nil)
    {
        [viewManager showManagedViewOfClassOnDefaultLayer:BackgroundView.class
                                               setupBlock:^(BackgroundView* backgroundView) {
                                                   self.backgroundView = backgroundView;
                                               }];
    }
}

- (void)showTitleBarForBook:(QBBook*)book
                    forUser:(QBUser*)user
           backButtonAction:(VoidBlock)backButtonAction
{
    BOOL firstTitleBar = _titleBarView == nil;
    
    if (firstTitleBar)
    {
        [viewManager showManagedViewOfClassOnDefaultLayer:TitleBarView.class
                                               setupBlock:^(TitleBarView* titleBarView) {
                                                   self.titleBarView = titleBarView;
                                               }];
    }
    
    NSMutableArray* sideMenuConfigs = [NSMutableArray object];
    
    SideMenuConfig* addNewQuoteConfig = [SideMenuConfig object];
    SideMenuConfig* inviteMembersConfig = [SideMenuConfig object];
    SideMenuConfig* displayOptionsConfig = [SideMenuConfig object];
    SideMenuConfig* viewStatsConfig = [SideMenuConfig object];
    SideMenuConfig* searchConfig = [SideMenuConfig object];
    
    [sideMenuConfigs addObject:addNewQuoteConfig];
    [sideMenuConfigs addObject:inviteMembersConfig];
    [sideMenuConfigs addObject:displayOptionsConfig];
    [sideMenuConfigs addObject:viewStatsConfig];
    [sideMenuConfigs addObject:searchConfig];
    
    addNewQuoteConfig.buttonTitleText = @"Add new quote";
    inviteMembersConfig.buttonTitleText = @"Invite members";
    displayOptionsConfig.buttonTitleText = @"Display options";
    viewStatsConfig.buttonTitleText = @"View stats";
    searchConfig.buttonTitleText = @"Search";
    
    addNewQuoteConfig.buttonAction = ^{
        [self showMenuForAddingNewQuoteToBook:book
                                      forUser:user
                                optionalQuote:nil];
    };

    inviteMembersConfig.buttonAction = ^{
        [self showMenuForInvitingNewMembersToBook:book
                                          forUser:user];
    };
    
    displayOptionsConfig.buttonAction = ^{
        [self showMenuForDisplayOptionsForBook:book
                                       forUser:user];
    };
    
    viewStatsConfig.buttonAction = ^{
        [self showMenuForViewingStatsForBook:book
                                     forUser:user];
    };
    
    searchConfig.buttonAction = ^{
        [self showMenuForSearchingInBook:book
                                 forUser:user];
    };
    
    [_titleBarView reconfigureAndAnimateTransitionWithTitle:book.title
                                          rightButtonAction:backButtonAction
                                              sideMenuTitle:@"Book Actions"
                                            sideMenuConfigs:sideMenuConfigs
                                           shouldAnimateOut:!firstTitleBar];
}

- (void)showTitleBarForQuote:(QBQuote*)quote
                     forUser:(QBUser*)user
            backButtonAction:(VoidBlock)backButtonAction
{
    BOOL firstTitleBar = _titleBarView == nil;
    
    if (firstTitleBar)
    {
        [viewManager showManagedViewOfClassOnDefaultLayer:TitleBarView.class
                                               setupBlock:^(TitleBarView* titleBarView) {
                                                   self.titleBarView = titleBarView;
                                               }];
    }
    
    NSMutableArray* sideMenuConfigs = [NSMutableArray object];
    
    [_titleBarView reconfigureAndAnimateTransitionWithTitle:[quote formatDisplayName]
                                          rightButtonAction:backButtonAction
                                              sideMenuTitle:@"Quote Actions"
                                            sideMenuConfigs:sideMenuConfigs
                                           shouldAnimateOut:!firstTitleBar];
}

- (void)showTitleBarWithTitle:(NSString*)title
             backButtonAction:(VoidBlock)backButtonAction
{
    BOOL firstTitleBar = _titleBarView == nil;
    
    if (firstTitleBar)
    {
        [viewManager showManagedViewOfClassOnDefaultLayer:TitleBarView.class
                                               setupBlock:^(TitleBarView* titleBarView) {
                                                   self.titleBarView = titleBarView;
                                               }];
    }
    
    
    
    [_titleBarView reconfigureAndAnimateTransitionWithTitle:title
                                          rightButtonAction:backButtonAction
                                              sideMenuTitle:@""
                                            sideMenuConfigs:nil
                                           shouldAnimateOut:firstTitleBar];
}

- (void)showContentViewWithSetupBlock:(void(^)(ContentView*))setupBlock
{
    CheckTrue(_contentView == nil);
    
    [viewManager showManagedViewOfClassOnDefaultLayer:ContentView.class
                                           setupBlock:^(ContentView* contentView) {
                                               self.contentView = contentView;
                                               setupBlock(contentView);
                                           }];
}

- (void)dismissContentView
{   
    [_contentView dismiss];
    
    self.contentView = nil;
}

- (void)showCreateNewLoginMenu
{
    [self dismissContentView];
    
    [self showDefaultBackground];
    
    [self showContentViewWithSetupBlock:^(ContentView* contentView) {
        __block NSString* email = nil;
        __block NSString* firstName = nil;
        __block NSString* lastName = nil;
        __block NSString* password = nil;
        __block NSString* confirm = nil;
        
        ContentViewConfig* contentViewConfig = [ContentViewConfig object];
        [contentViewConfig.viewConfigs addObject:ContentLabelConfig(kDefaultAdditionalHeight, NO, @"Basic info:")];
        [contentViewConfig.viewConfigs addObject:ContentTextFieldConfig_label(kDefaultAdditionalHeight, @"E-mail:", ^(NSString* enteredString) {
            email = enteredString;
        })];
        [contentViewConfig.viewConfigs addObject:ContentTextFieldConfig_label(kDefaultAdditionalHeight, @"First name:", ^(NSString* enteredString) {
            firstName = enteredString;
        })];
        [contentViewConfig.viewConfigs addObject:ContentTextFieldConfig_label(kDefaultAdditionalHeight, @"Last name", ^(NSString* enteredString) {
            lastName = enteredString;
        })];
        [contentViewConfig.viewConfigs addObject:ContentLabelConfig(kDefaultAdditionalHeight * .2, NO, @"Create password:")];
        ContentTextFieldConfig* passwordConfig = ContentTextFieldConfig_label(kDefaultAdditionalHeight, @"Password:",^(NSString* enteredString) {
            password = enteredString;
        });
        passwordConfig.secureTextEntry = YES;
        [contentViewConfig.viewConfigs addObject:passwordConfig];
        ContentTextFieldConfig* confirmConfig = ContentTextFieldConfig_label(kDefaultAdditionalHeight, @"Confirm", ^(NSString* enteredString) {
            confirm = enteredString;
        });
        confirmConfig.secureTextEntry = YES;
        [contentViewConfig.viewConfigs addObject:confirmConfig];
        [contentView configureWithContentViewConfig:contentViewConfig];
        
        ConfigureContentViewWithAction(contentView, @"Done", ^{
            [userManager createNewUserWithEmail:email
                                      firstName:firstName
                                       lastName:lastName
                                       password:password
                                        confirm:confirm
                                   successBlock:^(QBUser* newUser){
                                       [userManager loginUserWithEmail:email
                                                              password:password
                                                          successBlock:^(LoginResponse* loginResponse) {
                                                              [self showMenuForUser:loginResponse.user];
                                                          }
                                                          failureBlock:^{
                                                              [self confirmFailureWithText:@"Login failed"
                                                                              failureBlock:^{}];
                                                          }];
                                   }
                                   failureBlock:^{
                                       [self confirmFailureWithText:@"New User Failed"
                                                       failureBlock:^{}];
                                   }];

        });
    }];
    
    [self showTitleBarWithTitle:@"Create new login..."
               backButtonAction:^{
                   [self showLoginMenu];
               }];
}

- (void)showCreateNewBookMenuForUser:(QBUser*)user
{
    [self dismissContentView];
    
    [self showDefaultBackground];
    
    __block NSString* bookName = nil;
    
    [self showContentViewWithSetupBlock:^(ContentView* contentView) {
        ContentViewConfig* contentViewConfig = [ContentViewConfig object];
        contentViewConfig.initialSpacerHeight = 60;
        [contentViewConfig.viewConfigs addObject:ContentLabelConfig(kDefaultAdditionalHeight * 1.5, NO, @"Name the book:")];
        [contentViewConfig.viewConfigs addObject:ContentTextFieldConfig(kDefaultAdditionalHeight,^(NSString* enteredString) {
            bookName = [[NSString alloc] initWithString:enteredString];
        })];
        
        [contentView configureWithContentViewConfig:contentViewConfig];
        
        ConfigureContentViewWithAction(contentView, @"Create!", ^{
            [bookManager createNewBookWithBookName:bookName
                                      successBlock:^(QBBook* book){
                                          [bookName release];
                                          
                                          [self showMenuForInvitingNewMembersToBook:book
                                                                            forUser:user];
                                      }
                                      failureBlock:^{
                                          //[self refreshWithErrors];
                                          [self confirmFailureWithText:@"New Book Failed"
                                                          failureBlock:^{}];
                                      }];
        });
    }];
    
    [self showTitleBarWithTitle:@"Create new book..."
               backButtonAction:^{
                   [bookName release];
                   [self showMenuForUser:user];
               }];
}

- (void)confirmActionWithText:(NSString*)text
                 confirmBlock:(VoidBlock)confirmBlock
                 cancelBlock:(VoidBlock)cancelBlock
{
    [viewManager showManagedViewOfClassOnLayer:ConfirmActionView.class
                                     layerName:kPopupViewLayer
                                    setupBlock:^(ConfirmActionView* confirmActionView) {
                                        confirmActionView.titleLabel.text = text;
                                        confirmActionView.confirmBlock = confirmBlock;
                                        confirmActionView.cancelBlock = cancelBlock;
                                    }];
}

- (void)confirmFailureWithText:(NSString*)text
                 failureBlock:(VoidBlock)failureBlock
{
    [viewManager showManagedViewOfClassOnLayer:ConfirmActionView.class
                                     layerName:kPopupViewLayer
                                    setupBlock:^(ConfirmActionView* confirmActionView) {
                                        confirmActionView.titleLabel.text = text;
                                        confirmActionView.failureBlock = failureBlock;
                                    }];
}

- (void)showLoginMenu
{
    [self dismissContentView];
    
    [self showDefaultBackground];
    
    [self showContentViewWithSetupBlock:^(ContentView* contentView) {
        __block NSString* email = nil;
        __block NSString* password = nil;
        
        ContentViewConfig* contentViewConfig = [ContentViewConfig object];
        contentViewConfig.initialSpacerHeight = 80;
        [contentViewConfig.viewConfigs addObject:ContentTextFieldConfig_label(kDefaultAdditionalHeight, @"E-mail", ^(NSString* enteredString) {
            email = enteredString;
        })];
        ContentTextFieldConfig* config = ContentTextFieldConfig_label(kDefaultAdditionalHeight, @"Password", ^(NSString* enteredString) {
            password = enteredString;
        });
        config.secureTextEntry = YES;
        [contentViewConfig.viewConfigs addObject:config];

        [contentViewConfig.viewConfigs addObject:ContentButtonConfig(kDefaultAdditionalHeight, @"Login", ^{
            [userManager loginUserWithEmail:email
                                   password:password
                               successBlock:^(LoginResponse* loginResponse) {
                                    [self showMenuForUser:loginResponse.user];
                                }
                                failureBlock:^{
                                    [self confirmFailureWithText:@"Login failed"
                                                    failureBlock:^{}];
                                }];
        })];
        
        [contentView configureWithContentViewConfig:contentViewConfig];
        
        ConfigureContentViewWithAction(contentView, @"Create new login...", ^{
            [self showCreateNewLoginMenu];
        }); 
    }];
    
    [self showTitleBarWithTitle:@"Quote with me..."
               backButtonAction:nil];
}

- (void)showMenuForUser:(QBUser*)user
{
    [self dismissContentView];
    
    [self showDefaultBackground];
    
    [self showContentViewWithSetupBlock:^(ContentView* contentView) {
        ContentViewConfig* contentViewConfig = [ContentViewConfig object];
        
        if (user.bookIds == nil ||
            user.bookIds.count == 0)
        {
            [contentViewConfig.viewConfigs addObject:ContentLabelConfig(kDefaultAdditionalHeight * 3, YES, @"Get started by creating a new book!")];
        }
        else
        {
            for (NSNumber* bookId in user.bookIds)
            {
                QBBook* book = [bookManager bookForBookId:bookId.intValue];
                [contentViewConfig.viewConfigs addObject:ContentButtonConfig(kDefaultAdditionalHeight, book.title, ^{
                    [self showMenuForBook:book
                                  forUser:user];
                })];
            }
        }
        [contentView configureWithContentViewConfig:contentViewConfig];
        
        ConfigureContentViewWithAction(contentView, @"Create new book...", ^{
            [self showCreateNewBookMenuForUser:user];
        });
        
    }];
    
    [self showTitleBarWithTitle:@"Your Quotebooks"
               backButtonAction:^{
                   [self confirmActionWithText:@"Logout?"
                                  confirmBlock:^{
                                      [userManager logout];
                                      [userManager setActiveUser:nil];
                                      [self showLoginMenu];
                                  }
                                   cancelBlock:^{}];
               }];
}

- (void)showMenuForBook:(QBBook*)book
                forUser:(QBUser*)user
{
    [self dismissContentView];
    
    [self showDefaultBackground];
    
    [self showContentViewWithSetupBlock:^(ContentView* contentView) {
        ContentViewConfig* contentViewConfig = [ContentViewConfig object];
        for (QBQuote* quote in book.quotes)
        {
            [contentViewConfig.viewConfigs addObject:ContentButtonConfig(kDefaultAdditionalHeight, [quote formatDisplayName], ^{
                [self showMenuForViewingQuote:quote
                                      forBook:book
                                      forUser:user
                                    asPreview:NO];
            })];
        }
        
        [contentView configureWithContentViewConfig:contentViewConfig];
        
    }];
    
    [self showTitleBarForBook:book
                      forUser:user
             backButtonAction:^{
                 [self showMenuForUser:user];
             }];
}

- (void)showMenuForViewingQuote:(QBQuote*)quote
                        forBook:(QBBook*)book
                        forUser:(QBUser*)user
                      asPreview:(BOOL)asPreview
{
    [quote retain];
    
    [self dismissContentView];
    
    [self showDefaultBackground];
    
    [self showContentViewWithSetupBlock:^(ContentView* contentView) {
        ContentViewConfig* contentViewConfig = [ContentViewConfig object];
        contentViewConfig.initialSpacerHeight = 0;
        
        if (quote.quoteLines.count == 1)
        {
            QBQuoteLine* quoteLine = [quote.quoteLines lastObject];
            [contentViewConfig.viewConfigs addObject:ContentLabelConfig(kDefaultAdditionalHeight, NO, [quoteLine formatOnelineDisplay])];
            [contentViewConfig.viewConfigs addObject:ContentLabelConfig(kDefaultAdditionalHeight, NO, [quoteLine.who formatDisplayName])];
            [contentViewConfig.viewConfigs addObject:ContentLabelConfig(kDefaultAdditionalHeight, NO, [Util formatDate:quote.creationDate])];
            [contentViewConfig.viewConfigs addObject:ContentLabelConfig(kDefaultAdditionalHeight, NO, [quote formatContext])];
        }
        else
        {
            for (QBQuoteLine* quoteLine in quote.quoteLines)
            {
                ContentLabelConfig* labelConfig = ContentLabelConfig(kDefaultAdditionalHeight, NO, [quoteLine formatMultilineDisplay]);
                labelConfig.alignment = ContentConfigAlignmentLeft;
                [contentViewConfig.viewConfigs addObject:labelConfig];
            }
            [contentViewConfig.viewConfigs addObject:ContentLabelConfig(kDefaultAdditionalHeight, NO, [Util formatDate:quote.creationDate])];
            [contentViewConfig.viewConfigs addObject:ContentLabelConfig(kDefaultAdditionalHeight, NO, [quote formatContext])];
        }
        [contentView configureWithContentViewConfig:contentViewConfig];
        
        if (asPreview)
        {
            ConfigureContentViewWithAction(contentView, @"Looks good!", ^{
                [quoteManager addQuote:quote
                                toBook:book
                          successBlock:^(QBQuote* addedQuote){
                              [self showMenuForBook:book
                                            forUser:user];
                              [quote release];
                          }
                          failureBlock:^{
                             [self confirmFailureWithText:@"Add Quote Failed"
                                            failureBlock:^{}];
                          }];
            });
        }
    }];
    
    if (asPreview)
    {
        [self showTitleBarWithTitle:@"Quote Preview"
                   backButtonAction:^{
                       [self showMenuForAddingNewQuoteToBook:book
                                                     forUser:user
                                               optionalQuote:quote];
                       [quote release];
                   }];
    }
    else
    {
        [self showTitleBarWithTitle:book.title
                   backButtonAction:^{
                       [quote release];
                       [self showMenuForBook:book
                                     forUser:user];
                   }];
    }
}

- (void)showMenuForAddingNewQuoteToBook:(QBBook*)book
                                forUser:(QBUser*)user
                          optionalQuote:(QBQuote*)quoteArg
{
    [self dismissContentView];
    
    [self showDefaultBackground];
    
    __block QBQuote* quoteToEdit = ^{
        if (quoteArg == nil)
        {
            QBQuote* quote = [[QBQuote alloc] init];
            quote.quoteLines = [[NSMutableArray alloc] initWithObjects:[QBQuoteLine object], nil];
            quote.creationDate = nil;
            quote.quoteContext = nil;
            return quote;
        }
        return [quoteArg retain];
    }();
    
    [self showContentViewWithSetupBlock:^(ContentView* contentView) {
        void (^addQuoteLineToContentView)() = ^{
            int index = quoteToEdit.quoteLines.count;
            __block QBQuoteLine* quoteLine = [QBQuoteLine object];
            [quoteToEdit.quoteLines addObject:quoteLine];
            
            ContentTextFieldConfig* whoConfig = ContentTextFieldConfig_label(kDefaultAdditionalHeight, @"Who:", ^(NSString* enteredString) {
                quoteLine.who.nonuserQuoted = enteredString;
            });
            whoConfig.defaultFieldText = @"Required";
            
            ContentItemConfigToAdd* whoConfigToAdd = [ContentItemConfigToAdd object];
            whoConfigToAdd.contentItemConfig = whoConfig;
            whoConfigToAdd.index = index * 2 + 1;
            
            ContentTextFieldConfig* quoteTextConfig = ContentTextFieldConfig_label(kDefaultAdditionalHeight, @"Response:", ^(NSString* enteredString) {
                quoteLine.text = enteredString;
            });
            quoteTextConfig.defaultFieldText = @"Required";
            
            ContentItemConfigToAdd* quoteTextConfigToAdd = [ContentItemConfigToAdd object];
            quoteTextConfigToAdd.contentItemConfig = quoteTextConfig;
            quoteTextConfigToAdd.index = index * 2 + 2;
            
            NSMutableArray* contentItemConfigsToAdd = [NSMutableArray object];
            [contentItemConfigsToAdd addObject:whoConfigToAdd];
            [contentItemConfigsToAdd addObject:quoteTextConfigToAdd];
            
            [contentView addContentItemConfigs:contentItemConfigsToAdd];
        };
        
        ContentViewConfig* contentViewConfig = [ContentViewConfig object];
        [contentViewConfig.viewConfigs addObject:ContentLabelConfig(kDefaultAdditionalHeight, NO, @"Add new quote:")];
        for (QBQuoteLine* quoteLine in quoteToEdit.quoteLines)
        {
            int index = [quoteToEdit.quoteLines indexOfObject:quoteLine];

            ContentTextFieldConfig* whoConfig = ContentTextFieldConfig_label(kDefaultAdditionalHeight, @"Who:", ^(NSString* enteredString){
                QBQuoteLine* quoteLine = [quoteToEdit.quoteLines objectAtIndex:index];
                quoteLine.who.nonuserQuoted = enteredString;
            });
            whoConfig.defaultFieldText = @"Required";
            whoConfig.overrideFieldText = [quoteLine.who formatDisplayName];
            [contentViewConfig.viewConfigs addObject:whoConfig];
            
            ContentTextFieldConfig* quoteConfig = ContentTextFieldConfig_label(kDefaultAdditionalHeight, index == 0 ? @"Quote:" : @"Response:", ^(NSString* enteredString){
                QBQuoteLine* quoteLine = [quoteToEdit.quoteLines objectAtIndex:index];
                quoteLine.text = enteredString;
            });
            quoteConfig.defaultFieldText = @"Required";
            quoteConfig.overrideFieldText = quoteLine.text;
            [contentViewConfig.viewConfigs addObject:quoteConfig];
        }
        
        [contentViewConfig.viewConfigs addObject:ContentButtonConfig(kDefaultAdditionalHeight, @"Add Quote Line", ^{
            addQuoteLineToContentView();
        })];

        ContentTextFieldConfig* contextConfig = ContentTextFieldConfig_label(kDefaultAdditionalHeight, @"Context:", ^(NSString* enteredString){
            quoteToEdit.quoteContext = enteredString;
        });
        contextConfig.defaultFieldText = @"Re:";
        contextConfig.overrideFieldText = quoteToEdit.quoteContext;
        [contentViewConfig.viewConfigs addObject:contextConfig];
        
        [contentViewConfig.viewConfigs addObject:ContentLabelConfig(kDefaultAdditionalHeight, NO, @"When:")];
        
        ContentDatePickerConfig* dateConfig = ContentDatePickerConfig(kDefaultAdditionalHeight, ^(NSDate* enteredDate){
            quoteToEdit.creationDate = [[enteredDate copy] autorelease];
        });
        dateConfig.defaultDate = quoteToEdit.creationDate;
        [contentViewConfig.viewConfigs addObject:dateConfig];
        
        [contentView configureWithContentViewConfig:contentViewConfig];
        
        ConfigureContentViewWithAction(contentView, @"Preview...", ^{
            if (quoteToEdit.quoteLines.count > 0)
            {
                [self showMenuForViewingQuote:quoteToEdit
                                      forBook:book
                                      forUser:user
                                    asPreview:YES];
                
                [quoteToEdit release];
            }
        });
    }];
    
    [self showTitleBarForBook:book
                      forUser:user
             backButtonAction:^{
                 [self showMenuForBook:book
                               forUser:user];
                 
                 [quoteToEdit release];
             }];
}

- (void)showMenuForInvitingNewMembersToBook:(QBBook*)book
                                    forUser:(QBUser*)user
{
    [self dismissContentView];
    
    [self showDefaultBackground];
    
    [self showContentViewWithSetupBlock:^(ContentView* contentView) {
        __block NSMutableArray* users = [NSMutableArray new];
        
        ContentViewConfig* contentViewConfig = [ContentViewConfig object];
        contentViewConfig.initialSpacerHeight = 30;
        [contentViewConfig.viewConfigs addObject:ContentLabelConfig(kDefaultAdditionalHeight * 1.5, NO, @"Invite members:")];
        [contentViewConfig.viewConfigs addObject:ContentTextFieldConfig_label(kDefaultAdditionalHeight, @"E-mail:", ^(NSString* enteredString) {
//            [userManager retrieveUserWithEmail:enteredString
//                                  successBlock:^(QBUser* user) {
//                                      [users addObject:user];
//                                  }
//                                  failureBlock:^{
//                                      [self confirmFailureWithText:@"Get User Failed"
//                                                      failureBlock:^{}];
//                                  }];
        })];
        [contentViewConfig.viewConfigs addObject:ContentLabelConfig(kDefaultAdditionalHeight, NO, @"or...")];
        [contentViewConfig.viewConfigs addObject:ContentTextFieldConfig_label(kDefaultAdditionalHeight, @"Users:", ^(NSString* enteredString) {
            // This needs to be changed to a User Dropdown
            // This successblock needs to return a user
        })];
        [contentView configureWithContentViewConfig:contentViewConfig];
        
        ConfigureContentViewWithAction(contentView, @"Send invitations", ^{
            [self showMenuForConfirmingInvitationOfUsers:users
                                                  toBook:book
                                                 forUser:user];
        });
    }];
    
    [self showTitleBarForBook:book
                      forUser:user
             backButtonAction:^{
                 [self showMenuForBook:book
                               forUser:user];
             }];
}

- (void)showMenuForConfirmingInvitationOfUsers:(NSArray*)users
                                        toBook:(QBBook*)book
                                       forUser:(QBUser*)user
{
    [self dismissContentView];
    
    [self showDefaultBackground];
    [self showContentViewWithSetupBlock:^(ContentView* contentView) {
        ContentViewConfig* contentViewConfig = [ContentViewConfig object];
        contentViewConfig.initialSpacerHeight = 60;
        [contentViewConfig.viewConfigs addObject:ContentLabelConfig(kDefaultAdditionalHeight, NO, Format(@"An invitation to join \"%@\" has been sent to:", book.title))];
        for (QBUser* user in users)
        {
            [contentViewConfig.viewConfigs addObject:ContentLabelConfig(kDefaultAdditionalHeight, NO, Format(@"- %@", [user formatDisplayName]))];
        }
        [contentView configureWithContentViewConfig:contentViewConfig];
        
        ConfigureContentViewWithAction(contentView, @"Send invitation", ^{
            [bookManager sendInvitesToUsers:users
                                    forBook:book];
            [self showMenuForBook:book
                          forUser:user];
        });
    }];
    
    [self showTitleBarForBook:book
                      forUser:user
             backButtonAction:^{
                 [self showMenuForBook:book
                               forUser:user];
             }];
}

- (void)showMenuForDisplayOptionsForBook:(QBBook*)book
                                 forUser:(QBUser*)user
{
    [self dismissContentView];
    
    [self showDefaultBackground];
    
    [self showContentViewWithSetupBlock:^(ContentView* contentView) {
        ContentViewConfig* contentViewConfig = [ContentViewConfig object];
        [contentViewConfig.viewConfigs addObject:ContentLabelConfig(kDefaultAdditionalHeight, NO, @"Filter by...")];
        [contentViewConfig.viewConfigs addObject:ContentButtonConfig(kDefaultAdditionalHeight, @"Members", ^{
            //                                                   [self showMenuForChoosingMemberDispalysOnBook:book];
        })];
        [contentViewConfig.viewConfigs addObject:ContentLabelConfig(kDefaultAdditionalHeight, NO, @"Display...")];
        [contentViewConfig.viewConfigs addObject:ContentButtonConfig(kDefaultAdditionalHeight, @"Reverse (default)", ^{
        })];
        [contentViewConfig.viewConfigs addObject:ContentButtonConfig(kDefaultAdditionalHeight, @"Chronological", ^{
        })];
        [contentView configureWithContentViewConfig:contentViewConfig];
    }];
    
    [self showTitleBarForBook:book
                      forUser:user
             backButtonAction:^{
                 [self showMenuForBook:book
                               forUser:user];
             }];
}

- (void)showMenuForViewingStatsForBook:(QBBook*)book
                               forUser:(QBUser*)user
{
    [self dismissContentView];
    
    [self showDefaultBackground];
    
    [self showContentViewWithSetupBlock:^(ContentView* contentView) {
        ContentViewConfig* contentViewConfig = [ContentViewConfig object];
        [contentViewConfig.viewConfigs addObject:ContentLabelConfig(kDefaultAdditionalHeight, NO, @"Members")];
        for (QBUser* user in book.memberUsers)
        {
            [contentViewConfig.viewConfigs addObject:ContentLabelConfig(kDefaultAdditionalHeight, NO, Format(@"- %@", [user formatDisplayName]))];
        }
        [contentViewConfig.viewConfigs addObject:ContentLabelConfig(kDefaultAdditionalHeight, NO, @"Invited")];
        for (QBUser* user in book.invitedUsers)
        {
            [contentViewConfig.viewConfigs addObject:ContentLabelConfig(kDefaultAdditionalHeight, NO, Format(@"- %@", [user formatDisplayName]))];
        }
        [contentView configureWithContentViewConfig:contentViewConfig];
    }];
    
    [self showTitleBarForBook:book
                      forUser:user
             backButtonAction:^{
                 [self showMenuForBook:book
                               forUser:user];
             }];
}

- (void)showMenuForSearchingInBook:(QBBook*)book
                           forUser:(QBUser*)user
{
    [self dismissContentView];
    
    [self showDefaultBackground];
    
    [self showContentViewWithSetupBlock:^(ContentView* contentView) {
        ContentViewConfig* contentViewConfig = [ContentViewConfig object];
        [contentViewConfig.viewConfigs addObject:ContentLabelConfig(kDefaultAdditionalHeight * 3, NO, @"Search Keywords")];
        [contentViewConfig.viewConfigs addObject:ContentTextFieldConfig(kDefaultAdditionalHeight, ^(NSString* enteredString){
            
        })];
        [contentViewConfig.viewConfigs addObject:ContentButtonConfig(kDefaultAdditionalHeight, @"Run search...", ^{
        })];
        [contentView configureWithContentViewConfig:contentViewConfig];
    }];
    
    [self showTitleBarForBook:book
                      forUser:user
             backButtonAction:^{
                 [self showMenuForBook:book
                               forUser:user];
             }];
}

@end
