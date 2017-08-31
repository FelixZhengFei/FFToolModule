//
//  UICalculationTool.h
//  Vibin
//
//  Created by Sherlock on 12/19/13.
//  Copyright (c) 2013 Originate China. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICalculationTool : NSObject

+ (CGFloat)calculateTextViewContentHeight:(UITextView *)textView text:(NSString *)text font:(UIFont *)font;
+ (CGFloat)calculateTextViewContentHeight:(UITextView *)textView;
+ (CGFloat)calculateStringWidth:(NSString *)string withFont:(UIFont *)font;
+ (CGFloat)calculateStringHeight:(NSString *)string withFont:(UIFont *)font maxWidth:(CGFloat)bubbleMaxWidth;

@end
