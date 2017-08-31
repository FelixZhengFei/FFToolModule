//
//  UIImage+Rotation.m
//  PerfectImageCropper
//
//  Created by Jin Huang on 5/29/13.
//  Copyright (c) 2013 Jin Huang. All rights reserved.
//

#import "UIImage+Rotation.h"
#import <math.h>
CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
CGFloat RadiansToDegrees(CGFloat radians) {return radians * 180/M_PI;};

@implementation UIImage (Rotation)

- (UIImage *)imageRotatedByRadians:(CGFloat)radians
{
    return [self imageRotatedByDegrees:RadiansToDegrees(radians)];
}

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees
{
    CGFloat width=self.size.width;
    CGFloat heigth=self.size.height;
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    if(width<heigth)
    {
        rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,heigth, width)];
    }
    
    CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(bitmap, DegreesToRadians(degrees));
    
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    
    UIImage *resImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resImage;
}


- (UIImage *)imageResizeToSize:(CGSize)targetSize {
    @autoreleasepool {
        UIImage *sourceImage = self;
        CGFloat targetSizeWidth = targetSize.width;
        UIImage *newImage = nil;
        CGSize imageSize = sourceImage.size;
        CGFloat sourceImageWidth = imageSize.width;//原图－宽
        CGFloat sourceImageHeight = imageSize.height;//原图－长
        
        CGFloat newImageWidth = sourceImageWidth;//裁剪后图片－宽
        CGFloat newImageHeight = sourceImageHeight;//裁剪后图片－宽
        NSLog(@"原始图片尺寸===(%f,%f)", sourceImageWidth,sourceImageHeight);

        if (sourceImageWidth <= targetSizeWidth) {
            if (newImageHeight <= targetSizeWidth) {
                NSLog(@"裁剪后====%@", NSStringFromCGSize( CGSizeMake(newImageWidth, newImageHeight)));

                return sourceImage;
            } else { // 长 > targetSizeWidth
                CGFloat rateValue = sourceImageHeight / sourceImageWidth;//    长:宽 比
                if (rateValue > 2) {//大长图
                    NSLog(@"裁剪后====%@", NSStringFromCGSize( CGSizeMake(newImageWidth, newImageHeight)));
                    return sourceImage;
                } else {
                    newImageHeight = targetSizeWidth;
                    newImageWidth = targetSizeWidth / rateValue;
                }
            }
        } else {
            CGFloat rateValue = sourceImageWidth / sourceImageHeight;//    宽:长 比
            
            if (sourceImageHeight <= targetSizeWidth) {//正常图片
                if (rateValue <= 2) {
                    newImageWidth = targetSizeWidth;
                    newImageHeight = targetSizeWidth / rateValue;
                } else {//大宽图
                    NSLog(@"裁剪后====%@", NSStringFromCGSize( CGSizeMake(newImageWidth, newImageHeight)));
                    return sourceImage;
                }
            } else {//大图如 2000*1800
                if (rateValue <= 2) {
                    if (rateValue >= 1){
                        newImageWidth = targetSizeWidth;
                        newImageHeight = targetSizeWidth / rateValue;
                    } else {
                        newImageHeight= targetSizeWidth;
                        newImageWidth = targetSizeWidth* rateValue;
                    }
                } else {//大宽图
                    newImageHeight = targetSizeWidth;
                    newImageWidth = targetSizeWidth* rateValue;
                }
            }
        }
        CGSize resultSize = CGSizeMake(newImageWidth, newImageHeight);
        NSLog(@"裁剪后====%@", NSStringFromCGSize(resultSize));
        UIGraphicsBeginImageContextWithOptions(resultSize, NO, 1);
        [self drawInRect:CGRectMake(0, 0, resultSize.width, resultSize.height)];
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    }
}

- (CGFloat )getImageDataNeedComplessScale:(CGFloat)imageLength {
    CGFloat imageSize = imageLength/1024;
    if (imageSize<=200) {
        return 1.0;
    } else if (imageSize>200 && imageSize<=500) {
        return 0.9;
    } else if (imageSize>500 && imageSize<=1000) {
        return 0.8;
    } else if (imageSize>1000 && imageSize<=1500) {
        return 0.75;
    } else if (imageSize>1500 && imageSize<=2000) {
        return 0.7;
    } else if (imageSize>2000 && imageSize<=2500) {
        return 0.6;
    } else if (imageSize>2500 && imageSize<=3000) {
        return 0.5;
    } else if (imageSize>3000 && imageSize<=3500) {
        return 0.4;
    } else if (imageSize>3500 && imageSize<=4000) {
        return 0.3;
    } else if (imageSize>4000 && imageSize<=5000) {
        return 0.2;
    } else if (imageSize>5000 && imageSize<=6000) {
        return 0.1;
    } else if (imageSize>7000) {
        return 0.1;
    } else{
        return 1.0;
    }
}

//防止图片旋转90度
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

+ (CGSize )imageResizeToSizeForOneSiglerImageInCell:(CGSize)imageSize needSize:(CGFloat)needwidth {
//    if (imageSize.height ==0) {
//        return CGSizeMake(needwidth, needwidth);
//    }
    if (imageSize.width <=needwidth && imageSize.height <= needwidth) {
        return imageSize;
    }
    
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth =needwidth;
    CGFloat scaledHeight = needwidth;
    if (width > height) {
        scaleFactor = scaledWidth/width;
    }else {
        scaleFactor = scaledHeight/height;
    }
    
    scaledWidth  = width * scaleFactor;
    scaledHeight = height * scaleFactor;
    
    CGSize newSize = CGSizeMake(scaledWidth, scaledHeight);
    
    return newSize;
}


