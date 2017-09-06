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
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 60, 280, 80)];
    textView.layer.borderWidth = 1;
    textView.font = [UIFont systemFontOfSize:14];
    textView.ff_placeHolder = @"我就是传说中的placehouder";
    textView.ff_limitCount = 200;
    [self.view addSubview:textView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
