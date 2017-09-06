//
//  UITextView+FFLimitCounter.h
//  FFToolModule
//
//  Created by 郑强飞 on 2017/8/12.
//  Copyright © 2017年 郑强飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (FFLimitCounter)

/** 限制字数*/
@property (nonatomic, assign) NSInteger ff_limitCount;

/** lab的右边距(默认10)*/
@property (nonatomic, assign) CGFloat ff_labMargin;

/** lab的高度(默认20)*/
@property (nonatomic, assign) CGFloat ff_labHeight;

/** 统计限制字数Label*/
@property (nonatomic, readonly) UILabel *ff_inputLimitLabel;

@end
