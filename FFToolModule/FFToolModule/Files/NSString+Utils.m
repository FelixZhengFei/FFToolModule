
//
//  NSString+Utils.m
//  guanxin
//
//  Created by JeeRain 13-05-10.
//  Copyright (c) 2012年 左岸科技. All rights reserved.
//

#import "NSString+Utils.h"

@implementation NSString (Utils)

// 03/16 12:00
+ (NSString*)stringDateWithFormat:(NSString*)dateStr
{
    NSString *str=[NSString stringWithFormat:@"%@",dateStr];
    NSTimeInterval time=[str longLongValue];
    NSDate *modifyDate=[NSDate dateWithTimeIntervalSince1970:time/1000];
    NSDateFormatter *fomater=[[NSDateFormatter alloc] init];
    [fomater setDateFormat:@"MM/dd HH:mm"];
    NSString *stringDate=[fomater stringFromDate:modifyDate];
    return stringDate;
}

+ (NSString*)stringDateWithYear:(NSString*)str
{
    if (str == nil) {
        return str;
    }
    NSString *dateStr=[NSString stringWithFormat:@"%@",str];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-M-d HH:mm:ss.SSS"];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    NSLog(@"data==%@",date);
    NSDateFormatter *temPdateFormatter = [[NSDateFormatter alloc] init];
    [temPdateFormatter setDateFormat: @"yyyy 年 MM 月 dd 日 HH:mm"];
    NSString *strDate = [temPdateFormatter stringFromDate:date];
    return strDate;
}

//+ (NSString*)stringForDate:(NSString*)dateStr
//{
//    NSDateFormatter *fomater=[[NSDateFormatter alloc] init];
//    return stringDate;
//}

+ (NSDate *)dateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}



+ (NSString*)stringDateWithFormat:(NSString*)timestamp format:(NSString*)format
{
    NSString *publishString = timestamp;
    double publishLong = [publishString doubleValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:publishLong/1000];
    publishString = [formatter stringFromDate:publishDate];
    return publishString;
}

+ (NSTimeInterval)getNSTimeInterval:(NSString*)dateStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];   
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; 
    NSDate* date = [formatter dateFromString:dateStr];
    NSTimeInterval interval=[date timeIntervalSince1970]*1000;
    
    return interval;
}

+ (NSDate *)dateFromString11:(NSString *)dateStr{
    NSString *str=[NSString stringWithFormat:@"%@",dateStr];
    NSTimeInterval time=[str longLongValue];
    NSDate *modifyDate=[NSDate dateWithTimeIntervalSince1970:time/1000];
    return modifyDate;
}


+ (NSString *)getNowNSTimeInterval
{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
//    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
//    NSTimeInterval interval=[dat timeIntervalSince1970]*1000;
    long long dTime = [[NSNumber numberWithDouble:time] longLongValue];
    NSString *photoName =[NSString stringWithFormat:@"%llu.jpg",dTime*1000+rand()%1000];
    return photoName;
}

+ (NSString *)getNowNSTimeIntervalVideo
{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    //    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    //    NSTimeInterval interval=[dat timeIntervalSince1970]*1000;
    long long dTime = [[NSNumber numberWithDouble:time] longLongValue];
    NSString *photoName =[NSString stringWithFormat:@"%llu.mp4",dTime*1000+rand()%1000];
    return photoName;
}

