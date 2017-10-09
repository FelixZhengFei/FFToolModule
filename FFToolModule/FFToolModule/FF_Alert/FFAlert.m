//
//  FFAlert.m
//  FFToolModule
//
//  Created by 郑强飞 on 2017/8/12.
//  Copyright © 2017年 郑强飞. All rights reserved.
//

#import "FFAlert.h"

#import <Accelerate/Accelerate.h>

#import <objc/runtime.h>

#define IS_IPAD ({ UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 1 : 0; })
#define SCREEN_WIDTH CGRectGetWidth([[UIScreen mainScreen] bounds])
#define SCREEN_HEIGHT CGRectGetHeight([[UIScreen mainScreen] bounds])
#define VIEW_WIDTH CGRectGetWidth(self.view.frame)
#define VIEW_HEIGHT CGRectGetHeight(self.view.frame)
#define DEFAULTBORDERWIDTH (1.0f / [[UIScreen mainScreen] scale] + 0.02f)

#pragma mark - ===================配置模型===================

typedef NS_ENUM(NSInteger, FFBackgroundStyle) {
    /** 背景样式 模糊 */
    FFBackgroundStyleBlur,
    /** 背景样式 半透明 */
    FFBackgroundStyleTranslucent,
};

@interface FFAlertConfigModel ()

@property (nonatomic , strong ) NSMutableArray *modelActionArray;
@property (nonatomic , strong ) NSMutableArray *modelItemArray;
@property (nonatomic , strong ) NSMutableDictionary *modelItemInsetsInfo;

@property (nonatomic , assign ) CGFloat modelCornerRadius;
@property (nonatomic , assign ) CGFloat modelShadowOpacity;
@property (nonatomic , assign ) CGFloat modelOpenAnimationDuration;
@property (nonatomic , assign ) CGFloat modelCloseAnimationDuration;
@property (nonatomic , assign ) CGFloat modelBackgroundStyleColorAlpha;
@property (nonatomic , assign ) CGFloat modelWindowLevel;
@property (nonatomic , assign ) NSInteger modelQueuePriority;

@property (nonatomic , strong ) UIColor *modelHeaderColor;
@property (nonatomic , strong ) UIColor *modelBackgroundColor;

@property (nonatomic , assign ) BOOL modelIsClickHeaderClose;
@property (nonatomic , assign ) BOOL modelIsClickBackgroundClose;
@property (nonatomic , assign ) BOOL modelIsShouldAutorotate;
@property (nonatomic , assign ) BOOL modelIsQueue;
@property (nonatomic , assign ) BOOL modelIsContinueQueueDisplay;
@property (nonatomic , assign ) BOOL modelIsAvoidKeyboard;

@property (nonatomic , assign ) UIEdgeInsets modelHeaderInsets;

@property (nonatomic , copy ) NSString *modelIdentifier;

@property (nonatomic , copy ) CGFloat (^modelMaxWidthBlock)(FFScreenOrientationType);
@property (nonatomic , copy ) CGFloat (^modelMaxHeightBlock)(FFScreenOrientationType);

@property (nonatomic , copy ) void(^modelOpenAnimationConfigBlock)(void (^animatingBlock)(void) , void (^animatedBlock)(void));
@property (nonatomic , copy ) void(^modelCloseAnimationConfigBlock)(void (^animatingBlock)(void) , void (^animatedBlock)(void));
@property (nonatomic , copy ) void (^modelFinishConfig)(void);
@property (nonatomic , copy ) void (^modelCloseComplete)(void);

@property (nonatomic , assign ) FFBackgroundStyle modelBackgroundStyle;
@property (nonatomic , assign ) FFAnimationStyle modelOpenAnimationStyle;
@property (nonatomic , assign ) FFAnimationStyle modelCloseAnimationStyle;

@property (nonatomic , assign ) UIBlurEffectStyle modelBackgroundBlurEffectStyle;
@property (nonatomic , assign ) UIInterfaceOrientationMask modelSupportedInterfaceOrientations;

@property (nonatomic , strong ) UIColor *modelActionSheetCancelActionSpaceColor;
@property (nonatomic , assign ) CGFloat modelActionSheetCancelActionSpaceWidth;
@property (nonatomic , assign ) CGFloat modelActionSheetBottomMargin;

@end

@implementation FFAlertConfigModel

- (void)dealloc{
    
    _modelActionArray = nil;
    _modelItemArray = nil;
    _modelItemInsetsInfo = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        // 初始化默认值
        
        _modelCornerRadius = 13.0f; //默认圆角半径
        _modelShadowOpacity = 0.3f; //默认阴影不透明度
        _modelHeaderInsets = UIEdgeInsetsMake(20.0f, 20.0f, 20.0f, 20.0f); //默认间距
        _modelOpenAnimationDuration = 0.3f; //默认打开动画时长
        _modelCloseAnimationDuration = 0.2f; //默认关闭动画时长
        _modelBackgroundStyleColorAlpha = 0.45f; //自定义背景样式颜色透明度 默认为半透明背景样式 透明度为0.45f
        _modelWindowLevel = UIWindowLevelAlert;
        _modelQueuePriority = 0; //默认队列优先级 (大于0时才会加入队列)
        
        
        _modelActionSheetCancelActionSpaceColor = [UIColor clearColor]; //默认actionsheet取消按钮间隔颜色
        _modelActionSheetCancelActionSpaceWidth = 10.0f; //默认actionsheet取消按钮间隔宽度
        _modelActionSheetBottomMargin = 10.0f; //默认actionsheet距离屏幕底部距离
        
        _modelHeaderColor = [UIColor whiteColor]; //默认颜色
        _modelBackgroundColor = [UIColor blackColor]; //默认背景半透明颜色
        
        _modelIsClickBackgroundClose = NO; //默认点击背景不关闭
        _modelIsShouldAutorotate = YES; //默认支持自动旋转
        _modelIsQueue = NO; //默认不加入队列
        _modelIsContinueQueueDisplay = YES; //默认继续队列显示
        _modelIsAvoidKeyboard = YES; //默认闪避键盘
        
        _modelBackgroundStyle = FFBackgroundStyleTranslucent; //默认为半透明背景样式
        
        _modelBackgroundBlurEffectStyle = UIBlurEffectStyleDark; //默认模糊效果类型Dark
        _modelSupportedInterfaceOrientations = UIInterfaceOrientationMaskAll; //默认支持所有方向
        
        __weak typeof(self) weakSelf = self;
        
        _modelOpenAnimationConfigBlock = ^(void (^animatingBlock)(void), void (^animatedBlock)(void)) {
            
            [UIView animateWithDuration:weakSelf.modelOpenAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                if (animatingBlock) animatingBlock();
                
            } completion:^(BOOL finished) {
                
                if (animatedBlock) animatedBlock();
            }];
            
        };
        
        _modelCloseAnimationConfigBlock = ^(void (^animatingBlock)(void), void (^animatedBlock)(void)) {
            
            [UIView animateWithDuration:weakSelf.modelCloseAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                if (animatingBlock) animatingBlock();
                
            } completion:^(BOOL finished) {
                
                if (animatedBlock) animatedBlock();
            }];
            
        };

        
    }
    return self;
}

- (FFConfigToString)FFTitle{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *str){
        
        return weakSelf.FFAddTitle(^(UILabel *label) {
            
            label.text = str;
        });
        
    };
    
}


- (FFConfigToString)FFContent{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *str){
        
        return  weakSelf.FFAddContent(^(UILabel *label) {
            
            label.text = str;
        });

    };
    
}

- (FFConfigToView)FFCustomView{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIView *view){
        
        return weakSelf.FFAddCustomView(^(FFCustomView *custom) {
            
            custom.view = view;
            
            custom.positionType = FFCustomViewPositionTypeCenter;
        });
        
    };
    
}

- (FFConfigToStringAndBlock)FFAction{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *title , void(^block)(void)){
        
        return weakSelf.FFAddAction(^(FFAction *action) {
            
            action.type = FFActionTypeDefault;
            
            action.title = title;
            
            action.clickBlock = block;
        });
        
    };
    
}

- (FFConfigToStringAndBlock)FFCancelAction{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *title , void(^block)(void)){
        
        return weakSelf.FFAddAction(^(FFAction *action) {
            
            action.type = FFActionTypeCancel;
            
            action.title = title;
            
            action.font = [UIFont boldSystemFontOfSize:18.0f];
            
            action.clickBlock = block;
        });
        
    };
    
}

- (FFConfigToStringAndBlock)FFDestructiveAction{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *title , void(^block)(void)){
        
        return weakSelf.FFAddAction(^(FFAction *action) {
            
            action.type = FFActionTypeDestructive;
            
            action.title = title;
            
            action.titleColor = [UIColor redColor];
            
            action.clickBlock = block;
        });
        
    };
    
}

- (FFConfigToConfigLabel)FFAddTitle{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^block)(UILabel *)){
        
        return weakSelf.FFAddItem(^(FFItem *item) {
            
            item.type = FFItemTypeTitle;
            
            item.insets = UIEdgeInsetsMake(5, 0, 5, 0);
            
            item.block = block;
        });
        ;
    };
    
}

- (FFConfigToConfigLabel)FFAddContent{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^block)(UILabel *)){
        
        return weakSelf.FFAddItem(^(FFItem *item) {
            
            item.type = FFItemTypeContent;
            
            item.insets = UIEdgeInsetsMake(5, 0, 5, 0);
            
            item.block = block;
        });
        
    };
    
}

- (FFConfigToCustomView)FFAddCustomView{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^block)(FFCustomView *custom)){
        
        return weakSelf.FFAddItem(^(FFItem *item) {
            
            item.type = FFItemTypeCustomView;
            
            item.insets = UIEdgeInsetsMake(5, 0, 5, 0);
            
            item.block = block;
        });
        
    };
    
}

- (FFConfigToItem)FFAddItem{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^block)(FFItem *)){
        
        if (weakSelf) if (block) [weakSelf.modelItemArray addObject:block];
        
        return weakSelf;
    };
    
}

- (FFConfigToAction)FFAddAction{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^block)(FFAction *)){
        
        if (weakSelf) if (block) [weakSelf.modelActionArray addObject:block];
        
        return weakSelf;
    };
    
}

- (FFConfigToEdgeInsets)FFHeaderInsets{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIEdgeInsets insets){
        
        if (weakSelf) {
            
            if (insets.top < 0) insets.top = 0;
            
            if (insets.left < 0) insets.left = 0;
            
            if (insets.bottom < 0) insets.bottom = 0;
            
            if (insets.right < 0) insets.right = 0;
            
            weakSelf.modelHeaderInsets = insets;
        }
        
        return weakSelf;
    };
    
}

- (FFConfigToEdgeInsets)FFItemInsets{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIEdgeInsets insets){
        
        if (weakSelf) {
            
            if (weakSelf.modelItemArray.count) {
                
                if (insets.top < 0) insets.top = 0;
                
                if (insets.left < 0) insets.left = 0;
                
                if (insets.bottom < 0) insets.bottom = 0;
                
                if (insets.right < 0) insets.right = 0;
                
                [weakSelf.modelItemInsetsInfo setObject:[NSValue valueWithUIEdgeInsets:insets] forKey:@(weakSelf.modelItemArray.count - 1)];
                
            } else {
                
                NSAssert(YES, @"请在添加的某一项后面设置间距");
            }
            
        }
        
        return weakSelf;
    };
    
}

