//
//  NSString+DES.h
//  guanxinApp
//
//  Created by 郑强飞 on 15/5/29.
//  Copyright (c) 2015年 Zhenwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DES)

+ (NSString *)encryptWithText:(NSString *)sText;//加密
+ (NSString *)decryptWithText:(NSString *)sText;//解密

+(NSString*) decryptUseDES:(NSString*)cipherText key:(NSString*)key;
    +(NSString *) encryptUseDES:(NSString *)clearText key:(NSString *)key;

@end
