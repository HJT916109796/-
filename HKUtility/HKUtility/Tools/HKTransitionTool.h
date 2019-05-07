//
//  HKTransitionTool.h
//  HKUtility
//
//  Created by 胡锦涛 on 2019/4/17.
//  Copyright © 2019 胡锦涛. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, HKTransitionStyle) {
    HKTransitionStyleFade = 0,             // 渐退
    HKTransitionStyleSlideFromTop,         // 从顶部滑入滑出
    HKTransitionStyleSlideFromBottom,      // 从底部滑入滑出
    HKTransitionStyleSlideFromLeft,        // 从左边滑入滑出
    HKTransitionStyleSlideFromRight,       // 从右边滑入滑出
    HKTransitionStyleBounce,               // 弹窗效果
    HKTransitionStyleDropDown,              // 顶部滑入底部滑出
    HKTransitionStyleForChooseQuestion,      // 顶部滑入底部滑出
    
};
typedef NS_ENUM(NSInteger, HKMixTransitionStyle) {
    HKMixTransitionStyleRightInLeftOut = 0, // 右进左出
};
@interface HKTransitionTool : UIView

/**
 *  进入的动画 show animation
 */
+ (void)hk_showAnimationForContainerView:(UIView*)containerView withTransitionStyle:(HKTransitionStyle)transitionStyle completion:(void(^)(void))completion;

/**
 *  消失的动画
 */
+ (void)hk_disappearAnimationForContainerView:(UIView*)containerView withTransitionStyle:(HKTransitionStyle)transitionStyle completion:(void(^)(void))completion;

/**
 *  混合动画 showMixAnimation
 */
+ (void)hk_showMixAnimationForContainerView:(UIView*)containerView withMixTransitionStyle:(HKMixTransitionStyle)transitionStyle completion:(void(^)(void))completion;
@end

NS_ASSUME_NONNULL_END
