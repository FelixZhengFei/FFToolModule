//
//  FFAlert.h
//  FFToolModule
//
//  Created by 郑强飞 on 2017/8/12.
//  Copyright © 2017年 郑强飞. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#import "FFAlertHelper.h"


/*
 *************************简要说明************************
 
 Alert 使用方法
 
 [FFAlert alert].cofing.XXXXX.XXXXX.FFShow();
 
 ActionSheet 使用方法
 
 [FFAlert actionSheet].cofing.XXXXX.XXXXX.FFShow();
 
 特性:
 - 支持alert类型与actionsheet类型
 - 默认样式为Apple风格 可自定义其样式
 - 支持自定义标题与内容 可动态调整其样式
 - 支持自定义视图添加 同时可设置位置类型等 自定义视图size改变时会自动适应.
 - 支持输入框添加 自动处理键盘相关的细节
 - 支持屏幕旋转适应 同时可自定义横竖屏最大宽度和高度
 - 支持自定义action添加 可动态调整其样式
 - 支持内部添加的功能项的间距范围设置等
 - 支持圆角设置 支持阴影效果设置
 - 支持队列和优先级 多个同时显示时根据优先级顺序排队弹出 添加到队列的如被高优先级覆盖 以后还会继续显示.
 - 支持两种背景样式 1.半透明 (支持自定义透明度比例和颜色) 2.毛玻璃 (支持效果类型)
 - 支持自定义UIView动画方法
 - 支持自定义打开关闭动画样式(动画方向 渐变过渡 缩放过渡等)
 - 更多特性未来版本中将不断更新.
 
 设置方法结束后在最后请不要忘记使用.FFShow()方法来显示.
 
 最低支持iOS8及以上
 
 *****************************************************
 */


@interface FFAlert : NSObject

/** 初始化 */

+ (FFAlertConfig *)alert;

+ (FFAlertConfig *)actionsheet;

/** 获取Alert窗口 */

+ (FFAlertWindow *)getAlertWindow;

/** 设置主窗口 */

+ (void)configMainWindow:(UIWindow *)window;

/** 继续队列显示 */

+ (void)continueQueueDisplay;

/** 清空队列 */

+ (void)clearQueue;

/** 关闭 */

+ (void)closeWithCompletionBlock:(void (^)())completionBlock;

@end

@interface FFAlertConfigModel : NSObject

/** ✨通用设置 */

/** 设置 标题 -> 格式: .FFTitle(@@"") */
@property (nonatomic , copy , readonly ) FFConfigToString FFTitle;

/** 设置 内容 -> 格式: .FFContent(@@"") */
@property (nonatomic , copy , readonly ) FFConfigToString FFContent;

/** 设置 自定义视图 -> 格式: .FFCustomView(UIView) */
@property (nonatomic , copy , readonly ) FFConfigToView FFCustomView;

/** 设置 动作 -> 格式: .FFAction(@"name" , ^{ //code.. }) */
@property (nonatomic , copy , readonly ) FFConfigToStringAndBlock FFAction;

/** 设置 取消动作 -> 格式: .FFCancelAction(@"name" , ^{ //code.. }) */
@property (nonatomic , copy , readonly ) FFConfigToStringAndBlock FFCancelAction;

/** 设置 取消动作 -> 格式: .FFDestructiveAction(@"name" , ^{ //code.. }) */
@property (nonatomic , copy , readonly ) FFConfigToStringAndBlock FFDestructiveAction;

/** 设置 添加标题 -> 格式: .FFConfigTitle(^(UILabel *label){ //code.. }) */
@property (nonatomic , copy , readonly ) FFConfigToConfigLabel FFAddTitle;

/** 设置 添加内容 -> 格式: .FFConfigContent(^(UILabel *label){ //code.. }) */
@property (nonatomic , copy , readonly ) FFConfigToConfigLabel FFAddContent;

/** 设置 添加自定义视图 -> 格式: .FFAddCustomView(^(FFCustomView *){ //code.. }) */
@property (nonatomic , copy , readonly ) FFConfigToCustomView FFAddCustomView;

/** 设置 添加一项 -> 格式: .FFAddItem(^(FFItem *){ //code.. }) */
@property (nonatomic , copy , readonly ) FFConfigToItem FFAddItem;

/** 设置 添加动作 -> 格式: .FFAddAction(^(FFAction *){ //code.. }) */
@property (nonatomic , copy , readonly ) FFConfigToAction FFAddAction;

/** 设置 头部内的间距 -> 格式: .FFHeaderInsets(UIEdgeInsetsMake(20, 20, 20, 20)) */
@property (nonatomic , copy , readonly ) FFConfigToEdgeInsets FFHeaderInsets;

/** 设置 上一项的间距 (在它之前添加的项的间距) -> 格式: .FFItemInsets(UIEdgeInsetsMake(5, 0, 5, 0)) */
@property (nonatomic , copy , readonly ) FFConfigToEdgeInsets FFItemInsets;

