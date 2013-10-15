var kDocumentManagerName = "manager-document";

var createDocumentManagerFunction = function(core)
{
    var manager = new Manager(kDocumentManagerName, core);
    
    manager.getAppHeader = function()
    {
        var appHeader = {
            configureTitle: function(titleText)
            {
                var title = document.getElementById("appHeader_title");
                title.innerHTML = titleText;
            },
            
            clearRightButton: function()
            {
                var rightButton = document.getElementById("appHeader_rightButton");
                rightButton.style.visibility="hidden";
            },
            
            configureRightButton: function(buttonText, buttonFunction)
            {
                var rightButton = document.getElementById("appHeader_rightButton");
                rightButton.innerHTML = "";
                rightButton.appendChild(document.createTextNode(buttonText));
                rightButton.onclick = buttonFunction;
                rightButton.style.visibility="visible";
            },

            clearLeftButton: function()
            {
                var leftButton = document.getElementById("appHeader_leftButton");
                leftButton.style.visibility="hidden";
            },
            
            configureLeftButton: function(buttonText, buttonFunction)
            {
                var leftButton = document.getElementById("appHeader_leftButton");
                leftButton.innerHTML = "";
                leftButton.appendChild(document.createTextNode(buttonText));
                leftButton.onclick = buttonFunction;
                leftButton.style.visibility="visible";
            },
            
            clearConfiguration: function()
            {
                this.configureTitle("");
                this.clearRightButton();
                this.clearLeftButton();
            }
        };
        
        return appHeader;
    };
    
    manager.getAppBody = function()
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
    };
    
    return manager;
};

app.core.registerManager(kDocumentManagerName, createDocumentManagerFunction);
