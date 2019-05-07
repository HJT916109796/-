//
//  UIViewController+HKExtension.m
//  HKProject
//
//  Created by 胡锦涛 on 2018/7/27.
//  Copyright © 2018年 胡锦涛. All rights reserved.
//

#import "UIViewController+HKExtension.h"
#import <objc/runtime.h>
@implementation UIViewController (HKExtension)
+ (void)load {
    NSString *className = NSStringFromClass(self.class);
    NSLog(@"className %@", className);
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self changeSel:@selector(viewWillAppear:) toSel:@selector(HKViewWillAppear:)];
        [self changeSel:@selector(viewWillDisappear:) toSel:@selector(HKViewWillDisappear:)];
        [self changeSel:@selector(viewDidAppear:) toSel:@selector(HKViewDidAppear:)];
    });
    
}
+ (void)changeSel:(SEL)sel toSel:(SEL)tosel{
    
    Class class = [self class];
    
    SEL originalSelector = sel;
    SEL swizzledSelector = tosel;
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
-(void)HKViewDidAppear:(BOOL)animated{
    for (UIView * subview in self.view.subviews) {
        if ([subview respondsToSelector:@selector(setExclusiveTouch:)]) {
            [subview setExclusiveTouch:YES];
        }
    }
    [self HKViewDidAppear:animated];
}
- (void)HKViewWillAppear:(BOOL)animated{
    
    NSLog(@"HK_ViewWillAppear:----------------------%@",[self class]);
    [self HKViewWillAppear:animated];
}

- (void)HKViewWillDisappear:(BOOL)animated{
    
    NSLog(@"HK_ViewWillDisAppear:----------------------%@",[self class]);
    [self HKViewWillDisappear:animated];
}

///设置NavBarItem字体颜色
- (void)hk_setNavBarTextColor:(UIColor*)color {
    self.navigationController.navigationBar.tintColor = color == nil ? [UIColor blackColor] : color;
}

///设置NavBar背景颜色
- (void)hk_setNavBarBgColor:(UIColor*)bgColor {
    self.navigationController.navigationBar.barTintColor = bgColor == nil ? [UIColor whiteColor] : bgColor;
}

///设置导航条是否半透明
- (void)hk_setNavTranslucent:(BOOL)isTranslucent {
    if (isTranslucent) {
        self.navigationController.navigationBar.translucent = YES;
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    }else {
        self.navigationController.navigationBar.translucent = NO;
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:nil];
    }
}

///导航条设置是否隐藏
- (void)hk_setNavBarHidden:(BOOL)isHide {
    if (isHide) {
        self.navigationController.navigationBar.hidden = YES;
    }else {
        self.navigationController.navigationBar.hidden = NO;
    }
}

///设置状态栏字体颜色
- (void)hk_setStatusBarTextColor:(UIColor *)color {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

///设置状态栏背景颜色
- (void)hk_setStatusBarBackgroundColor:(UIColor *)color {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

///避免self.view在nav下面
- (void)hk_adjustNav{
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

///Present
- (void)hk_present:(UIViewController*)vc {
    [self presentViewController:vc animated:YES completion:nil];
}

///返回事件
- (void)hk_back {
    NSArray *viewcontrollers=self.navigationController.viewControllers;
    if (viewcontrollers.count>1) {
        if ([viewcontrollers objectAtIndex:viewcontrollers.count-1]==self) {
            //push方式
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        //present方式
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

///Dismiss
- (void)hk_dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

///回到根视图
- (void)hk_dismissToRoot {
    NSArray *viewcontrollers=self.navigationController.viewControllers;
    if (viewcontrollers.count>1) {
        if ([viewcontrollers objectAtIndex:viewcontrollers.count-1]==self) {
            //push方式
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        //present方式
        UIViewController *rootVC = self.presentingViewController;
        while (rootVC.presentingViewController) {
            rootVC = rootVC.presentingViewController;
        }
        [rootVC dismissViewControllerAnimated:YES completion:nil];
    }
}

///设置屏幕旋转方向 UIInterfaceOrientationPortrait
- (void)hk_setOrientation:(UIInterfaceOrientation)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

/*界面跳转动画*/
- (void)hk_makeTransionWith:(UIViewController*)vc;  {
    UIWindow * mainWindow = [[[UIApplication sharedApplication] delegate] window];
    [UIWindow transitionWithView:mainWindow duration:1 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:nil];
    mainWindow.rootViewController = vc;
}

- (void)hk_linearTransionTo:(UIViewController *)destination {
    destination.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:destination animated:NO completion:nil];
}

- (UIViewController *)hk_presentedViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
        return [self presentedViewController:topVC];
    }
    return topVC;
}

- (UIViewController *)presentedViewController:(UIViewController *)ctr
{
    if (ctr.presentedViewController)
    {
        ctr = ctr.presentedViewController;
        return [self presentedViewController:ctr];
    }
    return ctr;
}

@end
