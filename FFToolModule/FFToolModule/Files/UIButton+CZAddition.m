//
//  UIButton+CZAddition.m
//
//  Created by 刘凡 on 16/5/17.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "UIButton+CZAddition.h"

@implementation UIButton (CZAddition)

+ (instancetype)cz_textButton:(NSString *)title fontSize:(CGFloat)fontSize normalColor:(UIColor *)normalColor highlightedColor:(UIColor *)highlightedColor {
    return [self cz_textButton:title fontSize:fontSize normalColor:normalColor highlightedColor:highlightedColor backgroundImageName:nil];
}

+ (instancetype)cz_textButton:(NSString *)title fontSize:(CGFloat)fontSize normalColor:(UIColor *)normalColor highlightedColor:(UIColor *)highlightedColor backgroundImageName:(NSString *)backgroundImageName {
    
    UIButton *button = [[self alloc] init];
    
    [button setTitle:title forState:UIControlStateNormal];
    
    [button setTitleColor:normalColor forState:UIControlStateNormal];
    [button setTitleColor:highlightedColor forState:UIControlStateHighlighted];
    
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    
    if (backgroundImageName != nil) {
        [button setBackgroundImage:[UIImage imageNamed:backgroundImageName] forState:UIControlStateNormal];
        
        NSString *backgroundImageNameHL = [backgroundImageName stringByAppendingString:@"_highlighted"];
        [button setBackgroundImage:[UIImage imageNamed:backgroundImageNameHL] forState:UIControlStateHighlighted];
    }
    
    [button sizeToFit];
    
    return button;
}

+ (instancetype)cz_imageButton:(NSString *)imageName backgroundImageName:(NSString *)backgroundImageName {
    
    UIButton *button = [[self alloc] init];
    
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    NSString *imageNameHL = [imageName stringByAppendingString:@"_highlighted"];
    [button setImage:[UIImage imageNamed:imageNameHL] forState:UIControlStateHighlighted];
    
    [button setBackgroundImage:[UIImage imageNamed:backgroundImageName] forState:UIControlStateNormal];
    
    NSString *backgroundImageNameHL = [backgroundImageName stringByAppendingString:@"_highlighted"];
    [button setBackgroundImage:[UIImage imageNamed:backgroundImageNameHL] forState:UIControlStateHighlighted];
    
    [button sizeToFit];
    
    return button;
}

+ (instancetype)showButtonNumber:(NSInteger)aCount {
    UIButton *button = [[self alloc] init];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    button.userInteractionEnabled = NO;
    button.hidden = NO;
    
    if (aCount==0) {
        [button setHidden:YES];
        [button setTitle:@"" forState:UIControlStateNormal];
        [button setTitle:@"" forState:UIControlStateHighlighted];
    }else if (aCount>0&&aCount<=9){
        [button setHidden:NO];
        [button setBackgroundImage:[UIImage imageNamed:@"iconsmalldian_image"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"iconsmalldian_image"] forState:UIControlStateHighlighted];
        
        [button setFrame:CGRectMake(button.frame.origin.x, button.frame.origin.y, 16, 16)];
        [button setTitle:[NSString stringWithFormat:@"%ld",(long)aCount] forState:UIControlStateNormal];
        [button setTitle:[NSString stringWithFormat:@"%ld",(long)aCount] forState:UIControlStateHighlighted];
    }else if (aCount > 9 && aCount <= 99){
        [button setHidden:NO];
        [button setBackgroundImage:[UIImage imageNamed:@"iconZhongdian_image"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"iconZhongdian_image"] forState:UIControlStateHighlighted];
        
        [button setFrame:CGRectMake(button.frame.origin.x, button.frame.origin.y, 20, 16)];
        [button setTitle:[NSString stringWithFormat:@"%ld",(long)aCount] forState:UIControlStateNormal];
        [button setTitle:[NSString stringWithFormat:@"%ld",(long)aCount] forState:UIControlStateHighlighted];
    }else if (aCount>99){
        [button setHidden:NO];
        [button setBackgroundImage:[UIImage imageNamed:@"iconbigDian_image"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"iconbigDian_image"] forState:UIControlStateHighlighted];
        [button setFrame:CGRectMake(button.frame.origin.x, button.frame.origin.y, 30, 16)];
        [button setTitle:@"99+" forState:UIControlStateNormal];
        [button setTitle:@"99+" forState:UIControlStateHighlighted];
    }
    return button;
}

@end
