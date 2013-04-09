#import "Base.h"

@class Manager;

@interface AppDirector : NSObject

- (void)configure;

- (void)stopRunning;

- (void)beginRunning;

- (void)injectManagersIntoIVars:(id)injectee;

- (id)managerForClass:(Class)managerClass;

@end
