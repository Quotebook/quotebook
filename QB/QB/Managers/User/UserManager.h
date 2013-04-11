#import "QB.h"

@class QBUser;
@class LoginResponse;

@interface UserManager : Manager

- (QBUser*)getActiveUser;

- (void)setActiveUser:(QBUser*)user;

- (BOOL)shouldLoginImplicitly;

- (void)attemptImplicitLogin;

- (void)createNewUserWithEmail:(NSString*)email
                     firstName:(NSString*)firstName
                      lastName:(NSString*)lastName
                      password:(NSString*)password
                       confirm:(NSString*)confirm
                  successBlock:(void(^)(QBUser*))successBlock
                  failureBlock:(VoidBlock)failureBlock;

- (void)loginUserWithEmail:(NSString*)email
                  password:(NSString*)password
              successBlock:(void(^)(LoginResponse*))successBlock
              failureBlock:(VoidBlock)failureBlock;

- (void)logout;

- (void)retrieveUserWithEmail:(NSString*)email
                 successBlock:(void(^)(QBUser*))successBlock
                 failureBlock:(VoidBlock)failureBlock;

- (void)retrieveUserUuid:(int64_t)uuid
            successBlock:(void(^)(QBUser*))successBlock
            failureBlock:(VoidBlock)failureBlock;

@end
