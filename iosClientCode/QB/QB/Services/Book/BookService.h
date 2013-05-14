#import "QB.h"

@class QBBook;

@interface CreateNewBookRequest : ManagedPropertiesObject <SerializeByDefault>
@property (nonatomic, retain) NSString* bookTitle;
@end

@interface RetrieveBookRequest : ManagedPropertiesObject <SerializeByDefault>
@property (nonatomic, assign) int bookUuid;
@end

@interface BookService : Service

DeclareServiceCommand(createNewBook, CreateNewBookRequest, QBBook)

DeclareServiceCommand(retrieveBook, RetrieveBookRequest, QBBook)

@end

