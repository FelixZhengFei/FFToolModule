//
//  NSString+Extension.m
//  BasicFramework
//
//  Created by Rainy on 16/10/26.
//  Copyright © 2016年 Rainy. All rights reserved.
//
#if TARGET_IPHONE_SIMULATOR
#define kAppleLanguages(Chinese,English) [[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] isEqualToString:@"zh-Hans-US"] ? Chinese : English
#elif TARGET_OS_IPHONE
#define kAppleLanguages(Chinese,English) [[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] isEqualToString:@"zh-Hans-CN"] ? Chinese : English
#endif

#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Extension)
+(NSString *)ResetAmount:(NSString *)Amount_str segmentation_index:(int)segmentation_index segmentation_str:(NSString *)segmentation_str
{
    if ([NSString isNULL:Amount_str]) {
        return Amount_str;
    }
    
    NSArray *array_str = [Amount_str componentsSeparatedByString:@"."];
    
    NSString *num_str = array_str.count > 1 ? array_str[0] : Amount_str;
    
    int count = 0;
    long long int a = num_str.longLongValue;
    while (a != 0)
    {
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:num_str];
    NSMutableString *newstring = [NSMutableString string];
    while (count > segmentation_index) {
        count -= segmentation_index;
        NSRange rang = NSMakeRange(string.length - segmentation_index, segmentation_index);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:segmentation_str atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    
    return array_str.count > 1 ? [NSString stringWithFormat:@"%@.%@",newstring,array_str[1]] : newstring;
}

-(NSAttributedString *)AddRemoveLineOnStringRange:(NSRange )range lineWidth:(NSInteger )lineWidth {
    
    NSMutableAttributedString *temp_attributedStr = [[NSMutableAttributedString alloc]initWithString:self];
    [temp_attributedStr addAttribute:NSStrikethroughStyleAttributeName value:[NSString stringWithFormat:@"%ld",(long)lineWidth] range:range];
    return temp_attributedStr;
}

/**
 *  @brief  反转字符串
 *
 *  @param strSrc 被反转字符串
 *
 *  @return 反转后字符串
 */
- (NSString *)StringReverse
{
    NSMutableString* reverseString = [[NSMutableString alloc] init];
    NSInteger charIndex = [self length];
    while (charIndex > 0) {
        charIndex --;
        NSRange subStrRange = NSMakeRange(charIndex, 1);
        [reverseString appendString:[self substringWithRange:subStrRange]];
    }
    return reverseString;
}

-(NSString *)EncodingString
{
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

}
-(NSString *)RemovingEncoding
{
    return [self stringByRemovingPercentEncoding];

}

- (NSDictionary *)StringOfJsonConversionDictionary {
    
    if ([NSString isNULL:self]) {
        
        return nil;
        
    }
    
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *parseError;
    
    NSDictionary *Dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&parseError];
    
    if(parseError) {
        
        return nil;
    }
    
    return Dictionary;
    
}



- (NSString *)MD5string
{
    if ([NSString isNULL:self]) {
        return @"";
    }
    const char *value = [self UTF8String];
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    //CC_MD5(value, strlen(value), outputBuffer);
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}


-(NSMutableAttributedString *)setOtherColor:(UIColor *)Color font:(CGFloat)font forStr:(NSString *)forStr
{
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]init];
    
    if (![NSString isNULL:self]) {
        
        NSMutableString *temp = [NSMutableString stringWithString:self];
        
        NSRange range = [temp rangeOfString:forStr];
        
        str = [[NSMutableAttributedString alloc] initWithString:temp];
        [str addAttribute:NSForegroundColorAttributeName value:Color range:range];
        if (font) {
            
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:range];
        }
        
    }
    return str;
    
    
}

-(NSMutableAttributedString *)insertImg:(UIImage *)Img atIndex:(NSInteger )index IMGrect:(CGRect )IMGrect
{
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:self];
    
    if (![NSString isNULL:self] && index <= self.length - 1) {
        
        NSTextAttachment *attatchment = [[NSTextAttachment alloc] init];
        attatchment.image = Img;
        attatchment.bounds = IMGrect;
        [attributedText insertAttributedString:[NSAttributedString attributedStringWithAttachment:attatchment] atIndex:index];
    }
    
    return attributedText;

    
}

