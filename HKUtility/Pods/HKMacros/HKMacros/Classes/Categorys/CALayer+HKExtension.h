//
//  CALayer+HKExtension.h
//  HKProject
//
//  Created by 胡锦涛 on 2018/8/2.
//  Copyright © 2018年 胡锦涛. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (HKExtension)
/*
 *  动画类型
 */
typedef enum{
    
    ///动画类型:滴水效果(不支持过渡方向)
    HKTransitionAnimTypeRippleEffect=0,
    
    ///动画类型:收缩效果，如一块布被抽走(不支持过渡方向)
    HKTransitionAnimTypeSuckEffect,
    
    ///动画类型:相机镜头打开效果(不支持过渡方向)
    HKTransitionAnimTypeCameraOpen,
    
    ///动画类型:相机镜头关上效果(不支持过渡方向)
    HKTransitionAnimTypeCameraClose,
    
    ///动画类型:向上翻页效果
    HKTransitionAnimTypePageCurl,
    
    ///动画类型:向下翻页效果
    HKTransitionAnimTypePageUnCurl,
    
    ///动画类型:上下左右翻转效果
    HKTransitionAnimTypeOglFlip,
    
    ///动画类型:立方体翻滚效果
    HKTransitionAnimTypeCube,
    
    ///动画类型:将旧视图移开,显示下面的新视图  kCAHKTransitionReveal
    HKTransitionAnimTypeReveal,
    
    ///动画类型:新视图把旧视图推出去  kCAHKTransitionPush
    HKTransitionAnimTypePush,
    
    ///动画类型:新视图移到旧视图上面   kCAHKTransitionMoveIn
    HKTransitionAnimTypeMoveIn,
   
    ///动画类型:随机
    HKTransitionAnimTypeRamdom,
    
}HKTransitionAnimType;

/*
 *  动画方向
 */
typedef enum{
    
    //从上
    HKTransitionSubtypesFromTop=0,
    //从左
    HKTransitionSubtypesFromLeft,
    //从下
    HKTransitionSubtypesFromBotoom,
    //从右
    HKTransitionSubtypesFromRight,
    //随机
    HKTransitionSubtypesFromRamdom,
    
}HKTransitionSubType;


/*
 *  动画曲线
 */
typedef enum {
    
    //默认
    HKTransitionCurveDefault,
    //缓进
    HKTransitionCurveEaseIn,
    //缓出
    HKTransitionCurveEaseOut,
    //缓进缓出
    HKTransitionCurveEaseInEaseOut,
    //线性
    HKTransitionCurveLinear,
    //随机
    HKTransitionCurveRamdom,
    
}HKTransitionCurve;

/**
 *  转场动画
 *
 *  @param animType 转场动画类型
 *  @param subType  转动动画方向
 *  @param curve    转动动画曲线
 *  @param duration 转动动画时长
 *
 *  @return 转场动画实例
 */
-(CATransition *)transitionWithAnimType:(HKTransitionAnimType)animType subType:(HKTransitionSubType)subType curve:(HKTransitionCurve)curve duration:(CGFloat)duration;

///CABasic自旋转动画
- (void)hk_AddAutoRoration;

/** 核心动画-心跳 */
- (void)hk_HeartBeat;

/** 核心动画-图片抖动 */
- (void)hk_PictureShake;

/** 核心动画-图片移动位置 */
- (void)hk_PictureMovePosition;

/** 核心动画-转盘滚动 */
- (void)hk_WheelRotate;

///音乐封面-暂停动画 [self.imageView.layer pauseAnimate];
- (void)pauseAnimate;

///音乐封面-恢复动画 [self.imageView.layer resumeAnimate];
- (void)resumeAnimate;


@end
