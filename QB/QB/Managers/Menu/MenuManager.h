#import "QB.h"

@class QBBook;
@class QBQuote;

@interface MenuManager : Manager

- (void)showLoginMenu;

- (void)showAllBooksMenu;

@end

@interface MenuManager (Book)
// Books
- (void)showMenuForBook:(QBBook*)book;
- (void)showMenuForAddingNewQuoteToBook:(QBBook*)book
                          optionalQuote:(QBQuote*)quote;
- (void)showMenuForInvitingNewMembersToBook:(QBBook*)book;
- (void)showMenuForDisplayOptionsForBook:(QBBook*)book;
- (void)showMenuForViewingStatsForBook:(QBBook*)book;
- (void)showMenuForSearchingInBook:(QBBook*)book;

@end
