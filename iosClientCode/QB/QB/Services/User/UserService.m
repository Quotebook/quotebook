#import "UserService.h"
#import "OfflineManager.h"
#import "QBUser.h"

@implementation UserService

ServiceName(UserService);

QBServiceCommand(createNewUser, CreateNewUserRequest, QBUser, ^(CreateNewUserRequest* request) {
    return [[OfflineManager sharedInstance] createNewUserWithEmail:request.email
                                                         firstName:request.firstName
                                                          lastName:request.lastName
                                                          password:request.password];
});

QBServiceCommand(retrieveUser, RetrieveUserRequest, QBUser, ^(RetrieveUserRequest* request) {
    return [[OfflineManager sharedInstance] retrieveUserWithEmail:request.email
                                                           orUuid:request.uuid];
});

QBServiceCommand(login, LoginRequest, LoginResponse, ^(LoginRequest* request) {
    return [[OfflineManager sharedInstance] loginWithEmail:request.email
                                                  password:request.password];
});

QBServiceCommandNoInputNoResponse(logout, ^{
    [[OfflineManager sharedInstance] logout];
});

@end

@implementation CreateNewUserRequest
@end

@implementation RetrieveUserRequest
@end

@implementation LoginRequest
@end

@implementation LoginResponse
@end