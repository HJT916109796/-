//
//  UINavigationController+HKExtension.m
//  HKProject
//
//  Created by 胡锦涛 on 2018/7/27.
//  Copyright © 2018年 胡锦涛. All rights reserved.
/*给某个页面添加侧滑返回功能模块，可以设置导航是否隐藏, 前提是不能给根视图添加侧滑返回手势
 hk_interactivePopDisabled 此属性只要在ViewDidLoad使用一次即可*/

#import "UINavigationController+HKExtension.h"
#import <objc/runtime.h>

@interface HKFullScreenPopGestureRecognizerDelegate : NSObject <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UINavigationController *navigationController;

@end

@implementation HKFullScreenPopGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    // Ignore when no view controller is pushed into the navigation stack.
    if (self.navigationController.viewControllers.count <= 1) {
        return NO;
    }
    
    // Ignore when the active view controller doesn't allow interactive pop.
    UIViewController *topViewController = self.navigationController.viewControllers.lastObject;
    if (topViewController.hk_interactivePopDisabled) {
        return NO;
    }
    
    // Ignore when the beginning location is beyond max allowed initial distance to left edge.
    CGPoint beginningLocation = [gestureRecognizer locationInView:gestureRecognizer.view];
    CGFloat maxAllowedInitialDistance = topViewController.hk_maxAllowedInitialDistanceToLeftEdge;
    if (maxAllowedInitialDistance > 0 && beginningLocation.x > maxAllowedInitialDistance) {
        return NO;
    }
    
    // Ignore pan gesture when the navigation controller is currently in transition.
    if ([[self.navigationController valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    
    // Prevent calling the handler when the gesture begins in an opposite direction.
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    BOOL isLeftToRight = [UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionLeftToRight;
    CGFloat multiplier = isLeftToRight ? 1 : - 1;
    if ((translation.x * multiplier) <= 0) {
        return NO;
    }
    
    return YES;
}

@end

typedef void (^HKViewControllerWillAppearInjectBlock)(UIViewController *viewController, BOOL animated);

@interface UIViewController (HKFullscreenPopGesturePrivate)

@property (nonatomic, copy) HKViewControllerWillAppearInjectBlock hk_willAppearInjectBlock;

@end

@implementation UIViewController (HKFullscreenPopGesturePrivate)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method viewWillAppear_originalMethod = class_getInstanceMethod(self, @selector(viewWillAppear:));
        Method viewWillAppear_swizzledMethod = class_getInstanceMethod(self, @selector(hk_viewWillAppear:));
        method_exchangeImplementations(viewWillAppear_originalMethod, viewWillAppear_swizzledMethod);
        
        Method viewWillDisappear_originalMethod = class_getInstanceMethod(self, @selector(viewWillDisappear:));
        Method viewWillDisappear_swizzledMethod = class_getInstanceMethod(self, @selector(hk_viewWillDisappear:));
        method_exchangeImplementations(viewWillDisappear_originalMethod, viewWillDisappear_swizzledMethod);
    });
}

- (void)hk_viewWillAppear:(BOOL)animated
{
    // Forward to primary implementation.
    [self hk_viewWillAppear:animated];
    
    if (self.hk_willAppearInjectBlock) {
        self.hk_willAppearInjectBlock(self, animated);
    }
}

- (void)hk_viewWillDisappear:(BOOL)animated
{
    // Forward to primary implementation.
    [self hk_viewWillDisappear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIViewController *viewController = self.navigationController.viewControllers.lastObject;
        if (viewController && !viewController.hk_preferNavBarHidden) {
            //[self.navigationController setNavigationBarHidden:YES animated:NO];
        }
    });
}

