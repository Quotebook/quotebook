////
////var Event = function()
////{
////    return
////    {
////        callbacks: [],
////            
////        addCallback: function(callback, object)
////        {
////            var callback =
////            {
////                callbackObject: object,
////                callbackFunction: callback,
////                
////                execute: function(eventData)
////                {
////                    callbackObject.callbackFunction(eventData);
////                }
////            };
////            
////            callbacks.push(callback);
////        },
////        
////        executeCallbacks: function(eventData)
////        {
////            for (callback in callbacks)
////            {
////                callback.execute(eventData);
////            }
////        },
////        
////        removeCallbacksForObject(object)
////        {
////            for (var i = callbacks.length() - 1; i >= 0; --i)
////            {
////                if (callbacks[i].callbackObject == object)
////                {
////                    callbacks.splice(i, 1);
////                }
////            }
////        }
////    };
////};
//
//var Sandbox = function ()
//{
////    // Needs to be shared data
////    var boundEventsByEventType = {};
////    
////    return
////    {
////        // Functions
////        postEvent: function(eventData)
////        {
////            boundEventsByEventType[eventData.type].executeCallbacks(eventData);
////        },
////        
////        bindEventsForListener: function(eventTypeList, eventCallback, listener)
////        {
////            for (eventType in eventTypeList)
////            {
////                var event = eventListeners[eventType];
////                
////                if (event == null)
////                {
////                    event = new Event();
////                    
////                    eventListeners[eventType] = event;
////                }
////                
////                event.addCallback(eventCallback, listener);
////            }
////        },
////        
////        unbindAllEventsForListener: function(listener)
////        {
////            for (eventType in boundEventsByEventType)
////            {
////                var event = boundEventsByEventType[eventType];
////                
////                event.removeCallbacksForObject(listener);
////            }
////        },
////        
////        unbindEventsForListener: function(eventTypeList, listener)
////        {
////            for (eventType in eventTypeList)
////            {
////                boundEventCallbacksByEventType[eventType].removeCallbacksForObject(listener);
////            }
////        }
////    };
//};
