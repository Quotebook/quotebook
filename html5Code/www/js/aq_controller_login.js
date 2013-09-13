
var loginController =
{
    beginLoginFlow: function()
    {
        if (loginService.autoLogin())
        {
//            appController.openHTMLPage
//            login: function()
//            {
//                // how do i verify this user without fetching the password
//                
//                window.location.href="aq_userSplash.html";
//                
//                console.log("User logged in successfully. Name:", this.firstName, this.lastName, " email:", this.email, "password:", this.password);
//            },
            return;
        }
        
        appController.openHTMLPage("aq_login.html");
    },
    
    loginUserByEmail: function(email, password)
    {
        loginService.loginUser(email, password);
    }
};