- (FFConfigToFloat)FFMaxWidth{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        return weakSelf.FFConfigMaxWidth(^CGFloat(FFScreenOrientationType type) {
            
            return number;
        });
        
    };
    
}

- (FFConfigToFloat)FFMaxHeight{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        return weakSelf.FFConfigMaxHeight(^CGFloat(FFScreenOrientationType type) {
            
            return number;
        });
        
    };
    
}

- (FFConfigToFloatBlock)FFConfigMaxWidth{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat(^block)(FFScreenOrientationType type)){
        
        if (weakSelf) if (block) weakSelf.modelMaxWidthBlock = block;
        
        return weakSelf;
    };
    
}

- (FFConfigToFloatBlock)FFConfigMaxHeight{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat(^block)(FFScreenOrientationType type)){
        
        if (weakSelf) if (block) weakSelf.modelMaxHeightBlock = block;
        
        return weakSelf;
    };
    
}

- (FFConfigToFloat)FFCornerRadius{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) weakSelf.modelCornerRadius = number;
        
        return weakSelf;
    };
    
}

- (FFConfigToFloat)FFShadowOpacity{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) weakSelf.modelShadowOpacity = number;
        
        return weakSelf;
    };
    
}

- (FFConfigToFloat)FFOpenAnimationDuration{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) weakSelf.modelOpenAnimationDuration = number;
        
        return weakSelf;
    };
    
}

- (FFConfigToFloat)FFCloseAnimationDuration{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) weakSelf.modelCloseAnimationDuration = number;
        
        return weakSelf;
    };
    
}

- (FFConfigToColor)FFHeaderColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIColor *color){
        
        if (weakSelf) weakSelf.modelHeaderColor = color;
        
        return weakSelf;
    };
    
}

- (FFConfigToColor)FFBackGroundColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIColor *color){
        
        if (weakSelf) weakSelf.modelBackgroundColor = color;
        
        return weakSelf;
    };
    
}

- (FFConfigToFloat)FFBackgroundStyleTranslucent{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) {
            
            weakSelf.modelBackgroundStyle = FFBackgroundStyleTranslucent;
            
            weakSelf.modelBackgroundStyleColorAlpha = number;
        }
        
        return weakSelf;
    };
    
}

- (FFConfigToBlurEffectStyle)FFBackgroundStyleBlur{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIBlurEffectStyle style){
        
        if (weakSelf) {
            
            weakSelf.modelBackgroundStyle = FFBackgroundStyleBlur;
            
            weakSelf.modelBackgroundBlurEffectStyle = style;
        }
        
        return weakSelf;
    };
    
}

- (FFConfigToBool)FFClickHeaderClose{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(BOOL is){
        
        if (weakSelf) weakSelf.modelIsClickHeaderClose = is;
        
        return weakSelf;
    };
    
}

- (FFConfigToBool)FFClickBackgroundClose{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(BOOL is){
        
        if (weakSelf) weakSelf.modelIsClickBackgroundClose = is;
        
        return weakSelf;
    };
    
}

- (FFConfigToString)FFIdentifier{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSString *string){
        
        if (weakSelf) weakSelf.modelIdentifier = string;
        
        return weakSelf;
    };
    
}

- (FFConfigToBool)FFQueue{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(BOOL is){
        
        if (weakSelf) weakSelf.modelIsQueue = is;
        
        return weakSelf;
    };
    
}

- (FFConfigToInteger)FFPriority{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(NSInteger number){
        
        if (weakSelf) weakSelf.modelQueuePriority = number > 0 ? number : 0;
        
        return weakSelf;
    };
    
}

- (FFConfigToBool)FFContinueQueueDisplay{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(BOOL is){
        
        if (weakSelf) weakSelf.modelIsContinueQueueDisplay = is;
        
        return weakSelf;
    };
    
}

- (FFConfigToFloat)FFWindowLevel{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) weakSelf.modelWindowLevel = number;
        
        return weakSelf;
    };
    
}

- (FFConfigToBool)FFShouldAutorotate{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(BOOL is){
        
        if (weakSelf) weakSelf.modelIsShouldAutorotate = is;
        
        return weakSelf;
    };
    
}

- (FFConfigToInterfaceOrientationMask)FFSupportedInterfaceOrientations{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIInterfaceOrientationMask mask){
        
        if (weakSelf) weakSelf.modelSupportedInterfaceOrientations = mask;
        
        return weakSelf;
    };
    
}

- (FFConfigToBlockAndBlock)FFOpenAnimationConfig{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^block)(void (^animatingBlock)(void) , void (^animatedBlock)(void))){
        
        if (weakSelf) weakSelf.modelOpenAnimationConfigBlock = block;
        
        return weakSelf;
    };
    
}

- (FFConfigToBlockAndBlock)FFCloseAnimationConfig{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void(^block)(void (^animatingBlock)(void) , void (^animatedBlock)(void))){
        
        if (weakSelf) weakSelf.modelCloseAnimationConfigBlock = block;
        
        return weakSelf;
    };
    
}

- (FFConfigToAnimationStyle)FFOpenAnimationStyle{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(FFAnimationStyle style){
        
        if (weakSelf) weakSelf.modelOpenAnimationStyle = style;
        
        return weakSelf;
    };
    
}

- (FFConfigToAnimationStyle)FFCloseAnimationStyle{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(FFAnimationStyle style){
        
        if (weakSelf) weakSelf.modelCloseAnimationStyle = style;
        
        return weakSelf;
    };
    
}


- (FFConfig)FFShow{
    
    __weak typeof(self) weakSelf = self;
    
    return ^{
        
        if (weakSelf) {
            
            if (weakSelf.modelFinishConfig) weakSelf.modelFinishConfig();
        }
        
        return weakSelf;
    };
    
}

#pragma mark Alert Config

- (FFConfigToConfigTextField)FFAddTextField{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void (^block)(UITextField *)){
        
        return weakSelf.FFAddItem(^(FFItem *item) {
            
            item.type = FFItemTypeTextField;
            
            item.insets = UIEdgeInsetsMake(10, 0, 10, 0);
            
            item.block = block;
        });
        
    };
    
}

- (FFConfigToBool)FFAvoidKeyboard{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(BOOL is){
        
        if (weakSelf) weakSelf.modelIsAvoidKeyboard = is;
        
        return weakSelf;
    };
    
}

#pragma mark ActionSheet Config

- (FFConfigToFloat)FFActionSheetCancelActionSpaceWidth{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) weakSelf.modelActionSheetCancelActionSpaceWidth = number;
        
        return weakSelf;
    };
    
}

- (FFConfigToColor)FFActionSheetCancelActionSpaceColor{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIColor *color){
        
        if (weakSelf) weakSelf.modelActionSheetCancelActionSpaceColor = color;
        
        return weakSelf;
    };
    
}

- (FFConfigToFloat)FFActionSheetBottomMargin{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(CGFloat number){
        
        if (weakSelf) weakSelf.modelActionSheetBottomMargin = number;
        
        return weakSelf;
    };
    
}

- (FFConfigToBlock)FFCloseComplete{
    
    __weak typeof(self) weakSelf = self;
    
    return ^(void (^block)(void)){
        
        if (weakSelf) weakSelf.modelCloseComplete = block;
        
        return weakSelf;
    };
    
}

#pragma mark LazyLoading

- (NSMutableArray *)modelActionArray{
 
    if (!_modelActionArray) _modelActionArray = [NSMutableArray array];
    
    return _modelActionArray;
}

- (NSMutableArray *)modelItemArray{
    
    if (!_modelItemArray) _modelItemArray = [NSMutableArray array];
    
    return _modelItemArray;
}

- (NSMutableDictionary *)modelItemInsetsInfo{
    
    if (!_modelItemInsetsInfo) _modelItemInsetsInfo = [NSMutableDictionary dictionary];
    
    return _modelItemInsetsInfo;
}

@end

@interface FFAlert ()

@property (nonatomic , strong ) UIWindow *mainWindow;

@property (nonatomic , strong ) FFAlertWindow *FFWindow;

@property (nonatomic , strong ) NSMutableArray <FFAlertConfig *>*queueArray;

@property (nonatomic , strong ) FFBaseViewController *viewController;

@end

@protocol FFAlertProtocol <NSObject>

- (void)closeWithCompletionBlock:(void (^)(void))completionBlock;

@end

@implementation FFAlert

+ (FFAlert *)shareManager{
    
    static FFAlert *alertManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        alertManager = [[FFAlert alloc] init];
    });
    
    return alertManager;
}

+ (FFAlertConfig *)alert{
    
    FFAlertConfig *config = [[FFAlertConfig alloc] init];
    
    config.type = FFAlertTypeAlert;
    
    return config;
}

+ (FFAlertConfig *)actionsheet{
    
    FFAlertConfig *config = [[FFAlertConfig alloc] init];
    
    config.type = FFAlertTypeActionSheet;
    
    config.config.FFClickBackgroundClose(YES);
    
    return config;
}

+ (FFAlertWindow *)getAlertWindow{
    
    return [FFAlert shareManager].FFWindow;
}

+ (void)configMainWindow:(UIWindow *)window{
    
    if (window) [FFAlert shareManager].mainWindow = window;
}

+ (void)continueQueueDisplay{
    
    if ([FFAlert shareManager].queueArray.count) [FFAlert shareManager].queueArray.lastObject.config.modelFinishConfig();
}

+ (void)clearQueue{
    
    [[FFAlert shareManager].queueArray removeAllObjects];
}

+ (void)closeWithCompletionBlock:(void (^)(void))completionBlock{
    
    if ([FFAlert shareManager].queueArray.count) {
        
        FFAlertConfig *item = [FFAlert shareManager].queueArray.lastObject;
        
        if ([item respondsToSelector:@selector(closeWithCompletionBlock:)]) [item performSelector:@selector(closeWithCompletionBlock:) withObject:completionBlock];
    }
    
}

#pragma mark LazyLoading

- (NSMutableArray <FFAlertConfig *>*)queueArray{
    
    if (!_queueArray) _queueArray = [NSMutableArray array];
    
    return _queueArray;
}