/*邮箱验证 MODIFIED BY HELENSONG*/
+(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/*url验证 MODIFIED BY HELENSONG*/
+(BOOL)isValidateHttpUrl:(NSString *)httpUrl
{
    NSString *emailRegex = @"^(((file|gopher|news|nntp|telnet|http|ftp|https|ftps|sftp)://)|(www/.))+(([a-zA-Z0-9/._-]+/.[a-zA-Z]{2,6})|([0-9]{1,3}/.[0-9]{1,3}/.[0-9]{1,3}/.[0-9]{1,3}))(/[a-zA-Z0-9/&%_/./-~-]*)?$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:httpUrl];
}

+ (NSString *)addHttpToUrlString:(NSString *)urlString {
    NSLog(@"链接11111===%@",urlString);
    if ([urlString hasPrefix:@"Http:"]||[urlString hasPrefix:@"Https:"]) {
    } else {
        urlString = [NSString stringWithFormat:@"http://%@",urlString];
    }
    return urlString;
}

+ (BOOL)isMobileNumber:(NSString*)mobileNum
{
    NSString *phoneRegex = @"^((13[0-9])|(15[0-9])|(18[0-9])|(17[0-9])|(14[0,9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobileNum];
}

+ (BOOL)isValidatePassword:(NSString*)password
{
  //  NSString *pattern = @"(?!^\\d+$)(?!^[a-zA-Z]+$)(?!^[_#@]+$).{6,16}";
//    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
//    NSLog(@"phoneTest is %@",phoneTest);
//    return [phoneTest evaluateWithObject:mobileNum];
NSString * pattern = @"^[a-zA-Z0-9]\\S|\\S{5,15}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
}

+ (NSString *)removeWhiteString:(NSString *)string {
    if (string == nil) {
        return nil;
    }
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString* res = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return res;
}

+ (BOOL)isEmailAddress:(NSString *)aString
{
    BOOL legal = NO;
    
    do {
        NSString *username = [aString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([username length] == 0) {
            break;
        }
        
        NSUInteger i;
        for (i=0; i<[username length]; i++) {
            unichar c = [username characterAtIndex:i];
            
            if (c > 127) {
                break;
            }
        }
        if (i != [username length]) {
            break;
        }
        
        NSRange range;
        
        range = [username rangeOfString:@"."];
        if (range.location == NSNotFound) {
            break;
        }
        
        range = [username rangeOfString:@"@"];
        if (range.location == NSNotFound) {
            break;
        }
        
        range = [username rangeOfString:@","];
        if (range.location != NSNotFound) {
            break;
        }
        
        range = [username rangeOfString:@".."];
        if (range.location != NSNotFound) {
            break;
        }
        
        range = [username rangeOfString:@" "];
        if (range.location != NSNotFound) {
            break;
        }
        
        range = [username rangeOfString:@"@."];
        if (range.location != NSNotFound) {
            break;
        }
        
        if ([username hasPrefix:@"@"]) {
            break;
        }
        
        if ([username hasSuffix:@"."]) {
            break;
        }
        
        range = [username rangeOfString:@"@"];
        NSString *stringAfter = [username
                                 substringFromIndex:range.location+range.length];
        NSString *stringBefore = [username substringToIndex:range.location];
        
        range = [stringAfter rangeOfString:@"@"];
        if (range.location != NSNotFound) {
            break;
        }
        
        range = [stringBefore rangeOfString:@"@"];
        if (range.location != NSNotFound) {
            break;
        }
        
        range = [stringAfter rangeOfString:@"."];
        if (range.location == NSNotFound) {
            break;
        }
        
        legal = YES;
    } while (NO);
    
    return legal;
}

//计算文本的汉字数
+ (NSUInteger)lenghtWithString:(NSString *)string {
    NSUInteger len = string.length;
    // 汉字字符集
    NSString * pattern  = @"[^\\x00-\\xff]";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    // 计算中文字符的个数
    NSInteger numMatch = [regex numberOfMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, len)];
    return (len + numMatch+1)/2;
}

//计算文本的限制文本长度leng
+ (NSUInteger)cacleLimitString:(NSString *)string withLimit:(NSInteger)limitCount {
    NSUInteger len = string.length;
    // 汉字字符集
    NSString * pattern  = @"[^\\x00-\\xff]";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    // 计算中文字符的个数
    NSInteger numMatch = [regex numberOfMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, len)];
    return limitCount * 2 - numMatch;
}


+ (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

+ (NSUInteger)lenghtWithWhiteString:(NSString *)string {
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length;
}

+(NSString *)configStringFromServerString:(NSString *)string {
    NSString * str = [string stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    str = [str stringByReplacingOccurrencesOfString:@"</p>" withString:@"\n"];
    str = [str stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"<a href=\"" withString:@""];
   // str = [str stringByReplacingOccurrencesOfString:@"\"" withString:@" "];
//    str = [str stringByReplacingOccurrencesOfString:@"http://" withString:@""];
//    str = [str stringByReplacingOccurrencesOfString:@"https://" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"</a>" withString:@" "];
    str = [str stringByReplacingOccurrencesOfString:@">" withString:@" "];
    str = [str stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    str = [str stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    str = [str stringByReplacingOccurrencesOfString:@"<br/" withString:@"\n"];
    str = [str stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];

   // str = [self removeWhiteString:str];
    return str;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

//时间逻辑处理
+ (NSString *)getHourMinTimeStr:(NSString*) compareStr {
    NSString *str=[NSString stringWithFormat:@"%@",compareStr];
    NSTimeInterval time=[str doubleValue];
    NSDate *compareDate=[NSDate dateWithTimeIntervalSince1970:time/1000];
    
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    
    NSDate * senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH"];
    NSString * locationString=[dateformatter stringFromDate:senddate];
    int hours=[locationString intValue];
    
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@""];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@""];
    }
    
    else if((temp = temp/60) <hours){
        result = [NSString stringWithFormat:@""];
        
    } else if(temp<((long)hours+24l)&&temp>=(long)hours) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        result = [dateFormatter stringFromDate:compareDate];
        result = [NSString stringWithFormat:@"%@",result];
    } else if(temp<((long)hours+48l)&&temp>=(long)hours) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        result = [dateFormatter stringFromDate:compareDate];
        result = [NSString stringWithFormat:@"%@",result];
    } else {
        NSCalendar *cal = [NSCalendar currentCalendar];
        unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents *dateFormatter1 = [cal components:unitFlags fromDate:[NSDate date]];
        NSInteger currentYear = [dateFormatter1 year];
        
        NSCalendar *tempcal = [NSCalendar currentCalendar];
        unsigned int tempunitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents *tempdateFormatter1 = [tempcal components:tempunitFlags fromDate:compareDate];
        NSInteger tempyear = [tempdateFormatter1 year];
        if (tempyear < currentYear) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"HH:mm"];
            result = [dateFormatter stringFromDate:compareDate];
            result = [NSString stringWithFormat:@"%@",result];
        } else {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"HH:mm"];
            result = [dateFormatter stringFromDate:compareDate];
        }
        
    }
    return  result;
}

