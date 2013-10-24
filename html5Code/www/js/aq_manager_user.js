var kUserManagerName = "manager-user";

var temp_userIdGenerator = 0;

var createUserManagerFunction = function(core)
{
    var manager = new Manager(kUserManagerName, core);

    manager.currentlyLoggedInUserId = null;
    
    manager.attemptLogin = function(loginRequest)
    {
        logEvent("MANAGER", "AttemptLogin", "attemptLogin");
     
        if (manager.currentlyLoggedInUserId != null)
        {
            loginRequest.failureFunction("A user is still logged in.");
        }
        
        var successFunction = function(userView) {};
        var failureFunction = function(failureReason)
        {
            logAssert("Create New User failed. Reason: " + failureReason);
        };
      
        var userId = manager.getUserIdForEmail(loginRequest.email);
        
        if (userId != null)
        {
            manager.currentlyLoggedInUserId = userId;
            
            loginRequest.successFunction(userId);
        }
        else
        {
            loginRequest.failureFunction("User not found for email: " + loginRequest.email);
        }
    };
    
    manager.getUserIdForEmail = function(email)
    {
        // ask local data store fo all data of type user
        // crawl all local data for users with email
        // if found, return id
        var userDataViewFilter = function(dataHolder)
        {
            var userView = new UserView(dataHolder);
            return userView.email == email;
        };
        
        var userDataIds = core.getLocalDataStore().getDataIdsForTypeAndFilter(kDataType_user, userDataViewFilter);
        
        if (userDataIds.length > 1)
        {
            logAssert("Multiple users ids found for email: " + email);
        }
        
        var firstUserDataId = userDataIds[0];
        
        if (firstUserDataId != null)
        {
            return firstUserDataId;
        }
        
        // TODO: if not found, ask our sql interface
        return null;
    };
    
    manager.createNewUser = function(createNewUserRequest)
    {
        if (createNewUserRequest.validate() == false)
        {
            createNewUserRequest.failureFunction("Request did not validate.");
            return;
        }

        var userId = manager.getUserIdForEmail(createNewUserRequest.email);
        
        if (userId != null)
        {
            createNewUserRequest.failureFunction("User already exists for email: " + createNewUserRequest.email);
            return;
        }

        var data = createNewUserRequest.buildDataForNewUser();
        
        var userDataHolder = core.getLocalDataStore().createDataHolderForDataAndTypeAndId(data, kDataType_user, manager.createNextUserId());
        
        createNewUserRequest.successFunction(new UserView(userDataHolder));
    };
    
//    manager.addBookToUser = function
    
    manager.createNextUserId = function()
    {
        temp_userIdGenerator++;
        
        var userId = "u_" + temp_userIdGenerator;
        
        logEvent("USER", "CreateNextUserId", userId);
        
        return userId;
    };
    
    return manager;
};

app.core.registerManager(kUserManagerName, createUserManagerFunction);
