//
//  UIViewController+HKExtension.h
//  HKProject
//
//  Created by 胡锦涛 on 2018/7/27.
//  Copyright © 2018年 胡锦涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (HKExtension)

///设置NavBarItem字体颜色
- (void)hk_setNavBarTextColor:(UIColor*)color;

///设置NavBar背景颜色
- (void)hk_setNavBarBgColor:(UIColor*)bgColor;

///设置导航条是否半透明
- (void)hk_setNavTranslucent:(BOOL)isTranslucent;

///导航条设置是否隐藏
- (void)hk_setNavBarHidden:(BOOL)isHide;

///设置状态栏字体颜色
- (void)hk_setStatusBarTextColor:(UIColor *)color;

///设置状态栏背景颜色
- (void)hk_setStatusBarBackgroundColor:(UIColor *)color;

///避免self.view在nav下面
- (void)hk_adjustNav;

///Present
- (void)hk_present:(UIViewController*)vc;

///返回事件
- (void)hk_back;

///Dismiss
- (void)hk_dismiss;

///回到根视图
- (void)hk_dismissToRoot;

///设置屏幕旋转方向 UIInterfaceOrientationPortrait
- (void)hk_setOrientation:(UIInterfaceOrientation)orientation;

///界面跳转动画
- (void)hk_makeTransionWith:(UIViewController*)vc;

///界面跳转平滑过渡
- (void)hk_linearTransionTo:(UIViewController*)destination;

///getPresentedViewController
- (UIViewController *)hk_presentedViewController;

@end
