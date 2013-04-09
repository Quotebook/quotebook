#import "UserManager.h"
#import "MenuManager.h"
#import "UserService.h"
#import "BookManager.h"

@interface UserManager ()
{
    MenuManager* menuManager;
    BookManager* bookManager;
}
@property (nonatomic, retain) QBUser* currentActiveUser;
@end


@implementation UserManager

- (QBUser*)getActiveUser
{
    return _currentActiveUser;
}

- (void)setActiveUser:(QBUser*)user
{
    self.currentActiveUser = user;
}

- (void)load // omg shitty ENTRY POINT... 
{
    [menuManager showLoginMenu];
}

- (BOOL)internal_validateNewUserWithEmail:(NSString*)email
                                firstName:(NSString*)firstName
                                 lastName:(NSString*)lastName
                                 password:(NSString*)password
                                  confirm:(NSString*)confirm
{
    if (email == nil ||
        [email rangeOfString:@"@"].location == NSNotFound ||
        [email rangeOfString:@"."].location == NSNotFound ||
        firstName == nil ||
        ![password isEqualToString:confirm])
        return NO;
    return YES;
}

- (void)createNewUserWithEmail:(NSString*)email
                     firstName:(NSString*)firstName
                      lastName:(NSString*)lastName
                      password:(NSString*)password
                       confirm:(NSString*)confirm
                  successBlock:(void(^)(QBUser*))successBlock
                  failureBlock:(VoidBlock)failureBlock
{
    CreateNewUserRequest* request = [CreateNewUserRequest object];
    request.email = email;
    request.firstName = firstName;
    request.lastName = lastName;
    request.password = password;
    
    if ([self internal_validateNewUserWithEmail:email
                                      firstName:firstName
                                       lastName:lastName
                                       password:password
                                        confirm:confirm])
    {
        [UserService createNewUser:request
                   responseHandler:^(QBUser* newUser){
                       if (newUser == nil)
                       {
                           failureBlock();
                       }
                       else
                       {
                           successBlock(newUser);
                       }
                   }];
    }
    else
    {
        failureBlock();
    }
}

- (void)loginUserWithEmail:(NSString*)email
                  password:(NSString*)password
              successBlock:(void(^)(LoginResponse*))successBlock
              failureBlock:(VoidBlock)failureBlock
{
    CheckTrue(_currentActiveUser == nil);
    LoginRequest* request = [LoginRequest object];
    request.email = email;
    request.password = password;
    
    if (email != nil &&
        password != nil)
    {
        [UserService login:request
           responseHandler:^(LoginResponse* loginResponse) {
               if (loginResponse.user == nil)
               {
                   failureBlock();
               }
               else
               {
                   self.currentActiveUser = loginResponse.user;
                   
                   [bookManager addBooksToKnownBooks:loginResponse.books];
                   
                   successBlock(loginResponse);
               };
           }];
    }
    else
    {
        failureBlock();
    }
}

- (void)logout
{
    self.currentActiveUser = nil;
    [UserService logout];
}

- (void)retrieveUserWithEmail:(NSString*)email
                 successBlock:(void(^)(QBUser*))successBlock
                 failureBlock:(VoidBlock)failureBlock
{
    RetrieveUserRequest* request = [RetrieveUserRequest object];
    request.email = email;
    
    if (email != nil)
    {   
        [UserService retrieveUser:request
                  responseHandler:^(QBUser* user) {
                      if (user == nil)
                      {
                          failureBlock();
                      }
                      else
                      {
                          successBlock(user);
                      }
                  }];
    }
    else
    {
        failureBlock();
    }
}

- (void)retrieveUserUuid:(int64_t)uuid
            successBlock:(void(^)(QBUser*))successBlock
            failureBlock:(VoidBlock)failureBlock
{
    RetrieveUserRequest* request = [RetrieveUserRequest object];
    request.uuid = uuid;
    
    [UserService retrieveUser:request
              responseHandler:^(QBUser* user) {
                  user == nil ? failureBlock() : successBlock(user);
              }];
}

@end
