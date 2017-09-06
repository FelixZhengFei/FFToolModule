//
//  UIViewController+WrongMessage.m
//  FFToolModule
//
//  Created by  郑强飞 on 14/12/17.
//  Copyright (c) 2014年 郑强飞. All rights reserved.
//

#import "UIViewController+WrongMessage.h"
#import "FFMultiColorLoader.h"
#import "FFRightBlackAlertView.h"

#define animition_tag 12220
#define animition_tag1 13420

@implementation UIViewController (WrongMessage)

#pragma mark - Overlay Activity Indicator methods

- (void)showRunningActivity {
    self.view.userInteractionEnabled = NO;
    FFMultiColorLoader* multiColorLoader = [[FFMultiColorLoader alloc] init];
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
    FFMultiColorLoader *multiColorLoader = (FFMultiColorLoader *) [self.view viewWithTag:animition_tag];
    [multiColorLoader stopAnimation];
    [multiColorLoader removeFromSuperview];
}

- (void)showWrongActivity:(NSString*)wrongText isHide:(BOOL)isHideAuto {
    if ([@"" isEqual:wrongText] ||[@" " isEqual:wrongText] || wrongText == nil || [wrongText isEqual:@"(null)"] ||[wrongText isEqual:@"<null>"] || [wrongText isEqual:[NSNull null]]) {
        return ;
    }
    wrongText = [wrongText stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    FFRightBlackAlertView* anminView = [[FFRightBlackAlertView alloc] initWithFrame:CGRectMake(0, ([[UIScreen mainScreen] bounds].size.height - 80-64)/2, [[UIScreen mainScreen] bounds].size.width, 40)];
    anminView.tag = animition_tag1;
    [self.view addSubview:anminView];
    [anminView startAnimate:wrongText];
    [self performSelector:@selector(hideWrongActivity) withObject:nil afterDelay:1.50f];
}

- (void)hideWrongActivity{
    self.view.userInteractionEnabled = YES;
    FFRightBlackAlertView *anminView = (FFRightBlackAlertView *) [self.view viewWithTag:animition_tag1];
    [anminView stopAnimate];
    [anminView removeFromSuperview];
}


@end
