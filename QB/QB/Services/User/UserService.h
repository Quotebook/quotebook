#import "QB.h"

@class QBUser;

@interface CreateNewUserRequest : ManagedPropertiesObject <SerializeByDefault>
@property (nonatomic, retain) NSString* email;
@property (nonatomic, retain) NSString* password;
@property (nonatomic, retain) NSString* firstName;
@property (nonatomic, retain) NSString* lastName;
@end

@interface RetrieveUserRequest : ManagedPropertiesObject <SerializeByDefault>
@property (nonatomic, retain) NSString* email;
@property (nonatomic, assign) int64_t uuid;
@end

@interface LoginRequest : ManagedPropertiesObject <SerializeByDefault>
@property (nonatomic, retain) NSString* email;
@property (nonatomic, retain) NSString* password;
@end

@interface LoginResponse : ManagedPropertiesObject <SerializeByDefault>
@property (nonatomic, retain) QBUser* user;
@property (nonatomic, retain) NSArray* books;
@end

@interface UserService : Service

DeclareServiceCommand(createNewUser, CreateNewUserRequest, QBUser)

DeclareServiceCommand(retrieveUser, RetrieveUserRequest, QBUser)

DeclareServiceCommand(login, LoginRequest, LoginResponse)

DeclareServiceCommandNoInputNoResponse(logout)

@end


