//
//  PassWordTool.h
//  ZLYIwown
//
//  Created by 郑强飞 on 2017/8/12.
//  Copyright © 2017年 郑强飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFPassWordTool : NSObject
/**
 *    @brief    存储密码
 *
 *    @param     password     密码内容
 */
+(void)savePassWord:(NSString *)password;

/**
 *    @brief    读取密码
 *
 *    @return    密码内容
 */
+(id)readPassWord;

/**
 *    @brief    删除密码数据
 */
+(void)deletePassWord;

@end