//时间逻辑处理
+ (NSString *)getMouthDayTimeStr:(NSString*) compareStr {
    NSString *str=[NSString stringWithFormat:@"%@",compareStr];
    NSTimeInterval time=[str doubleValue];
    NSDate *compareDate=[NSDate dateWithTimeIntervalSince1970:time/1000];
    
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    
    NSDate * senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH"];
    NSString * locationString=[dateformatter stringFromDate:senddate];
    int hours=[locationString intValue];
    
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%lu分钟前",temp];
    }
    
    else if((temp = temp/60) <hours){
        result = [NSString stringWithFormat:@"%lu小时前",temp];
        
    } else if(temp<((long)hours+24l)&&temp>=(long)hours) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        result = [dateFormatter stringFromDate:compareDate];
        result = [NSString stringWithFormat:@"昨天"];
    } else if(temp<((long)hours+48l)&&temp>=(long)hours) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        result = [dateFormatter stringFromDate:compareDate];
        result = [NSString stringWithFormat:@"前天"];
    } else {
        NSCalendar *cal = [NSCalendar currentCalendar];
        unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents *dateFormatter1 = [cal components:unitFlags fromDate:[NSDate date]];
        NSInteger currentYear = [dateFormatter1 year];
        
        NSCalendar *tempcal = [NSCalendar currentCalendar];
        unsigned int tempunitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents *tempdateFormatter1 = [tempcal components:tempunitFlags fromDate:compareDate];
        NSInteger tempyear = [tempdateFormatter1 year];
        if (tempyear < currentYear) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"YYYY-MM-dd"];
            result = [dateFormatter stringFromDate:compareDate];
            result = [NSString stringWithFormat:@"%@",result];
        } else {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM-dd"];
            result = [dateFormatter stringFromDate:compareDate];
        }
        
    }
    return  result;
}

//时间逻辑处理
+ (NSString *) getTimeStr:(NSString*) compareStr {
    
    NSString *str=[NSString stringWithFormat:@"%@",compareStr];
    NSTimeInterval time=[str doubleValue];
    NSDate *compareDate=[NSDate dateWithTimeIntervalSince1970:time/1000];
    
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    
    NSDate * senddate=[NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH"];
    NSString * locationString=[dateformatter stringFromDate:senddate];
    int hours=[locationString intValue];
    
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%lu分钟前",temp];
    }
    
    else if((temp = temp/60) <hours){
        result = [NSString stringWithFormat:@"%lu小时前",temp];
        
    } else if(temp<((long)hours+24l)&&temp>=(long)hours) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        result = [dateFormatter stringFromDate:compareDate];
        result = [NSString stringWithFormat:@"昨天%@",result];
    } else if(temp<((long)hours+48l)&&temp>=(long)hours) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        result = [dateFormatter stringFromDate:compareDate];
        result = [NSString stringWithFormat:@"前天%@",result];
    } else {
        NSCalendar *cal = [NSCalendar currentCalendar];
        unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents *dateFormatter1 = [cal components:unitFlags fromDate:[NSDate date]];
        NSInteger currentYear = [dateFormatter1 year];
        
        NSCalendar *tempcal = [NSCalendar currentCalendar];
        unsigned int tempunitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents *tempdateFormatter1 = [tempcal components:tempunitFlags fromDate:compareDate];
        NSInteger tempyear = [tempdateFormatter1 year];
        if (tempyear < currentYear) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"YYYY-MM-dd"];
            result = [dateFormatter stringFromDate:compareDate];
            result = [NSString stringWithFormat:@"%@",result];
        } else {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM-dd"];
            result = [dateFormatter stringFromDate:compareDate];
        }
        
    }
    return  result;
}


