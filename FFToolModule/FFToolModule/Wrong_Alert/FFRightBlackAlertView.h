//
//  FFRightBlackAlertView.h
//  FFToolModule
//
//  Created by  郑强飞 on 14/12/17.
//  Copyright (c) 2014年 郑强飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFRightBlackAlertView : UIView  {
    CGFloat viewHeight;
}

- (void)startAnimate:(NSString *)alerText;
- (void)stopAnimate;

@end
