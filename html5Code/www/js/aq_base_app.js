// MODULE NAME LIST
// module-appSplashMenu
// module-loginMenu
// module-sideMenu
// module-userMenu

var app =
{
    //core: new Core(),
    
    // Application Constructor
    initialize: function()
    {
        this.bindEvents();
        //core.startModule("module-appSplashMenu");
    },
    
    // Bind Event Listeners
    //
    // Bind any events that are required on startup. Common events are:
    // 'load', 'deviceready', 'offline', and 'online'.
    bindEvents: function()
    {
        document.addEventListener('deviceready', this.onDeviceReady, false);
        document.addEventListener('ontouchmove', this.blockElasticScroll, false);
        document.addEventListener('load', this.load, false);
        document.addEventListener('offline', this.offline, false);
        document.addEventListener('online', this.online, false);
    },
    
    // deviceready Event Handler
    //
    // The scope of 'this' is the event. In order to call the 'receivedEvent'
    // function, we must explicity call 'app.receivedEvent(...);'
    onDeviceReady: function()
    {
        app.receivedEvent('deviceready');
    },
    
    // Update DOM on a Received Event
    receivedEvent: function(id)
    {
        var parentElement = document.getElementById(id);
        var listeningElement = parentElement.querySelector('.listening');
        var receivedElement = parentElement.querySelector('.received');

        listeningElement.setAttribute('style', 'display:none;');
        receivedElement.setAttribute('style', 'display:block;');

        console.log('Received Event: ' + id);
    },
    
    blockElasticScroll: function(event)
    {
        event.preventDefault();
    },
    
    load: function()
    {
        console.log('Received Event: load');
    },
    
    offline: function()
    {
        console.log('Received Event: offline';
    },
    
    online: function()
    {
        console.log('Received Event: online');
    }
};
