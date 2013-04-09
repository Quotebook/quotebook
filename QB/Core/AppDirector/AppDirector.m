#import "AppDirector.h"
#import "Manager.h"
#import "Base.h"
#import "ViewManager.h"

@interface AppDirector ()
{
    CADisplayLink* displayLink;
}

@property (nonatomic, retain) NSDictionary* managersByClass;
@property (nonatomic, retain) ViewManager* viewManager;
@property (nonatomic, assign) BOOL shouldReload;

@end


@implementation AppDirector

- (void)dealloc
{
    [AppDirector releaseRetainedPropertiesOfObject:self];
    [super dealloc];
}

- (void)configure
{
    [self internal_setupManagers];
    
    [self injectManagersIntoIVars:self];
}

- (void)stopRunning
{
    if (displayLink)
    {
        [displayLink invalidate];
        displayLink = nil;
    }
}

- (void)beginRunning
{
    self.shouldReload = YES;
    
    [self internal_performNextFrame];

    if (displayLink == nil)
    {
        displayLink = [[UIScreen mainScreen] displayLinkWithTarget:self selector:@selector(internal_performNextFrame)];
        [displayLink setFrameInterval:2]; // 1 - 60fps, 2 - 30fps, etc.
        [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
}

- (void)internal_performNextFrame
{
    if (_shouldReload)
    {
        for (Manager* manager in _managersByClass.allValues)
        {
            [manager unload];
        }
        for (Manager* manager in _managersByClass.allValues)
        {
            [manager load];
        }
        
        self.shouldReload = NO;
    }
    
    for (Manager* manager in _managersByClass.allValues)
    {
        [manager update];
    }
    
}

- (void)internal_setupManagers
{
    NSArray* managerClasses = [Util allClassesWithSuperClass:Manager.class];
    
    NSMutableDictionary* managersByClass = [NSMutableDictionary object];
    
    for (Class managerClass in managerClasses)
    {
        Manager* manager = [managerClass object];
        
        manager.director = self;
        
        [managersByClass setObject:manager
                            forKey:NSStringFromClass([manager class])];
    }
    
    self.managersByClass = managersByClass;
    
	for (Manager* manager in _managersByClass.allValues)
    {
		[self injectManagersIntoIVars:manager];
    }
}

- (void)injectManagersIntoIVars:(id)injectee
{
    Class injecteeClass = [injectee class];
    while (injecteeClass &&
           injecteeClass != [NSObject class])
    {
        unsigned int ivarListCount = 0;
        Ivar* ivarList = class_copyIvarList(injecteeClass, &ivarListCount);
		
        for (int i = 0; i < ivarListCount; i++)
        {
			Class ivarClass = [NSObject classForIvar:ivarList[i]];
            
			if (ivarClass != nil)
			{
				id registeredManager = [_managersByClass objectForKey:NSStringFromClass(ivarClass)];
				
				if (registeredManager != nil)
				{
					object_setIvar(injectee, ivarList[i], registeredManager);
				}
			}
        }
        
        free(ivarList);
        injecteeClass = [injecteeClass superclass];
    }
}

- (id)managerForClass:(Class)managerClass
{
    return _managersByClass[NSStringFromClass(managerClass)];
}

@end
