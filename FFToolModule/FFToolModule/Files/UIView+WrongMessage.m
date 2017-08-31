//
//  UIViewController+WrongMessage.m
//  guanxinApp
//
//  Created by  郑强飞 on 14/12/15.
//  Copyright (c) 2014年 Zhenwei. All rights reserved.
//

#import "UIView+WrongMessage.h"
#import "BLMultiColorLoader.h"
#import "GXRightAlertView.h"
#import "NSString+Utils.h"

#define animition_tag 14320
#define animition_tag1 13420

@implementation UIView (WrongMessage)

#pragma mark - Overlay Activity Indicator methods

-(void)showRunningActivity {
    self.userInteractionEnabled = NO;

    BLMultiColorLoader* multiColorLoader = [[BLMultiColorLoader alloc] init];
    multiColorLoader.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width-80)/2, ([[UIScreen mainScreen] bounds].size.height - 80-64)/2, 80, 80);
    multiColorLoader.tag = animition_tag;
    [self addSubview:multiColorLoader];
    multiColorLoader.lineWidth = 2.0;
    multiColorLoader.colorArray = [NSArray arrayWithObjects:[UIColor colorWithRed:50/255.0 green:152/255.0 blue:255/255.0 alpha:1], nil];
    multiColorLoader.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    multiColorLoader.layer.shadowOffset = CGSizeMake(2,6);//shadowOffset阴影偏移,x向右偏移2，y向下偏移6，默认(0, -3),这个跟shadowRadius配合使用
    multiColorLoader.layer.shadowOpacity = 0.7;
    [multiColorLoader startAnimation];
}

- (void)hideRunningActivity {
    self.userInteractionEnabled = YES;
    BLMultiColorLoader *multiColorLoader = (BLMultiColorLoader *) [self viewWithTag:animition_tag];
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
    [self addSubview:anminView];
    [anminView startAnimate:wrongText];
    [self performSelector:@selector(hideWrongActivity) withObject:nil afterDelay:1.50f];
}

- (void)hideWrongActivity{
    self.userInteractionEnabled = YES;
    GXRightAlertView *anminView = (GXRightAlertView *) [self viewWithTag:animition_tag1];
    [anminView stopAnimate];
    [anminView removeFromSuperview];
}

@end
