
#import <UIKit/UIKit.h>
#import "CanvasView.h"

@interface HistogramViewController : UIViewController<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
	UIActionSheet *cameraSheet;
	UIActionSheet *saveSheet;
	CanvasView *canvas;
}

- (IBAction) showCameraSheet;
- (IBAction) showSaveSheet;
- (void) actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void) imagePickerController:(UIImagePickerController*)picker didFinishPickingImage:(UIImage*)image editingInfo:(NSDictionary*)editingInfo;

@end

