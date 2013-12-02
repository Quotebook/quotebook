var kUserMenuId_moduleName = "module-userMenu";

var kUserMenuId_textInput_who = "userMenuId_textInput_who";
var kUserMenuId_textInput_quote = "userMenuId_textInput_quote";
var kUserMenuId_textInput_date = "userMenuId_textInput_date";
var kUserMenuId_textInput_context = "userMenuId_textInput_context";

var kUserMenuId_textInput_newBookTitle = "userMenuId_textInput_newBookTitle";

var createUserMenuModuleFunction = function(sandbox)
{
    var module = new Module(kUserMenuId_moduleName, sandbox);

    module.quoteLineKeyIndex = 0;
    
    module.init = function()
    {
        module.buildDefaultForUserView(sandbox.getCurrentlyLoggedInUser());
        
        module.quoteLineKeyIndex = 0;
    };
    
    module.destroy = function()
    {
    };
    
    module.getNextWhoIndexedKey = function()
    {
        return kUserMenuId_textInput_who + module.quoteLineKeyIndex;
    };
    
    module.getNextQuoteIndexedKey = function()
    {
        return kUserMenuId_textInput_quote + module.quoteLineKeyIndex;
    };
    
    module.buildDefaultForUserView = function(userView)
    {
        var logoutFunction = function()
        {
            module.postEvent("LogoutSuccessful", "");
        }; 
        
        module.clearAppBodyOnBuild();
        
        var appBody = module.getAppBody();
        
        // Prompt to add new books
        var buildForNewBookFunction = function()
        {
            module.buildForNewBookForUserView(userView);
        };
        
        if (userView.bookIds.length > 0)
        {
            // Build buttons for current books
            for (var i = 0; i < userView.bookIds.length; ++i)
            {
                var bookView = sandbox.getBookViewByUserViewAndBookId(userView, userView.bookIds[i]);
                
                var buildForBookViewFunction = function()
                {
                    logMessage("working title = " + bookView.title);
                    module.buildForUserViewAndBookViewAndOptionalQuoteView(userView, bookView, null);
                };
                
                // TODO - check the element id of this button... could be squashing it
                var button = appBody.addButtonWithData(bookView.title, bookView, function(mouseEvent)
                                                       {
                                                            module.buildForUserViewAndBookViewAndOptionalQuoteView(userView, mouseEvent.target.userData, null);
                                                       });

                button.id = "id_" + i;
                appBody.addLineBreak();
                appBody.addLineBreak(); 
            }
            
            // DEBUG
            appBody.addButton("Add another book", buildForNewBookFunction)
            // !DEBUG
        }
        else
        {
            appBody.addDiv("To get started, add your first quotebook!");
            appBody.addLineBreak();
            appBody.addLineBreak();
            appBody.addButton("Add first book", buildForNewBookFunction)
        }
        
        var appHeader = module.getAppHeader();
        appHeader.clearConfiguration();
        appHeader.configureTitle(userView.firstName + " " + userView.lastName);
        appHeader.configureLeftButton("Menu", sandbox.menuButtonAction);
        appHeader.configureRightButton("Logout", logoutFunction);
    };
    
    module.buildForNewBookForUserView = function(userView)
    {
        module.clearAppBodyOnBuild();
        
        var appBody = module.getAppBody();
        
        var backFunction = function()
        {
            module.buildDefaultForUserView(userView);
        }
        
        var createBookFunction = function()
        {
            var bookTitle = appBody.getElementForId(kUserMenuId_textInput_newBookTitle).value;
  
            var bookManager = sandbox.getBookManager();
            
            var successFunction = function(bookView)
            {
                // LEFT OFF
                sandbox.writeAllData();
                
                module.buildForUserViewAndBookViewAndOptionalQuoteView(userView, bookView, null);
            };
            
            var failureFunction = function(failureReason)
            {
                logAssert("Create New Book failed. Reason: " + failureReason);
            };
            
            var request = new CreateNewBookRequest(bookTitle, userView, successFunction, failureFunction);
            
            bookManager.createNewBookForUserView(request);
        };

        appBody.addDiv("Give your book a title!");
        appBody.addLineBreak();
        appBody.addLineBreak();
        appBody.addTextInput("Book Title", kUserMenuId_textInput_newBookTitle);
        appBody.addLineBreak();
        appBody.addLineBreak();
        appBody.addButton("Create", createBookFunction);
        
        var appHeader = module.getAppHeader();
        appHeader.clearConfiguration();
        appHeader.configureTitle(userView.firstName + " " + userView.lastName);
        appHeader.configureLeftButton("Menu", sandbox.menuButtonAction);
        appHeader.configureRightButton("Back", backFunction);
    };
    
    
    module.buildForUserViewAndBookViewAndOptionalQuoteView = function(userView, bookView, optionalQuoteViewToFocus)
    {
        // Confirm quote is a child of this book
        // Confirm book is a child of this user - maybe. Consider the case where yore viewing another users books/quotes
        module.clearAppBodyOnBuild();
        
        var appBody = module.getAppBody();
        
        // Prompt to add new quote
        var buildForNewQuoteFunction = function()
        {
            module.buildForAddNewQuoteForBookView(userView, bookView);
        };
        
        if (bookView.quoteIds.length > 0)
        {
            // Build buttons for current quotes
            for (var i = 0; i < bookView.quoteIds.length; ++i)
            {
                var userData = {};
                userData.bookView = bookView;
                userData.quoteView = sandbox.getQuoteViewByBookViewAndQuoteId(bookView, bookView.quoteIds[i]);
                
                appBody.addButtonWithdata(quoteView.quoteText, userData, function(mouseEvent)
                                          {
                                            var userData = mouseEvent.target.userData;
                                          
                                            module.buildForUserViewAndBookViewAndOptionalQuoteView(userView, userData.bookView, userData.quoteView);
                                          });
                appBody.addLineBreak();
                appBody.addLineBreak();
            }
            
            // DEBUG
            appBody.addButton("Add another quote", buildForNewQuoteFunction)
            // !DEBUG
        }
        else
        {
            appBody.addDiv("Create your first quote!");
            appBody.addLineBreak();
            appBody.addLineBreak();
            appBody.addButton("Add first quote", buildForNewQuoteFunction)
        }
        
        var backFunction = function()
        {
            module.buildDefaultForUserView(userView);
        };
        
        var appHeader = module.getAppHeader();
        appHeader.clearConfiguration();
        appHeader.configureTitle(bookView.title);
        appHeader.configureLeftButton("Menu", sandbox.menuButtonAction);
        appHeader.configureRightButton("Back", backFunction);
    };
    
    module.buildForAddNewQuoteForBookView = function(userView, bookView)
    {
        var backFunction = function()
        {
            module.buildDefaultForUserView(userView);
        };
        
        var previewFunction = function()
        {
            var appBody = module.getAppBody();
            
            var quoteLines = [];
            
            for (var i = 0; i < module.quoteLineKeyIndex; ++i)
            {
                var quoteLine = {};
                var whoIndexedKey = kUserMenuId_textInput_who + i;
                var quoteIndexedKey = kUserMenuId_textInput_quote + i;
                
                quoteLine.who = appBody.getElementForId(whoIndexedKey).value;
                quoteLine.quoteText = appBody.getElementForId(quoteIndexedKey).value;
                
                quoteLines.push(quoteLine);
            }
            
            var date = "Date: Input not implemented";
            var context = appBody.getElementForId(kUserMenuId_textInput_context).value;
            
            module.buildForPreviewNewQuoteForBookView(userView, bookView, quoteLines, date, context);
        };
        
        // DEBUG
        var DEBUG_useDefaultSingleLinedQuote = function()
        {
            var quoteLines = [];
            
            var quoteLine = {};
                
            quoteLine.who = "Default who";
            quoteLine.quoteText = "Default quote";
                
            quoteLines.push(quoteLine);
            
            module.buildForPreviewNewQuoteForBookView(userView, bookView, quoteLines, "Default date", "Default context");
        };
        
        var DEBUG_useDefaultMultiLinedQuote = function()
        {
            var quoteLines = [];
            
            var quoteLine1 = {};
            quoteLine1.who = "Default who1";
            quoteLine1.quoteText = "Default quote1";

            var quoteLine2 = {};
            quoteLine2.who = "Default who2";
            quoteLine2.quoteText = "Default quote2";
            
            var quoteLine3 = {};
            quoteLine3.who = "Default who3";
            quoteLine3.quoteText = "Default quote3";
            
            quoteLines.push(quoteLine1);
            quoteLines.push(quoteLine2);
            quoteLines.push(quoteLine3);
            
            module.buildForPreviewNewQuoteForBookView(userView, bookView, quoteLines, "Default date", "Default context");
        };
        // !DEBUG
        
        module.clearAppBodyOnEvent("content change");
        
        var appBody = module.getAppBody();
        
        appBody.addDiv("Add new Quote:");
        appBody.addLineBreak();
        appBody.addTextInput("Who", module.getNextWhoIndexedKey());
        appBody.addLineBreak();
        appBody.addTextInput("Quote", module.getNextQuoteIndexedKey());
        appBody.addLineBreak();
        appBody.addButton("Add Line", logNotYetImplemented);
        appBody.addLineBreak();
        appBody.addTextInput("Context", kUserMenuId_textInput_context);
        appBody.addLineBreak();
        appBody.addDiv("Oct 8, 2013 - 9:03am");
        appBody.addLineBreak();
        appBody.addButton("Preview", previewFunction);
        appBody.addLineBreak();
        
        // DEBUG
        appBody.addButton("(DEBUG)Use default single lined quotes", DEBUG_useDefaultSingleLinedQuote);
        appBody.addLineBreak();
        appBody.addButton("(DEBUG)Use default multi lined quotes", DEBUG_useDefaultMultiLinedQuote);
        appBody.addLineBreak();
        // DEBUG
        
        module.quoteLineKeyIndex++;
        
        var appHeader = module.getAppHeader();
        appHeader.clearConfiguration();
        appHeader.configureTitle("Add New Quote");
        appHeader.configureLeftButton("Menu", sandbox.menuButtonAction);
        appHeader.configureRightButton("Back", backFunction);
    };
    
    module.buildForPreviewNewQuoteForBookView = function(userView, bookView, quoteLines, date, context)
    {
        var backFunction = function()
        {
            module.buildForAddNewQuoteForBookView(userView, bookView);
        };
        
        var createQuoteFunction = function()
        {
            var successFunction = function(quoteView)
            {
                module.buildForUserViewAndBookViewAndOptionalQuoteView(userView, bookView, quoteView);
            };
            
            var failureFunction = function(failureReason)
            {
                logAssert("Create New Quote Failed. Reason: " + failureReason);
            };

            var request = new CreateNewQuoteRequest(quoteLines, date, context, bookView, successFunction, failureFunction);

            sandbox.getQuoteManager().createNewQuote(request);
        };
        
        module.clearAppBodyOnEvent("content change");
        
        var appBody = module.getAppBody();
        
        for (var i = 0; i < quoteLines.length; ++i)
        {
            var quote = quoteLines[i];
            
            appBody.addDiv(quote.quote); // quote
            appBody.addLineBreak();
            appBody.addLineBreak();
            appBody.addDiv(quote.who); // who
            appBody.addLineBreak();
            appBody.addLineBreak();
        }
        
        appBody.addDiv(date); // date
        appBody.addLineBreak();
        appBody.addLineBreak();
        appBody.addDiv("Re: " + context); // context
        appBody.addLineBreak();
        appBody.addLineBreak();
        appBody.addButton("Add The Quote", createQuoteFunction);
        
        var appHeader = module.getAppHeader();
        appHeader.clearConfiguration();
        appHeader.configureTitle("Preview Quote");
        appHeader.configureLeftButton("Menu", sandbox.menuButtonAction);
        appHeader.configureRightButton("Back", backFunction);
    };
    
    module.buildForInviteAFriend = function()
    {
        var backFunction = function()
        {
            module.buildDefaultForUserView(userView);
        };
        
        module.clearAppBodyOnEvent("content change");
        
        var appBody = module.getAppBody();
        
        appBody.addDiv("Invite a friend:");
        appBody.addLineBreak();
        appBody.addTextInput("Who", kUserMenuId_textInput_who);
        appBody.addLineBreak();
        appBody.addButton("Invite", logNotYetImplemented);
        appBody.addLineBreak();
        
        var appHeader = module.getAppHeader();
        appHeader.clearConfiguration();
        appHeader.configureTitle("Invite A Friend");
        appHeader.configureLeftButton("Menu", sandbox.menuButtonAction);
        appHeader.configureRightButton("Back", backFunction);
    };
    
    return module;
};

app.core.registerModule(kUserMenuId_moduleName, createUserMenuModuleFunction);
