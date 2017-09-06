//
//  UITextView+FFPlaceHolder.h
//  FFToolModule
//
//  Created by 郑强飞 on 2017/8/12.
//  Copyright © 2017年 郑强飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (FFPlaceHolder)

/** placeHolder
 文本
 */
@property (nonatomic, copy) NSString *ff_placeHolder;

/** placeHolderColor 
 颜色
 */
@property (nonatomic, strong) UIColor *ff_placeHolderColor;

/** placeHolderLabel
 
 */
@property (nonatomic, readonly) UILabel *ff_placeHolderLabel;

@end
