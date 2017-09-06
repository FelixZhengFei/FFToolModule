//
//  FFMultiColorLoader.h
//  FFToolModule
//
//  Created by  郑强飞 on 14/12/15.
//  Copyright (c) 2014年 Zhenwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFMultiColorLoader : UIView

/**
 * Array of UIColor
 */
@property (nonatomic, strong) NSArray *colorArray;

/**
 * lineWidth of the stroke
 */
@property (nonatomic) CGFloat lineWidth;

- (void)startAnimation;
- (void)stopAnimation;
- (void)stopAnimationAfter:(NSTimeInterval)timeInterval;
- (BOOL)isAnimating;

@end
