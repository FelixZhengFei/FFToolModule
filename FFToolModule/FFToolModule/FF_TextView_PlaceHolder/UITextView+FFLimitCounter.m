//
//  UITextView+FFLimitCounter.m
//  FFToolModule
//
//  Created by 郑强飞 on 2017/8/12.
//  Copyright © 2017年 郑强飞. All rights reserved.
//

#import "UITextView+FFLimitCounter.h"
#import <objc/runtime.h>

static char limitCountKey;
static char labMarginKey;
static char labHeightKey;
@implementation UITextView (FFLimitCounter)

+ (void)load {
    [super load];
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"layoutSubviews")),
                                   class_getInstanceMethod(self.class, @selector(FFLimitCounter_swizzling_layoutSubviews)));
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc")),
                                   class_getInstanceMethod(self.class, @selector(FFLimitCounter_swizzled_dealloc)));
}

#pragma mark - swizzled

- (void)FFLimitCounter_swizzled_dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    @try {
        [self removeObserver:self forKeyPath:@"layer.borderWidth"];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    [self FFLimitCounter_swizzled_dealloc];
}

- (void)FFLimitCounter_swizzling_layoutSubviews {
    [self FFLimitCounter_swizzling_layoutSubviews];
    if (self.ff_limitCount) {
        UIEdgeInsets textContainerInset = self.textContainerInset;
        textContainerInset.bottom = self.ff_labHeight;
        self.contentInset = textContainerInset;
        CGFloat x = CGRectGetMinX(self.frame)+self.layer.borderWidth;
        CGFloat y = CGRectGetMaxY(self.frame)-self.contentInset.bottom-self.layer.borderWidth;
        CGFloat width = CGRectGetWidth(self.bounds)-self.layer.borderWidth*2;
        CGFloat height = self.ff_labHeight;
        self.ff_inputLimitLabel.frame = CGRectMake(x, y, width, height);
        if ([self.superview.subviews containsObject:self.ff_inputLimitLabel]) {
            return;
        }
        [self.superview insertSubview:self.ff_inputLimitLabel aboveSubview:self];
    }
}

#pragma mark - associated

- (NSInteger)ff_limitCount {
    return [objc_getAssociatedObject(self, &limitCountKey) integerValue];
}

- (void)setFf_limitCount:(NSInteger)ff_limitCount {
    objc_setAssociatedObject(self, &limitCountKey, @(ff_limitCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self updateLimitCount];
}

- (CGFloat)ff_labMargin {
    return [objc_getAssociatedObject(self, &labMarginKey) floatValue];
}

- (void)setFf_labMargin:(CGFloat)ff_labMargin {
    objc_setAssociatedObject(self, &labMarginKey, @(ff_labMargin), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self updateLimitCount];
}

- (CGFloat)ff_labHeight {
    return [objc_getAssociatedObject(self, &labHeightKey) floatValue];
}

- (void)setFf_labHeight:(CGFloat)ff_labHeight {
    objc_setAssociatedObject(self, &labHeightKey, @(ff_labHeight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self updateLimitCount];
}

#pragma mark -config

- (void)configTextView {
    self.ff_labHeight = 20;
    self.ff_labMargin = 10;
}

#pragma mark - update

- (void)updateLimitCount {
    if (self.text.length>self.ff_limitCount) {
        self.text = [self.text substringToIndex:self.ff_limitCount];
    }
    NSString *showText = [NSString stringWithFormat:@"%lu/%ld",(unsigned long)self.text.length,(long)self.ff_limitCount];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString
                                              alloc] initWithString:showText];
    NSUInteger length = [showText length];
    NSMutableParagraphStyle *
    style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.tailIndent = -self.ff_labMargin; //设置与尾部的距离
    style.alignment = NSTextAlignmentRight;//靠右显示
    [attrString addAttribute:NSParagraphStyleAttributeName value:style
                       range:NSMakeRange(0, length)];
    self.ff_inputLimitLabel.attributedText = attrString;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"layer.borderWidth"]) {
        [self updateLimitCount];
    }
}

#pragma mark - lazzing

- (UILabel *)ff_inputLimitLabel {
    UILabel *label = objc_getAssociatedObject(self, @selector(ff_inputLimitLabel));
    if (!label) {
        label = [[UILabel alloc] init];
        label.backgroundColor = self.backgroundColor;
        label.textColor = [UIColor lightGrayColor];
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont systemFontOfSize:12];
        objc_setAssociatedObject(self, @selector(ff_inputLimitLabel), label, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateLimitCount)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:self];
        [self addObserver:self forKeyPath:@"layer.borderWidth" options:NSKeyValueObservingOptionNew context:nil];
        [self configTextView];
    }
    return label;
}


@end