/*0--1 : lerp( float percent, float x, float y ){ return x + ( percent * ( y - x ) ); };*/
+ (float)lerp:(float)percent min:(float)nMin max:(float)nMax
{
    float result = nMin;
    
    result = nMin + percent * (nMax - nMin);
    
    return result;
}


+ (NSString *)getDiscTanceStringWithDistance:(double) distance{
    NSString *ditancSt = @"";
    if (distance<=100) {
        ditancSt =[NSString stringWithFormat:@"100m"];
    } else if (distance>100 &&distance<2000) {
        ditancSt =[NSString stringWithFormat:@"%.2fm",distance];
    } else {
        ditancSt =[NSString stringWithFormat:@"%.2fkm",distance/1000];
    }
    return ditancSt;
}

+ (NSString *)addImageUrl:(NSString *)imagePath appentString:(NSString *)addString{
    if (imagePath == nil || [NSString isNULLOrEmpty:imagePath]) {
        return imagePath;
    }
    NSString *tempType = [imagePath pathExtension];
    if ([imagePath length]>[tempType length]+1) {
        NSString *tempPath = [imagePath substringToIndex:([imagePath length] - [tempType length]-1)];
        return [NSString stringWithFormat:@"%@%@.%@",tempPath,addString,tempType];
    }
    return imagePath;
}

+ (BOOL)isNULLOrEmpty:(NSString *)string {
    if ([@"" isEqual:string] ||[@" " isEqual:string] || string == nil || [string isEqual:@"(null)"] ||[string isEqual:@"<null>"] || [string isEqual:[NSNull null]]) {
        return YES;
    }
    return NO;
}


//将文件copy到tmp目录
+ (NSURL *)fileURLForBuggyWKWebView8:(NSURL *)fileURL {
    NSError *error = nil;
    if (!fileURL.fileURL || ![fileURL checkResourceIsReachableAndReturnError:&error]) {
        return nil;
    }
    // Create "/temp/www" directory
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *temDirURL = [[NSURL fileURLWithPath:NSTemporaryDirectory()] URLByAppendingPathComponent:@"www"];
    [fileManager createDirectoryAtURL:temDirURL withIntermediateDirectories:YES attributes:nil error:&error];

    NSURL *dstURL = [temDirURL URLByAppendingPathComponent:fileURL.lastPathComponent];
    // Now copy given file to the temp directory
    [fileManager removeItemAtURL:dstURL error:&error];
    [fileManager copyItemAtURL:fileURL toURL:dstURL error:&error];
    // Files in "/temp/www" load flawlesly :)
    return dstURL;
}


+ (NSMutableArray *)getWeakDay {
   NSMutableArray* _dataArry = [NSMutableArray arrayWithCapacity:7];
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate * today = [NSDate date];
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *jinDateString = @"今天";
    
    
    NSDateFormatter *showDateFormatter = [[NSDateFormatter alloc] init];
    [showDateFormatter setDateFormat:@"MM月dd日"];
    
    
    for (int days = 0; days < 7; days ++) {
        NSString *dateString = [myDateFormatter stringFromDate:[today dateByAddingTimeInterval:days * secondsPerDay]];
        NSString *showDataString = [showDateFormatter stringFromDate:[today dateByAddingTimeInterval:days * secondsPerDay]];
        
        if (days == 0) {
            jinDateString = @"今天";
        } else if (days ==1) {
            jinDateString = @"明天";
            
        }else if (days ==2) {
            jinDateString = @"后天";
            
        } else {
            jinDateString = showDataString;
            
        }
        
        NSString * xq = [self calculateWeek:dateString];
        NSString * itemStr = [NSString stringWithFormat:@"%@(%@)",jinDateString,xq];
        [_dataArry addObject:itemStr];
    }
    return _dataArry;
}


+ (NSString *)calculateWeek:(NSString *)dateStr{
    NSString* string = dateStr;
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* inputDate = [inputFormatter dateFromString:string];
    //计算week数
    NSCalendar * myCalendar = [NSCalendar currentCalendar];
    myCalendar.timeZone = [NSTimeZone systemTimeZone];
    NSInteger week = [[myCalendar components:NSCalendarUnitWeekday fromDate:inputDate] weekday];
    switch (week) {
        case 1:
        {
            return @"周日";
        }
        case 2:
        {
            return @"周一";
        }
        case 3:
        {
            return @"周二";
        }
        case 4:
        {
            return @"周三";
        }
        case 5:
        {
            return @"周四";
        }
        case 6:
        {
            return @"周五";
        }
        case 7:
        {
            return @"周六";
        }
    }
    
    return @"";
}


@end
