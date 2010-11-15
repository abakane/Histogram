
#import "CanvasView.h"
#import "CGUtils.h"

#define AX 32.0
#define AY 450.0
#if TARGET_IPHONE_SIMULATOR
#define LOOP 120.0
#else
#define LOOP 40.0
#endif


@implementation CanvasView

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
			[self setBackgroundColor:[UIColor blackColor]];
			context = [CGUtils getCGContext:frame.size];//
			CGContextSetRGBFillColor(context, 0.2, 0.2, 0.2, 1.0);
			CGContextFillRect( context, CGRectMake(AX, 10, 255.0, 440));
			
			timerInterval = 1.0/LOOP;
    }
    return self;
}

- (void)dealloc
{
	[super dealloc];
}



//--------------------------------------------------------------- 描画
- (void)drawRect:(CGRect)rect
{
	CGContextRef currentContext = UIGraphicsGetCurrentContext();
	CGImageRef _image = CGBitmapContextCreateImage(context);
	CGContextDrawImage(currentContext, CGRectMake(0, 0, rect.size.width, rect.size.height), _image);
	CGImageRelease(_image);
}


//--------------------------------------------------------------- 処理開始
- (void) startProcessing:(CGImageRef)image withOrientation:(UIImageOrientation)orientation
{
	NSLog(@"CanvasView startProcessing ---------------------");
	resizedImage = [CGUtils getResizeCGImage:image withOrientation:orientation fromRect:CGRectMake(0.0, 0.0, CGImageGetWidth(image), CGImageGetHeight(image)) toSize:CGSizeMake(500.0, 500.0)];
	CGImageRetain(resizedImage);
	
	endBool = NO;
	d = 0.15;
	_x = 0;
	_y = 0;
	_w = CGImageGetWidth(resizedImage);
	_h = CGImageGetHeight(resizedImage);
	bitsPerComponent = CGImageGetBitsPerComponent(resizedImage);
	bitsPerPixel = CGImageGetBitsPerPixel(resizedImage);
	bytesPerRow = CGImageGetBytesPerRow(resizedImage);
	colorSpace = CGImageGetColorSpace(resizedImage);
	bitmapInfo = CGImageGetBitmapInfo(resizedImage);
	shouldInterpolate = CGImageGetShouldInterpolate(resizedImage);
	intent = CGImageGetRenderingIntent(resizedImage);
	dataProvider = CGImageGetDataProvider(resizedImage);
	data = CGDataProviderCopyData(dataProvider);
	buffer = (UInt8*)CFDataGetBytePtr(data);
	
	ary = [[NSMutableArray alloc] init];
	for(int i=0; i<256; i++)
	{
		[ary addObject:[NSNumber numberWithInt:0]];
	}
	timer = [NSTimer scheduledTimerWithTimeInterval:timerInterval target:self selector:@selector(update) userInfo:nil repeats:YES];
}


//--------------------------------------------------------------- アップデート
- (void)update
{
	for(int i=0; i<100; i++)
	{
		if(endBool)return;//
		UInt8 *t = buffer + _y*bytesPerRow + _x*4;
		Float32 r = *(t+2);
		Float32 g = *(t+1);
		Float32 b = *(t+0);
		int y = (int)(r*0.299+g*0.587+b*0.114);
		int p;
		[[ary objectAtIndex:y] getValue:&p];
		[ary replaceObjectAtIndex:y withObject:[NSNumber numberWithInt:++p]];
		
		CGContextSetRGBFillColor(context, r/256.0, g/256.0, b/256.0, 1.0);
		CGContextFillRect(context, CGRectMake(AX+y, AY-p*d, 1.0, 1.0));
		[self setNeedsDisplay];
		
		*(t+2) = *(t+1) = *(t+0) = y;
		
		if( ++_x >= _w )
		{
			_x = 0;
			if( ++_y >= _h )
			{
				NSLog(@"finished");
				CFDataRef resultData = CFDataCreate(NULL, buffer, CFDataGetLength(data) );
				CGDataProviderRef resultDataProvider = CGDataProviderCreateWithCFData(resultData);
				const CGFloat decode[] = {
					0.0, 1.0,
					0.0, 1.0,
					0.0, 1.0,
					0.0, 0.7
				};
				resizedImage = CGImageCreate( _w, _h, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpace, bitmapInfo, resultDataProvider, decode, shouldInterpolate, intent);
				CGContextDrawImage(context, CGRectMake(AX, 10.0, 255.0, 255.0), resizedImage);
				CGImageRelease(resizedImage);
				CFRelease(data);
				CFRelease(dataProvider);
				endBool = YES;
			}
		}
		
	}
}

@end
