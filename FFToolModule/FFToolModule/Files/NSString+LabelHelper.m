//
//  NSString+LabelHelper.m
//  guanxinApp
//
//  Created by  郑强飞 on 14-10-29.
//  Copyright (c) 2014年 Zhenwei. All rights reserved.
//

#import "NSString+LabelHelper.h"

@implementation NSString (LabelHelper)



// 正则判断手机号码地址格式
+ (BOOL)isMobileNumberForPhone:(NSString *)mobileNum {
    if (mobileNum == nil|| [mobileNum length]==0) {
        return YES;
    }
    /**
     * 手机号码
     * 移动：134[0-8],135,136,183,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^((13[0-9])|(15[^4,\\D])|(18[0-9])|(17[6-8])|(14[5,7]))\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))     {
        return YES;
    } else {
        return NO;
    }
}

+(BOOL)isCardNumber:(NSString *)cardNumber{
        NSString *emailRegex = @"^((([0-9]{10}(0?[1-9]|1[0-2])((0?[1-9])|((1|2)[0-9])|30|31)[X0-9]{1}))|([0-9]{10}(0?[1-9]|1[0-2])((0?[1-9])|((1|2)[0-9])|30|31)[0-9]{3}[X0-9]{1}))$";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        return [emailTest evaluateWithObject:cardNumber];
}


+ (BOOL)isNULLOrEmpty:(NSString *)string {
    if ([@"" isEqual:string] ||[@" " isEqual:string] || string == nil || [string isEqual:@"(null)"] ||[string isEqual:@"<null>"] || [string isEqual:[NSNull null]]) {
        return YES;
        }
    return NO;
}
@end
