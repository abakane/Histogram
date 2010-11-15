
#import <Foundation/Foundation.h>


@interface CGUtils : NSObject
{
}
+ (CGImageRef) getResizeCGImage:(CGImageRef)image withOrientation:(UIImageOrientation)orientation fromRect:(CGRect)rect toSize:(CGSize)size;
+ (CGContextRef) getCGContext:(CGSize)aSize;
@end