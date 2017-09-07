//
//  FFCountDownButton.h
//  FFCountDownButton
//
//  Created by 郑强飞 on 2017/8/12.
//  Copyright © 2017年 郑强飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FFCountDownButton;

typedef NSString* (^CountDownChanging)(FFCountDownButton *countDownButton,NSUInteger second);
typedef NSString* (^CountDownFinished)(FFCountDownButton *countDownButton,NSUInteger second);
typedef void (^TouchedCountDownButtonHandler)(FFCountDownButton *countDownButton,NSInteger tag);


@interface FFCountDownButton : UIButton

@property(nonatomic,strong) id userInfo;

///倒计时按钮点击回调
- (void)countDownButtonHandler:(TouchedCountDownButtonHandler)touchedCountDownButtonHandler;
//倒计时时间改变回调
- (void)countDownChanging:(CountDownChanging)countDownChanging;
//倒计时结束回调
- (void)countDownFinished:(CountDownFinished)countDownFinished;
///开始倒计时
- (void)startCountDownWithSecond:(NSUInteger)second;
///停止倒计时
- (void)stopCountDown;

@end
