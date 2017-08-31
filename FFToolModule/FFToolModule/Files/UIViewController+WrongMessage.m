//
//  UIViewController+WrongMessage.m
//  guanxinApp
//
//  Created by  郑强飞 on 14/12/15.
//  Copyright (c) 2014年 Zhenwei. All rights reserved.
//

#import "UIViewController+WrongMessage.h"
#import "BLMultiColorLoader.h"
#import "GXRightAlertView.h"
#import "NSString+Utils.h"

#define animition_tag 12220
#define animition_tag1 13420

@implementation UIViewController (WrongMessage)

#pragma mark - Overlay Activity Indicator methods

-(void)showRunningActivity {
    self.view.userInteractionEnabled = NO;
    BLMultiColorLoader* multiColorLoader = [[BLMultiColorLoader alloc] init];
    multiColorLoader.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width-80)/2, ([[UIScreen mainScreen] bounds].size.height - 80-64)/2, 80, 80);
    multiColorLoader.tag = animition_tag;
    [self.view addSubview:multiColorLoader];
    multiColorLoader.lineWidth = 2.0;
    multiColorLoader.colorArray = [NSArray arrayWithObjects:[UIColor colorWithRed:50/255.0 green:152/255.0 blue:255/255.0 alpha:1], nil];
    [self.view bringSubviewToFront:multiColorLoader];
    [multiColorLoader startAnimation];
}

- (void)hideRunningActivity {
    self.view.userInteractionEnabled = YES;
    BLMultiColorLoader *multiColorLoader = (BLMultiColorLoader *) [self.view viewWithTag:animition_tag];
    [multiColorLoader stopAnimation];
    [multiColorLoader removeFromSuperview];
}


- (void)showWrongActivity:(NSString*)wrongText isHide:(BOOL)isHideAuto {
    if ([NSString isNULLOrEmpty:wrongText]) {
        return;
    }
    wrongText = [wrongText stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    GXRightAlertView* anminView = [[GXRightAlertView alloc] initWithFrame:CGRectMake(0, ([[UIScreen mainScreen] bounds].size.height - 80-64)/2, [[UIScreen mainScreen] bounds].size.width, 40)];
    anminView.tag = animition_tag1;
    [self.view addSubview:anminView];
    [anminView startAnimate:wrongText];
    [self performSelector:@selector(hideWrongActivity) withObject:nil afterDelay:1.50f];
}

- (void)hideWrongActivity{
    self.view.userInteractionEnabled = YES;
    GXRightAlertView *anminView = (GXRightAlertView *) [self.view viewWithTag:animition_tag1];
    [anminView stopAnimate];
    [anminView removeFromSuperview];
}


@end
