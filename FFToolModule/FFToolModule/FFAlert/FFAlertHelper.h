//
//  FFAlertHelper.h
//  FFToolModule
//
//  Created by 郑强飞 on 2017/8/12.
//  Copyright © 2017年 郑强飞. All rights reserved.
//

#ifndef FFAlertHelper_h
#define FFAlertHelper_h

FOUNDATION_EXPORT double FFAlertVersionNumber;
FOUNDATION_EXPORT const unsigned char FFAlertVersionString[];

@class FFAlert , FFAlertConfig , FFAlertConfigModel , FFAlertWindow , FFAction , FFItem , FFCustomView;

typedef NS_ENUM(NSInteger, FFScreenOrientationType) {
    /** 屏幕方向类型 横屏 */
    FFScreenOrientationTypeHorizontal,
    /** 屏幕方向类型 竖屏 */
    FFScreenOrientationTypeVertical
};


typedef NS_ENUM(NSInteger, FFAlertType) {
    
    FFAlertTypeAlert,
    
    FFAlertTypeActionSheet
};


typedef NS_ENUM(NSInteger, FFActionType) {
    /** 默认 */
    FFActionTypeDefault,
    /** 取消 */
    FFActionTypeCancel,
    /** 销毁 */
    FFActionTypeDestructive
};


typedef NS_OPTIONS(NSInteger, FFActionBorderPosition) {
    /** Action边框位置 上 */
    FFActionBorderPositionTop      = 1 << 0,
    /** Action边框位置 下 */
    FFActionBorderPositionBottom   = 1 << 1,
    /** Action边框位置 左 */
    FFActionBorderPositionLeft     = 1 << 2,
    /** Action边框位置 右 */
    FFActionBorderPositionRight    = 1 << 3
};


typedef NS_ENUM(NSInteger, FFItemType) {
    /** 标题 */
    FFItemTypeTitle,
    /** 内容 */
    FFItemTypeContent,
    /** 输入框 */
    FFItemTypeTextField,
    /** 自定义视图 */
    FFItemTypeCustomView,
};


typedef NS_ENUM(NSInteger, FFCustomViewPositionType) {
    /** 居中 */
    FFCustomViewPositionTypeCenter,
    /** 靠左 */
    FFCustomViewPositionTypeLeft,
    /** 靠右 */
    FFCustomViewPositionTypeRight
};

typedef NS_OPTIONS(NSInteger, FFAnimationStyle) {
    /** 动画样式方向 默认 */
    FFAnimationStyleOrientationNone    = 1 << 0,
    /** 动画样式方向 上 */
    FFAnimationStyleOrientationTop     = 1 << 1,
    /** 动画样式方向 下 */
    FFAnimationStyleOrientationBottom  = 1 << 2,
    /** 动画样式方向 左 */
    FFAnimationStyleOrientationLeft    = 1 << 3,
    /** 动画样式方向 右 */
    FFAnimationStyleOrientationRight   = 1 << 4,
    
    /** 动画样式 淡入淡出 */
    FFAnimationStyleFade               = 1 << 12,
    
    /** 动画样式 缩放 放大 */
    FFAnimationStyleZoomEnlarge        = 1 << 24,
    /** 动画样式 缩放 缩小 */
    FFAnimationStyleZoomShrink         = 2 << 24,
};

typedef FFAlertConfigModel *(^FFConfig)();
typedef FFAlertConfigModel *(^FFConfigToBool)(BOOL is);
typedef FFAlertConfigModel *(^FFConfigToInteger)(NSInteger number);
typedef FFAlertConfigModel *(^FFConfigToFloat)(CGFloat number);
typedef FFAlertConfigModel *(^FFConfigToString)(NSString *str);
typedef FFAlertConfigModel *(^FFConfigToView)(UIView *view);
typedef FFAlertConfigModel *(^FFConfigToColor)(UIColor *color);
typedef FFAlertConfigModel *(^FFConfigToEdgeInsets)(UIEdgeInsets insets);
typedef FFAlertConfigModel *(^FFConfigToAnimationStyle)(FFAnimationStyle style);
typedef FFAlertConfigModel *(^FFConfigToBlurEffectStyle)(UIBlurEffectStyle style);
typedef FFAlertConfigModel *(^FFConfigToInterfaceOrientationMask)(UIInterfaceOrientationMask);
typedef FFAlertConfigModel *(^FFConfigToFloatBlock)(CGFloat(^)(FFScreenOrientationType type));
typedef FFAlertConfigModel *(^FFConfigToAction)(void(^)(FFAction *action));
typedef FFAlertConfigModel *(^FFConfigToCustomView)(void(^)(FFCustomView *custom));
typedef FFAlertConfigModel *(^FFConfigToStringAndBlock)(NSString *str , void (^)());
typedef FFAlertConfigModel *(^FFConfigToConfigLabel)(void(^)(UILabel *label));
typedef FFAlertConfigModel *(^FFConfigToConfigTextField)(void(^)(UITextField *textField));
typedef FFAlertConfigModel *(^FFConfigToItem)(void(^)(FFItem *item));
typedef FFAlertConfigModel *(^FFConfigToBlock)(void(^block)());
typedef FFAlertConfigModel *(^FFConfigToBlockAndBlock)(void(^)(void (^animatingBlock)() , void (^animatedBlock)()));

#endif /* FFAlertHelper_h */
