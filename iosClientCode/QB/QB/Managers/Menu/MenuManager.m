#import "MenuManager.h"
#import "BackgroundView.h"
#import "ContentView.h"
#import "ContentViewConfig.h"
#import "ContentItem_button.h"
#import "ContentItem_label.h"
#import "ContentItem_textField.h"
#import "ContentItem_datePicker.h"
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

#define ContentButtonConfig(additionalViewHeightArg, buttonTitleArg, labelTextArg, onTapBlockArg) ^ContentButtonConfig*{ \
ContentButtonConfig* contentButtonConfig = [ContentButtonConfig object]; \
contentButtonConfig.additionalViewHeight = additionalViewHeightArg; \
contentButtonConfig.buttonTitle = buttonTitleArg; \
contentButtonConfig.labelText = labelTextArg; \
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

#define ContentTextFieldConfig(additionalViewHeightArg, shouldUseTextViewArg, textBlockArg) ^ContentTextFieldConfig*{ \
ContentTextFieldConfig* contentTextFieldConfig = [ContentTextFieldConfig object]; \
contentTextFieldConfig.additionalViewHeight = additionalViewHeightArg; \
contentTextFieldConfig.textBlock = textBlockArg; \
contentTextFieldConfig.shouldUseTextView = shouldUseTextViewArg; \
return contentTextFieldConfig; \
}()

