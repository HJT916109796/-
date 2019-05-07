//
//  HKTransitionTool.m
//  HKUtility
//
//  Created by 胡锦涛 on 2019/4/17.
//  Copyright © 2019 胡锦涛. All rights reserved.
/*
 使用案例
 普通动画
 前提：先执行[self.view addSubview];
 - (void)showOtherAnsweringBgView {
 self.otherAnswerBgView.hidden = NO;
 [HKTransitionTool showAnimationForContainerView:self.otherAnswerBgView withTransitionStyle:STTransitionStyleForChooseQuestion completion:^{}];
 }
 - (void)disappearOtherAnsweringBgView {
 self.otherAnswerBgView.hidden = YES;
 [HKTransitionTool disappearAnimationForContainerView:self.otherAnswerBgView withTransitionStyle:STTransitionStyleForChooseQuestion completion:^{}];
 }
 
 混合动画
 self.hidden = NO;
 [HKTransitionTool showMixAnimationForContainerView:self.bgImgView withMixTransitionStyle:STMixTransitionStyleRightInLeftOut completion:^{
 self.hidden = YES;
 }];
 */

#import "HKTransitionTool.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HKPrefixHeader.h"

static HKTransitionTool *shareManager = nil;
@implementation HKTransitionTool
///动画单例
+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[HKTransitionTool alloc] init];
    });
    return shareManager;
}
//为了防止别人不小心利用alloc/init方式创建示例，也为了防止别人故意为之，我们要保证不管用什么方式创建都只能是同一个实例对象
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [super allocWithZone:zone];
    });
    return shareManager;
}

/**
 *  进入的动画 show animation
 */
+ (void)showAnimationForContainerView:(UIView*)containerView withTransitionStyle:(HKTransitionStyle)transitionStyle completion:(void(^)(void))completion {
    [[HKTransitionTool shareManager] showAnimationForContainerView:containerView withTransitionStyle:transitionStyle completion:completion];
}

/**
 *  消失的动画
 */
+ (void)disappearAnimationForContainerView:(UIView*)containerView withTransitionStyle:(HKTransitionStyle)transitionStyle completion:(void(^)(void))completion{
    [[HKTransitionTool shareManager] disappearAnimationForContainerView:containerView withTransitionStyle:transitionStyle completion:completion];
}
/**
 *  进入的动画 show animation
 */
