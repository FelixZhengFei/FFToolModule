//
//  UICalculationTool.m
//  Vibin
//
//  Created by Sherlock on 12/19/13.
//  Copyright (c) 2013 Originate China. All rights reserved.
//

#import "UICalculationTool.h"

@implementation UICalculationTool

+ (CGFloat)calculateTextViewContentHeight:(UITextView *)textView {
  return [self calculateTextViewContentHeight:textView text:textView.text font:textView.font];
}

+ (CGFloat)calculateTextViewContentHeight:(UITextView *)textView text:(NSString *)text font:(UIFont *)font {
  CGRect frame = textView.bounds;
  
  // Take account of the padding added around the text.
  UIEdgeInsets contentInsets = textView.contentInset;
  frame.size.width -= contentInsets.left + contentInsets.right;
  frame.size.height -= contentInsets.top + contentInsets.bottom;
  

    UIEdgeInsets textContainerInsets = textView.textContainerInset;
    CGFloat leftRightPadding = textContainerInsets.left + textContainerInsets.right + textView.textContainer.lineFragmentPadding * 2;
    CGFloat topBottomPadding = textContainerInsets.top + textContainerInsets.bottom;
    
    frame.size.width -= leftRightPadding;
    frame.size.height -= topBottomPadding;
  
  
  NSString *textToMeasure = text;
  if ([textToMeasure hasSuffix:@"\n"]) {
    textToMeasure = [NSString stringWithFormat:@"%@-", text];
  }
  
  NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
  [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
  
  NSDictionary *attributes = @{ NSFontAttributeName:font, NSParagraphStyleAttributeName : paragraphStyle };
  

    CGRect size = [textToMeasure boundingRectWithSize:CGSizeMake(CGRectGetWidth(frame), MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attributes
                                              context:nil];
    return ceilf(CGRectGetHeight(size));
  
}


+ (CGFloat)calculateStringWidth:(NSString *)string withFont:(UIFont *)font {
  CGFloat stringWidth;
    stringWidth = [string sizeWithAttributes:@{NSFontAttributeName:font}].width;  
  return ceilf(stringWidth);
}

+ (CGFloat)calculateStringHeight:(NSString *)string withFont:(UIFont *)font maxWidth:(CGFloat)bubbleMaxWidth{
  CGSize  retSize = [string boundingRectWithSize:CGSizeMake(bubbleMaxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
    return retSize.height;
}


@end
