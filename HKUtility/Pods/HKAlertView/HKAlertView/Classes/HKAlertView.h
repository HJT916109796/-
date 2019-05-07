//
//  HKAlertView.h
//  CallShow
//
//  Created by 胡锦涛 on 2018/4/25.
//  Copyright © 2018年 胡锦涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKMacro.h"

HK_EXTERN NSString *const HKAlertViewWillShowNotification;
HK_EXTERN NSString *const HKAlertViewDidShowNotification;
HK_EXTERN NSString *const HKAlertViewWillDismissNotification;
HK_EXTERN NSString *const HKAlertViewDidDismissNotification;

typedef NS_ENUM(NSInteger, HKAppearanceStyle) {
    HKAppearanceStyle_CallShow = 0,  // 默认,紫色
    HKAppearanceStyle_Security // 安全卫士，蓝色
};
typedef NS_ENUM(NSInteger, HKAlertViewStyle) {
    HKAlertViewStyleAlert = 0,  // 默认
    HKAlertViewStyleActionSheet // 暂未实现(有空再编写Frame)
};

typedef NS_ENUM(NSInteger, HKAlertViewButtonType) {
    HKAlertViewButtonTypeDefault = 0,   // 字体默认蓝色
    HKAlertViewButtonTypeDestructive,   // 字体默认红色
    HKAlertViewButtonTypeCancel         // 字体默认绿色
};

typedef NS_ENUM(NSInteger, HKAlertViewBackgroundStyle) {
    HKAlertViewBackgroundStyleSolid = 0,    // 平面的
    HKAlertViewBackgroundStyleGradient      // 聚光的
};

typedef NS_ENUM(NSInteger, HKAlertViewButtonsListStyle) {
    HKAlertViewButtonsListStyleNormal = 0,
    HKAlertViewButtonsListStyleRows // 每个按钮都是一行
};

typedef NS_ENUM(NSInteger, HKAlertViewTransitionStyle) {
    HKAlertViewTransitionStyleFade = 0,             // 渐退
    HKAlertViewTransitionStyleSlideFromTop,         // 从顶部滑入滑出
    HKAlertViewTransitionStyleSlideFromBottom,      // 从底部滑入滑出
    HKAlertViewTransitionStyleSlideFromLeft,        // 从左边滑入滑出
    HKAlertViewTransitionStyleSlideFromRight,       // 从右边滑入滑出
    HKAlertViewTransitionStyleBounce,               // 弹窗效果
    HKAlertViewTransitionStyleDropDown              // 顶部滑入底部滑出
};

@class HKAlertView;
typedef void(^HKAlertViewHandler)(HKAlertView *alertView);
@interface HKAlertView : UIView
/** 标题-只支持1行 */
@property (nonatomic, copy) NSString *title;

/** 消息描述-支持多行 */
@property (nonatomic, copy) NSString *message;

/** 消息描述-支持多行 */
@property (nonatomic, copy) NSMutableAttributedString *attributeMsg;

@property (nonatomic, assign) HKAlertViewStyle alertViewStyle;              // 默认是HKAlertViewStyleAlert
@property (nonatomic, assign) HKAlertViewTransitionStyle transitionStyle;   // 默认是 HKAlertViewTransitionStyleFade
@property (nonatomic, assign) HKAlertViewBackgroundStyle backgroundStyle;   // 默认是 HKAlertViewBackgroundStyleSolid
@property (nonatomic, assign) HKAlertViewButtonsListStyle buttonsListStyle; // 默认是 HKAlertViewButtonsListStyleNormal

@property (nonatomic, copy) HKAlertViewHandler willShowHandler;
@property (nonatomic, copy) HKAlertViewHandler didShowHandler;
@property (nonatomic, copy) HKAlertViewHandler willDismissHandler;
@property (nonatomic, copy) HKAlertViewHandler didDismissHandler;

@property (nonatomic, strong) UIColor *viewBackgroundColor          UI_APPEARANCE_SELECTOR; // 默认是白色
@property (nonatomic, strong) UIColor *titleColor                   UI_APPEARANCE_SELECTOR; // 默认是黑色
@property (nonatomic, strong) UIColor *messageColor                 UI_APPEARANCE_SELECTOR; // 默认是灰色
@property (nonatomic, strong) UIColor *defaultButtonTitleColor      UI_APPEARANCE_SELECTOR; // 默认是白色
@property (nonatomic, strong) UIColor *cancelButtonTitleColor       UI_APPEARANCE_SELECTOR; // 默认是白色
@property (nonatomic, strong) UIColor *destructiveButtonTitleColor  UI_APPEARANCE_SELECTOR; // 默认是白色
@property (nonatomic, strong) UIFont *titleFont                     UI_APPEARANCE_SELECTOR; // 默认是18.0
@property (nonatomic, strong) UIFont *messageFont                   UI_APPEARANCE_SELECTOR; // 默认是16.0
@property (nonatomic, strong) UIFont *buttonFont                    UI_APPEARANCE_SELECTOR; // 默认是buttonFontSize
@property (nonatomic, assign) CGFloat cornerRadius                  UI_APPEARANCE_SELECTOR; // 默认是10.0

/**
 * 设置取消按钮图片和状态
 */
- (void)setCancelButtonImage:(UIImage *)cancelButtonImage forState:(UIControlState)state    UI_APPEARANCE_SELECTOR;

/**
 *  设置毁灭性按钮图片和状态
 */
- (void)setDestructiveButtonImage:(UIImage *)destructiveButtonImage forState:(UIControlState)state  UI_APPEARANCE_SELECTOR;

/**
 *  初始化一个弹窗提示
 */
/*一个按钮*/
+ (instancetype)showTitle:(NSString *)title andMessage:(NSString *)message
              ensureTitle:(NSString*)ensureTitle ensureHandler:(HKAlertViewHandler)ensureHandler;
/*两个按钮*/

/** CallShowStyle */
+ (instancetype)showWithTitle:(NSString *)title andMessage:(NSString *)message cancelTitle:(NSString *)cancelTitle cancelHandler:(HKAlertViewHandler)cancelHandler ensureTitle:(NSString*)ensureTitle ensureHandler:(HKAlertViewHandler)ensureHandler;
+ (instancetype)showWithTitle:(NSString *)title attributeMessage:(NSMutableAttributedString *)attributeMessage cancelTitle:(NSString *)cancelTitle cancelHandler:(HKAlertViewHandler)cancelHandler ensureTitle:(NSString*)ensureTitle ensureHandler:(HKAlertViewHandler)ensureHandler;

/** SecurityStyle */
+ (instancetype)securityShowWithTitle:(NSString *)title attributeMessage:(NSMutableAttributedString *)attributeMessage cancelTitle:(NSString *)cancelTitle cancelHandler:(HKAlertViewHandler)cancelHandler ensureTitle:(NSString*)ensureTitle ensureHandler:(HKAlertViewHandler)ensureHandler;
+ (instancetype)securityShowWithTitle:(NSString *)title andMessage:(NSString *)message cancelTitle:(NSString *)cancelTitle cancelHandler:(HKAlertViewHandler)cancelHandler ensureTitle:(NSString*)ensureTitle ensureHandler:(HKAlertViewHandler)ensureHandler;

/** 显示弹窗提示 */
- (void)show;

@end
