
#import <UIKit/UIKit.h>

@class HistogramViewController;

@interface HistogramAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    HistogramViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet HistogramViewController *viewController;

@end

