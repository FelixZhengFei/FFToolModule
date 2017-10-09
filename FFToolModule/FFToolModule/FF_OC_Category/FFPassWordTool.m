//
//  PassWordTool.m
//  ZLYIwown
//
//  Created by 郑强飞 on 2017/8/12.
//  Copyright © 2017年 郑强飞. All rights reserved.
//

#import "FFPassWordTool.h"
#import "FFKeychainTool.h"

@implementation FFPassWordTool

static NSString * const KEY_IN_KEYCHAIN = @"com.weifengdai.app.userid";
static NSString * const KEY_PASSWORD = @"com.weifengdai.app.password";

+(void)savePassWord:(NSString *)password {
    NSMutableDictionary *usernamepasswordKVPairs = [NSMutableDictionary dictionary];
    [usernamepasswordKVPairs setObject:password forKey:KEY_PASSWORD];
    [FFKeychainTool save:KEY_IN_KEYCHAIN data:usernamepasswordKVPairs];
}

+(id)readPassWord {
    NSMutableDictionary *usernamepasswordKVPair = (NSMutableDictionary *)[FFKeychainTool load:KEY_IN_KEYCHAIN];
    return [usernamepasswordKVPair objectForKey:KEY_PASSWORD];
}

+(void)deletePassWord {
    [FFKeychainTool delete:KEY_IN_KEYCHAIN];
}
@end
