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

#define ConfigureContentViewWithMainMenu(contentViewArg, mainMenuBlockArg) { \
contentViewArg.mainMenuBlock = mainMenuBlockArg; \
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

- (void)showTitleBarWithTitle:(NSString*)title
{
    if (_titleBarView == nil)
    {
        [viewManager showManagedViewOfClassOnDefaultLayer:TitleBarView.class
                                               setupBlock:^(TitleBarView* titleBarView) {
                                                   self.titleBarView = titleBarView;
                                                   titleBarView.titleLabel.text = title;
                                               }];
    }
    else
    {
        _titleBarView.titleLabel.text = title;
        [_titleBarView bringSubviewToFront];
    }
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
        
        ConfigureContentViewWithMainMenu(contentView, ^{
            [self showLoginMenu];
        });
        
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
                                                              [self showAllBooksMenu];
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
    
    [self showTitleBarWithTitle:@"Create new login..."];
}

- (void)showCreateNewBookMenu
{
    [self dismissContentView];
    
    [self showDefaultBackground];
    
    [self showContentViewWithSetupBlock:^(ContentView* contentView) {
        __block NSString* bookName = nil;
        
        ContentViewConfig* contentViewConfig = [ContentViewConfig object];
        contentViewConfig.initialSpacerHeight = 60;
        [contentViewConfig.viewConfigs addObject:ContentLabelConfig(kDefaultAdditionalHeight * 1.5, NO, @"Name the book:")];
        [contentViewConfig.viewConfigs addObject:ContentTextFieldConfig(kDefaultAdditionalHeight,^(NSString* enteredString) {
            bookName = [[NSString alloc] initWithString:enteredString];
        })];
        
        [contentView configureWithContentViewConfig:contentViewConfig];
        
        ConfigureContentViewWithMainMenu(contentView, ^{
            [bookName release];
            
            [self showAllBooksMenu];
        });
        
        ConfigureContentViewWithAction(contentView, @"Create!", ^{
            [bookManager createNewBookWithBookName:bookName
                                      successBlock:^(QBBook* book){
                                          [bookName release];
                                          
                                          [self showMenuForInvitingNewMembersToBook:book];
                                      }
                                      failureBlock:^{
                                          //[self refreshWithErrors];
                                          [self confirmFailureWithText:@"New Book Failed"
                                                          failureBlock:^{}];
                                      }];
        });
    }];
    
    [self showTitleBarWithTitle:@"Create new book..."];
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
                                    [self showAllBooksMenu];
                                }
                                failureBlock:^{
                                    [self confirmFailureWithText:@"Login failed"
                                                    failureBlock:^{}];
                                }];
        })];
        
        [contentView configureWithContentViewConfig:contentViewConfig];
        
        ConfigureContentViewWithMainMenu(contentView, ^{});
        
        ConfigureContentViewWithAction(contentView, @"Create new login...", ^{
            [self showCreateNewLoginMenu];
        }); 
    }];
    
    [self showTitleBarWithTitle:@"Quote with me..."];
}

- (void)showAllBooksMenu
{
    [self dismissContentView];
    
    [self showDefaultBackground];
    
    [self showContentViewWithSetupBlock:^(ContentView* contentView) {
        ContentViewConfig* contentViewConfig = [ContentViewConfig object];
        
        QBUser* activeUser = userManager.getActiveUser;
        
        if (activeUser.bookIds == nil ||
            activeUser.bookIds.count == 0)
        {
            [contentViewConfig.viewConfigs addObject:ContentLabelConfig(kDefaultAdditionalHeight * 3, YES, @"Get started by creating a new book!")];
        }
        else
        {
            for (NSNumber* bookId in activeUser.bookIds)
            {
                QBBook* book = [bookManager bookForBookId:bookId.intValue];
                [contentViewConfig.viewConfigs addObject:ContentButtonConfig(kDefaultAdditionalHeight, book.title, ^{
                    [self showMenuForBook:book];
                })];
            }
        }
        [contentView configureWithContentViewConfig:contentViewConfig];
        
        ConfigureContentViewWithMainMenu(contentView, ^{
            [self confirmActionWithText:@"Logout?"
                           confirmBlock:^{
                               [userManager logout];
                               [userManager setActiveUser:nil];
                               [self showLoginMenu];
                           }
                           cancelBlock:^{}];
        });
        
        ConfigureContentViewWithAction(contentView, @"Create new book...", ^{
            [self showCreateNewBookMenu];
        });
        
    }];
    
    [self showTitleBarWithTitle:@"Your Quotebooks"];
}

@end

@implementation MenuManager (Book)

