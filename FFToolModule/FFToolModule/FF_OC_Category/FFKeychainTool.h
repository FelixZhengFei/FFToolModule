//
//  KeychainTool.h
//  ZLYIwown
//
//  Created by 郑强飞 on 2017/8/12.
//  Copyright © 2017年 郑强飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFKeychainTool : NSObject

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service ;

+ (void)save:(NSString *)service data:(id)data ;

+ (id)load:(NSString *)service ;

+ (void)delete:(NSString *)service ;

@end
