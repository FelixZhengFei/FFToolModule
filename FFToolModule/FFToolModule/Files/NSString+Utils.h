//
//  NSString+Utils.h
//  guanxin
//
//  Created by JeeRain 13-05-10.
//  Copyright (c) 2012年 左岸科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f)
#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
#define IS_IOS5 ([[[UIDevice currentDevice] systemVersion] floatValue] < 6.0f)

@interface NSString (Utils)

+ (NSString *)stringDateWithFormat:(NSString*)dateStr;
+ (NSDate *)dateFromString:(NSString *)dateString;
+ (NSString *)stringDateWithFormat:(NSString*)dateStr format:(NSString*)format;
+ (NSString *)stringDateWithYear:(NSString*)dateStr;

+ (NSTimeInterval)getNSTimeInterval:(NSString*)dateStr;

+ (NSDate *)dateFromString11:(NSString *)dateStr;
+(BOOL)isValidateHttpUrl:(NSString *)httpUrl;

+ (NSString *)getNowNSTimeInterval;
+ (NSString *)getNowNSTimeIntervalVideo;

+ (BOOL)isMobileNumber:(NSString*)mobileNum;

+ (BOOL)isValidateEmail:(NSString *)email;
+(NSString *)removeWhiteString:(NSString *)string;
+ (BOOL)isEmailAddress:(NSString *)aString;
+ (BOOL)isValidatePassword:(NSString*)mobileNum;
+ (NSString *)addHttpToUrlString:(NSString *)urlString;

//计算文本的字数
+ (NSUInteger)lenghtWithString:(NSString *)string;
//计算文本的限制文本长度leng
+ (NSUInteger)cacleLimitString:(NSString *)string withLimit:(NSInteger)limitCount;
+ (NSUInteger)lenghtWithWhiteString:(NSString *)string;


+(NSString *)configStringFromServerString:(NSString *)string;
/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

+ (NSString *)getHourMinTimeStr:(NSString*) compareStr;
+ (NSString *)getMouthDayTimeStr:(NSString*) compareStr;
//时间逻辑处理
+ (NSString *)getTimeStr:(NSString*) compareStr;

+ (float)lerp:(float)percent min:(float)nMin max:(float)nMax;
+ (NSString *)getDiscTanceStringWithDistance:(double) distance;
+ (NSString *)addImageUrl:(NSString *)imagePath appentString:(NSString *)addString;
+ (BOOL)isNULLOrEmpty:(NSString *)string;
+ (NSURL *)fileURLForBuggyWKWebView8:(NSURL *)fileURL;
+ (NSMutableArray *)getWeakDay;
+ (BOOL)validateNumber:(NSString*)number;//判断只能输入数字

@end