- (void)showMenuForBook:(QBBook*)book
{
    if ([book isEmpty])
    {
        [self showMenuForBookActions:book];
        return;
    }
    
    [self dismissContentView];
    
    [self showDefaultBackground];
    
    [self showContentViewWithSetupBlock:^(ContentView* contentView) {
        ContentViewConfig* contentViewConfig = [ContentViewConfig object];
        for (QBQuote* quote in book.quotes)
        {
            [contentViewConfig.viewConfigs addObject:ContentButtonConfig(kDefaultAdditionalHeight, [quote formatDisplayName], ^{
                [self showMenuForViewingQuote:quote
                                      forBook:book
                                    asPreview:NO];
            })];
        }
        
        [contentView configureWithContentViewConfig:contentViewConfig];
        
        ConfigureContentViewWithMainMenu(contentView, ^{
            [self showAllBooksMenu];
        });
        
        ConfigureContentViewWithAction(contentView, @"Book Actions", ^{
            [self showMenuForBookActions:book];
        });
    }];
    
    [self showTitleBarWithTitle:book.title];
}

- (void)showMenuForViewingQuote:(QBQuote*)quote
                        forBook:(QBBook*)book
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
        
        ConfigureContentViewWithMainMenu(contentView, ^{
            if (asPreview)
            {
                [self showMenuForAddingNewQuoteToBook:book
                                        optionalQuote:quote];
                [quote release];
            }
            else
            {
                [quote release];
                [self showMenuForBook:book];
            }
        });
        
        if (asPreview)
        {
            ConfigureContentViewWithAction(contentView, @"Looks good!", ^{
                [quoteManager addQuote:quote
                                toBook:book
                          successBlock:^(QBQuote* addedQuote){
                              [self showMenuForBook:book];
                              [quote release];
                          }
                          failureBlock:^{
                             [self confirmFailureWithText:@"Add Quote Failed"
                                            failureBlock:^{}];
                          }];
            });
        }
        else
        {
            ConfigureContentViewWithAction(contentView, @"All quotes", ^{
                [self showMenuForBook:book];
                
                [quote release];
            });
        }
    }];
    
    if (asPreview)
    {
        [self showTitleBarWithTitle:@"Quote Preview"];
    }
    else
    {
        [self showTitleBarWithTitle:book.title];
    }
}

- (void)showMenuForBookActions:(QBBook*)book
{
    if (book.isEmpty)
    {
        [self showMenuForAddingNewQuoteToBook:book
                                optionalQuote:nil];
        return;
    }
    
    [self dismissContentView];
    
    [self showDefaultBackground];
    
    [self showContentViewWithSetupBlock:^(ContentView* contentView) {
        ContentViewConfig* contentViewConfig = [ContentViewConfig object];
        [contentViewConfig.viewConfigs addObject:ContentButtonConfig(kDefaultAdditionalHeight, @"Add new quote", ^{
            [self showMenuForAddingNewQuoteToBook:book
                                    optionalQuote:nil];
        })];
        [contentViewConfig.viewConfigs addObject:ContentButtonConfig(kDefaultAdditionalHeight, @"Invite members", ^{
            [self showMenuForInvitingNewMembersToBook:book];
        })];
        [contentViewConfig.viewConfigs addObject:ContentButtonConfig(kDefaultAdditionalHeight, @"Display options", ^{
            [self showMenuForDisplayOptionsForBook:book];
        })];
        [contentViewConfig.viewConfigs addObject:ContentButtonConfig(kDefaultAdditionalHeight, @"View stats", ^{
            [self showMenuForViewingStatsForBook:book];
        })];
        [contentViewConfig.viewConfigs addObject:ContentButtonConfig(kDefaultAdditionalHeight, @"Search", ^{
            [self showMenuForSearchingInBook:book];
        })];
        [contentView configureWithContentViewConfig:contentViewConfig];
        
        ConfigureContentViewWithMainMenu(contentView, ^{
            if ([book isEmpty])
            {
                [self showAllBooksMenu];
            }
            else
            {
                [self showMenuForBook:book];
            }
        });
    }];
    
    [self showTitleBarWithTitle:book.title];
}