+ (CGSize )imageResizeForDongTaiOneImage:(CGSize)imageSize needSize:(CGFloat)needwidth {
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth;
    scaleFactor = width/height;
    scaledWidth  = needwidth * scaleFactor;
    CGSize newSize = CGSizeMake(scaledWidth, needwidth);
    return newSize;
}

+ (UIImage *) createRoundedRectImage:(UIImage*)image size:(CGSize)size
{
    @autoreleasepool
    {
        // the size of CGContextRef
        int w = size.width;
        int h = size.height;
        
        UIImage *img = image;
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
        CGRect rect = CGRectMake(0, 0, w, h);
        
        CGContextBeginPath(context);
        addRoundedRectToPath(context, rect, 10, 10);
        CGContextClosePath(context);
        CGContextClip(context);
        CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
        CGImageRef imageMasked = CGBitmapContextCreateImage(context);
        CGContextRelease(context);
        CGColorSpaceRelease(colorSpace);
        return [UIImage imageWithCGImage:imageMasked];
    }
}

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
                                 float ovalHeight)
{   @autoreleasepool
    {
        float fw, fh;
        if (ovalWidth == 0 || ovalHeight == 0) {
            CGContextAddRect(context, rect);
            return;
        }
        
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
        CGContextScaleCTM(context, ovalWidth, ovalHeight);
        fw = CGRectGetWidth(rect) / ovalWidth;
        fh = CGRectGetHeight(rect) / ovalHeight;
        
        CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
        CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
        CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
        CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
        CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
        
        CGContextClosePath(context);
        CGContextRestoreGState(context);
    }
}

+ (id)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r
{
    int w = size.width;
    int h = size.height;
    
    UIImage *img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    //CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, r, r);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    img = [UIImage imageWithCGImage:imageMasked];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageMasked);
    
    return img;
}


+ (UIImageView*)getParameterCreateLabBgImage:(NSString *)_strContent strFont:(UIFont *)_strFont {
    
    NSString *strTrimSpaceName = [_strContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    CGSize sizeLabel = [strTrimSpaceName sizeWithAttributes:@{NSFontAttributeName: _strFont}];
    CGSize sizeRealLabel = CGSizeMake(sizeLabel.width + 10, sizeLabel.height + 10);
    CGRect backRect = CGRectMake(0,0,sizeRealLabel.width+2, sizeRealLabel.height+2);
    CGRect frontRect = CGRectMake(1,1,sizeRealLabel.width, sizeRealLabel.height);
    
//    UILabel *backLab = [[UILabel alloc] init];
//    [backLab.layer setMasksToBounds:YES];
//    [backLab.layer setCornerRadius:sizeRealLabel.height / 2.0];
//    [backLab setFrame:backRect];
    
    UILabel *frontLab = [[UILabel alloc] init];
    [frontLab.layer setMasksToBounds:YES];
    [frontLab.layer setCornerRadius:2];
    [frontLab setFrame:frontRect];
    
    UILabel *textLab = [[UILabel alloc] init];
    [textLab.layer setMasksToBounds:YES];
    [textLab.layer setCornerRadius:2];
    [textLab setFrame:frontRect];
    [textLab setTextAlignment:NSTextAlignmentCenter];
    [textLab setBackgroundColor:[UIColor clearColor]];
    [textLab setText:strTrimSpaceName];
    [textLab setFont:_strFont];
    [textLab setTextColor:[UIColor whiteColor]];
    
    UIImageView *tempImage = [[UIImageView alloc] initWithFrame:backRect];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat red2[4] = {70.0/255.0, 197.0/255.0, 187.0/255.0, 1};
    CGFloat green2[4] = {70.0/255.0, 197.0/255.0, 187.0/255.0, 1};
    CGFloat blue2[4] = {70.0/255.0, 197.0/255.0, 187.0/255.0, 1};
    
    CGColorRef red3 = CGColorCreate(colorSpace, red2);
    CGColorRef green3 = CGColorCreate(colorSpace, green2);
    CGColorRef blue3 = CGColorCreate(colorSpace, blue2);
    
    NSArray *colors2 = [NSArray arrayWithObjects:(__bridge id) red3, (__bridge id) green3, (__bridge id) blue3,nil];
    CAGradientLayer *_gradientFontLayer2 = [CAGradientLayer layer];
    _gradientFontLayer2.colors = colors2;
    _gradientFontLayer2.locations = [NSArray arrayWithObjects:
                                     [NSNumber numberWithFloat:1.0],
                                     [NSNumber numberWithFloat:0.4],
                                     [NSNumber numberWithFloat:0.9],
                                     nil];
    [_gradientFontLayer2 setMasksToBounds:YES];
    [_gradientFontLayer2 setCornerRadius:4];
    [_gradientFontLayer2 setFrame:frontLab.layer.frame];
    [tempImage.layer addSublayer:_gradientFontLayer2];
    [tempImage addSubview:textLab];
    return tempImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); return image;
}

@end;