- (FFAlertWindow *)FFWindow{
    
    if (!_FFWindow) {
        
        _FFWindow = [[FFAlertWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        _FFWindow.backgroundColor = [UIColor clearColor];
        
        _FFWindow.windowLevel = UIWindowLevelAlert;
        
        _FFWindow.hidden = YES;
    }
    
    return _FFWindow;
}

@end

@implementation FFAlertWindow

@end

@interface FFItem ()

@property (nonatomic , copy ) void (^updateBlock)(FFItem *);

@end

@implementation FFItem

- (void)update{
    
    if (self.updateBlock) self.updateBlock(self);
}

@end

@interface FFAction ()

@property (nonatomic , copy ) void (^updateBlock)(FFAction *);

@end

@implementation FFAction

- (void)update{
    
    if (self.updateBlock) self.updateBlock(self);
}

@end

@interface FFItemView : UIView

@property (nonatomic , strong ) FFItem *item;

+ (FFItemView *)view;

@end

@implementation FFItemView

+ (FFItemView *)view{
    
    return [[FFItemView alloc] init];;
}

@end

@interface FFItemLabel : UILabel

@property (nonatomic , strong ) FFItem *item;

@property (nonatomic , copy ) void (^textChangedBlock)(void);

+ (FFItemLabel *)label;

@end

@implementation FFItemLabel

+ (FFItemLabel *)label{
    
    return [[FFItemLabel alloc] init];
}

- (void)setText:(NSString *)text{
    
    [super setText:text];
    
    if (self.textChangedBlock) self.textChangedBlock();
}

- (void)setAttributedText:(NSAttributedString *)attributedText{
    
    [super setAttributedText:attributedText];
    
    if (self.textChangedBlock) self.textChangedBlock();
}

- (void)setFont:(UIFont *)font{
    
    [super setFont:font];
    
    if (self.textChangedBlock) self.textChangedBlock();
}

- (void)setNumberOfLines:(NSInteger)numberOfLines{
    
    [super setNumberOfLines:numberOfLines];
    
    if (self.textChangedBlock) self.textChangedBlock();
}

@end

@interface FFItemTextField : UITextField

@property (nonatomic , strong ) FFItem *item;

+ (FFItemTextField *)textField;

@end

@implementation FFItemTextField

+ (FFItemTextField *)textField{
    
    return [[FFItemTextField alloc] init];
}

@end

@interface FFActionButton : UIButton

@property (nonatomic , strong ) FFAction *action;

@property (nonatomic , copy ) void (^heightChangedBlock)(void);

+ (FFActionButton *)button;

@end

@interface FFActionButton ()

@property (nonatomic , strong ) UIColor *borderColor;

@property (nonatomic , assign ) CGFloat borderWidth;

@property (nonatomic , strong ) CALayer *topLayer;

@property (nonatomic , strong ) CALayer *bottomLayer;

@property (nonatomic , strong ) CALayer *leftLayer;

@property (nonatomic , strong ) CALayer *rightLayer;

@end

@implementation FFActionButton

+ (FFActionButton *)button{
    
    return [FFActionButton buttonWithType:UIButtonTypeCustom];;
}

- (void)setAction:(FFAction *)action{
    
    _action = action;
    
    self.clipsToBounds = YES;
    
    if (action.title) [self setTitle:action.title forState:UIControlStateNormal];
    
    if (action.highlight) [self setTitle:action.highlight forState:UIControlStateHighlighted];
    
    if (action.attributedTitle) [self setAttributedTitle:action.attributedTitle forState:UIControlStateNormal];
    
    if (action.attributedHighlight) [self setAttributedTitle:action.attributedHighlight forState:UIControlStateHighlighted];
    
    if (action.font) [self.titleLabel setFont:action.font];
    
    if (action.titleColor) [self setTitleColor:action.titleColor forState:UIControlStateNormal];
    
    if (action.highlightColor) [self setTitleColor:action.highlightColor forState:UIControlStateHighlighted];
    
    if (action.backgroundColor) [self setBackgroundImage:[self getImageWithColor:action.backgroundColor] forState:UIControlStateNormal];
    
    if (action.backgroundHighlightColor) [self setBackgroundImage:[self getImageWithColor:action.backgroundHighlightColor] forState:UIControlStateHighlighted];
    
    if (action.borderColor) [self setBorderColor:action.borderColor];
    
    if (action.borderWidth > 0) [self setBorderWidth:action.borderWidth < DEFAULTBORDERWIDTH ? DEFAULTBORDERWIDTH : action.borderWidth]; else [self setBorderWidth:0.0f];
    
    if (action.image) [self setImage:action.image forState:UIControlStateNormal];
    
    if (action.highlightImage) [self setImage:action.highlightImage forState:UIControlStateHighlighted];
    
    if (action.height) [self setActionHeight:action.height];
    
    if (action.cornerRadius) [self.layer setCornerRadius:action.cornerRadius];
    
    [self setImageEdgeInsets:action.imageEdgeInsets];
    
    [self setTitleEdgeInsets:action.titFFdgeInsets];
    if (action.borderPosition & FFActionBorderPositionTop &&
        action.borderPosition & FFActionBorderPositionBottom &&
        action.borderPosition & FFActionBorderPositionLeft &&
        action.borderPosition & FFActionBorderPositionRight) {
        
        self.layer.borderWidth = action.borderWidth;
        
        self.layer.borderColor = action.borderColor.CGColor;
        
        [self removeTopBorder];
        
        [self removeBottomBorder];
        
        [self removeLeftBorder];
        
        [self removeRightBorder];
    
    } else {
        
        self.layer.borderWidth = 0.0f;
     
        self.layer.borderColor = [UIColor clearColor].CGColor;
        
        if (action.borderPosition & FFActionBorderPositionTop) [self addTopBorder]; else [self removeTopBorder];
        
        if (action.borderPosition & FFActionBorderPositionBottom) [self addBottomBorder]; else [self removeBottomBorder];
        
        if (action.borderPosition & FFActionBorderPositionLeft) [self addLeftBorder]; else [self removeLeftBorder];
        
        if (action.borderPosition & FFActionBorderPositionRight) [self addRightBorder]; else [self removeRightBorder];
    }
    
    __weak typeof(self) weakSelf = self;
    
    action.updateBlock = ^(FFAction *act) {
        
        if (weakSelf) weakSelf.action = act;
    };
    
}

- (CGFloat)actionHeight{
    
    return self.frame.size.height;
}

- (void)setActionHeight:(CGFloat)height{
    
    BOOL isChange = [self actionHeight] == height ? NO : YES;
    
    CGRect buttonFrame = self.frame;
    
    buttonFrame.size.height = height;
    
    self.frame = buttonFrame;
    
    if (isChange) {
        
        if (self.heightChangedBlock) self.heightChangedBlock();
    }
    
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    if (_topLayer) _topLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.borderWidth);
    
    if (_bottomLayer) _bottomLayer.frame = CGRectMake(0, self.frame.size.height - self.borderWidth, self.frame.size.width, self.borderWidth);
    
    if (_leftLayer) _leftLayer.frame = CGRectMake(0, 0, self.borderWidth, self.frame.size.height);
    
    if (_rightLayer) _rightLayer.frame = CGRectMake(self.frame.size.width - self.borderWidth, 0, self.borderWidth, self.frame.size.height);
}

- (void)addTopBorder{
    
    [self.layer addSublayer:self.topLayer];
}

- (void)addBottomBorder{
    
    [self.layer addSublayer:self.bottomLayer];
}

- (void)addLeftBorder{
    
    [self.layer addSublayer:self.leftLayer];
}

- (void)addRightBorder{
    
    [self.layer addSublayer:self.rightLayer];
}

- (void)removeTopBorder{
    
    if (_topLayer) [_topLayer removeFromSuperlayer]; _topLayer = nil;
}

- (void)removeBottomBorder{
    
    if (_bottomLayer) [_bottomLayer removeFromSuperlayer]; _bottomLayer = nil;
}

- (void)removeLeftBorder{
    
    if (_leftLayer) [_leftLayer removeFromSuperlayer]; _leftLayer = nil;
}

- (void)removeRightBorder{
    
    if (_rightLayer) [_rightLayer removeFromSuperlayer]; _rightLayer = nil;
}

- (CALayer *)createLayer{
    
    CALayer *layer = [CALayer layer];
    
    layer.backgroundColor = self.borderColor.CGColor;
    
    return layer;
}

- (CALayer *)topLayer{
    
    if (!_topLayer) _topLayer = [self createLayer];
    
    return _topLayer;
}

- (CALayer *)bottomLayer{
    
    if (!_bottomLayer) _bottomLayer = [self createLayer];
    
    return _bottomLayer;
}

- (CALayer *)leftLayer{
    
    if (!_leftLayer) _leftLayer = [self createLayer];
    
    return _leftLayer;
}

- (CALayer *)rightLayer{
    
    if (!_rightLayer) _rightLayer = [self createLayer];
    
    return _rightLayer;
}

- (UIImage *)getImageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end

@interface FFCustomView ()

@property (nonatomic , strong ) FFItem *item;

@property (nonatomic , assign ) CGSize size;

@property (nonatomic , copy ) void (^sizeChangedBlock)(void);

@end

@implementation FFCustomView

- (void)dealloc{
    
    if (_view) [_view removeObserver:self forKeyPath:@"frame"];
}

- (void)setSizeChangedBlock:(void (^)(void))sizeChangedBlock{
    
    _sizeChangedBlock = sizeChangedBlock;
    
    if (_view) {
        
        [_view layoutSubviews];
        
        _size = _view.frame.size;
        
        [_view addObserver: self forKeyPath: @"frame" options: NSKeyValueObservingOptionNew context: nil];
    }
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    UIView *view = (UIView *)object;
    
    if (!CGSizeEqualToSize(self.size, view.frame.size)) {
        
        self.size = view.frame.size;
        
        if (self.sizeChangedBlock) self.sizeChangedBlock();
    }
    
}

@end

@interface UIView (FFShadowViewHandle)

@end

static NSString *const FFShadowViewHandleKeyFrame = @"frame";
static NSString *const FFShadowViewHandleKeyAlpha = @"alpha";
static NSString *const FFShadowViewHandleKeyCenter = @"center";
static NSString *const FFShadowViewHandleKeyHidden = @"hidden";
static NSString *const FFShadowViewHandleKeyTransform = @"transform";
static NSString *const FFShadowViewHandleKeyBackgroundColor = @"backgroundColor";

@implementation UIView (FFShadowViewHandle)

+ (void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSArray *selStringsArray = @[@"dealloc" , @"layoutSubviews" , @"removeFromSuperview"];
        
        [selStringsArray enumerateObjectsUsingBlock:^(NSString *selString, NSUInteger idx, BOOL *stop) {
            
            NSString *FFSelString = [@"FF_alert_" stringByAppendingString:selString];
            
            Method originalMethod = class_getInstanceMethod(self, NSSelectorFromString(selString));
            
            Method FFMethod = class_getInstanceMethod(self, NSSelectorFromString(FFSelString));
            
            BOOL isAddedMethod = class_addMethod(self, NSSelectorFromString(selString), method_getImplementation(FFMethod), method_getTypeEncoding(FFMethod));
            
            if (isAddedMethod) {
            
                class_replaceMethod(self, NSSelectorFromString(FFSelString), method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
            
            } else {
                
                method_exchangeImplementations(originalMethod, FFMethod);
            }
            
        }];
        
    });
    
}

- (void)FF_alert_dealloc{
    
    if ([self isAddShadow]) objc_removeAssociatedObjects(self);
    
    [self FF_alert_dealloc];
}

- (void)FF_alert_layoutSubviews{
    
    if ([self isAddShadow]) [[self shadowView] layoutSubviews];
    
    [self FF_alert_layoutSubviews];
}

- (void)FF_alert_removeFromSuperview{
    
    [self removeShadow];
    
    [self FF_alert_removeFromSuperview];
}

- (void)cornerRadius:(CGFloat)cornerRadius{
    
    self.layer.cornerRadius = cornerRadius;

    if ([self isAddShadow]) [self shadowView].layer.cornerRadius = cornerRadius;
}