- (void)showMenuForAddingNewQuoteToBook:(QBBook*)book
                          optionalQuote:(QBQuote*)quoteArg
{
    [self dismissContentView];
    
    [self showDefaultBackground];
    
    [self showContentViewWithSetupBlock:^(ContentView* contentView) {
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
        
        void (^addQuoteLineToContentView)() = ^{
            int index = quoteToEdit.quoteLines.count;
            __block QBQuoteLine* quoteLine = [QBQuoteLine object];
            [quoteToEdit.quoteLines addObject:quoteLine];
            
            ContentTextFieldConfig* quoteTextConfig = ContentTextFieldConfig_label(kDefaultAdditionalHeight, @"Quote:", ^(NSString* enteredString) {
                quoteLine.text = enteredString;
            });
            quoteTextConfig.defaultFieldText = @"Required";
            
            ContentItemConfigToAdd* quoteTextConfigToAdd = [ContentItemConfigToAdd object];
            quoteTextConfigToAdd.contentItemConfig = quoteTextConfig;
            quoteTextConfigToAdd.index = index * 2 + 1;
            
            ContentTextFieldConfig* whoConfig = ContentTextFieldConfig_label(kDefaultAdditionalHeight, @"Who:", ^(NSString* enteredString) {
                quoteLine.who.nonuserQuoted = enteredString;
            });
            whoConfig.defaultFieldText = @"Required";
            
            ContentItemConfigToAdd* whoConfigToAdd = [ContentItemConfigToAdd object];
            whoConfigToAdd.contentItemConfig = whoConfig;
            whoConfigToAdd.index = index * 2 + 2;
            
            NSMutableArray* contentItemConfigsToAdd = [NSMutableArray object];
            [contentItemConfigsToAdd addObject:quoteTextConfigToAdd];
            [contentItemConfigsToAdd addObject:whoConfigToAdd];
            
            [contentView addContentItemConfigs:contentItemConfigsToAdd];
        };
        
        ContentViewConfig* contentViewConfig = [ContentViewConfig object];
        [contentViewConfig.viewConfigs addObject:ContentLabelConfig(kDefaultAdditionalHeight, NO, @"Add new quote:")];
        for (QBQuoteLine* quoteLine in quoteToEdit.quoteLines)
        {
            int index = [quoteToEdit.quoteLines indexOfObject:quoteLine];
            ContentTextFieldConfig* quoteConfig = ContentTextFieldConfig_label(kDefaultAdditionalHeight, @"Quote:", ^(NSString* enteredString){
                QBQuoteLine* quoteLine = [quoteToEdit.quoteLines objectAtIndex:index];
                quoteLine.text = enteredString;
            });
            quoteConfig.defaultFieldText = @"Required";
            quoteConfig.overrideFieldText = quoteLine.text;
            [contentViewConfig.viewConfigs addObject:quoteConfig];
            
            ContentTextFieldConfig* whoConfig = ContentTextFieldConfig_label(kDefaultAdditionalHeight, @"Who:", ^(NSString* enteredString){
                QBQuoteLine* quoteLine = [quoteToEdit.quoteLines objectAtIndex:index];
                quoteLine.who.nonuserQuoted = enteredString;
            });
            whoConfig.defaultFieldText = @"Required";
            whoConfig.overrideFieldText = [quoteLine.who formatDisplayName];
            [contentViewConfig.viewConfigs addObject:whoConfig];
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
        
        ConfigureContentViewWithMainMenu(contentView, ^{
            [self showMenuForBook:book];
            
            [quoteToEdit release];
        });
        
        ConfigureContentViewWithAction(contentView, @"Preview...", ^{
            if (quoteToEdit.quoteLines.count > 0)
            {
                [self showMenuForViewingQuote:quoteToEdit
                                      forBook:book
                                    asPreview:YES];
                
                [quoteToEdit release];
            }
        });
    }];
    
    [self showTitleBarWithTitle:book.title];
}

- (void)showMenuForInvitingNewMembersToBook:(QBBook*)book
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
        
        ConfigureContentViewWithMainMenu(contentView, ^{
            [self showMenuForBook:book];
        });
        
        ConfigureContentViewWithAction(contentView, @"Send invitations", ^{
            [self showMenuForConfirmingInvitationOfUsers:users
                                                  toBook:book];
        });
    }];
    
    [self showTitleBarWithTitle:book.title];;
}

- (void)showMenuForConfirmingInvitationOfUsers:(NSArray*)users
                                        toBook:(QBBook*)book
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
        
        ConfigureContentViewWithMainMenu(contentView, ^{[self showMenuForBook:book];});
        
        ConfigureContentViewWithAction(contentView, @"Send invitation", ^{
            [bookManager sendInvitesToUsers:users
                                    forBook:book];
            [self showMenuForBook:book];
        });
    }];
    
    [self showTitleBarWithTitle:book.title];
}

- (void)showMenuForDisplayOptionsForBook:(QBBook*)book
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
        
        ConfigureContentViewWithMainMenu(contentView, ^{[self showMenuForBook:book];});
    }];
    
    [self showTitleBarWithTitle:book.title];
}

- (void)showMenuForViewingStatsForBook:(QBBook*)book
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
        
        ConfigureContentViewWithMainMenu(contentView, ^{[self showMenuForBook:book];});
    }];
    
    [self showTitleBarWithTitle:book.title];
}

- (void)showMenuForSearchingInBook:(QBBook*)book
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
        
        ConfigureContentViewWithMainMenu(contentView, ^{[self showMenuForBook:book];});
    }];
    
    [self showTitleBarWithTitle:book.title];
}

@end
