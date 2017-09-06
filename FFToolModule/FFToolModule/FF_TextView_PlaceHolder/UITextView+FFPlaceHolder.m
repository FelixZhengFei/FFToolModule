//
//  UITextView+FFPlaceHolder.m
//  FFToolModule
//
//  Created by 郑强飞 on 2017/8/12.
//  Copyright © 2017年 郑强飞. All rights reserved.
//

#import "UITextView+FFPlaceHolder.h"
#import <objc/runtime.h>

static const void *ff_placeHolderKey;

@implementation UITextView (FFPlaceHolder)

+ (void)load {
    [super load];
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"layoutSubviews")),
                                   class_getInstanceMethod(self.class, @selector(ffPlaceHolder_swizzling_layoutSubviews)));
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc")),
                                   class_getInstanceMethod(self.class, @selector(ffPlaceHolder_swizzled_dealloc)));
}

#pragma mark - swizzled

- (void)ffPlaceHolder_swizzled_dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self ffPlaceHolder_swizzled_dealloc];
}

- (void)ffPlaceHolder_swizzling_layoutSubviews {
    if (self.ff_placeHolder) {
        UIEdgeInsets textContainerInset = self.textContainerInset;
        CGFloat lineFragmentPadding = self.textContainer.lineFragmentPadding;
        CGFloat x = lineFragmentPadding + textContainerInset.left + self.layer.borderWidth;
        CGFloat y = textContainerInset.top + self.layer.borderWidth;
        CGFloat width = CGRectGetWidth(self.bounds) - x - textContainerInset.right - 2*self.layer.borderWidth;
        CGFloat height = [self.ff_placeHolderLabel sizeThatFits:CGSizeMake(width, 0)].height;
        self.ff_placeHolderLabel.frame = CGRectMake(x, y, width, height);
    }
    [self ffPlaceHolder_swizzling_layoutSubviews];
}

#pragma mark - associated

- (NSString *)ff_placeHolder {
    return objc_getAssociatedObject(self, &ff_placeHolderKey);
}

- (void)setFf_placeHolder:(NSString *)ff_placeHolder{
    objc_setAssociatedObject(self, &ff_placeHolderKey, ff_placeHolder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self updatePlaceHolder];
}

- (UIColor *)ff_placeHolderColor {
    return self.ff_placeHolderLabel.textColor;
}

- (void)setFf_placeHolderColor:(UIColor *)ff_placeHolderColor{
    self.ff_placeHolderLabel.textColor = ff_placeHolderColor;
}

#pragma mark - update

- (void)updatePlaceHolder {
    if (self.text.length) {
        [self.ff_placeHolderLabel removeFromSuperview];
        return;
    }
    self.ff_placeHolderLabel.font = self.font?self.font:self.cacutDefaultFont;
    self.ff_placeHolderLabel.textAlignment = self.textAlignment;
    self.ff_placeHolderLabel.text = self.ff_placeHolder;
    [self insertSubview:self.ff_placeHolderLabel atIndex:0];
}

#pragma mark - lazzing

- (UILabel *)ff_placeHolderLabel {
    UILabel *placeHolderLab = objc_getAssociatedObject(self, @selector(ff_placeHolderLabel));
    if (!placeHolderLab) {
        placeHolderLab = [[UILabel alloc] init];
        placeHolderLab.numberOfLines = 0;
        placeHolderLab.textColor = [UIColor lightGrayColor];
        objc_setAssociatedObject(self, @selector(ff_placeHolderLabel), placeHolderLab, OBJC_ASSOCIATION_RETAIN);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePlaceHolder) name:UITextViewTextDidChangeNotification object:self];
    }
    return placeHolderLab;
}

- (UIFont *)cacutDefaultFont {
    static UIFont *font = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UITextView *textview = [[UITextView alloc] init];
        textview.text = @" ";
        font = textview.font;
    });
    return font;
}




@end




