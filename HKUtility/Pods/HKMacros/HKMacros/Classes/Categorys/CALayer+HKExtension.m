//
//  CALayer+HKExtension.m
//  HKProject
//
//  Created by 胡锦涛 on 2018/8/2.
//  Copyright © 2018年 胡锦涛. All rights reserved.
//

#import "CALayer+HKExtension.h"
#import <UIKit/UIKit.h>
//把角度转成弧度
#define angle2Rad(angle) ((angle) / 180.0 * M_PI)
@implementation CALayer (HKExtension)
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
-(CATransition *)transitionWithAnimType:(HKTransitionAnimType)animType subType:(HKTransitionSubType)subType curve:(HKTransitionCurve)curve duration:(CGFloat)duration{
    
    NSString *key = @"transition";
    
    if([self animationForKey:key]!=nil){
        [self removeAnimationForKey:key];
    }
    
    CATransition *transition=[CATransition animation];
    
    //动画时长
    transition.duration=duration;
    
    //动画类型
    transition.type=[self animaTypeWithTransitionType:animType];
    
    //动画方向
    transition.subtype=[self animaSubtype:subType];
    
    //缓动函数
    transition.timingFunction=[CAMediaTimingFunction functionWithName:[self curve:curve]];
    
    //完成动画删除
    transition.removedOnCompletion = YES;
    
    [self addAnimation:transition forKey:key];
    
    return transition;
}


/*
 *  返回动画曲线
 */
-(NSString *)curve:(HKTransitionCurve)curve{
    
    //曲线数组
    NSArray *funcNames=@[kCAMediaTimingFunctionDefault,kCAMediaTimingFunctionEaseIn,kCAMediaTimingFunctionEaseInEaseOut,kCAMediaTimingFunctionEaseOut,kCAMediaTimingFunctionLinear];
    
    return [self objFromArray:funcNames index:curve isRamdom:(HKTransitionCurveRamdom == curve)];
}



/*
 *  返回动画方向
 */
-(NSString *)animaSubtype:(HKTransitionSubType)subType{
    
    //设置转场动画的方向
    NSArray *subtypes=@[kCATransitionFromTop,kCATransitionFromLeft,kCATransitionFromBottom,kCATransitionFromRight];
    
    return [self objFromArray:subtypes index:subType isRamdom:(HKTransitionSubtypesFromRamdom == subType)];
}




/*
 *  返回动画类型
 */
-(NSString *)animaTypeWithTransitionType:(HKTransitionAnimType)type{
    
    //设置转场动画的类型
    NSArray *animArray=@[@"rippleEffect",@"suckEffect",@"cameraIrisHollowOpen",@"cameraIrisHollowClose",@"pageCurl",@"pageUnCurl",@"oglFlip",@"cube",@"reveal",@"push",@"moveIn"];
    
    return [self objFromArray:animArray index:type isRamdom:(HKTransitionAnimTypeRamdom == type)];
}



/*
 *  统一从数据返回对象
 */
-(id)objFromArray:(NSArray *)array index:(NSUInteger)index isRamdom:(BOOL)isRamdom{
    
    NSUInteger count = array.count;
    
    NSUInteger i = isRamdom?arc4random_uniform((u_int32_t)count) : index;
    
    return array[i];
}

///CABasic自旋转动画
- (void)hk_AddAutoRoration{
    CABasicAnimation * rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:2*M_PI];
    rotationAnimation.duration = 4.0f;
    rotationAnimation.repeatCount = MAXFLOAT;
    rotationAnimation.removedOnCompletion = NO;
    [self addAnimation:rotationAnimation forKey:nil];
}

/** 核心动画-心跳 */
- (void)hk_HeartBeat{
    //创建动画对象
    CABasicAnimation * animation = [CABasicAnimation animation];
    
    //设置属性值
    animation.keyPath = @"transform.scale";
    animation.toValue = @0;
    
    //设置动画执行时长
    animation.duration = 2.0f;
    
    //设置动画执行次数
    animation.repeatCount = MAXFLOAT;
    
    //自动反转(怎么回去，怎么回来)
    animation.autoreverses = YES;
    animation.removedOnCompletion = NO;
    //添加动画
    [self addAnimation:animation forKey:nil];
}

/** 核心动画-图片抖动 */
- (void)hk_PictureShake{
    //创建动画对象
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animation];
    
    //设置属性值
    animation.keyPath = @"transform.rotation";
    animation.values = @[@(angle2Rad(-3)),@(angle2Rad(3)),@(angle2Rad(-3))];
    
    //设置动画执行时长
    animation.duration = 0.5f;
    
    //设置动画执行次数
    animation.repeatCount = MAXFLOAT;
    
    //自动反转(怎么回去，怎么回来)
    //animation.autoreverses = YES;
    
    //添加动画
    [self addAnimation:animation forKey:nil];
}

/** 核心动画-图片移动位置 */
- (void)hk_PictureMovePosition{
    //创建动画对象
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animation];
    
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(50, 50)];
    [path addLineToPoint:CGPointMake(300, 50)];
    [path addLineToPoint:CGPointMake(300, 400)];
    
    //设置属性值
    animation.keyPath = @"position";
    animation.path =path.CGPath;
    
    //设置动画执行时长
    animation.duration = 2.0f;
    
    //添加动画
    [self addAnimation:animation forKey:nil];
}

/** 核心动画-转盘滚动 */
- (void)hk_WheelRotate{
    //创建动画对象
    CABasicAnimation * animation = [CABasicAnimation animation];
    
    //设置属性值
    animation.keyPath = @"transform.rotation";
    animation.toValue = @(M_PI * 3);
    
    //设置动画执行时长
    animation.duration = 1.0f;
    
    //设置动画执行次数
    animation.repeatCount = MAXFLOAT;
    
    //添加动画
    [self addAnimation:animation forKey:nil];
}

- (void)pauseAnimate{
    
    CFTimeInterval pausedTime = [self convertTime:CACurrentMediaTime() fromLayer:nil];
    self.speed = 0.0;
    self.timeOffset = pausedTime;
}

- (void)resumeAnimate{
    
    CFTimeInterval pausedTime = self.timeOffset;
    self.speed = 1.0;
    self.timeOffset = 0.0;
    self.beginTime = 0.0;
    CFTimeInterval timeSincePause = [self convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.beginTime = timeSincePause;
}


@end
