//
//  UIViewController+WrongMessage.h
//  FFToolModule
//
//  Created by 郑强飞 on 14/12/17.
//  Copyright (c) 2014年 郑强飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (WrongMessage)

- (void)showRunningActivity;
- (void)hideRunningActivity;
- (void)showWrongActivity:(NSString*)wrongText;
- (void)hideWrongActivity;

@end