- (void)addShadowWithShadowOpacity:(CGFloat)shadowOpacity{
    
    if (self.superview) {
        
        if (![self shadowView]) {
            
            UIView *shadowView = [[UIView alloc] initWithFrame:self.frame];
            
            shadowView.backgroundColor = self.backgroundColor;
            
            shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
            
            shadowView.layer.shadowRadius = 5;
            
            shadowView.layer.shadowOffset = CGSizeMake(0, 2);
            
            shadowView.layer.shadowOpacity = shadowOpacity;
         
            [self.superview insertSubview:shadowView belowSubview:self];
            
            [self addObserver:self forKeyPath:FFShadowViewHandleKeyFrame options:NSKeyValueObservingOptionNew context:NULL];
            [self addObserver:self forKeyPath:FFShadowViewHandleKeyAlpha options:NSKeyValueObservingOptionNew context:NULL];
            [self addObserver:self forKeyPath:FFShadowViewHandleKeyCenter options:NSKeyValueObservingOptionNew context:NULL];
            [self addObserver:self forKeyPath:FFShadowViewHandleKeyHidden options:NSKeyValueObservingOptionNew context:NULL];
            [self addObserver:self forKeyPath:FFShadowViewHandleKeyTransform options:NSKeyValueObservingOptionNew context:NULL];
            [self addObserver:self forKeyPath:FFShadowViewHandleKeyBackgroundColor options:NSKeyValueObservingOptionNew context:NULL];
            
            objc_setAssociatedObject(self, @selector(shadowView), shadowView , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        
        [self setIsAddShadow:YES];
    }
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:FFShadowViewHandleKeyFrame]) {
        
        CGRect frame = [change[NSKeyValueChangeNewKey] CGRectValue];
        
        [self shadowView].frame = frame;
    }
    
    if ([keyPath isEqualToString:FFShadowViewHandleKeyAlpha]) {
        
        CGFloat alpha = [change[NSKeyValueChangeNewKey] floatValue];
        
        [self shadowView].alpha = alpha;
    }
    
    if ([keyPath isEqualToString:FFShadowViewHandleKeyCenter]) {
        
        CGPoint center = [change[NSKeyValueChangeNewKey] CGPointValue];
        
        [self shadowView].center = center;
    }
    
    if ([keyPath isEqualToString:FFShadowViewHandleKeyCenter]) {
        
        CGPoint center = [change[NSKeyValueChangeNewKey] CGPointValue];
        
        [self shadowView].center = center;
    }
    
    if ([keyPath isEqualToString:FFShadowViewHandleKeyHidden]) {
        
        bool hidden = [change[NSKeyValueChangeNewKey] boolValue];
        
        [self shadowView].hidden = hidden;
    }
    
    if ([keyPath isEqualToString:FFShadowViewHandleKeyTransform]) {
        
        CGAffineTransform transform = [change[NSKeyValueChangeNewKey] CGAffineTransformValue];
        
        [self shadowView].transform = transform;
    }
    
    if ([keyPath isEqualToString:FFShadowViewHandleKeyBackgroundColor]) {
        
        UIColor *color = change[NSKeyValueChangeNewKey];
        
        [self shadowView].backgroundColor = color;
    }
    
}

- (void)removeShadow{
    
    if (![self isAddShadow]) return;
    
    [self removeObserver:self forKeyPath:FFShadowViewHandleKeyFrame];
    [self removeObserver:self forKeyPath:FFShadowViewHandleKeyAlpha];
    [self removeObserver:self forKeyPath:FFShadowViewHandleKeyCenter];
    [self removeObserver:self forKeyPath:FFShadowViewHandleKeyHidden];
    [self removeObserver:self forKeyPath:FFShadowViewHandleKeyTransform];
    [self removeObserver:self forKeyPath:FFShadowViewHandleKeyBackgroundColor];
    
    [[self shadowView] removeFromSuperview];
}

- (UIView *)shadowView{
    
    return objc_getAssociatedObject(self, _cmd);
}

- (BOOL)isAddShadow{
    
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setIsAddShadow:(BOOL)isAddShadow{
    
    objc_setAssociatedObject(self, @selector(isAddShadow), @(isAddShadow) , OBJC_ASSOCIATION_ASSIGN);
}

@end

@interface FFBaseViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic , strong ) FFAlertConfigModel *config;

@property (nonatomic , strong ) UIWindow *currentKeyWindow;

@property (nonatomic , strong ) UIVisualEffectView *backgroundVisualEffectView;

@property (nonatomic , assign ) FFScreenOrientationType orientationType;

@property (nonatomic , strong ) FFCustomView *customView;

@property (nonatomic , assign ) BOOL isShowing;

@property (nonatomic , assign ) BOOL isClosing;

@property (nonatomic , copy ) void (^openFinishBlock)(void);

@property (nonatomic , copy ) void (^closeFinishBlock)(void);

@end

@implementation FFBaseViewController

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    _config = nil;
    
    _currentKeyWindow = nil;
    
    _backgroundVisualEffectView = nil;
    
    _customView = nil;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.extendedLayoutIncludesOpaqueBars = NO;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (self.config.modelBackgroundStyle == FFBackgroundStyleBlur) {
        
        self.backgroundVisualEffectView = [[UIVisualEffectView alloc] initWithEffect:nil];
        
        self.backgroundVisualEffectView.frame = self.view.frame;
        
        [self.view addSubview:self.backgroundVisualEffectView];
    }

    self.view.backgroundColor = [self.config.modelBackgroundColor colorWithAlphaComponent:0.0f];
    
    self.orientationType = VIEW_HEIGHT > VIEW_WIDTH ? FFScreenOrientationTypeVertical : FFScreenOrientationTypeHorizontal;
}

- (void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
    if (self.backgroundVisualEffectView) self.backgroundVisualEffectView.frame = self.view.frame;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    self.orientationType = size.height > size.width ? FFScreenOrientationTypeVertical : FFScreenOrientationTypeHorizontal;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (self.config.modelIsClickBackgroundClose) [self closeAnimationsWithCompletionBlock:nil];
}

#pragma mark start animations

- (void)showAnimationsWithCompletionBlock:(void (^)(void))completionBlock{
    
    [self.currentKeyWindow endEditing:YES];
    
    [self.view setUserInteractionEnabled:NO];
}

#pragma mark close animations
    
- (void)closeAnimationsWithCompletionBlock:(void (^)(void))completionBlock{
    
    [[FFAlert shareManager].FFWindow endEditing:YES];
}

#pragma mark LazyLoading

- (UIWindow *)currentKeyWindow{
    
    if (!_currentKeyWindow) _currentKeyWindow = [FFAlert shareManager].mainWindow;
    
    if (!_currentKeyWindow) _currentKeyWindow = [UIApplication sharedApplication].keyWindow;
    
    if (_currentKeyWindow.windowLevel != UIWindowLevelNormal) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"windowLevel == %ld AND hidden == 0 " , UIWindowLevelNormal];
        
        _currentKeyWindow = [[UIApplication sharedApplication].windows filteredArrayUsingPredicate:predicate].firstObject;
    }
    
    if (_currentKeyWindow) if (![FFAlert shareManager].mainWindow) [FFAlert shareManager].mainWindow = _currentKeyWindow;
    
    return _currentKeyWindow;
}

#pragma mark - 旋转

- (BOOL)shouldAutorotate{
    
    return self.config.modelIsShouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return self.config.modelSupportedInterfaceOrientations;
}

@end

#pragma mark - Alert

@interface FFAlertViewController ()

@property (nonatomic , strong ) UIView *containerView;

@property (nonatomic , strong ) UIScrollView *alertView;

@property (nonatomic , strong ) NSMutableArray <id>*alertItemArray;

@property (nonatomic , strong ) NSMutableArray <FFActionButton *>*alertActionArray;

@end

@implementation FFAlertViewController
{
    CGFloat alertViewHeight;
    CGRect keyboardFrame;
    BOOL isShowingKeyboard;
}

- (void)dealloc{
    
    _alertView = nil;
    
    _alertItemArray = nil;
    
    _alertActionArray = nil;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self configNotification];
    
    [self configAlert];
}