/** 设置 最大宽度 -> 格式: .FFMaxWidth(280.0f) */
@property (nonatomic , copy , readonly ) FFConfigToFloat FFMaxWidth;

/** 设置 最大高度 -> 格式: .FFMaxHeight(400.0f) */
@property (nonatomic , copy , readonly ) FFConfigToFloat FFMaxHeight;

/** 设置 设置最大宽度 -> 格式: .FFConfigMaxWidth(CGFloat(^)(^CGFloat(FFScreenOrientationType type) { return 280.0f; }) */
@property (nonatomic , copy , readonly ) FFConfigToFloatBlock FFConfigMaxWidth;

/** 设置 设置最大高度 -> 格式: .FFConfigMaxHeight(CGFloat(^)(^CGFloat(FFScreenOrientationType type) { return 600.0f; }) */
@property (nonatomic , copy , readonly ) FFConfigToFloatBlock FFConfigMaxHeight;

/** 设置 圆角半径 -> 格式: .FFCornerRadius(13.0f) */
@property (nonatomic , copy , readonly ) FFConfigToFloat FFCornerRadius;

/** 设置 阴影不透明 -> 格式: .FFShadowOpacity(0.3f) */
@property (nonatomic , copy , readonly ) FFConfigToFloat FFShadowOpacity;

/** 设置 开启动画时长 -> 格式: .FFOpenAnimationDuration(0.3f) */
@property (nonatomic , copy , readonly ) FFConfigToFloat FFOpenAnimationDuration;

/** 设置 关闭动画时长 -> 格式: .FFCloseAnimationDuration(0.2f) */
@property (nonatomic , copy , readonly ) FFConfigToFloat FFCloseAnimationDuration;

/** 设置 颜色 -> 格式: .FFHeaderColor(UIColor) */
@property (nonatomic , copy , readonly ) FFConfigToColor FFHeaderColor;

/** 设置 背景颜色 -> 格式: .FFBackGroundColor(UIColor) */
@property (nonatomic , copy , readonly ) FFConfigToColor FFBackGroundColor;

/** 设置 半透明背景样式及透明度 [默认] -> 格式: .FFBackgroundStyleTranslucent(0.45f) */
@property (nonatomic , copy , readonly ) FFConfigToFloat FFBackgroundStyleTranslucent;

/** 设置 模糊背景样式及类型 -> 格式: .FFBackgroundStyleBlur(UIBlurEffectStyleDark) */
@property (nonatomic , copy , readonly ) FFConfigToBlurEffectStyle FFBackgroundStyleBlur;

/** 设置 点击头部关闭 -> 格式: .FFClickHeaderClose(YES) */
@property (nonatomic , copy , readonly ) FFConfigToBool FFClickHeaderClose;

/** 设置 点击背景关闭 -> 格式: .FFClickBackgroundClose(YES) */
@property (nonatomic , copy , readonly ) FFConfigToBool FFClickBackgroundClose;

/** 设置 标识 -> 格式: .FFIdentifier(@@"ident") */
@property (nonatomic , copy , readonly ) FFConfigToString FFIdentifier;

/** 设置 是否加入到队列 -> 格式: .FFQueue(YES) */
@property (nonatomic , copy , readonly ) FFConfigToBool FFQueue;

/** 设置 优先级 -> 格式: .FFPriority(1000) */
@property (nonatomic , copy , readonly ) FFConfigToInteger FFPriority;

/** 设置 是否继续队列显示 -> 格式: .FFContinueQueue(YES) */
@property (nonatomic , copy , readonly ) FFConfigToBool FFContinueQueueDisplay;

/** 设置 window等级 -> 格式: .FFWindowLevel(UIWindowLevel) */
@property (nonatomic , copy , readonly ) FFConfigToFloat FFWindowLevel;

/** 设置 是否支持自动旋转 -> 格式: .FFShouldAutorotate(YES) */
@property (nonatomic , copy , readonly ) FFConfigToBool FFShouldAutorotate;

/** 设置 是否支持显示方向 -> 格式: .FFShouldAutorotate(UIInterfaceOrientationMaskAll) */
@property (nonatomic , copy , readonly ) FFConfigToInterfaceOrientationMask FFSupportedInterfaceOrientations;

/** 设置 打开动画配置 -> 格式: .FFOpenAnimationConfig(^(void (^animatingBlock)(void), void (^animatedBlock)(void)) { //code.. }) */
@property (nonatomic , copy , readonly ) FFConfigToBlockAndBlock FFOpenAnimationConfig;

/** 设置 关闭动画配置 -> 格式: .FFCloseAnimationConfig(^(void (^animatingBlock)(void), void (^animatedBlock)(void)) { //code.. }) */
@property (nonatomic , copy , readonly ) FFConfigToBlockAndBlock FFCloseAnimationConfig;

/** 设置 打开动画样式 -> 格式: .FFOpenAnimationStyle() */
@property (nonatomic , copy , readonly ) FFConfigToAnimationStyle FFOpenAnimationStyle;

