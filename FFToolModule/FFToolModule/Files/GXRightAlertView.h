//
//  GXRightAlertView.h
//  guanxinApp
//
//  Created by  郑强飞 on 14/12/17.
//  Copyright (c) 2014年 Zhenwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICalculationTool.h"

@interface GXRightAlertView : UIView  {

    CGFloat viewHeight;
}

- (void)startAnimate:(NSString *)alerText;
- (void)stopAnimate;

@end
