// MODULE NAME LIST
// module-appSplashMenu
// module-loginMenu
// module-sideMenu
// module-userMenu

var app =
{
    core: new Core(),
    
    // Application Constructor
    initialize: function()
    {
        this.bindEvents();
    },
    
    // Bind Event Listeners
    //
    // Bind any events that are required on startup. Common events are:
    // 'load', 'deviceready', 'offline', and 'online'.
    bindEvents: function()
    {
        document.addEventListener('deviceready', this.onDeviceReady, false);
        document.addEventListener('ontouchmove', this.blockElasticScroll, false);
    },
    
    // deviceready Event Handler
    //
    // The scope of 'this' is the event. In order to call the 'receivedEvent'
    // function, we must explicity call 'app.receivedEvent(...);'
    registerAllModules: function()
    {
//        registerAppSplashMenu();
        registerLoginMenu();
        registerUserMenu();
    },
    
    onDeviceReady: function()
    {
        app.receivedEvent('deviceready');
        
        app.registerAllModules();
        
        app.core.startModule("module-loginMenu");
    },
    
    startUserMenu: function()
    {
        logEvent("hi", "caleb", "hurry");
        app.core.stopModule("module-loginMenu");
        app.core.startModule("module-userMenu");
        logEvent("hi", "caleb", "hurry");
    },
    
    onClick: function()
    {
        logEvent("APP", "onClick", "w/e");
    },
    
    // Update DOM on a Received Event
    receivedEvent: function(id)
    {
        var parentElement = document.getElementById(id);
        var listeningElement = parentElement.querySelector('.listening');
        var receivedElement = parentElement.querySelector('.received');

        listeningElement.setAttribute('style', 'display:none;');
        receivedElement.setAttribute('style', 'display:block;');

        logEvent("APP", "EventReceived", id);
    },
    
    blockElasticScroll: function(event)
    {
        event.preventDefault();
    }
};