#define ContentTextFieldConfig_label(additionalViewHeightArg, labelTextArg, shouldUseTextViewArg, textBlockArg) ^ContentTextFieldConfig*{ \
ContentTextFieldConfig* contentTextFieldConfig = [ContentTextFieldConfig object]; \
contentTextFieldConfig.additionalViewHeight = additionalViewHeightArg; \
contentTextFieldConfig.textBlock = textBlockArg; \
contentTextFieldConfig.shouldUseTextView = shouldUseTextViewArg; \
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
    
    SideMenuConfig* inviteMembersConfig = [SideMenuConfig object];
    SideMenuConfig* displayOptionsConfig = [SideMenuConfig object];
    SideMenuConfig* viewStatsConfig = [SideMenuConfig object];
    SideMenuConfig* searchConfig = [SideMenuConfig object];
    
    [sideMenuConfigs addObject:inviteMembersConfig];
    [sideMenuConfigs addObject:displayOptionsConfig];
    [sideMenuConfigs addObject:viewStatsConfig];
    [sideMenuConfigs addObject:searchConfig];
    
    inviteMembersConfig.buttonTitleText = @"Invite members";
    displayOptionsConfig.buttonTitleText = @"Display options";
    viewStatsConfig.buttonTitleText = @"View stats";
    searchConfig.buttonTitleText = @"Search";
    
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
    
    SideMenuConfig* editQuoteConfig = [SideMenuConfig object];
    SideMenuConfig* emailToFriendQuoteConfig = [SideMenuConfig object];
    SideMenuConfig* createPostcardQuoteConfig = [SideMenuConfig object];
    
    [sideMenuConfigs addObject:editQuoteConfig];
    [sideMenuConfigs addObject:emailToFriendQuoteConfig];
    [sideMenuConfigs addObject:createPostcardQuoteConfig];
    
    editQuoteConfig.buttonTitleText = @"Edit quote";
    emailToFriendQuoteConfig.buttonTitleText = @"Email to friend";
    createPostcardQuoteConfig.buttonTitleText = @"Create postcard";
    
    editQuoteConfig.buttonAction = ^{
        
    };
    
    emailToFriendQuoteConfig.buttonAction = ^{
        
    };
    
    createPostcardQuoteConfig.buttonAction = ^{
    };
    
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
        [contentViewConfig.contentItemConfigs addObject:ContentLabelConfig(kDefaultAdditionalHeight, NO, @"Basic info:")];
        [contentViewConfig.contentItemConfigs addObject:ContentTextFieldConfig_label(kDefaultAdditionalHeight, @"E-mail:", NO, ^(NSString* enteredString) {
            email = [enteredString copy];
        })];
        [contentViewConfig.contentItemConfigs addObject:ContentTextFieldConfig_label(kDefaultAdditionalHeight, @"First name:", NO, ^(NSString* enteredString) {
            firstName = [enteredString copy];
        })];
        [contentViewConfig.contentItemConfigs addObject:ContentTextFieldConfig_label(kDefaultAdditionalHeight, @"Last name", NO, ^(NSString* enteredString) {
            lastName = [enteredString copy];
        })];
        [contentViewConfig.contentItemConfigs addObject:ContentLabelConfig(kDefaultAdditionalHeight * .2, NO, @"Create password:")];
        ContentTextFieldConfig* passwordConfig = ContentTextFieldConfig_label(kDefaultAdditionalHeight, @"Password:", NO, ^(NSString* enteredString) {
            password = [enteredString copy];
        });
        passwordConfig.secureTextEntry = YES;
        [contentViewConfig.contentItemConfigs addObject:passwordConfig];
        ContentTextFieldConfig* confirmConfig = ContentTextFieldConfig_label(kDefaultAdditionalHeight, @"Confirm", NO, ^(NSString* enteredString) {
            confirm = [enteredString copy];
        });
        confirmConfig.secureTextEntry = YES;
        [contentViewConfig.contentItemConfigs addObject:confirmConfig];
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
        [contentViewConfig.contentItemConfigs addObject:ContentLabelConfig(kDefaultAdditionalHeight * 1.5, NO, @"Name the book:")];
        [contentViewConfig.contentItemConfigs addObject:ContentTextFieldConfig(kDefaultAdditionalHeight, NO, ^(NSString* enteredString) {
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
        [contentViewConfig.contentItemConfigs addObject:ContentTextFieldConfig_label(kDefaultAdditionalHeight, @"E-mail", NO, ^(NSString* enteredString) {
            email = [enteredString copy];
        })];
        ContentTextFieldConfig* config = ContentTextFieldConfig_label(kDefaultAdditionalHeight, @"Password", NO, ^(NSString* enteredString) {
            password = [enteredString copy];
        });
        config.secureTextEntry = YES;
        [contentViewConfig.contentItemConfigs addObject:config];

        [contentViewConfig.contentItemConfigs addObject:ContentButtonConfig(kDefaultAdditionalHeight, @"Login", nil, ^{
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
            [contentViewConfig.contentItemConfigs addObject:ContentLabelConfig(kDefaultAdditionalHeight * 2, YES, @"Get started by creating a new book!")];
            
            [contentViewConfig.contentItemConfigs addObject:ContentButtonConfig(kDefaultAdditionalHeight, @"Create new book...", nil, ^{
                [self showCreateNewBookMenuForUser:user];
            })];
        }
        else
        {
            for (NSNumber* bookId in user.bookIds)
            {
                QBBook* book = [bookManager bookForBookId:bookId.intValue];
                [contentViewConfig.contentItemConfigs addObject:ContentButtonConfig(kDefaultAdditionalHeight, book.title, nil, ^{
                    [self showMenuForBook:book
                                  forUser:user];
                })];
            }
            
            ConfigureContentViewWithAction(contentView, @"Add new book", ^{
                [self showCreateNewBookMenuForUser:user];
            });
        }
        [contentView configureWithContentViewConfig:contentViewConfig];
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
        if (book.isEmpty)
        {
            ContentViewConfig* contentViewConfig = [ContentViewConfig object];
            
            [contentViewConfig.contentItemConfigs addObject:ContentLabelConfig(kDefaultAdditionalHeight * 2, YES, @"Get started by creating a new quote!")];
            
            [contentViewConfig.contentItemConfigs addObject:ContentButtonConfig(kDefaultAdditionalHeight, @"Add new quote", nil, ^{
                [self showMenuForAddingNewQuoteToBook:book
                                              forUser:user
                                        optionalQuote:nil];
            })];
            
            [contentView configureWithContentViewConfig:contentViewConfig];
        }
        else
        {
            ContentScrollViewConfig* contentScrollViewConfig = [ContentScrollViewConfig object];
            
            contentScrollViewConfig.enablePaging = YES;
            
            for (QBQuote* quote in book.quotes)
            {
                ContentViewConfig* contentViewConfig = [ContentViewConfig object];
                contentViewConfig.initialSpacerHeight = 0;
                
                if (quote.quoteLines.count == 1)
                {
                    QBQuoteLine* quoteLine = [quote.quoteLines lastObject];
                    [contentViewConfig.contentItemConfigs addObject:ContentLabelConfig(kDefaultAdditionalHeight, NO, [quoteLine formatOnelineDisplay])];
                    [contentViewConfig.contentItemConfigs addObject:ContentLabelConfig(kDefaultAdditionalHeight, NO, [quoteLine.who formatDisplayName])];
                    [contentViewConfig.contentItemConfigs addObject:ContentLabelConfig(kDefaultAdditionalHeight, NO, [Util formatDate:quote.creationDate])];
                    ContentLabelConfig* contentLabelConfig = ContentLabelConfig(kDefaultAdditionalHeight, NO, [quote formatContext]);
                    contentLabelConfig.font = ContentConfigFontBoldItalic;
                    [contentViewConfig.contentItemConfigs addObject:contentLabelConfig];
                }
                else
                {
                    for (QBQuoteLine* quoteLine in quote.quoteLines)
                    {
                        ContentLabelConfig* labelConfig = ContentLabelConfig(kDefaultAdditionalHeight, NO, [quoteLine formatMultilineDisplay]);
                        labelConfig.alignment = ContentConfigAlignmentLeft;
                        [contentViewConfig.contentItemConfigs addObject:labelConfig];
                    }
                    [contentViewConfig.contentItemConfigs addObject:ContentLabelConfig(kDefaultAdditionalHeight, NO, [Util formatDate:quote.creationDate])];
                    ContentLabelConfig* contentLabelConfig = ContentLabelConfig(kDefaultAdditionalHeight, NO, [quote formatContext]);
                    contentLabelConfig.font = ContentConfigFontBoldItalic;
                    [contentViewConfig.contentItemConfigs addObject:contentLabelConfig];
                }
                [contentScrollViewConfig.contentViewConfigs addObject:contentViewConfig];
            }
            [contentView configureWithContentScrollViewConfig:contentScrollViewConfig];
            
            ConfigureContentViewWithAction(contentView, @"Add new quote", ^{
                [self showMenuForAddingNewQuoteToBook:book
                                              forUser:user
                                        optionalQuote:nil];
            });
        }
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
            [contentViewConfig.contentItemConfigs addObject:ContentLabelConfig(kDefaultAdditionalHeight, NO, [quoteLine formatOnelineDisplay])];
            [contentViewConfig.contentItemConfigs addObject:ContentLabelConfig(kDefaultAdditionalHeight, NO, [quoteLine.who formatDisplayName])];
            [contentViewConfig.contentItemConfigs addObject:ContentLabelConfig(kDefaultAdditionalHeight, NO, [Util formatDate:quote.creationDate])];
            ContentLabelConfig* contentLabelConfig = ContentLabelConfig(kDefaultAdditionalHeight, NO, [quote formatContext]);
            contentLabelConfig.font = ContentConfigFontBoldItalic;
            [contentViewConfig.contentItemConfigs addObject:contentLabelConfig];
        }
        else
        {
            for (QBQuoteLine* quoteLine in quote.quoteLines)
            {
                ContentLabelConfig* labelConfig = ContentLabelConfig(kDefaultAdditionalHeight, NO, [quoteLine formatMultilineDisplay]);
                labelConfig.alignment = ContentConfigAlignmentLeft;
                [contentViewConfig.contentItemConfigs addObject:labelConfig];
            }
            [contentViewConfig.contentItemConfigs addObject:ContentLabelConfig(kDefaultAdditionalHeight, NO, [Util formatDate:quote.creationDate])];
            ContentLabelConfig* contentLabelConfig = ContentLabelConfig(kDefaultAdditionalHeight, NO, [quote formatContext]);
            contentLabelConfig.font = ContentConfigFontBoldItalic;
            [contentViewConfig.contentItemConfigs addObject:contentLabelConfig];
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

                       //[quote release]; TODO - crash has to do with blocks.
                   }];
    }
    else
    {
        [self showTitleBarForQuote:quote
                           forUser:user
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
    [quoteArg retain];
    
    [self dismissContentView];
    
    [self showDefaultBackground];
    
    __block QBQuote* quoteToEdit = ^{
        if (quoteArg == nil)
        {
            QBQuote* quote = [[QBQuote alloc] init];
            quote.quoteLines = [[[NSMutableArray alloc] initWithObjects:[QBQuoteLine object], nil] autorelease];
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
            
            ContentTextFieldConfig* whoConfig = ContentTextFieldConfig_label(kDefaultAdditionalHeight, @"Who:", NO, ^(NSString* enteredString) {
                quoteLine.who.nonuserQuoted = enteredString;
            });
            whoConfig.defaultFieldText = @"Required";
            
            ContentItemConfigToAdd* whoConfigToAdd = [ContentItemConfigToAdd object];
            whoConfigToAdd.contentItemConfig = whoConfig;
            whoConfigToAdd.index = index * 2 + 1;
            
            ContentTextFieldConfig* quoteTextConfig = ContentTextFieldConfig_label(kDefaultAdditionalHeight, @"Response:", YES, ^(NSString* enteredString) {
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
        [contentViewConfig.contentItemConfigs addObject:ContentLabelConfig(kDefaultAdditionalHeight, NO, @"Add new quote:")];
        for (QBQuoteLine* quoteLine in quoteToEdit.quoteLines)
        {
            int index = [quoteToEdit.quoteLines indexOfObject:quoteLine];

            ContentTextFieldConfig* whoConfig = ContentTextFieldConfig_label(kDefaultAdditionalHeight, @"Who:", NO, ^(NSString* enteredString){
                QBQuoteLine* quoteLine = [quoteToEdit.quoteLines objectAtIndex:index];
                quoteLine.who.nonuserQuoted = enteredString;
            });
            whoConfig.defaultFieldText = @"Required";
            whoConfig.overrideFieldText = [quoteLine.who formatDisplayName];
            [contentViewConfig.contentItemConfigs addObject:whoConfig];
            
            ContentTextFieldConfig* quoteConfig = ContentTextFieldConfig_label(kDefaultAdditionalHeight, index == 0 ? @"Quote:" : @"Response:", YES, ^(NSString* enteredString){
                QBQuoteLine* quoteLine = [quoteToEdit.quoteLines objectAtIndex:index];
                quoteLine.text = enteredString;
            });
            quoteConfig.defaultFieldText = @"Required";
            quoteConfig.overrideFieldText = quoteLine.text;
            [contentViewConfig.contentItemConfigs addObject:quoteConfig];
        }
        
        [contentViewConfig.contentItemConfigs addObject:ContentButtonConfig(kDefaultAdditionalHeight, @"+", @"Add Line", ^{
            addQuoteLineToContentView();
        })];

        ContentTextFieldConfig* contextConfig = ContentTextFieldConfig_label(kDefaultAdditionalHeight, @"Context:", NO, ^(NSString* enteredString){
            quoteToEdit.quoteContext = enteredString;
        });
        contextConfig.defaultFieldText = @"Re:";
        contextConfig.overrideFieldText = quoteToEdit.quoteContext;
        [contentViewConfig.contentItemConfigs addObject:contextConfig];
                
        ContentDatePickerConfig* dateConfig = ContentDatePickerConfig(kDefaultAdditionalHeight, ^(NSDate* enteredDate){
            quoteToEdit.creationDate = [[enteredDate copy] autorelease];
        });
        dateConfig.defaultDate = quoteToEdit.creationDate;
        [contentViewConfig.contentItemConfigs addObject:dateConfig];
        
        [contentView configureWithContentViewConfig:contentViewConfig];
        
        ConfigureContentViewWithAction(contentView, @"Preview...", ^{
            if (quoteToEdit.quoteLines.count > 0)
            {
                [self showMenuForViewingQuote:quoteToEdit
                                      forBook:book
                                      forUser:user
                                    asPreview:YES];
                
                //[quoteToEdit release]; TODO Leaking - crash has to do with blocks.
                //[quoteArg release];
            }
        });
    }];
    
    [self showTitleBarForBook:book
                      forUser:user
             backButtonAction:^{
                 [self showMenuForBook:book
                               forUser:user];
                 
                 //[quoteToEdit release]; TODO Leaking - crash has to do with blocks.
                 //[quoteArg release];
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
        [contentViewConfig.contentItemConfigs addObject:ContentLabelConfig(kDefaultAdditionalHeight * 1.5, NO, @"Invite members:")];
        [contentViewConfig.contentItemConfigs addObject:ContentTextFieldConfig_label(kDefaultAdditionalHeight, @"E-mail:", NO, ^(NSString* enteredString) {
//            [userManager retrieveUserWithEmail:enteredString
//                                  successBlock:^(QBUser* user) {
//                                      [users addObject:user];
//                                  }
//                                  failureBlock:^{
//                                      [self confirmFailureWithText:@"Get User Failed"
//                                                      failureBlock:^{}];
//                                  }];
        })];
        [contentViewConfig.contentItemConfigs addObject:ContentLabelConfig(kDefaultAdditionalHeight, NO, @"or...")];
        [contentViewConfig.contentItemConfigs addObject:ContentTextFieldConfig_label(kDefaultAdditionalHeight, @"Users:", NO, ^(NSString* enteredString) {
            // This needs to be changed to a User Dropdown
            // This successblock needs to return a user
        })];
        [contentView configureWithContentViewConfig:contentViewConfig];
        
        ConfigureContentViewWithAction(contentView, @"Send invitations", ^{
            [self showMenuForConfirmingInvitationOfUsers:users
                                                  toBook:book
                                                 forUser:user];
            [users release];
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
        [contentViewConfig.contentItemConfigs addObject:ContentLabelConfig(kDefaultAdditionalHeight, NO, Format(@"An invitation to join \"%@\" has been sent to:", book.title))];
        for (QBUser* user in users)
        {
            [contentViewConfig.contentItemConfigs addObject:ContentLabelConfig(kDefaultAdditionalHeight, NO, Format(@"- %@", [user formatDisplayName]))];
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
        [contentViewConfig.contentItemConfigs addObject:ContentLabelConfig(kDefaultAdditionalHeight, NO, @"Filter by...")];
        [contentViewConfig.contentItemConfigs addObject:ContentButtonConfig(kDefaultAdditionalHeight, @"Members", nil, ^{
            //                                                   [self showMenuForChoosingMemberDispalysOnBook:book];
        })];
        [contentViewConfig.contentItemConfigs addObject:ContentLabelConfig(kDefaultAdditionalHeight, NO, @"Display...")];
        [contentViewConfig.contentItemConfigs addObject:ContentButtonConfig(kDefaultAdditionalHeight, @"Reverse (default)", nil, ^{
        })];
        [contentViewConfig.contentItemConfigs addObject:ContentButtonConfig(kDefaultAdditionalHeight, @"Chronological", nil, ^{
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
        [contentViewConfig.contentItemConfigs addObject:ContentLabelConfig(kDefaultAdditionalHeight, NO, @"Members")];
        for (QBUser* user in book.memberUsers)
        {
            [contentViewConfig.contentItemConfigs addObject:ContentLabelConfig(kDefaultAdditionalHeight, NO, Format(@"- %@", [user formatDisplayName]))];
        }
        [contentViewConfig.contentItemConfigs addObject:ContentLabelConfig(kDefaultAdditionalHeight, NO, @"Invited")];
        for (QBUser* user in book.invitedUsers)
        {
            [contentViewConfig.contentItemConfigs addObject:ContentLabelConfig(kDefaultAdditionalHeight, NO, Format(@"- %@", [user formatDisplayName]))];
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
        [contentViewConfig.contentItemConfigs addObject:ContentLabelConfig(kDefaultAdditionalHeight * 3, NO, @"Search Keywords")];
        [contentViewConfig.contentItemConfigs addObject:ContentTextFieldConfig(kDefaultAdditionalHeight, NO, ^(NSString* enteredString){
            
        })];
        [contentViewConfig.contentItemConfigs addObject:ContentButtonConfig(kDefaultAdditionalHeight, @"Run search...", nil, ^{
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