- (void)configNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notify{
    
    if (self.config.modelIsAvoidKeyboard) {
        
        double duration = [[[notify userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        keyboardFrame = [[[notify userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        isShowingKeyboard = keyboardFrame.origin.y < SCREEN_HEIGHT;
        
        [UIView beginAnimations:@"keyboardWillChangeFrame" context:NULL];
        
        [UIView setAnimationDuration:duration];
        
        [self updateAlertLayout];
        
        [UIView commitAnimations];
    }
    
}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    if (!self.isShowing && !self.isClosing) [self updateAlertLayout];
}

- (void)updateAlertLayout{
    
    [self updateAlertLayoutWithViewWidth:VIEW_WIDTH ViewHeight:VIEW_HEIGHT];
}

- (void)updateAlertLayoutWithViewWidth:(CGFloat)viewWidth ViewHeight:(CGFloat)viewHeight{
    
    CGFloat alertViewMaxWidth = self.config.modelMaxWidthBlock(self.orientationType);
    
    CGFloat alertViewMaxHeight = self.config.modelMaxHeightBlock(self.orientationType);
    
    if (isShowingKeyboard) {
        
        if (keyboardFrame.size.height) {
            
            [self updateAlertItemsLayout];
            
            CGFloat keyboardY = keyboardFrame.origin.y;
            
            CGRect alertViewFrame = self.alertView.frame;
            
            CGFloat tempAlertViewHeight = keyboardY - alertViewHeight < 20 ? keyboardY - 20 : alertViewHeight;
            
            CGFloat tempAlertViewY = keyboardY - tempAlertViewHeight - 10;
            
            CGFloat originalAlertViewY = (viewHeight - alertViewFrame.size.height) * 0.5f;
            
            alertViewFrame.size.height = tempAlertViewHeight;
            
            alertViewFrame.size.width = alertViewMaxWidth;
            
            self.alertView.frame = alertViewFrame;
            
            CGRect containerFrame = self.containerView.frame;
            
            containerFrame.size.width = alertViewFrame.size.width;
            
            containerFrame.size.height = alertViewFrame.size.height;
            
            containerFrame.origin.x = (viewWidth - alertViewFrame.size.width) * 0.5f;
            
            containerFrame.origin.y = tempAlertViewY < originalAlertViewY ? tempAlertViewY : originalAlertViewY;
            
            self.containerView.frame = containerFrame;
            
            [self.alertView scrollRectToVisible:[self findFirstResponder:self.alertView].frame animated:YES];
        }
        
    } else {
        
        [self updateAlertItemsLayout];
        
        CGRect alertViewFrame = self.alertView.frame;
        
        alertViewFrame.size.width = alertViewMaxWidth;
        
        alertViewFrame.size.height = alertViewHeight > alertViewMaxHeight ? alertViewMaxHeight : alertViewHeight;
        
        self.alertView.frame = alertViewFrame;
        
        CGRect containerFrame = self.containerView.frame;
        
        containerFrame.size.width = alertViewFrame.size.width;
        
        containerFrame.size.height = alertViewFrame.size.height;
        
        containerFrame.origin.x = (viewWidth - alertViewMaxWidth) * 0.5f;
        
        containerFrame.origin.y = (viewHeight - alertViewFrame.size.height) * 0.5f;
        
        self.containerView.frame = containerFrame;
    }
    
}

- (void)updateAlertItemsLayout{
    
    [UIView setAnimationsEnabled:NO];
    
    alertViewHeight = 0.0f;
    
    CGFloat alertViewMaxWidth = self.config.modelMaxWidthBlock(self.orientationType);
    
    [self.alertItemArray enumerateObjectsUsingBlock:^(id  _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if (idx == 0) alertViewHeight += self.config.modelHeaderInsets.top;
        
        if ([item isKindOfClass:UIView.class]) {
            
            FFItemView *view = (FFItemView *)item;
            
            CGRect viewFrame = view.frame;
            
            viewFrame.origin.x = self.config.modelHeaderInsets.left + view.item.insets.left;
            
            viewFrame.origin.y = alertViewHeight + view.item.insets.top;
            
            viewFrame.size.width = alertViewMaxWidth - viewFrame.origin.x - self.config.modelHeaderInsets.right - view.item.insets.right;
            
            if ([item isKindOfClass:UILabel.class]) viewFrame.size.height = [item sizeThatFits:CGSizeMake(viewFrame.size.width, MAXFLOAT)].height;
            
            view.frame = viewFrame;
            
            alertViewHeight += view.frame.size.height + view.item.insets.top + view.item.insets.bottom;
            
        } else if ([item isKindOfClass:FFCustomView.class]) {
            
            FFCustomView *custom = (FFCustomView *)item;
            
            CGRect viewFrame = custom.view.frame;
            
            if (custom.isAutoWidth) {
                
                custom.positionType = FFCustomViewPositionTypeCenter;
                
                viewFrame.size.width = alertViewMaxWidth - self.config.modelHeaderInsets.left - custom.item.insets.left - self.config.modelHeaderInsets.right - custom.item.insets.right;
            }
            
            switch (custom.positionType) {
                
                case FFCustomViewPositionTypeCenter:
                   
                    viewFrame.origin.x = (alertViewMaxWidth - viewFrame.size.width) * 0.5f;
                    
                    break;
                    
                case FFCustomViewPositionTypeLeft:
                    
                    viewFrame.origin.x = self.config.modelHeaderInsets.left + custom.item.insets.left;
                    
                    break;
                    
                case FFCustomViewPositionTypeRight:
                    
                    viewFrame.origin.x = alertViewMaxWidth - self.config.modelHeaderInsets.right - custom.item.insets.right - viewFrame.size.width;
                    
                    break;
                    
                default:
                    break;
            }
            
            viewFrame.origin.y = alertViewHeight + custom.item.insets.top;
            
            custom.view.frame = viewFrame;
            
            alertViewHeight += viewFrame.size.height + custom.item.insets.top + custom.item.insets.bottom;
        }
        
        if (item == self.alertItemArray.lastObject) alertViewHeight += self.config.modelHeaderInsets.bottom;
    }];
    
    for (FFActionButton *button in self.alertActionArray) {
        
        CGRect buttonFrame = button.frame;
        
        buttonFrame.origin.x = button.action.insets.left;
        
        buttonFrame.origin.y = alertViewHeight + button.action.insets.top;
        
        buttonFrame.size.width = alertViewMaxWidth - button.action.insets.left - button.action.insets.right;
        
        button.frame = buttonFrame;
        
        alertViewHeight += buttonFrame.size.height + button.action.insets.top + button.action.insets.bottom;
    }
    
    if (self.alertActionArray.count == 2) {
        
        FFActionButton *buttonA = self.alertActionArray.count == self.config.modelActionArray.count ? self.alertActionArray.firstObject : self.alertActionArray.lastObject;
        
        FFActionButton *buttonB = self.alertActionArray.count == self.config.modelActionArray.count ? self.alertActionArray.lastObject : self.alertActionArray.firstObject;
        
        UIEdgeInsets buttonAInsets = buttonA.action.insets;
        
        UIEdgeInsets buttonBInsets = buttonB.action.insets;
        
        CGFloat buttonAHeight = CGRectGetHeight(buttonA.frame) + buttonAInsets.top + buttonAInsets.bottom;
        
        CGFloat buttonBHeight = CGRectGetHeight(buttonB.frame) + buttonBInsets.top + buttonBInsets.bottom;
        
        //CGFloat maxHeight = buttonAHeight > buttonBHeight ? buttonAHeight : buttonBHeight;
        
        CGFloat minHeight = buttonAHeight < buttonBHeight ? buttonAHeight : buttonBHeight;
        
        CGFloat minY = (buttonA.frame.origin.y - buttonAInsets.top) > (buttonB.frame.origin.y - buttonBInsets.top) ? (buttonB.frame.origin.y - buttonBInsets.top) : (buttonA.frame.origin.y - buttonAInsets.top);
        
        buttonA.frame = CGRectMake(buttonAInsets.left, minY + buttonAInsets.top, (alertViewMaxWidth / 2) - buttonAInsets.left - buttonAInsets.right, buttonA.frame.size.height);
        
        buttonB.frame = CGRectMake((alertViewMaxWidth / 2) + buttonBInsets.left, minY + buttonBInsets.top, (alertViewMaxWidth / 2) - buttonBInsets.left - buttonBInsets.right, buttonB.frame.size.height);
        
        alertViewHeight -= minHeight;
    }
    
    self.alertView.contentSize = CGSizeMake(alertViewMaxWidth, alertViewHeight);
    
    [UIView setAnimationsEnabled:YES];
}

- (void)configAlert{
    
    __weak typeof(self) weakSelf = self;
    
    _containerView = [UIView new];
    
    [self.view addSubview: _containerView];
    
    [self.containerView addSubview: self.alertView];
    
    [self.alertView addShadowWithShadowOpacity:self.config.modelShadowOpacity];
    
    [self.alertView cornerRadius:self.config.modelCornerRadius];
    
    
    [self.config.modelItemArray enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        void (^itemBlock)(FFItem *) = obj;
        
        FFItem *item = [[FFItem alloc] init];
        
        if (itemBlock) itemBlock(item);
        
        NSValue *insetValue = [self.config.modelItemInsetsInfo objectForKey:@(idx)];
        
        if (insetValue) item.insets = insetValue.UIEdgeInsetsValue;
        
        switch (item.type) {
                
            case FFItemTypeTitle:
            {
                void(^block)(UILabel *label) = item.block;
                
                FFItemLabel *label = [FFItemLabel label];
                
                [self.alertView addSubview:label];
                
                [self.alertItemArray addObject:label];
                
                label.textAlignment = NSTextAlignmentCenter;
                
                label.font = [UIFont boldSystemFontOfSize:18.0f];
                
                label.textColor = [UIColor blackColor];
                
                label.numberOfLines = 0;
                
                if (block) block(label);
                
                label.item = item;
                
                label.textChangedBlock = ^{
                    
                    if (weakSelf) [weakSelf updateAlertLayout];
                };
            }
                break;
                
            case FFItemTypeContent:
            {
                void(^block)(UILabel *label) = item.block;
                
                FFItemLabel *label = [FFItemLabel label];
                
                [self.alertView addSubview:label];
                
                [self.alertItemArray addObject:label];
                
                label.textAlignment = NSTextAlignmentCenter;
                
                label.font = [UIFont systemFontOfSize:14.0f];
                
                label.textColor = [UIColor blackColor];
                
                label.numberOfLines = 0;
                
                if (block) block(label);
                
                label.item = item;
                
                label.textChangedBlock = ^{
                  
                    if (weakSelf) [weakSelf updateAlertLayout];
                };
            }
                break;
                
            case FFItemTypeCustomView:
            {
                void(^block)(FFCustomView *) = item.block;
                
                FFCustomView *custom = [[FFCustomView alloc] init];
                
                block(custom);
                
                [self.alertView addSubview:custom.view];
                
                [self.alertItemArray addObject:custom];
                
                custom.item = item;
                
                custom.sizeChangedBlock = ^{
                    
                    if (weakSelf) [weakSelf updateAlertLayout];
                };
            }
                break;
                
            case FFItemTypeTextField:
            {
                FFItemTextField *textField = [FFItemTextField textField];
                
                textField.frame = CGRectMake(0, 0, 0, 40.0f);
                
                [self.alertView addSubview:textField];
                
                [self.alertItemArray addObject:textField];
                
                textField.borderStyle = UITextBorderStyleRoundedRect;
                
                void(^block)(UITextField *textField) = item.block;
                
                if (block) block(textField);
                
                textField.item = item;
            }
                break;
                
            default:
                break;
        }
        
    }];
    
    [self.config.modelActionArray enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL * _Nonnull stop) {
       
        void (^block)(FFAction *action) = item;
        
        FFAction *action = [[FFAction alloc] init];
        
        if (block) block(action);
        
        if (!action.font) action.font = [UIFont systemFontOfSize:18.0f];
        
        if (!action.title) action.title = @"按钮";
        
        if (!action.titleColor) action.titleColor = [UIColor colorWithRed:21/255.0f green:123/255.0f blue:245/255.0f alpha:1.0f];
        
        if (!action.backgroundColor) action.backgroundColor = self.config.modelHeaderColor;
        
        if (!action.backgroundHighlightColor) action.backgroundHighlightColor = action.backgroundHighlightColor = [UIColor colorWithWhite:0.97 alpha:1.0f];
        
        if (!action.borderColor) action.borderColor = [UIColor colorWithWhite:0.84 alpha:1.0f];
        
        if (!action.borderWidth) action.borderWidth = DEFAULTBORDERWIDTH;
        
        if (!action.borderPosition) action.borderPosition = (self.config.modelActionArray.count == 2 && idx == 0) ? FFActionBorderPositionTop | FFActionBorderPositionRight : FFActionBorderPositionTop;
        
        if (!action.height) action.height = 45.0f;
        
        FFActionButton *button = [FFActionButton button];
        
        button.action = action;
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.alertView addSubview:button];
        
        [self.alertActionArray addObject:button];
        
        button.heightChangedBlock = ^{
            
            if (weakSelf) [weakSelf updateAlertLayout];
        };
        
    }];
    
    // 更新布局
    
    [self updateAlertLayout];
    
    [self showAnimationsWithCompletionBlock:^{
    
        if (weakSelf) [weakSelf updateAlertLayout];
    }];
    
}

- (void)buttonAction:(UIButton *)sender{
    
    BOOL isClose = NO;
    
    void (^clickBlock)(void) = nil;
    
    for (FFActionButton *button in self.alertActionArray) {
        
        if (button == sender) {
        
            switch (button.action.type) {
                
                case FFActionTypeDefault:
                    
                    isClose = button.action.isClickNotClose ? NO : YES;
                    
                    break;
                
                case FFActionTypeCancel:
                    
                    isClose = YES;
                    
                    break;
                    
                case FFActionTypeDestructive:
                    
                    isClose = YES;
                    
                    break;
                    
                default:
                    break;
            }
            
            clickBlock = button.action.clickBlock;
            
            break;
        }
        
    }
    
    if (isClose) {
        
        [self closeAnimationsWithCompletionBlock:^{
        
            if (clickBlock) clickBlock();
        }];
        
    } else {
        
        if (clickBlock) clickBlock();
    }
    
}

- (void)headerTapAction:(UITapGestureRecognizer *)tap{
    
    if (self.config.modelIsClickHeaderClose) [self closeAnimationsWithCompletionBlock:nil];
}

#pragma mark start animations

- (void)showAnimationsWithCompletionBlock:(void (^)(void))completionBlock{
    
    [super showAnimationsWithCompletionBlock:completionBlock];
    
    if (self.isShowing) return;
    
    self.isShowing = YES;
    
    CGFloat viewWidth = VIEW_WIDTH;
    
    CGFloat viewHeight = VIEW_HEIGHT;
    
    CGRect containerFrame = self.containerView.frame;
    
    if (self.config.modelOpenAnimationStyle & FFAnimationStyleOrientationNone) {
        
        containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
        
        containerFrame.origin.y = (viewHeight - containerFrame.size.height) * 0.5f;
        
    } else if (self.config.modelOpenAnimationStyle & FFAnimationStyleOrientationTop) {
        
        containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
        
        containerFrame.origin.y = 0 - containerFrame.size.height;
        
    } else if (self.config.modelOpenAnimationStyle & FFAnimationStyleOrientationBottom) {
        
        containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
        
        containerFrame.origin.y = viewHeight;
        
    } else if (self.config.modelOpenAnimationStyle & FFAnimationStyleOrientationLeft) {
        
        containerFrame.origin.x = 0 - containerFrame.size.width;
        
        containerFrame.origin.y = (viewHeight - containerFrame.size.height) * 0.5f;
        
    } else if (self.config.modelOpenAnimationStyle & FFAnimationStyleOrientationRight) {
        
        containerFrame.origin.x = viewWidth;
        
        containerFrame.origin.y = (viewHeight - containerFrame.size.height) * 0.5f;
    }
    
    self.containerView.frame = containerFrame;
    
    if (self.config.modelOpenAnimationStyle & FFAnimationStyleFade) self.containerView.alpha = 0.0f;
    
    if (self.config.modelOpenAnimationStyle & FFAnimationStyleZoomEnlarge) self.containerView.transform = CGAffineTransformMakeScale(0.6f , 0.6f);
    
    if (self.config.modelOpenAnimationStyle & FFAnimationStyleZoomShrink) self.containerView.transform = CGAffineTransformMakeScale(1.2f , 1.2f);
    
    __weak typeof(self) weakSelf = self;
    
    if (self.config.modelOpenAnimationConfigBlock) self.config.modelOpenAnimationConfigBlock(^{
        
        if (!weakSelf) return ;
        
        if (weakSelf.config.modelBackgroundStyle == FFBackgroundStyleTranslucent) {
            
            weakSelf.view.backgroundColor = [weakSelf.view.backgroundColor colorWithAlphaComponent:weakSelf.config.modelBackgroundStyleColorAlpha];
            
        } else if (weakSelf.config.modelBackgroundStyle == FFBackgroundStyleBlur) {
            
            weakSelf.backgroundVisualEffectView.effect = [UIBlurEffect effectWithStyle:weakSelf.config.modelBackgroundBlurEffectStyle];
        }
        
        CGRect containerFrame = weakSelf.containerView.frame;
        
        containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
        
        containerFrame.origin.y = (viewHeight - containerFrame.size.height) * 0.5f;
        
        weakSelf.containerView.frame = containerFrame;
        
        weakSelf.containerView.alpha = 1.0f;
        
        weakSelf.containerView.transform = CGAffineTransformIdentity;
        
    }, ^{
       
        if (!weakSelf) return ;
        
        weakSelf.isShowing = NO;
        
        [weakSelf.view setUserInteractionEnabled:YES];
        
        if (weakSelf.openFinishBlock) weakSelf.openFinishBlock();
        
        if (completionBlock) completionBlock();
    });
    
}

#pragma mark close animations

- (void)closeAnimationsWithCompletionBlock:(void (^)(void))completionBlock{
    
    [super closeAnimationsWithCompletionBlock:completionBlock];
    
    if (self.isClosing) return;
    
    self.isClosing = YES;
    
    CGFloat viewWidth = VIEW_WIDTH;
    
    CGFloat viewHeight = VIEW_HEIGHT;
    
    __weak typeof(self) weakSelf = self;
    
    if (self.config.modelCloseAnimationConfigBlock) self.config.modelCloseAnimationConfigBlock(^{
        
        if (!weakSelf) return ;
        
        if (weakSelf.config.modelBackgroundStyle == FFBackgroundStyleTranslucent) {
            
            weakSelf.view.backgroundColor = [weakSelf.view.backgroundColor colorWithAlphaComponent:0.0f];
            
        } else if (weakSelf.config.modelBackgroundStyle == FFBackgroundStyleBlur) {
            
            weakSelf.backgroundVisualEffectView.alpha = 0.0f;
        }
        
        CGRect containerFrame = weakSelf.containerView.frame;
        
        if (weakSelf.config.modelCloseAnimationStyle & FFAnimationStyleOrientationNone) {
            
            containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
            
            containerFrame.origin.y = (viewHeight - containerFrame.size.height) * 0.5f;
            
        } else if (weakSelf.config.modelCloseAnimationStyle & FFAnimationStyleOrientationTop) {
            
            containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
            
            containerFrame.origin.y = 0 - containerFrame.size.height;
            
        } else if (weakSelf.config.modelCloseAnimationStyle & FFAnimationStyleOrientationBottom) {
            
            containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
            
            containerFrame.origin.y = viewHeight;
            
        } else if (weakSelf.config.modelCloseAnimationStyle & FFAnimationStyleOrientationLeft) {
            
            containerFrame.origin.x = 0 - containerFrame.size.width;
            
            containerFrame.origin.y = (viewHeight - containerFrame.size.height) * 0.5f;
            
        } else if (weakSelf.config.modelCloseAnimationStyle & FFAnimationStyleOrientationRight) {
            
            containerFrame.origin.x = viewWidth;
            
            containerFrame.origin.y = (viewHeight - containerFrame.size.height) * 0.5f;
        }
        
        weakSelf.containerView.frame = containerFrame;
        
        if (weakSelf.config.modelCloseAnimationStyle & FFAnimationStyleFade) weakSelf.containerView.alpha = 0.0f;
        
        if (weakSelf.config.modelCloseAnimationStyle & FFAnimationStyleZoomEnlarge) weakSelf.containerView.transform = CGAffineTransformMakeScale(1.2f , 1.2f);
        
        if (weakSelf.config.modelCloseAnimationStyle & FFAnimationStyleZoomShrink) weakSelf.containerView.transform = CGAffineTransformMakeScale(0.6f , 0.6f);
        
    }, ^{
       
        if (!weakSelf) return ;
        
        weakSelf.isClosing = NO;
        
        if (weakSelf.closeFinishBlock) weakSelf.closeFinishBlock();
        
        if (completionBlock) completionBlock();
    });
    
}

#pragma mark Tool

- (UIView *)findFirstResponder:(UIView *)view{
    
    if (view.isFirstResponder) return view;
    
    for (UIView *subView in view.subviews) {
        
        UIView *firstResponder = [self findFirstResponder:subView];
        
        if (firstResponder) return firstResponder;
    }
    
    return nil;
}

#pragma mark delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    return (touch.view == self.alertView) ? YES : NO;
}

#pragma mark LazyLoading

- (UIScrollView *)alertView{
    
    if (!_alertView) {
        
        _alertView = [[UIScrollView alloc] init];
        
        _alertView.backgroundColor = self.config.modelHeaderColor;
        
        _alertView.directionalLockEnabled = YES;
        
        _alertView.bounces = NO;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerTapAction:)];
        
        tap.numberOfTapsRequired = 1;
        
        tap.numberOfTouchesRequired = 1;
        
        tap.delegate = self;
        
        [_alertView addGestureRecognizer:tap];
    }
    
    return _alertView;
}

