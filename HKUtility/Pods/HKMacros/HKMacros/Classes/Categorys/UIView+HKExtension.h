//
//  UIView+HKExtension.h
//  HKProject
//
//  Created by 胡锦涛 on 2018/7/26.
//  Copyright © 2018年 胡锦涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HKExtension)

@property CGFloat hk_left;
@property CGFloat hk_top;
@property CGFloat hk_right;
@property CGFloat hk_bottom;
@property CGPoint hk_position;
@property CGFloat hk_x;
@property CGFloat hk_y;

@property CGSize hk_size;
@property CGFloat hk_width;
@property CGFloat hk_height;

@property (nonatomic) CGFloat hk_centerX;
@property (nonatomic) CGFloat hk_centerY;

/*设置是否可见*/
@property BOOL  hk_visible;

/** 普通切圆角 */
- (void)hk_circle;

/** 圆角=高的一半 */
- (void)hk_roundCorner;

/*切圆角最终解决方案*/
- (void)hk_addCorner:(CGFloat)radius;

/*移除所有子视图*/
- (void)hk_removeAllSubviews;

/*添加点击事件*/
- (void)hk_addTapTarget:(id)target action:(SEL)action;

#pragma mark - 伸缩变换

/*弹出*/
- (void)hk_popOutsideWithDuration:(NSTimeInterval)duration;

/*弹进*/
- (void)hk_popInsideWithDuration:(NSTimeInterval)duration;

/*UITableViewCell翻转*/
- (void)hk_CellFlipping;

/*The view controller whose view contains this view.*/
- (UIViewController*)hk_viewController;

/*设置背景图*/
- (void)hk_setBackgroundImage:(UIImage*)image;
- (UIImage*)hk_toImage;

/** 移除投影*/
- (void)hk_removeShadow;

/** 添加投影*/
- (void)hk_addShadowWithColor: (UIColor *)color opacity: (CGFloat)opacity offset: (CGSize)size cornerRadius: (CGFloat)radius;

///添加渐变色-Frame跟父视图一样
- (void)hk_addGradientColors:(NSArray*)gradientColors isVertical:(BOOL)vertical;

///添加渐变色(横向或竖向)
- (void)hk_addGradientColors:(NSArray*)gradientColors isVertical:(BOOL)vertical GradientFrame:(CGRect)frame;

///添加渐变色(圆形斜向渐变)Oblique倾斜的
- (void)hk_addObliqueGradientColors:(NSArray*)gradientColors GradientFrame:(CGRect)frame;

//移除渐变层级
- (void)hk_removeGradientLayers;

/**
 *  设置部分圆角(绝对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 */
- (void)hk_addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii;

/**
 *  设置部分圆角(相对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 *  @param rect    需要设置的圆角view的rect
 */
- (void)hk_addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii
                 viewRect:(CGRect)rect;

#pragma mark---------手势相关------
///添加点击手势
- (void)hk_addTapGestureWithTarget:(id)target action:(SEL)action;

///添加拖动手势
- (void)hk_addPanGestureWithTarget:(id)target action:(SEL)action;

///添加捏合手势
- (void)hk_addPinchGestureWithTarget:(id)target action:(SEL)action;

///添加旋转手势
- (void)hk_addRotationGestureWithTarget:(id)target action:(SEL)action;

///添加长按手势
- (void)hk_addLongPressGestureWithTarget:(id)target action:(SEL)action withDuration:(NSInteger)duration;

///添加滑动手势
- (void)hk_addSwipeGestureWithTarget:(id)target action:(SEL)action withDirection:(UISwipeGestureRecognizerDirection)direction;

@end
