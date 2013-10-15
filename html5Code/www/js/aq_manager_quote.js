var kQuoteManagerName = "manager-quote";

var createQuoteManagerFunction = function(core)
{
    var manager = new Manager(kQuoteManagerName, core);
    
    return manager;
};

app.core.registerManager(kQuoteManagerName, createQuoteManagerFunction);


//
//core.registerManager("login", function(sandbox)
//{
//    var manager = {
//        // -----------------------
//        // DATA
//        // -----------------------
//        // Currently logged in active user
//        activeUser: null,
//        
//        
//        // -----------------------
//        // FUNCTIONS
//        // -----------------------
//        getUserByEmail: function(email)
//        {
//            var user = factory.createClassByName("user");
//            user.initializeWithData("Caleb", "Fisher", "caleb_fisher@yahoo.com", "password");
//            return user;
//        },
//        
//        doesUserExistForEmail: function(email)
//        {
//            return true;
//        },
//        
//        autoLogin: function()
//        {
//            var autoLoginEmail = "caleb_fisher@yahoo.com"; // TODO - cache this somewhere Update cache upon successful login.
//            var autoLoginPassword = "password"; // TODO - cache this somewhere. Update cache upon successful login.
//            
//            if (autoLoginEmail == null ||
//                !this.doesUserExistForEmail(autoLoginEmail))
//            {
//                return false;
//            }
//            
//            var user = this.getUserByEmail(autoLoginEmail);
//            
//            if (!user.verifyPassword(autoLoginPassword))
//            {
//                return false;
//            }
//            
//            loginUser(autoLoginEmail, autoLoginPassword);
//        },
//        
//        loginUser: function(email, password)
//        {
//            var user = this.getUserByEmail(autoLoginEmail);
//            
//            if (!user.verifyPassword(autoLoginPassword))
//            {
//                // Assert.
//            }
//            
//            this.activeUser = user;
//        }
//    };
//                     
//    return manager;
//});