- (void)showAnimationForContainerView:(UIView*)containerView withTransitionStyle:(HKTransitionStyle)transitionStyle completion:(void(^)(void))completion {
    switch (transitionStyle) {
        case HKTransitionStyleFade: {
            containerView.alpha = 0;
            
            [UIView animateWithDuration:0.3 animations:^{
                containerView.alpha = 1;
            } completion:^(BOOL finished) {
                if (completion) {
                    completion();
                }
            }];
            break;
        }
        case HKTransitionStyleSlideFromTop: {
            CGRect rect = containerView.frame;
            CGRect originalRect = rect;
            rect.origin.y = -HK_DEVICE_HEIGHT;
            containerView.frame = rect;
            
            [UIView animateWithDuration:0.3 animations:^{
                containerView.frame = originalRect;
            } completion:^(BOOL finished) {
                if (completion) {
                    completion();
                }
            }];
            break;
        }
        case HKTransitionStyleSlideFromBottom: {
            CGRect rect = containerView.frame;
            CGRect originalRect = rect;
            rect.origin.y = HK_DEVICE_HEIGHT;
            containerView.frame = rect;
            
            [UIView animateWithDuration:0.3 animations:^{
                containerView.frame = originalRect;
            } completion:^(BOOL finished) {
                if (completion) {
                    completion();
                }
            }];
            break;
        }
        case HKTransitionStyleForChooseQuestion: {
            CGRect rect = containerView.frame;
            CGRect originalRect = rect;
            rect.origin.y = rect.size.height + 160;
            containerView.frame = rect;
            
            [UIView animateWithDuration:0.3 animations:^{
                containerView.frame = originalRect;
            } completion:^(BOOL finished) {
                if (completion) {
                    completion();
                }
            }];
            break;
        }
        case HKTransitionStyleSlideFromLeft: {
            CGRect rect = containerView.frame;
            CGRect originalRect = rect;
            rect.origin.x = -rect.size.width;
            containerView.frame = rect;
            
            [UIView animateWithDuration:0.3 animations:^{
                containerView.frame = originalRect;
            } completion:^(BOOL finished) {
                if (completion) {
                    completion();
                }
            }];
            break;
        }
        case HKTransitionStyleSlideFromRight: {
            CGRect rect = containerView.frame;
            CGRect originalRect = rect;
            rect.origin.x += HK_DEVICE_WIDTH;
            containerView.frame = rect;
            
            [UIView animateWithDuration:0.3 animations:^{
                containerView.frame = originalRect;
            } completion:^(BOOL finished) {
                if (completion) {
                    completion();
                }
            }];
            break;
        }
        case HKTransitionStyleBounce: {
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            animation.values = @[@(0.01), @(1.2), @(0.9), @(1)];
            animation.keyTimes = @[@(0), @(0.4), @(0.6), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = 0.5;
            animation.delegate = self;
            [animation setValue:completion forKey:@"handler"];
            [containerView.layer addAnimation:animation forKey:@"bouce"];
            break;
        }
        case HKTransitionStyleDropDown: {
            CGFloat y = containerView.center.y;
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
            animation.values = @[@(y - self.hk_height), @(y + 20), @(y - 10), @(y)];
            animation.keyTimes = @[@(0), @(0.5), @(0.75), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = 0.4;
            animation.delegate = self;
            [animation setValue:completion forKey:@"handler"];
            [containerView.layer addAnimation:animation forKey:@"dropdown"];
            break;
        }
        default:
            break;
    }
}

/**
 *  消失的动画
 */
- (void)disappearAnimationForContainerView:(UIView*)containerView withTransitionStyle:(HKTransitionStyle)transitionStyle completion:(void(^)(void))completion {
    switch (transitionStyle) {
        case HKTransitionStyleSlideFromBottom: {
            CGRect rect = containerView.frame;
            rect.origin.y = self.hk_height;
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                containerView.frame = rect;
            } completion:^(BOOL finished) {
                if (completion) {
                    completion();
                }
            }];
            break;
        }
        case HKTransitionStyleForChooseQuestion: {
            CGRect rect = containerView.frame;
            rect.origin.y = self.hk_height;
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                containerView.frame = rect;
            } completion:^(BOOL finished) {
                if (completion) {
                    completion();
                }
            }];
            break;
        }
        case HKTransitionStyleSlideFromTop: {
            CGRect rect = containerView.frame;
            rect.origin.y = -rect.size.height;
            
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                containerView.frame = rect;
            } completion:^(BOOL finished) {
                if (completion) {
                    completion();
                }
            }];
            break;
        }
        case HKTransitionStyleSlideFromLeft: {
            CGRect rect = containerView.frame;
            rect.origin.x = -rect.size.width;
            
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                containerView.frame = rect;
            } completion:^(BOOL finished) {
                if (completion) {
                    completion();
                }
            }];
            break;
        }
        case HKTransitionStyleSlideFromRight: {
            CGRect rect = containerView.frame;
            rect.origin.x = rect.size.width;
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                containerView.frame = rect;
            } completion:^(BOOL finished) {
                if (completion) {
                    completion();
                }
            }];
            break;
        }
        case HKTransitionStyleFade: {
            [UIView animateWithDuration:0.25 animations:^{
                containerView.alpha = 0;
            } completion:^(BOOL finished) {
                if (completion) {
                    completion();
                }
            }];
            break;
        }
        case HKTransitionStyleBounce: {
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            animation.values = @[@(1), @(1.2), @(0.01)];
            animation.keyTimes = @[@(0), @(0.4), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = 0.35;
            animation.delegate = self;
            [animation setValue:completion forKey:@"handler"];
            [containerView.layer addAnimation:animation forKey:@"bounce"];
            containerView.transform = CGAffineTransformMakeScale(0.01, 0.01);
            break;
        }
        case HKTransitionStyleDropDown: {
            CGPoint point = containerView.center;
            point.y += self.hk_height;
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                containerView.center = point;
                CGFloat angle = ((CGFloat)arc4random_uniform(100) - 50.f) / 100.f;
                containerView.transform = CGAffineTransformMakeRotation(angle);
            } completion:^(BOOL finished) {
                if (completion) {
                    completion();
                }
            }];
            break;
        }
        default:
            break;
    }
}

#pragma mark - 混合动画
///混合动画 showMixAnimation
+ (void)hk_showMixAnimationForContainerView:(UIView*)containerView withMixTransitionStyle:(HKMixTransitionStyle)transitionStyle completion:(void(^)(void))completion {
    [[HKTransitionTool shareManager] hk_showMixAnimationForContainerView:containerView withMixTransitionStyle:transitionStyle completion:completion];
}
/**
 *  混合动画 showMixAnimation
 */
- (void)hk_showMixAnimationForContainerView:(UIView*)containerView withMixTransitionStyle:(HKMixTransitionStyle)transitionStyle completion:(void(^)(void))completion {
    switch (transitionStyle) {
        case HKMixTransitionStyleRightInLeftOut: {
            containerView.hidden = NO;
            CGRect rect = containerView.frame;
            CGRect originalRect = rect;
            rect.origin.x += HK_DEVICE_WIDTH;
            containerView.frame = rect;
            
            [UIView animateWithDuration:0.3 animations:^{
                containerView.frame = originalRect;
            } completion:^(BOOL finished) {
                
            }];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //消失动画
                __block CGRect rect = containerView.frame;
                rect.origin.x = -rect.size.width;
                
                [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    containerView.frame = rect;
                } completion:^(BOOL finished) {
                    containerView.hidden = YES;
                    //frame复原
                    rect.origin.x = 0;
                    containerView.frame = rect;
                    if (completion) {
                        completion();
                    }
                }];
            });
            break;
        }
            
        default:
            break;
    }
}
@end
