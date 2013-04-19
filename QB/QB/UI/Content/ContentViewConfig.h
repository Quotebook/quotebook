#import "QB.h"

typedef enum
{
    ContentConfigAlignmentNone = -1,
    ContentConfigAlignmentLeft = NSTextAlignmentLeft,
    ContentConfigAlignmentRight = NSTextAlignmentRight,
    ContentConfigAlignmentCenter = NSTextAlignmentCenter
} ContentConfigAlignment;

@interface ContentViewConfig : ManagedPropertiesObject
@property (nonatomic, retain) NSMutableArray* viewConfigs;
@property (nonatomic, assign) int initialSpacerHeight;
@end

@interface ContentItemConfig : ManagedPropertiesObject
@property (nonatomic, assign) int additionalViewHeight;
@end

@interface ContentButtonConfig : ContentItemConfig
@property (nonatomic, retain) NSString* buttonTitle;
@property (nonatomic, copy) VoidBlock onTapBlock;
@end

@interface ContentLabelConfig : ContentItemConfig
@property (nonatomic, retain) NSString* labelText;
@property (nonatomic, assign) BOOL wordWrap;
@property (nonatomic, assign) ContentConfigAlignment alignment;
@end

@interface ContentTextFieldConfig : ContentItemConfig
@property (nonatomic, retain) NSString* labelText;
@property (nonatomic, retain) NSString* overrideFieldText;
@property (nonatomic, retain) NSString* defaultFieldText;
@property (nonatomic, assign) BOOL secureTextEntry;
@property (nonatomic, copy) void(^textBlock)(NSString*);
@end

@interface ContentDatePickerConfig : ContentItemConfig
@property (nonatomic, copy) void(^dateBlock)(NSDate*);
@property (nonatomic, retain) NSDate* defaultDate;
@end

@interface ContentItemConfigToAdd : ManagedPropertiesObject
@property (nonatomic, retain) ContentItemConfig* contentItemConfig;
@property (nonatomic, assign) int index;
@end