/** 设置 关闭动画样式 -> 格式: .FFCloseAnimationStyle() */
@property (nonatomic , copy , readonly ) FFConfigToAnimationStyle FFCloseAnimationStyle;


/** 显示  -> 格式: .FFShow() */
@property (nonatomic , copy , readonly ) FFConfig FFShow;

/** ✨alert 专用设置 */

/** 设置 添加输入框 -> 格式: .FFAddTextField(^(UITextField *){ //code.. }) */
@property (nonatomic , copy , readonly ) FFConfigToConfigTextField FFAddTextField;

/** 设置 是否闪避键盘 -> 格式: .FFAvoidKeyboard(YES) */
@property (nonatomic , copy , readonly ) FFConfigToBool FFAvoidKeyboard;

/** ✨actionSheet 专用设置 */

/** 设置 取消动作的间隔宽度 -> 格式: .FFActionSheetCancelActionSpaceWidth(10.0f) */
@property (nonatomic , copy , readonly ) FFConfigToFloat FFActionSheetCancelActionSpaceWidth;

/** 设置 取消动作的间隔颜色 -> 格式: .FFActionSheetCancelActionSpaceColor(UIColor) */
@property (nonatomic , copy , readonly ) FFConfigToColor FFActionSheetCancelActionSpaceColor;

/** 设置 ActionSheet距离屏幕底部的间距 -> 格式: .FFActionSheetBottomMargin(10.0f) */
@property (nonatomic , copy , readonly ) FFConfigToFloat FFActionSheetBottomMargin;



/** 设置 当前关闭回调 -> 格式: .FFCloseComplete(^{ //code.. }) */
@property (nonatomic , copy , readonly ) FFConfigToBlock FFCloseComplete;

@end


@interface FFItem : NSObject

/** item类型 */
@property (nonatomic , assign ) FFItemType type;

/** item间距范围 */
@property (nonatomic , assign ) UIEdgeInsets insets;

/** item设置视图Block */
@property (nonatomic , copy ) void (^block)(id view);

- (void)update;

@end

@interface FFAction : NSObject

/** action类型 */
@property (nonatomic , assign ) FFActionType type;

/** action标题 */
@property (nonatomic , strong ) NSString *title;

/** action高亮标题 */
@property (nonatomic , strong ) NSString *highlight;

/** action标题(attributed) */
@property (nonatomic , strong ) NSAttributedString *attributedTitle;

/** action高亮标题(attributed) */
@property (nonatomic , strong ) NSAttributedString *attributedHighlight;

/** action字体 */
@property (nonatomic , strong ) UIFont *font;

/** action标题颜色 */
@property (nonatomic , strong ) UIColor *titleColor;

/** action高亮标题颜色 */
@property (nonatomic , strong ) UIColor *highlightColor;

/** action背景颜色 */
@property (nonatomic , strong ) UIColor *backgroundColor;

/** action高亮背景颜色 */
@property (nonatomic , strong ) UIColor *backgroundHighlightColor;

/** action图片 */
@property (nonatomic , strong ) UIImage *image;

/** action高亮图片 */
@property (nonatomic , strong ) UIImage *highlightImage;

/** action间距范围 */
@property (nonatomic , assign ) UIEdgeInsets insets;

/** action图片的间距范围 */
@property (nonatomic , assign ) UIEdgeInsets imageEdgeInsets;

/** action标题的间距范围 */
@property (nonatomic , assign ) UIEdgeInsets titFFdgeInsets;

/** action圆角曲率 */
@property (nonatomic , assign ) CGFloat cornerRadius;

/** action高度 */
@property (nonatomic , assign ) CGFloat height;

/** action边框宽度 */
@property (nonatomic , assign ) CGFloat borderWidth;

/** action边框颜色 */
@property (nonatomic , strong ) UIColor *borderColor;

/** action边框位置 */
@property (nonatomic , assign ) FFActionBorderPosition borderPosition;

/** action点击不关闭 (仅适用于默认类型) */
@property (nonatomic , assign ) BOOL isClickNotClose;

/** action点击事件回调Block */
@property (nonatomic , copy ) void (^clickBlock)();

- (void)update;

@end

@interface FFCustomView : NSObject

/** 自定义视图对象 */
@property (nonatomic , strong ) UIView *view;

/** 自定义视图位置类型 (默认为居中) */
@property (nonatomic , assign ) FFCustomViewPositionType positionType;

/** 是否自动适应宽度 */
@property (nonatomic , assign ) BOOL isAutoWidth;

@end


@interface FFAlertConfig : NSObject

@property (nonatomic , strong ) FFAlertConfigModel *config;

@property (nonatomic , assign ) FFAlertType type;

@end


@interface FFAlertWindow : UIWindow @end

@interface FFBaseViewController : UIViewController @end

@interface FFAlertViewController : FFBaseViewController @end

@interface FFActionSheetViewController : FFBaseViewController @end
