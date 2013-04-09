#import "QB.h"

@interface QBViewDirector : UIViewController

@property (nonatomic, retain) IBOutlet ViewLayer* defaultViewLayer;
@property (nonatomic, retain) IBOutlet ViewLayer* statusViewLayer;
@property (nonatomic, retain) IBOutlet ViewLayer* popupViewLayer;
@property (nonatomic, retain) IBOutlet ViewLayer* loadingViewLayer;

@end
