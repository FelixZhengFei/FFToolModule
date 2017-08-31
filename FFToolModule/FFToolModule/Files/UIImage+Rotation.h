//
//  UIImage+Rotation.h
//  PerfectImageCropper
//
//  Created by Jin Huang on 5/29/13.
//  Copyright (c) 2013 Jin Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIImage (Rotation)

- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
+ (CGSize )imageResizeToSizeForOneSiglerImageInCell:(CGSize)imageSize needSize:(CGFloat)width;
+ (UIImage *) createRoundedRectImage:(UIImage*)image size:(CGSize)size;
+ (CGSize )imageResizeForDongTaiOneImage:(CGSize)imageSize needSize:(CGFloat)needwidth;
+ (id)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r;

//获取图片压缩系数
- (CGFloat )getImageDataNeedComplessScale:(CGFloat)imageLength;
- (UIImage *)imageResizeToSize:(CGSize)targetSize;

//个性标签
+ (UIImageView*)getParameterCreateLabBgImage:(NSString *)_strContent strFont:(UIFont *)_strFont;
+ (UIImage *)imageWithColor:(UIColor *)color;

//防止图片旋转90度
- (UIImage *)fixOrientation:(UIImage *)aImage;

@end
