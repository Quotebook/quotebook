#import "Utilities.h"
#import <objc/runtime.h>
#import "ViewManager.h"

NSDateFormatter* dateFormatter = nil;

@implementation Util

+ (NSArray*)allClassesWithSuperClass:(Class)superClass
{
    NSMutableArray* matchingClasses = [[[NSMutableArray alloc] init] autorelease];
    
    unsigned int numClasses = objc_getClassList(NULL, 0);

    Class* classes = malloc(sizeof(Class) * numClasses);
    numClasses = objc_getClassList(classes, numClasses);

    for (int i = 0; i < numClasses; ++i)
    {
        Class currentClass = classes[i];
        
        do
        {
            currentClass = class_getSuperclass(currentClass);
            
            if (currentClass == superClass)
            {
                [matchingClasses addObject:classes[i]];
                break;
            }
        }
        while (currentClass != nil);
    }
    
    return matchingClasses;
}

+ (NSString*)formatedDate:(NSDate *)date
{
    if (dateFormatter == nil)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
//        [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [dateFormatter setDateFormat:@"EEEE hh:mm a 'on' MM/dd/yyyy"];
    }

    return [dateFormatter stringFromDate:date];
}

@end