- (NSMutableArray *)alertItemArray{
    
    if (!_alertItemArray) _alertItemArray = [NSMutableArray array];
    
    return _alertItemArray;
}

- (NSMutableArray <FFActionButton *>*)alertActionArray{
    
    if (!_alertActionArray) _alertActionArray = [NSMutableArray array];
    
    return _alertActionArray;
}

@end

#pragma mark - ActionSheet

@interface FFActionSheetViewController ()

@property (nonatomic , strong ) UIView *containerView;

@property (nonatomic , strong ) UIScrollView *actionSheetView;

@property (nonatomic , strong ) NSMutableArray <id>*actionSheetItemArray;

@property (nonatomic , strong ) NSMutableArray <FFActionButton *>*actionSheetActionArray;

@property (nonatomic , strong ) UIView *actionSheetCancelActionSpaceView;

@property (nonatomic , strong ) FFActionButton *actionSheetCancelAction;

@end

@implementation FFActionSheetViewController
{
    BOOL isShowed;
}

- (void)dealloc{
    
    _actionSheetView = nil;
    
    _actionSheetCancelAction = nil;
    
    _actionSheetActionArray = nil;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self configActionSheet];
}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    if (!self.isShowing && !self.isClosing) [self updateActionSheetLayout];
}

- (void)updateActionSheetLayout{
    
    [self updateActionSheetLayoutWithViewWidth:VIEW_WIDTH ViewHeight:VIEW_HEIGHT];
}

