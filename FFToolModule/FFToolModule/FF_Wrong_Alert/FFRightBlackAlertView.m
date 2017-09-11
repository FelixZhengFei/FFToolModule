//
//  FFRightBlackAlertView.m
//  FFToolModule
//
//  Created by  郑强飞 on 14/12/17.
//  Copyright (c) 2014年 郑强飞. All rights reserved.
//

#import "FFRightBlackAlertView.h"

@implementation FFRightBlackAlertView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        viewHeight = 40;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        viewHeight = 40;
    }
    return self;
}

- (void)addBlackImageView:(NSString *)wrongText {
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
    [self addSubview:imageView];
    
    imageView.layer.cornerRadius = 8;
    imageView.layer.borderColor = [UIColor clearColor].CGColor;
    imageView.layer.masksToBounds = YES;
    [imageView.layer setBorderWidth:0.5];
    
    UILabel *textLable = [[UILabel alloc] init];
    textLable.backgroundColor = [UIColor clearColor];
    textLable.text = wrongText;
    textLable.font = [UIFont systemFontOfSize:14];
    textLable.numberOfLines = 0;
    textLable.textAlignment = NSTextAlignmentCenter;
    textLable.textColor = [UIColor whiteColor];
    textLable.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGFloat stringWidth = [wrongText sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].width;
    CGFloat offset= ceilf(stringWidth);
    
    CGFloat width = MAX(offset, 60);
    if (width > [[UIScreen mainScreen] bounds].size.width-40) {
        width =[[UIScreen mainScreen] bounds].size.width-40;
        viewHeight +=20;
        textLable.numberOfLines = 0;
        
    } else {
        textLable.numberOfLines = 1;
    }
    textLable.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width - width)/2, 0, width, viewHeight);
    imageView.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width - width-20)/2, 0, width+20, viewHeight);
    [self addSubview:textLable];
}

- (void)addImageAnimaiton:(NSString *)alerText {
    [self removeImageAnimaiton];
    [self setHidden:NO];
    [self addBlackImageView:alerText];
}

- (void)removeImageAnimaiton {
    if (self.subviews.count) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    [self setHidden:YES];
}

- (void)startAnimate:(NSString *)alerText {
    [self addImageAnimaiton:alerText];
}

- (void)stopAnimate {
    [self performSelector:@selector(removeImageAnimaiton) withObject:nil afterDelay:1.5];
}

@end