- (BOOL)isChinese
{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}
- (NSString *)pinyin
{
    NSMutableString *str = [self mutableCopy];
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    
    return [str stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString *)pinyinInitial
{
    NSMutableString *str = [self mutableCopy];
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    
    NSArray *word = [str componentsSeparatedByString:@" "];
    NSMutableString *initial = [[NSMutableString alloc] initWithCapacity:str.length / 3];
    for (NSString *str in word) {
        [initial appendString:[str substringToIndex:1]];
    }
    return initial;
}
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
}

- (CGSize)sizeWithFont:(UIFont *)font
{
    return [self sizeWithFont:font maxW:MAXFLOAT];
    
    
}
- (CGSize)sizeWithFont:(UIFont *)font andMaxW:(CGFloat)maxW
{
    return [self sizeWithFont:font maxW:maxW];
    
    
}

+(BOOL)isNULL:(id)string{

    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}



- (BOOL)isEmail {
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [regExPredicate evaluateWithObject:self];
}

- (BOOL)isPhoneNumber {
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink|NSTextCheckingTypePhoneNumber error:nil];
    return [detector numberOfMatchesInString:self options:0 range:NSMakeRange(0, [self length])];
}

- (BOOL)isDigit {
    NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:self];
    return [alphaNums isSupersetOfSet:inStringSet];
}

- (BOOL)isNumeric {
    NSString *regex = @"([0-9])+((\\.|,)([0-9])+)?";
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [regExPredicate evaluateWithObject:self];
}

- (BOOL)isUrl {
    NSString *regex = @"https?:\\/\\/[\\S]+";
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [regExPredicate evaluateWithObject:self];
}

- (BOOL)isMinLength:(NSUInteger)length {
    return (self.length >= length);
}

- (BOOL)isMaxLength:(NSUInteger)length {
    return (self.length <= length);
}

- (BOOL)isMinLength:(NSUInteger)min andMaxLength:(NSUInteger)max {
    return ([self isMinLength:min] && [self isMaxLength:max]);
}

- (BOOL)isEmpty {
    return (!self.length);
}

//身份证号
+ (BOOL)CheckIsIdentityCard: (NSString *)identityCard {
    //判断是否为空
    if (identityCard==nil||identityCard.length <= 0) {
        return NO;
    }
    //判断是否是18位，末尾是否是x
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    if(![identityCardPredicate evaluateWithObject:identityCard]){
        return NO;
    }
    //判断生日是否合法
    NSRange range = NSMakeRange(6,8);
    NSString *datestr = [identityCard substringWithRange:range];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat : @"yyyyMMdd"];
    if([formatter dateFromString:datestr]==nil){
        return NO;
    }
    
    //判断校验位
    if(identityCard.length==18)
    {
        NSArray *idCardWi= @[ @"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2" ]; //将前17位加权因子保存在数组里
        NSArray * idCardY=@[ @"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2" ]; //这是除以11后，可能产生的11位余数、验证码，也保存成数组
        int idCardWiSum=0; //用来保存前17位各自乖以加权因子后的总和
        for(int i=0;i<17;i++){
            idCardWiSum+=[[identityCard substringWithRange:NSMakeRange(i,1)] intValue]*[idCardWi[i] intValue];
        }
        
        int idCardMod=idCardWiSum%11;//计算出校验码所在数组的位置
        NSString *idCardLast=[identityCard substringWithRange:NSMakeRange(17,1)];//得到最后一位身份证号码
        
        //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
        if(idCardMod==2){
            if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]){
                return YES;
            }else{
                return NO;
            }
        }else{
            //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
            if([idCardLast intValue]==[idCardY[idCardMod] intValue]){
                return YES;
            }else{
                return NO;
            }
        }
    }
    return NO;
}

@end