- (HKViewControllerWillAppearInjectBlock)hk_willAppearInjectBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHk_willAppearInjectBlock:(HKViewControllerWillAppearInjectBlock)block
{
    objc_setAssociatedObject(self, @selector(hk_willAppearInjectBlock), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

@implementation UINavigationController (HKExtension)

///设置NavBar属性
- (void)hk_setNavBar:(NSDictionary*)params {
    CGFloat font;
    UIColor *bgColor;
    UIColor *foregroundColor;
    if (params == nil) {
        font = 17;
        foregroundColor = [UIColor whiteColor];
        bgColor = [UIColor whiteColor];
    }else {
        font = [params[@"font"] floatValue];
        foregroundColor = params[@"foregroundColor"];
        bgColor = params[@"bgColor"];
    }
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:font]; // 字体大小
    attrs[NSForegroundColorAttributeName] = foregroundColor; // 颜色
    //self.navigationBar.tintColor = [UIColor whiteColor];
    UINavigationBar *naviBar = [UINavigationBar appearance];
    naviBar.barTintColor = bgColor;
    naviBar.tintColor = [UIColor whiteColor];
    [naviBar setTitleTextAttributes:attrs];
    // 解决iOS11界面缩放后导航栏空出状态栏的空隙的问题 方法1
    //[naviBar setBackgroundImage:[UIImage imageNamed:@"yitiji_date_nav_bg"] forBarMetrics:UIBarMetricsDefault];
}

+ (void)load
{
    // Inject "-pushViewController:animated:"
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(pushViewController:animated:);
        SEL swizzledSelector = @selector(fd_pushViewController:animated:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)fd_pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (![self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.hk_popGestureRecognizer]) {
        
        // Add our own gesture recognizer to where the onboard screen edge pan gesture recognizer is attached to.
        [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.hk_popGestureRecognizer];
        
        // Forward the gesture events to the private handler of the onboard gesture recognizer.
        NSArray *internalTargets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
        id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
        SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
        self.hk_popGestureRecognizer.delegate = self.hk_popGestureRecognizerDelegate;
        [self.hk_popGestureRecognizer addTarget:internalTarget action:internalAction];
        
        // Disable the onboard gesture recognizer.
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    // Handle perferred navigation bar appearance.
    [self fd_setupViewControllerBasedNavigationBarAppearanceIfNeeded:viewController];
    
    // Forward to primary implementation.
    if (![self.viewControllers containsObject:viewController]) {
        [self fd_pushViewController:viewController animated:animated];
    }
}

- (void)fd_setupViewControllerBasedNavigationBarAppearanceIfNeeded:(UIViewController *)appearingViewController
{
    if (!self.hk_baseNavBarAppearanceEnabled) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    HKViewControllerWillAppearInjectBlock block = ^(UIViewController *viewController, BOOL animated) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf setNavigationBarHidden:viewController.hk_preferNavBarHidden animated:animated];
        }
    };
    
    // Setup will appear inject block to appearing view controller.
    // Setup disappearing view controller as well, because not every view controller is added into
    // stack by pushing, maybe by "-setViewControllers:".
    appearingViewController.hk_willAppearInjectBlock = block;
    UIViewController *disappearingViewController = self.viewControllers.lastObject;
    if (disappearingViewController && !disappearingViewController.hk_willAppearInjectBlock) {
        disappearingViewController.hk_willAppearInjectBlock = block;
    }
}

- (HKFullScreenPopGestureRecognizerDelegate *)hk_popGestureRecognizerDelegate
{
    HKFullScreenPopGestureRecognizerDelegate *delegate = objc_getAssociatedObject(self, _cmd);
    
    if (!delegate) {
        delegate = [[HKFullScreenPopGestureRecognizerDelegate alloc] init];
        delegate.navigationController = self;
        
        objc_setAssociatedObject(self, _cmd, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return delegate;
}

- (UIPanGestureRecognizer *)hk_popGestureRecognizer
{
    UIPanGestureRecognizer *panGestureRecognizer = objc_getAssociatedObject(self, _cmd);
    
    if (!panGestureRecognizer) {
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
        panGestureRecognizer.maximumNumberOfTouches = 1;
        
        objc_setAssociatedObject(self, _cmd, panGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return panGestureRecognizer;
}
- (BOOL)hk_baseNavBarAppearanceEnabled
{
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if (number) {
        return number.boolValue;
    }
    self.hk_baseNavBarAppearanceEnabled = YES;
    return YES;
}

- (void)setHk_baseNavBarAppearanceEnabled:(BOOL)enabled
{
    SEL key = @selector(hk_baseNavBarAppearanceEnabled);
    objc_setAssociatedObject(self, key, @(enabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation UIViewController (FDFullscreenPopGesture)

- (BOOL)hk_interactivePopDisabled
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setHk_interactivePopDisabled:(BOOL)disabled
{
    objc_setAssociatedObject(self, @selector(hk_interactivePopDisabled), @(disabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)hk_preferNavBarHidden
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setHk_preferNavBarHidden:(BOOL)hidden
{
    objc_setAssociatedObject(self, @selector(hk_preferNavBarHidden), @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (CGFloat)hk_maxAllowedInitialDistanceToLeftEdge
{
#if CGFLOAT_IS_DOUBLE
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
#else
    return [objc_getAssociatedObject(self, _cmd) floatValue];
#endif
}

- (void)setHk_maxAllowedInitialDistanceToLeftEdge:(CGFloat)distance
{
    SEL key = @selector(hk_maxAllowedInitialDistanceToLeftEdge);
    objc_setAssociatedObject(self, key, @(MAX(0, distance)), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
