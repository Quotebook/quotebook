
var app = new Object();

app.core = new Core();
    
app.initialize = function()
{
    this.bindEvents();
};

app.bindEvents = function()
{
    document.addEventListener('deviceready', this.onDeviceReady, false);
    document.addEventListener('ontouchmove', this.blockElasticScroll, false);
};

app.onDeviceReady = function()
{
    app.receivedEvent('deviceready');
    
    logEvent("APP", "BeginStartUp", "========================================");
    
    app.core.logAllRegisteredClasses();
    
    app.core.startAllRegisteredManagers();
    
    app.core.bindEventForListener("LoginSuccessful", function(eventData){ app.loginSuccessful(eventData) }, app);
    app.core.bindEventForListener("LogoutSuccessful", function(eventData){ app.logoutSuccessful(eventData) }, app);
    
    app.core.startModule(kLoginMenuId_moduleName);
    
    logEvent("APP", "StartUpComplete", "========================================");
};

app.receivedEvent = function(id)
{
    var parentElement = document.getElementById(id);
    var listeningElement = parentElement.querySelector('.listening');
    var receivedElement = parentElement.querySelector('.received');
    
    listeningElement.setAttribute('style', 'display:none;');
    receivedElement.setAttribute('style', 'display:block;');
    
    logEvent("APP", "App Event", id);
};

app.blockElasticScroll = function(event)
{
    event.preventDefault();
};

app.loginSuccessful = function(eventData)
{
    app.core.stopAllModules();
    app.core.startModule(kUserMenuId_moduleName);
};

app.logoutSuccessful = function(eventData)
{
    app.core.stopAllModules();
    app.core.startModule(kLoginMenuId_moduleName);
};
