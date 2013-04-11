#import "UserManager.h"
#import "UserService.h"
#import "BookManager.h"
#import "MenuManager.h"

#define kUserDefaults_lastLoginEmail @"lastLoginEmail"
#define kUserDefaults_lastLoginPassword @"lastLoginPassword"

@interface UserManager ()
{
    BookManager* bookManager;
    MenuManager* menuManager;
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

- (void)internal_clearUserDefaults
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaults_lastLoginEmail];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaults_lastLoginPassword];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)internal_setLastLoginEmail:(NSString*)lastLoginEmail
                 lastLoginPassword:(NSString*)lastLoginPassword
{
    [[NSUserDefaults standardUserDefaults] setObject:lastLoginEmail
                                              forKey:kUserDefaults_lastLoginEmail];
    [[NSUserDefaults standardUserDefaults] setObject:lastLoginPassword
                                              forKey:kUserDefaults_lastLoginPassword];
    [[NSUserDefaults standardUserDefaults] synchronize];}



- (BOOL)shouldLoginImplicitly
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaults_lastLoginEmail] != nil &&
           [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaults_lastLoginPassword] != nil;
}

- (void)attemptImplicitLogin
{
    CheckTrue([self shouldLoginImplicitly])
    
    NSString* lastLoginEmail = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaults_lastLoginEmail];
    NSString* lastLoginPassword = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaults_lastLoginPassword];
    
    if (lastLoginEmail != nil &&
        lastLoginPassword != nil)
    {
        [self loginUserWithEmail:lastLoginEmail
                        password:lastLoginPassword
                    successBlock:^(LoginResponse* loginResponse) {
                        [menuManager showAllBooksMenu];
                    }
                    failureBlock:^{
                        [menuManager showLoginMenu];
                    }];
        
    }
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
                   [self internal_clearUserDefaults];
                   
                   failureBlock();
               }
               else
               {
                   [self internal_setLastLoginEmail:email
                                  lastLoginPassword:password];
                   
                   self.currentActiveUser = loginResponse.user;
                   
                   [bookManager addBooksToKnownBooks:loginResponse.books];
                   
                   successBlock(loginResponse);
               };
           }];
    }
    else
    {
        [self internal_clearUserDefaults];
        
        failureBlock();
    }
}

- (void)logout
{
    self.currentActiveUser = nil;
    
    [self internal_clearUserDefaults];
    
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
