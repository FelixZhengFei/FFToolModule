//
//  NSString+helper.m
//  ApliTest
//
//  Created by 郑强飞 on 2017/5/25.
//  Copyright © 2017年 郑强飞. All rights reserved.
//

#import "NSString+helper.h"
#import "Order.h"
#import "RSADataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

@implementation NSString (helper)

+ (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

+(void)doAlipayPay
{
    
    NSString *appID = @"2015111000751192";
    
    NSString * rsaPrivateKey= @"MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDHqwpmXHHYSoe5ObOqyyFSj9wQS1tfOrUcxASAj33mCtX5BTbpO5QH3f3wjI9DnqPjetEOILCjR1VgeYVEGlwIYIj8vC3TdIqqqhGMjo6kSqmvslBdTwwZXCiK1ute8s8Z9H1gHK8hTEjxSrwy9ZoanEBkFsqw4akOrBnKu0DZIG+4L2Ivb7OOtSanaWNB9+UYvRdk4q9QufRz4Cwl99CGWV1zzmLdKpYtnifdSpWCdo1qt89w5yybcgc5R7aoFqHs75WQyyJORTUu5zlw1LWTXjgLyWT0SqzGBx+QCEay4T3R34hQtUX5hksqAGad4ItSzWt1bsD11wBYQQBzA7efAgMBAAECggEBAIzui06o3apfIOF6eviInCKcbCYMKphS5ddB/DOKFME00McOCS4i4V+UL1OEwvJlnSRJYhnotQTqqraHz6q8OE2pZceOQ4JHdkDz/aMKVGBeWtsqr1LNIqsbw3oMLOI93DRjv8MBPBPytmGp8KC/fmBd/Y0oETU8colqrGHOPf2CifIRX0+ayTskimAkL7ddXxImvc1PAWPdFFcXtuNvtrrTZonKcixa7AWWsZYaFHZE+8Yz/68AqwFVYozFvf1yrMb4uFOZGVHEsJFTuc4dQ5cS8LtdQjmVVeh1G/NL38bZICdar/KGg1SeJRZ6bNl1Hu5QvInDlq5hS5yw36hxPcECgYEA7vKdwXrl0PC7gFi9KBhYKYTI3UG51qOcTlB0ZI+qS/YQTDhmt2AbfztpoIH8UYvMy1b8koQ2aQasuxGjntM1d6eCGQUllZDvf/UjvRkr7J5Iz1jPRXfxM2BCh4QFdJaspHhRvnd0kYJqDSSHNpBZCIvxGXCUXDv/WALSROS7eJECgYEA1erRUYn4HEAbEVLPKeMq+GEKZbO9s2pTpn3ZY8FYJHy/wb5cPIjt4eowD8q4vWz8phb28PqieYXThV3GUsOTdsnoWWErZPGtT+UOTTEuBwmzd1dDw1ZG3Cw09SbUoztQSVhXvty0GrsKK1Wk6VOi76MfbFCJrjhSFa2W3VRBxS8CgYBaEwlXAz4Y6na0Jj+AGtU5KX4SshEdEWX9u6R0uBeJNQPlx6ko3UjgSIRD5lw4XUvhJzRlAwQDyWlZx4d3esUACxwm1GLbo9w0zzMeuJtvQifOSfswg8tgA5xwu1rXHWmNQnIGK7+8jn3t4GQ8NGPrrd1AKskyj8ds5PtgzxzAkQKBgHJpgULHNDiH4PJHBB43LghifpkepVuMhukJbnf4NRhu0HDjS5nk8rZd9w67Mku+OvLqXXFN3BB7D0LJgQVLLVffbbJAUmFPEY8lx5xprWB+Q8qUld2oC4Y+7qQf/KLBWpOf+G5QxNN3Ll03FVjmLsNUz72y5bCU1vJZQdNm+TZpAoGBAJ1hL+ODNs6UhOadXoNGdpjiA0grk5BVIZ/AqHg2CyoLBLCG69iXgYaEU2axHP2BCFsW3uy0I/Im6eCLPoPBBxjQxBSIqr19XuYmkGbBD04KNZ3kVfrzLBuJ+fwvjTa/XW7PDAEVl1kCHPS0MeQbsVUeB1uUsrpC0lkO/cVg5T+Z";
    NSString *rsa2PrivateKey = @"";
    //partner和seller获取失败,提示
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order* order = [Order new];
    
    // NOTE: app_id设置
    order.app_id = appID;
    
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    // NOTE: 支付版本
    order.version = @"1.0";
    
    // NOTE: sign_type 根据商户设置的私钥来决定
    order.sign_type = (rsa2PrivateKey.length > 1)?@"RSA2":@"RSA";
    
    // NOTE: 商品数据
    order.biz_content = [BizContent new];
    order.biz_content.body = @"我是测试数据";
    order.biz_content.subject = @"1";
    order.biz_content.out_trade_no = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f", 0.01]; //商品价格
    
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    NSLog(@"orderSpec = %@",orderInfo);
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    NSString *signedString = nil;
    RSADataSigner* signer = [[RSADataSigner alloc] initWithPrivateKey:((rsa2PrivateKey.length > 1)?rsa2PrivateKey:rsaPrivateKey)];
    if ((rsa2PrivateKey.length > 1)) {
        signedString = [signer signString:orderInfo withRSA2:YES];
    } else {
        signedString = [signer signString:orderInfo withRSA2:NO];
    }
    
    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = @"alisdkdemo";
        
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
    }
}

@end
