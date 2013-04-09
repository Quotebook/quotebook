#import "BookService.h"
#import "OfflineManager.h"
#import "QBBook.h"


@implementation BookService

ServiceName(BookService)

QBServiceCommand(createNewBook, CreateNewBookRequest, QBBook, ^(CreateNewBookRequest* request) {
    return [[OfflineManager sharedInstance] createNewBookWithBookTitle:request.bookTitle];
})

QBServiceCommand(retrieveBook, RetrieveBookRequest, QBBook, ^(RetrieveBookRequest* request) {
    return [[OfflineManager sharedInstance] retrieveBookWithBookUuid:request.bookUuid];
})

@end

@implementation CreateNewBookRequest
@end

@implementation RetrieveBookRequest
@end
