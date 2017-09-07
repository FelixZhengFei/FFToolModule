//
//  ViewController.m
//  FFToolModule
//
//  Created by 郑强飞 on 2017/8/12.
//  Copyright © 2017年 郑强飞. All rights reserved.
//

#import "ViewController.h"
#import "FFToolModuleHeader.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // [self textviewPlaceHolder];
    [self testCountDownButton];
    
}

//textview
- (void)textviewPlaceHolder {
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 60, 280, 80)];
    textView.layer.borderWidth = 1;
    textView.font = [UIFont systemFontOfSize:14];
    textView.ff_placeHolder = @"我就是传说中的placehouder";
    textView.ff_limitCount = 200;
    [self.view addSubview:textView];
}

//倒计时
- (void)testCountDownButton {
    FFCountDownButton *_countDownCode = [FFCountDownButton buttonWithType:UIButtonTypeCustom];
    _countDownCode.frame = CGRectMake(81, 200, 200, 40);
    [_countDownCode setTitle:@"发送验证码" forState:UIControlStateNormal];
    _countDownCode.backgroundColor = [UIColor blueColor];
    _countDownCode.clipsToBounds = YES;
    _countDownCode.layer.cornerRadius = 10;
    _countDownCode.layer.masksToBounds = YES;
    [self.view addSubview:_countDownCode];
    
    [_countDownCode countDownButtonHandler:^(FFCountDownButton*sender, NSInteger tag) {
        sender.enabled = NO;
        NSLog(@"发送。。。。。");
        [sender startCountDownWithSecond:10];
        [sender countDownChanging:^NSString *(FFCountDownButton *countDownButton,NSUInteger second) {
            NSString *title = [NSString stringWithFormat:@"剩余%zd秒",second];
            [countDownButton setBackgroundColor:[UIColor grayColor]];
            return title;
        }];
        [sender countDownFinished:^NSString *(FFCountDownButton *countDownButton, NSUInteger second) {
            countDownButton.enabled = YES;
            [countDownButton setBackgroundColor:[UIColor blueColor]];
            return @"点击重新获取";
        }];
    }];
    /*
     想停止的时候调用 stopCountDown
     - (IBAction)countDownXibStop:(id)sender {
     [_countDownCode stopCountDown];
     }
     */
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
