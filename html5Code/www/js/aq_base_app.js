
var app =
{
    core: new Core(),
    
    initialize: function()
    {
        this.bindEvents();
    },
    
    bindEvents: function()
    {
        document.addEventListener('deviceready', this.onDeviceReady, false);
        document.addEventListener('ontouchmove', this.blockElasticScroll, false);
    },
    
    onDeviceReady: function()
    {        
        app.receivedEvent('deviceready');
        
        logEvent("APP", "BeginStartUp", "========================================");
        
        app.core.logAllRegisteredClasses();
        
        app.core.startAllRegisteredServices();
        
        app.core.bindEventForListener("LoginSuccessful", function(eventData){ app.loginSuccessful(eventData) }, app);
        
        app.core.startModule(getLoginMenuModuleName());
        
        logEvent("APP", "StartUpComplete", "========================================");
    },
    
    receivedEvent: function(id)
    {
        var parentElement = document.getElementById(id);
        var listeningElement = parentElement.querySelector('.listening');
        var receivedElement = parentElement.querySelector('.received');

        listeningElement.setAttribute('style', 'display:none;');
        receivedElement.setAttribute('style', 'display:block;');

        logEvent("APP", "App Event", id);
    },
    
    blockElasticScroll: function(event)
    {
        event.preventDefault();
    },
    
    loginSuccessful: function(eventData)
    {
        app.core.stopAllModules();
        app.core.startModule(getUserMenuModuleName());
    }
};
