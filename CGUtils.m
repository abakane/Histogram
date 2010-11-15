
#import "CGUtils.h"

#define DEG2RAD M_PI/180.0

@implementation CGUtils

//--------------------------------------------------------------- CGImageRefをリサイズ
+ (CGImageRef) getResizeCGImage:(CGImageRef)image withOrientation:(UIImageOrientation)orientation fromRect:(CGRect)rect toSize:(CGSize)size
{
	NSLog(@"CGUtils getResizeCGImage---------------------");
	CGFloat w = CGImageGetWidth(image);
	CGFloat h = CGImageGetHeight(image);
	CGFloat tx = rect.origin.x;
	CGFloat ty = rect.origin.y;
	
	CGAffineTransform transform = CGAffineTransformIdentity;
	
	CGFloat ratio = size.width/rect.size.width;
	
	switch(orientation)
	{
		case UIImageOrientationUp: //EXIF = 1
			NSLog(@"UP");
			transform = CGAffineTransformIdentity;
			break;
			
		case UIImageOrientationUpMirrored: //EXIF = 2
			NSLog(@"UP Mirrored");
			transform = CGAffineTransformMakeTranslation(w, 0.0);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			break;
			
		case UIImageOrientationDown: //EXIF = 3
			NSLog(@"DOWN");
			transform = CGAffineTransformMakeTranslation(w, h);
			transform = CGAffineTransformRotate(transform, 180.0*DEG2RAD);
			break;
			
		case UIImageOrientationDownMirrored: //EXIF = 4
			NSLog(@"DOWN Mirrored");
			transform = CGAffineTransformMakeTranslation(0.0, h);
			transform = CGAffineTransformScale(transform, 1.0, -1.0);
			break;
			
		case UIImageOrientationLeftMirrored: //EXIF = 5
			NSLog(@"LEFT Mirrored");
			transform = CGAffineTransformMakeTranslation(w, h);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			transform = CGAffineTransformRotate(transform, 270.0*DEG2RAD);
			break;
			
		case UIImageOrientationLeft: //EXIF = 6
			NSLog(@"LEFT");
			transform = CGAffineTransformMakeTranslation(0.0, w);
			transform = CGAffineTransformRotate(transform, 270.0*DEG2RAD);
			break;
			
		case UIImageOrientationRightMirrored: //EXIF = 7
			NSLog(@"RIGHT Mirrored");
			transform = CGAffineTransformMakeScale(-1.0, 1.0);
			transform = CGAffineTransformRotate(transform, 90.0*DEG2RAD);
			break;
			
		case UIImageOrientationRight: //EXIF = 8
			NSLog(@"RIGHT");
			transform = CGAffineTransformMakeTranslation(h, 0.0);
			transform = CGAffineTransformRotate(transform, 90.0*DEG2RAD);
			break;
			
		default:
			NSLog(@"NULL");
			[NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
	}
	
	CGContextRef tmpContext = [self getCGContext:size];
	
	if (orientation == UIImageOrientationRight || orientation == UIImageOrientationLeft)
	{
		CGContextScaleCTM(tmpContext, -ratio, ratio);
		CGContextTranslateCTM(tmpContext, -(h-tx), -ty);
	}
	else {
		CGContextScaleCTM(tmpContext, ratio, -ratio);
		CGContextTranslateCTM(tmpContext, -tx, -(h-ty));
	}
	
	CGContextConcatCTM(tmpContext, transform);
	
	CGContextDrawImage(tmpContext, CGRectMake( 0.0, 0.0, w, h), image);
	CGImageRef tmpImage = CGBitmapContextCreateImage(tmpContext);
	CGContextRelease(tmpContext);
	return tmpImage;
}

//--------------------------------------------------------------- CGContextRefを返す
+ (CGContextRef) getCGContext:(CGSize)aSize
{
	CGBitmapInfo bitmapInfo = kCGImageAlphaPremultipliedLast;
	//CGBitmapInfo bitmapInfo = kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Little;
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef cgContext = CGBitmapContextCreate(nil, aSize.width, aSize.height, 8, aSize.width*4, colorSpace, bitmapInfo);
	CGColorSpaceRelease(colorSpace);
	return cgContext;
}

+ (void) CGContextFillRoundRect:(CGContextRef)context withRect:(CGRect)rect withRadius:(CGFloat)radius
{
	CGContextMoveToPoint( context, CGRectGetMinX( rect ), CGRectGetMidY( rect ));
	CGContextAddArcToPoint( context, CGRectGetMinX( rect ), CGRectGetMinY( rect ), CGRectGetMidX( rect ), CGRectGetMinY( rect ), radius );
	CGContextAddArcToPoint( context, CGRectGetMaxX( rect ), CGRectGetMinY( rect ), CGRectGetMaxX( rect ), CGRectGetMidY( rect ), radius );
	CGContextAddArcToPoint( context, CGRectGetMaxX( rect ), CGRectGetMaxY( rect ), CGRectGetMidX( rect ), CGRectGetMaxY( rect ), radius );
	CGContextAddArcToPoint( context, CGRectGetMinX( rect ), CGRectGetMaxY( rect ), CGRectGetMinX( rect ), CGRectGetMidY( rect ), radius );
	CGContextClosePath( context );
	CGContextDrawPath( context, kCGPathFillStroke );
}


@end
