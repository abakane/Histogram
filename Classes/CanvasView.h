
#import <UIKit/UIKit.h>


@interface CanvasView : UIView
{
	CGContextRef context;
	CGImageRef resizedImage;
	NSTimer *timer;
	NSTimeInterval timerInterval;
	
	size_t bitsPerComponent;
	size_t bitsPerPixel;
	size_t bytesPerRow;
	CGColorSpaceRef colorSpace;
	CGBitmapInfo bitmapInfo;
	bool shouldInterpolate;
	CGColorRenderingIntent intent;
	CGDataProviderRef dataProvider;
	CFDataRef data;
	UInt8* buffer;
	int _w;
	int _h;
	int _x;
	int _y;
	BOOL endBool;
	CGFloat d;
	
	NSMutableArray *ary;
}

- (void)startProcessing:(CGImageRef)image withOrientation:(UIImageOrientation)orientation;
- (void)update;


@end