- (void)updateActionSheetLayoutWithViewWidth:(CGFloat)viewWidth ViewHeight:(CGFloat)viewHeight{
    
    CGFloat actionSheetViewMaxWidth = self.config.modelMaxWidthBlock(self.orientationType);
    
    CGFloat actionSheetViewMaxHeight = self.config.modelMaxHeightBlock(self.orientationType);
    
    [UIView setAnimationsEnabled:NO];
    
    __block CGFloat actionSheetViewHeight = 0.0f;
    
    [self.actionSheetItemArray enumerateObjectsUsingBlock:^(id  _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx == 0) actionSheetViewHeight += self.config.modelHeaderInsets.top;
        
        if ([item isKindOfClass:UIView.class]) {
            
            FFItemView *view = (FFItemView *)item;
            
            CGRect viewFrame = view.frame;
            
            viewFrame.origin.x = self.config.modelHeaderInsets.left + view.item.insets.left;
            
            viewFrame.origin.y = actionSheetViewHeight + view.item.insets.top;
            
            viewFrame.size.width = actionSheetViewMaxWidth - viewFrame.origin.x - self.config.modelHeaderInsets.right - view.item.insets.right;
            
            if ([item isKindOfClass:UILabel.class]) viewFrame.size.height = [item sizeThatFits:CGSizeMake(viewFrame.size.width, MAXFLOAT)].height;
            
            view.frame = viewFrame;
            
            actionSheetViewHeight += view.frame.size.height + view.item.insets.top + view.item.insets.bottom;
            
        } else if ([item isKindOfClass:FFCustomView.class]) {
            
            FFCustomView *custom = (FFCustomView *)item;
            
            CGRect viewFrame = custom.view.frame;
            
            if (custom.isAutoWidth) {
                
                custom.positionType = FFCustomViewPositionTypeCenter;
                
                viewFrame.size.width = actionSheetViewMaxWidth - self.config.modelHeaderInsets.left - custom.item.insets.left - self.config.modelHeaderInsets.right - custom.item.insets.right;
            }
            
            switch (custom.positionType) {
                    
                case FFCustomViewPositionTypeCenter:
                    
                    viewFrame.origin.x = (actionSheetViewMaxWidth - viewFrame.size.width) * 0.5f;
                    
                    break;
                    
                case FFCustomViewPositionTypeLeft:
                    
                    viewFrame.origin.x = self.config.modelHeaderInsets.left + custom.item.insets.left;
                    
                    break;
                    
                case FFCustomViewPositionTypeRight:
                    
                    viewFrame.origin.x = actionSheetViewMaxWidth - self.config.modelHeaderInsets.right - custom.item.insets.right - viewFrame.size.width;
                    
                    break;
                    
                default:
                    break;
            }
            
            viewFrame.origin.y = actionSheetViewHeight + custom.item.insets.top;
            
            custom.view.frame = viewFrame;
            
            actionSheetViewHeight += viewFrame.size.height + custom.item.insets.top + custom.item.insets.bottom;
        }
        
        if (item == self.actionSheetItemArray.lastObject) actionSheetViewHeight += self.config.modelHeaderInsets.bottom;
    }];
    
    for (FFActionButton *button in self.actionSheetActionArray) {
        
        CGRect buttonFrame = button.frame;
        
        buttonFrame.origin.x = button.action.insets.left;
        
        buttonFrame.origin.y = actionSheetViewHeight + button.action.insets.top;
        
        buttonFrame.size.width = actionSheetViewMaxWidth - button.action.insets.left - button.action.insets.right;
        
        button.frame = buttonFrame;
        
        actionSheetViewHeight += buttonFrame.size.height + button.action.insets.top + button.action.insets.bottom;
    }
    
    self.actionSheetView.contentSize = CGSizeMake(actionSheetViewMaxWidth, actionSheetViewHeight);
    
    [UIView setAnimationsEnabled:YES];
    
    CGFloat cancelActionTotalHeight = self.actionSheetCancelAction ? self.actionSheetCancelAction.actionHeight + self.config.modelActionSheetCancelActionSpaceWidth : 0.0f;
    
    CGRect actionSheetViewFrame = self.actionSheetView.frame;
    
    actionSheetViewFrame.size.width = actionSheetViewMaxWidth;
    
    actionSheetViewFrame.size.height = actionSheetViewHeight > actionSheetViewMaxHeight - cancelActionTotalHeight ? actionSheetViewMaxHeight - cancelActionTotalHeight : actionSheetViewHeight;
    
    actionSheetViewFrame.origin.x = 0;
    
    self.actionSheetView.frame = actionSheetViewFrame;
    
    if (self.actionSheetCancelAction) {
        
        CGRect spaceFrame = self.actionSheetCancelActionSpaceView.frame;
        
        spaceFrame.origin.x = 0;
        
        spaceFrame.origin.y = actionSheetViewFrame.origin.y + actionSheetViewFrame.size.height;
        
        spaceFrame.size.width = actionSheetViewMaxWidth;
        
        spaceFrame.size.height = self.config.modelActionSheetCancelActionSpaceWidth;
        
        self.actionSheetCancelActionSpaceView.frame = spaceFrame;
        
        CGRect buttonFrame = self.actionSheetCancelAction.frame;
        
        buttonFrame.origin.x = 0;
        
        buttonFrame.origin.y = actionSheetViewFrame.origin.y + actionSheetViewFrame.size.height + spaceFrame.size.height;
        
        buttonFrame.size.width = actionSheetViewMaxWidth;
        
        self.actionSheetCancelAction.frame = buttonFrame;
    }
    
    CGRect containerFrame = self.containerView.frame;
    
    containerFrame.size.width = actionSheetViewFrame.size.width;
    
    containerFrame.size.height = actionSheetViewFrame.size.height + cancelActionTotalHeight;
    
    containerFrame.origin.x = (viewWidth - actionSheetViewMaxWidth) * 0.5f;
    
    if (isShowed) {
        
        containerFrame.origin.y = (viewHeight - containerFrame.size.height) - self.config.modelActionSheetBottomMargin;
        
    } else {
        
        containerFrame.origin.y = viewHeight;
    }
    
    self.containerView.frame = containerFrame;
}

- (void)configActionSheet{
    
    __weak typeof(self) weakSelf = self;
    
    _containerView = [UIView new];
    
    [self.view addSubview: _containerView];
    
    [self.containerView addSubview: self.actionSheetView];
    
    [self.actionSheetView addShadowWithShadowOpacity:self.config.modelShadowOpacity];
    
    [self.actionSheetView cornerRadius:self.config.modelCornerRadius];
    
    
    [self.config.modelItemArray enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        void (^itemBlock)(FFItem *) = obj;
        
        FFItem *item = [[FFItem alloc] init];
        
        if (itemBlock) itemBlock(item);
        
        NSValue *insetValue = [self.config.modelItemInsetsInfo objectForKey:@(idx)];
        
        if (insetValue) item.insets = insetValue.UIEdgeInsetsValue;
        
        switch (item.type) {
                
            case FFItemTypeTitle:
            {
                void(^block)(UILabel *label) = item.block;
                
                FFItemLabel *label = [FFItemLabel label];
                
                [self.actionSheetView addSubview:label];
                
                [self.actionSheetItemArray addObject:label];
                
                label.textAlignment = NSTextAlignmentCenter;
                
                label.font = [UIFont boldSystemFontOfSize:16.0f];
                
                label.textColor = [UIColor darkGrayColor];
                
                label.numberOfLines = 0;
                
                if (block) block(label);
                
                label.item = item;
                
                label.textChangedBlock = ^{
                    
                    if (weakSelf) [weakSelf updateActionSheetLayout];
                };
            }
                break;
                
            case FFItemTypeContent:
            {
                void(^block)(UILabel *label) = item.block;
                
                FFItemLabel *label = [FFItemLabel label];
                
                [self.actionSheetView addSubview:label];
                
                [self.actionSheetItemArray addObject:label];
                
                label.textAlignment = NSTextAlignmentCenter;
                
                label.font = [UIFont systemFontOfSize:14.0f];
                
                label.textColor = [UIColor grayColor];
                
                label.numberOfLines = 0;
                
                if (block) block(label);
                
                label.item = item;
                
                label.textChangedBlock = ^{
                    
                    if (weakSelf) [weakSelf updateActionSheetLayout];
                };
            }
                break;
                
            case FFItemTypeCustomView:
            {
                void(^block)(FFCustomView *) = item.block;
                
                FFCustomView *custom = [[FFCustomView alloc] init];
                
                block(custom);
                
                [self.actionSheetView addSubview:custom.view];
                
                [self.actionSheetItemArray addObject:custom];
                
                custom.item = item;
                
                custom.sizeChangedBlock = ^{
                    
                    if (weakSelf) [weakSelf updateActionSheetLayout];
                };
            }
                break;
            default:
                break;
        }
        
    }];
    
    for (id item in self.config.modelActionArray) {
        
        void (^block)(FFAction *action) = item;
        
        FFAction *action = [[FFAction alloc] init];
        
        if (block) block(action);
        
        if (!action.font) action.font = [UIFont systemFontOfSize:18.0f];
        
        if (!action.title) action.title = @"按钮";
        
        if (!action.titleColor) action.titleColor = [UIColor colorWithRed:21/255.0f green:123/255.0f blue:245/255.0f alpha:1.0f];
        
        if (!action.backgroundColor) action.backgroundColor = self.config.modelHeaderColor;
        
        if (!action.backgroundHighlightColor) action.backgroundHighlightColor = action.backgroundHighlightColor = [UIColor colorWithWhite:0.97 alpha:1.0f];
        
        if (!action.borderColor) action.borderColor = [UIColor colorWithWhite:0.86 alpha:1.0f];
        
        if (!action.borderWidth) action.borderWidth = DEFAULTBORDERWIDTH;
        
        if (!action.height) action.height = 57.0f;
        
        FFActionButton *button = [FFActionButton button];
        
        switch (action.type) {
                
            case FFActionTypeCancel:
            {
                [button addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                
                button.backgroundColor = action.backgroundColor;
                
                [self.containerView addSubview:button];
                
                [button addShadowWithShadowOpacity:self.config.modelShadowOpacity];
                
                [button cornerRadius:self.config.modelCornerRadius];
                
                self.actionSheetCancelAction = button;
                
                self.actionSheetCancelActionSpaceView = [[UIView alloc] init];
                
                self.actionSheetCancelActionSpaceView.backgroundColor = self.config.modelActionSheetCancelActionSpaceColor;
                
                [self.containerView addSubview:self.actionSheetCancelActionSpaceView];
            }
                break;
                
            default:
            {
                if (!action.borderPosition) action.borderPosition = FFActionBorderPositionTop;
                
                [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
                
                [self.actionSheetView addSubview:button];
                
                [self.actionSheetActionArray addObject:button];
            }
                break;
        }
        
        button.action = action;
        
        button.heightChangedBlock = ^{
          
            if (weakSelf) [weakSelf updateActionSheetLayout];
        };
    }
    
    // 更新布局
    
    [self updateActionSheetLayout];
    
    [self showAnimationsWithCompletionBlock:^{
        
        if (weakSelf) {
            
            [weakSelf updateActionSheetLayout];
        }
        
    }];
    
}

- (void)buttonAction:(UIButton *)sender{
    
    BOOL isClose = NO;
    
    void (^clickBlock)(void) = nil;
    
    for (FFActionButton *button in self.actionSheetActionArray) {
        
        if (button == sender) {
            
            switch (button.action.type) {
                    
                case FFActionTypeDefault:
                    
                    isClose = button.action.isClickNotClose ? NO : YES;
                    
                    break;
                    
                case FFActionTypeCancel:
                    
                    isClose = YES;
                    
                    break;
                    
                case FFActionTypeDestructive:
                    
                    isClose = YES;
                    
                    break;
                    
                default:
                    break;
            }
            
            clickBlock = button.action.clickBlock;
            
            break;
        }
        
    }
    
    if (isClose) {
        
        [self closeAnimationsWithCompletionBlock:^{
            
            if (clickBlock) clickBlock();
        }];
        
    } else {
        
        if (clickBlock) clickBlock();
    }
    
}

- (void)cancelButtonAction:(UIButton *)sender{
    
    void (^clickBlock)(void) = self.actionSheetCancelAction.action.clickBlock;
    
    [self closeAnimationsWithCompletionBlock:^{
        
        if (clickBlock) clickBlock();
    }];
    
}

- (void)headerTapAction:(UITapGestureRecognizer *)tap{
    
    if (self.config.modelIsClickHeaderClose) [self closeAnimationsWithCompletionBlock:nil];
}

#pragma mark start animations

- (void)showAnimationsWithCompletionBlock:(void (^)(void))completionBlock{
    
    [super showAnimationsWithCompletionBlock:completionBlock];
    
    if (self.isShowing) return;
    
    self.isShowing = YES;
    
    isShowed = YES;
    
    CGFloat viewWidth = VIEW_WIDTH;
    
    CGFloat viewHeight = VIEW_HEIGHT;
    
    CGRect containerFrame = self.containerView.frame;
    
    if (self.config.modelOpenAnimationStyle & FFAnimationStyleOrientationNone) {
        
        containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
        
        containerFrame.origin.y = (viewHeight - containerFrame.size.height) - self.config.modelActionSheetBottomMargin;
        
    } else if (self.config.modelOpenAnimationStyle & FFAnimationStyleOrientationTop) {
        
        containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
        
        containerFrame.origin.y = 0 - containerFrame.size.height;
        
    } else if (self.config.modelOpenAnimationStyle & FFAnimationStyleOrientationBottom) {
        
        containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
        
        containerFrame.origin.y = viewHeight;
        
    } else if (self.config.modelOpenAnimationStyle & FFAnimationStyleOrientationLeft) {
        
        containerFrame.origin.x = 0 - containerFrame.size.width;
        
        containerFrame.origin.y = (viewHeight - containerFrame.size.height) - self.config.modelActionSheetBottomMargin;
        
    } else if (self.config.modelOpenAnimationStyle & FFAnimationStyleOrientationRight) {
        
        containerFrame.origin.x = viewWidth;
        
        containerFrame.origin.y = (viewHeight - containerFrame.size.height) - self.config.modelActionSheetBottomMargin;
    }
    
    self.containerView.frame = containerFrame;
    
    if (self.config.modelOpenAnimationStyle & FFAnimationStyleFade) self.containerView.alpha = 0.0f;
    
    if (self.config.modelOpenAnimationStyle & FFAnimationStyleZoomEnlarge) self.containerView.transform = CGAffineTransformMakeScale(0.6f , 0.6f);
    
    if (self.config.modelOpenAnimationStyle & FFAnimationStyleZoomShrink) self.containerView.transform = CGAffineTransformMakeScale(1.2f , 1.2f);
    
    __weak typeof(self) weakSelf = self;
    
    if (self.config.modelOpenAnimationConfigBlock) self.config.modelOpenAnimationConfigBlock(^{
        
        if (!weakSelf) return ;
        
        switch (weakSelf.config.modelBackgroundStyle) {
                
            case FFBackgroundStyleBlur:
            {
                weakSelf.backgroundVisualEffectView.effect = [UIBlurEffect effectWithStyle:weakSelf.config.modelBackgroundBlurEffectStyle];
            }
                break;
                
            case FFBackgroundStyleTranslucent:
            {
                weakSelf.view.backgroundColor = [weakSelf.config.modelBackgroundColor colorWithAlphaComponent:weakSelf.config.modelBackgroundStyleColorAlpha];
            }
                break;
                
            default:
                break;
        }
        
        CGRect containerFrame = weakSelf.containerView.frame;
        
        containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
        
        containerFrame.origin.y = (viewHeight - containerFrame.size.height) - weakSelf.config.modelActionSheetBottomMargin;
        
        weakSelf.containerView.frame = containerFrame;
        
        weakSelf.containerView.alpha = 1.0f;
        
        weakSelf.containerView.transform = CGAffineTransformIdentity;
        
    }, ^{
       
        if (!weakSelf) return ;
        
        weakSelf.isShowing = NO;
        
        [weakSelf.view setUserInteractionEnabled:YES];
        
        if (weakSelf.openFinishBlock) weakSelf.openFinishBlock();
        
        if (completionBlock) completionBlock();
    });
    
}

#pragma mark close animations

- (void)closeAnimationsWithCompletionBlock:(void (^)(void))completionBlock{
    
    [super closeAnimationsWithCompletionBlock:completionBlock];
    
    if (self.isClosing) return;
    
    self.isClosing = YES;
    
    isShowed = NO;
    
    CGFloat viewWidth = VIEW_WIDTH;
    
    CGFloat viewHeight = VIEW_HEIGHT;
    
    __weak typeof(self) weakSelf = self;
    
    if (self.config.modelCloseAnimationConfigBlock) self.config.modelCloseAnimationConfigBlock(^{
        
        if (!weakSelf) return ;
        
        switch (weakSelf.config.modelBackgroundStyle) {
                
            case FFBackgroundStyleBlur:
            {
                weakSelf.backgroundVisualEffectView.alpha = 0.0f;
            }
                break;
                
            case FFBackgroundStyleTranslucent:
            {
                weakSelf.view.backgroundColor = [weakSelf.view.backgroundColor colorWithAlphaComponent:0.0f];
            }
                break;
                
            default:
                break;
        }
        
        CGRect containerFrame = weakSelf.containerView.frame;
        
        if (weakSelf.config.modelCloseAnimationStyle & FFAnimationStyleOrientationNone) {
            
        } else if (weakSelf.config.modelCloseAnimationStyle & FFAnimationStyleOrientationTop) {
            
            containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
            
            containerFrame.origin.y = 0 - containerFrame.size.height;
            
        } else if (weakSelf.config.modelCloseAnimationStyle & FFAnimationStyleOrientationBottom) {
            
            containerFrame.origin.x = (viewWidth - containerFrame.size.width) * 0.5f;
            
            containerFrame.origin.y = viewHeight;
            
        } else if (weakSelf.config.modelCloseAnimationStyle & FFAnimationStyleOrientationLeft) {
            
            containerFrame.origin.x = 0 - containerFrame.size.width;
            
        } else if (weakSelf.config.modelCloseAnimationStyle & FFAnimationStyleOrientationRight) {
            
            containerFrame.origin.x = viewWidth;
        }
        
        weakSelf.containerView.frame = containerFrame;
        
        if (weakSelf.config.modelCloseAnimationStyle & FFAnimationStyleFade) weakSelf.containerView.alpha = 0.0f;
        
        if (weakSelf.config.modelCloseAnimationStyle & FFAnimationStyleZoomEnlarge) weakSelf.containerView.transform = CGAffineTransformMakeScale(1.2f , 1.2f);
        
        if (weakSelf.config.modelCloseAnimationStyle & FFAnimationStyleZoomShrink) weakSelf.containerView.transform = CGAffineTransformMakeScale(0.6f , 0.6f);
        
    }, ^{
        
        if (!weakSelf) return ;
        
        weakSelf.isClosing = NO;
        
        if (weakSelf.closeFinishBlock) weakSelf.closeFinishBlock();
        
        if (completionBlock) completionBlock();
    });
    
}

#pragma mark delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    return (touch.view == self.actionSheetView) ? YES : NO;
}

