//
//  UIViewController+WrongMessage.h
//  guanxinApp
//
//  Created by  郑强飞 on 14/12/15.
//  Copyright (c) 2014年 Zhenwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (WrongMessage)

- (void)showRunningActivity;
- (void)hideRunningActivity;
- (void)showWrongActivity:(NSString*)wrongText isHide:(BOOL)isHideAuto;
- (void)hideWrongActivity;
@end
