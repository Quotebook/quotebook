
var Sandbox = function (core)
{
    return {
        // -----------------------
        // EVENTS
        // -----------------------
        postEvent: function(eventData)
        {
            core.postEvent(eventData);
        },
        
        bindEventsForListener: function(eventTypeList, eventCallback, listener)
        {
            core.bindEventsForListener(eventTypeList, eventCallback, listener);
        },
        
        unbindAllEventsForListener: function(listener)
        {
            core.unbindAllEventsForListener(listener);
        },
        
        unbindEventsForListener: function(eventTypeList, listener)
        {
            core.unbindEventsForListener(eventTypeList, listener);
        },
        
        // -----------------------
        // DOCUMENT
        // -----------------------
        getAppBody: function()
        {
            var appBody = {
                appBodyElement: document.getElementById("appBody"),
                
                addLineBreak: function()
                {
                    var pageBreak = document.createElement("br");
                    
                    this.appBodyElement.appendChild(pageBreak);
                    
                    return pageBreak;
                },
                
                addButton: function(buttonName, buttonOnClickFunction)
                {
                    var button = document.createElement("BUTTON");
                    
                    button.appendChild(document.createTextNode(buttonName));
                    button.onclick = buttonOnClickFunction;
                    this.appBodyElement.appendChild(button);
                    
                    return button;
                },
                
                addDiv: function(divInnerHTML)
                {
                    var div = document.createElement("DIV");
                    
                    div.innerHTML = divInnerHTML;
                    this.appBodyElement.appendChild(div);
                    
                    return div;
                },
                
                addTextInput: function(textFieldName)
                {
                    this.appBodyElement.appendChild(document.createTextNode(textFieldName));
                    
                    var textInput = document.createElement("INPUT");
                    textInput.setAttribute("type", "TEXT");
                    textInput.setAttribute("name", textFieldName);
                    textInput.appendChild(document.createTextNode(textFieldName));
                    this.appBodyElement.appendChild(textInput);
                    
                    return textInput;
                },
                
                addPasswordInput: function(passwordFieldName)
                {
                    this.appBodyElement.appendChild(document.createTextNode(passwordFieldName));
                    
                    var passwordInput = document.createElement("INPUT");
                    passwordInput.setAttribute("type", "PASSWORD");
                    this.appBodyElement.appendChild(passwordInput);
                    
                    return passwordInput;
                },
                
                clearContent: function(contextDescription)
                {
                    logEvent("SANDBOX", "ClearAppBody", contextDescription);
                    this.appBodyElement.innerHTML = "";
                }
            };
            
            return appBody;
        },
        
        // -----------------------
        // SERVICES
        // -----------------------
        getUserService: function()
        {
            return core.getServiceById(getUserServiceName());
        },
        
        getBookService: function ()
        {
            return core.getServiceById(getBookServiceName());
        },
    
        getQuoteService: function()
        {
            return core.getServiceById(getQuoteServiceName());
        },
    };
};