#pragma mark LazyLoading

- (UIView *)actionSheetView{
    
    if (!_actionSheetView) {
        
        _actionSheetView = [[UIScrollView alloc] init];
        
        _actionSheetView.backgroundColor = self.config.modelHeaderColor;
        
        _actionSheetView.directionalLockEnabled = YES;
        
        _actionSheetView.bounces = NO;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerTapAction:)];
        
        tap.numberOfTapsRequired = 1;
        
        tap.numberOfTouchesRequired = 1;
        
        tap.delegate = self;
        
        [_actionSheetView addGestureRecognizer:tap];
    }
    
    return _actionSheetView;
}

- (NSMutableArray <id>*)actionSheetItemArray{
    
    if (!_actionSheetItemArray) _actionSheetItemArray = [NSMutableArray array];
    
    return _actionSheetItemArray;
}

- (NSMutableArray <FFActionButton *>*)actionSheetActionArray{
    
    if (!_actionSheetActionArray) _actionSheetActionArray = [NSMutableArray array];
    
    return _actionSheetActionArray;
}

@end

@interface FFAlertConfig ()<FFAlertProtocol>

@end

@implementation FFAlertConfig

- (void)dealloc{
    
    _config = nil;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        __weak typeof(self) weakSelf = self;
        
        self.config.modelFinishConfig = ^{
            
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            if (!strongSelf) return;
        
            if ([FFAlert shareManager].queueArray.count) {
                
                FFAlertConfig *last = [FFAlert shareManager].queueArray.lastObject;
                
                if (!strongSelf.config.modelIsQueue && last.config.modelQueuePriority > strongSelf.config.modelQueuePriority) return;
                
                if (!last.config.modelIsQueue && last.config.modelQueuePriority <= strongSelf.config.modelQueuePriority) [[FFAlert shareManager].queueArray removeObject:last];
                
                if (![[FFAlert shareManager].queueArray containsObject:strongSelf]) {
                    
                    [[FFAlert shareManager].queueArray addObject:strongSelf];
                    
                    [[FFAlert shareManager].queueArray sortUsingComparator:^NSComparisonResult(FFAlertConfig *configA, FFAlertConfig *configB) {
                        
                        return configA.config.modelQueuePriority > configB.config.modelQueuePriority ? NSOrderedDescending
                        : configA.config.modelQueuePriority == configB.config.modelQueuePriority ? NSOrderedSame : NSOrderedAscending;
                    }];
                    
                }
                
                if ([FFAlert shareManager].queueArray.lastObject == strongSelf) [strongSelf show];
                
            } else {
             
                [strongSelf show];
                
                [[FFAlert shareManager].queueArray addObject:strongSelf];
            }
            
        };
        
    }
    
    return self;
}

- (void)setType:(FFAlertType)type{
    
    _type = type;
    
    // 处理默认值
    
    switch (type) {
            
        case FFAlertTypeAlert:
            
            self.config
            .FFConfigMaxWidth(^CGFloat(FFScreenOrientationType type) {
               
                return 280.0f;
            })
            .FFConfigMaxHeight(^CGFloat(FFScreenOrientationType type) {
                
                return SCREEN_HEIGHT - 40.0f;
            })
            .FFOpenAnimationStyle(FFAnimationStyleOrientationNone | FFAnimationStyleFade | FFAnimationStyleZoomEnlarge)
            .FFCloseAnimationStyle(FFAnimationStyleOrientationNone | FFAnimationStyleFade | FFAnimationStyleZoomShrink);
            
            break;
            
        case FFAlertTypeActionSheet:
            
            self.config
            .FFConfigMaxWidth(^CGFloat(FFScreenOrientationType type) {
                
                return type == FFScreenOrientationTypeHorizontal ? SCREEN_HEIGHT - 20.0f : SCREEN_WIDTH - 20.0f;
            })
            .FFConfigMaxHeight(^CGFloat(FFScreenOrientationType type) {
                
                return SCREEN_HEIGHT - 40.0f;
            })
            .FFOpenAnimationStyle(FFAnimationStyleOrientationBottom)
            .FFCloseAnimationStyle(FFAnimationStyleOrientationBottom);
            
            break;
            
        default:
            break;
    }
    
}

- (void)show{
    
    switch (self.type) {
            
        case FFAlertTypeAlert:
            
            [FFAlert shareManager].viewController = [[FFAlertViewController alloc] init];
            
            break;
            
        case FFAlertTypeActionSheet:
            
            [FFAlert shareManager].viewController = [[FFActionSheetViewController alloc] init];
            
            break;
            
        default:
            break;
    }
    
    if (![FFAlert shareManager].viewController) return;
    
    [FFAlert shareManager].viewController.config = self.config;
    
    [FFAlert shareManager].FFWindow.windowLevel = self.config.modelWindowLevel;
    
    [FFAlert shareManager].FFWindow.rootViewController = [FFAlert shareManager].viewController;
    
    [FFAlert shareManager].FFWindow.hidden = NO;
    
    [[FFAlert shareManager].FFWindow makeKeyAndVisible];
    
    __weak typeof(self) weakSelf = self;
    
    [FFAlert shareManager].viewController.openFinishBlock = ^{
        
    };
    
    [FFAlert shareManager].viewController.closeFinishBlock = ^{
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (!strongSelf) return;
        
        if ([FFAlert shareManager].queueArray.lastObject == strongSelf) {
            
            [FFAlert shareManager].FFWindow.hidden = YES;
            
            [[FFAlert shareManager].FFWindow resignKeyWindow];
            
            [FFAlert shareManager].FFWindow.rootViewController = nil;
            
            [FFAlert shareManager].viewController = nil;
            
            [[FFAlert shareManager].queueArray removeObject:strongSelf];
            
            if (strongSelf.config.modelIsContinueQueueDisplay) [FFAlert continueQueueDisplay];
            
        } else {
            
            [[FFAlert shareManager].queueArray removeObject:strongSelf];
        }
        
        if (strongSelf.config.modelCloseComplete) strongSelf.config.modelCloseComplete();
    };
    
}

- (void)closeWithCompletionBlock:(void (^)(void))completionBlock{
    
    if ([FFAlert shareManager].viewController) [[FFAlert shareManager].viewController closeAnimationsWithCompletionBlock:completionBlock];
}

#pragma mark - LazyLoading

- (FFAlertConfigModel *)config{
    
    if (!_config) _config = [[FFAlertConfigModel alloc] init];
    
    return _config;
}

@end
