
#import "HistogramViewController.h"
#import "CGUtils.h"

@implementation HistogramViewController


// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
    }
    return self;
}

- (void)dealloc {
	[super dealloc];
}


- (void)viewDidLoad
{
	[super viewDidLoad];
	canvas = [[CanvasView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 460.0)];
	[self.view addSubview:canvas];
}


//--------------------------------------------------------------- アクションシートを表示
- (IBAction) showCameraSheet
{	
	if( TARGET_IPHONE_SIMULATOR )
	{
		[self actionSheet:nil clickedButtonAtIndex:0];
	}else{
		[self actionSheet:nil clickedButtonAtIndex:1];
	}
}

- (IBAction)showSaveSheet
{
	saveSheet = [[[UIActionSheet alloc] init] autorelease];
	[saveSheet setDelegate:self];
	//[saveSheet addButtonWithTitle:@"Save to Photo Album"];
	//[saveSheet addButtonWithTitle:@"Export to Twitter"];
	[saveSheet addButtonWithTitle: NSLocalizedString(@"Send Email", nil)];
	[saveSheet addButtonWithTitle: NSLocalizedString(@"Cancel", nil)];
	[saveSheet setCancelButtonIndex:1];
	[saveSheet showInView:[self view]];
}

//--------------------------------------------------------------- モードを選択
- (void) actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if( actionSheet == nil )
	{
		UIImagePickerControllerSourceType sourceType;
		switch (buttonIndex)
		{
			case 0:
				sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
				break;
			case 1:
				sourceType = UIImagePickerControllerSourceTypeCamera;
				break;
			case 2:
				sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
			default:
				sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
				break;
		}
		if( ![UIImagePickerController isSourceTypeAvailable:sourceType] ) return;
		
		UIImagePickerController *imagePicker = [[[UIImagePickerController alloc] init] autorelease];
		[imagePicker setSourceType:sourceType];
		[imagePicker setAllowsEditing:NO];//
		[imagePicker setDelegate:self];
		
		[self	presentModalViewController:imagePicker animated:YES];
	}
}

//--------------------------------------------------------------- イメージを取り込む
- (void) imagePickerController:(UIImagePickerController*)picker didFinishPickingImage:(UIImage*)image editingInfo:(NSDictionary*)editingInfo
{
	//ピッカーを隠す
	[self dismissModalViewControllerAnimated:YES];
	CGImageRef originalImage = image.CGImage;
	[canvas startProcessing:originalImage withOrientation:image.imageOrientation];////
}


@end
