//
//  NSString+LabelHelper.h
//  guanxinApp
//
//  Created by  郑强飞 on 14-10-29.
//  Copyright (c) 2014年 Zhenwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LabelHelper)
+ (BOOL)isMobileNumberForPhone:(NSString *)mobileNum;
+ (BOOL)isNULLOrEmpty:(NSString *)string;
+(BOOL)isCardNumber:(NSString *)cardNumber;

@end
