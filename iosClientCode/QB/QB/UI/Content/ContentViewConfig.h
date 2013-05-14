#import "QB.h"

typedef enum
{
    ContentConfigAlignmentNone = -1,
    ContentConfigAlignmentLeft = NSTextAlignmentLeft,
    ContentConfigAlignmentRight = NSTextAlignmentRight,
    ContentConfigAlignmentCenter = NSTextAlignmentCenter
} ContentConfigAlignment;

typedef enum
{
    ContentConfigFontNormal = 0,
    ContentConfigFontBold,
    ContentConfigFontItalic,
    ContentConfigFontBoldItalic
} ContentConfigFont;

@interface ContentViewConfig : ManagedPropertiesObject
@property (nonatomic, retain) NSMutableArray* contentItemConfigs;
@property (nonatomic, assign) int initialSpacerHeight;
@end

@interface ContentScrollViewConfig : ManagedPropertiesObject
@property (nonatomic, retain) NSMutableArray* contentViewConfigs;
@property (nonatomic, assign) BOOL enablePaging;
@property (nonatomic, assign) BOOL enableLooping;
@property (nonatomic, assign) BOOL enableScrolling;
@property (nonatomic, assign) BOOL enableVerticalScrolling;
@property (nonatomic, assign) int indexToFocus;
@end

@interface ContentItemConfig : ManagedPropertiesObject
@property (nonatomic, assign) int additionalViewHeight;
@end

@interface ContentItemConfigToAdd : ManagedPropertiesObject
@property (nonatomic, retain) ContentItemConfig* contentItemConfig;
@property (nonatomic, assign) int index;
@end


