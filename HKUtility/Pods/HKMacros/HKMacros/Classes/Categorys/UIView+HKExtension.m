//
//  UIView+HKExtension.m
//  HKProject
//
//  Created by 胡锦涛 on 2018/7/26.
//  Copyright © 2018年 胡锦涛. All rights reserved.
//

#import "UIView+HKExtension.h"
#import <QuartzCore/QuartzCore.h>
#import "HKMacro.h"
#import "NSObject+HKExtension.h"
@implementation UIView (HKExtension)
+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL systemSel = @selector(addSubview:);
        SEL swizzSel = @selector(hk_addSubview:);
        [self hk_changeSel:systemSel toSel:swizzSel];
    });
}

- (void)hk_addSubview:(UIView *)view{
    if ([view respondsToSelector:@selector(setExclusiveTouch:)]) {
        [view setExclusiveTouch:YES];
    }
    [self hk_addSubview:view];
}

- (void)st_myAddSubview:(UIView *)view{
    if ([view respondsToSelector:@selector(setExclusiveTouch:)]) {
        [view setExclusiveTouch:YES];
    }
    [self st_myAddSubview:view];
}
- (CGPoint)hk_position {
    return self.frame.origin;
}

-(void)setHk_position:(CGPoint)hk_position {
    CGRect rect = self.frame;
    rect.origin = hk_position;
    [self setFrame:rect];
}

- (CGFloat)hk_x {
    return self.frame.origin.x;
}

-(void)setHk_x:(CGFloat)hk_x {
    CGRect rect = self.frame;
    rect.origin.x = hk_x;
    [self setFrame:rect];
}

- (CGFloat)hk_y {
    return self.frame.origin.y;
}

-(void)setHk_y:(CGFloat)hk_y {
    CGRect rect = self.frame;
    rect.origin.y = hk_y;
    [self setFrame:rect];
}

- (CGFloat)hk_left {
    return self.frame.origin.x;
}
-(void)setHk_left:(CGFloat)hk_left {
    CGRect frame = self.frame;
    frame.origin.x = hk_left;
    self.frame = frame;
}

- (CGFloat)hk_top {
    return self.frame.origin.y;
}

-(void)setHk_top:(CGFloat)hk_top{
    CGRect frame = self.frame;
    frame.origin.y = hk_top;
    self.frame = frame;
}

- (CGFloat)hk_right {
    return self.frame.origin.x + self.frame.size.width;
}

-(void)setHk_right:(CGFloat)hk_right {
    CGRect frame = self.frame;
    frame.origin.x = hk_right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)hk_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

-(void)setHk_bottom:(CGFloat)hk_bottom {
    CGRect frame = self.frame;
    frame.origin.y = hk_bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)hk_centerX {
    return self.center.x;
}
-(void)setHk_centerX:(CGFloat)hk_centerX {
    self.center = CGPointMake(hk_centerX, self.center.y);
}

- (CGFloat)hk_centerY {
    return self.center.y;
}

-(void)setHk_centerY:(CGFloat)hk_centerY {
    self.center = CGPointMake(self.center.x, hk_centerY);
}

- (BOOL)hk_visible {
    return !self.hidden;
}

-(void)setHk_visible:(BOOL)hk_visible {
    self.hidden=!hk_visible;
}

- (CGSize)hk_size {
    return [self frame].size;
}

-(void)setHk_size:(CGSize)hk_size {
    CGRect rect = self.frame;
    rect.size = hk_size;
    [self setFrame:rect];
}

- (CGFloat)hk_width {
    return self.frame.size.width;
}

-(void)setHk_width:(CGFloat)hk_width {
    CGRect rect = self.frame;
    rect.size.width = hk_width;
    [self setFrame:rect];
}

- (CGFloat)hk_height {
    return self.frame.size.height;
}

-(void)setHk_height:(CGFloat)hk_height {
    CGRect rect = self.frame;
    rect.size.height = hk_height;
    [self setFrame:rect];
}
#pragma mark---------伸缩变换------
//弹出
- (void)hk_popOutsideWithDuration:(NSTimeInterval)duration {
    
    self.transform = CGAffineTransformIdentity;
    [UIView animateKeyframesWithDuration:duration delay:0 options:0 animations: ^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 / 3.0 animations: ^{
            self.transform = CGAffineTransformMakeScale(1.5f, 1.5f); // 放大
        }];
        [UIView addKeyframeWithRelativeStartTime:1/3.0 relativeDuration:1/3.0 animations: ^{
            self.transform = CGAffineTransformMakeScale(0.8f, 0.8f); // 放小
        }];
        [UIView addKeyframeWithRelativeStartTime:2/3.0 relativeDuration:1/3.0 animations: ^{
            self.transform = CGAffineTransformMakeScale(1.0f, 1.0f); //恢复原样
        }];
    } completion:nil];
}
//弹进
- (void)hk_popInsideWithDuration:(NSTimeInterval)duration {
    
    self.transform = CGAffineTransformIdentity;
    [UIView animateKeyframesWithDuration:duration delay:0 options:0 animations: ^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 / 2.0 animations: ^{
            self.transform = CGAffineTransformMakeScale(0.7f, 0.7f); // 放小
        }];
        [UIView addKeyframeWithRelativeStartTime:1/2.0 relativeDuration:1/2.0 animations: ^{
            self.transform = CGAffineTransformMakeScale(1.0f, 1.0f); //恢复原样
        }];
    } completion:nil];
}

- (void)hk_CellFlipping {
    [UIView transitionWithView:self duration:1 options:UIViewAnimationOptionTransitionFlipFromRight animations:nil completion:nil];
}
//添加点击事件
- (void)hk_addTapTarget:(id)target action:(SEL)action {
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:target action:action];
    [self addGestureRecognizer:tapGesturRecognizer];
}

- (void)hk_circle {
    self.layer.cornerRadius = self.hk_height/2;
    self.layer.masksToBounds = YES;
}

/** 圆角-高的一般 */
- (void)hk_roundCorner {
    [self hk_addCorner:self.hk_height/2];
}

- (void)hk_addCorner:(CGFloat)radius{
    [self hk_addCorner:radius borderWidth:1 borderColor:[UIColor blackColor] backGroundColor:[UIColor clearColor]];
}

- (void)hk_addCorner:(CGFloat)radius
         borderWidth:(CGFloat)borderWidth
         borderColor:(UIColor *)borderColor
     backGroundColor:(UIColor*)bgColor{
    /*
     1.layer.cornerRadius不会触发离屏渲染，该属性只是对边框和背景颜色起作用，适用于内部没有其他控件的view。
     2.CAShapeLayer+UIBezierPath会触发离屏渲染。
     3.最好的方式就是使用Core Graphics的方式绘制圆角图片。
     因此，根据场景来使用，如果界面中圆角的地方不多，第一种方式是最简单快捷，效率最高的。如果用到的圆角很多，那还是使用Core Graphics的方式
     
     */
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[self hk_drawRectWithRoundedCorner:radius borderWidth:borderWidth borderColor:borderColor backGroundColor:bgColor]];
    [self insertSubview:imageView atIndex:0];
}

- (UIImage *)hk_drawRectWithRoundedCorner:(CGFloat)radius
                              borderWidth:(CGFloat)borderWidth
                              borderColor:(UIColor *)borderColor
                          backGroundColor:(UIColor*)bgColor{
    CGSize size = self.bounds.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef contextRef =  UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(contextRef, borderWidth);
    CGContextSetStrokeColorWithColor(contextRef, borderColor.CGColor);
    CGContextSetFillColorWithColor(contextRef, bgColor.CGColor);
    
    CGFloat halfBorderWidth = borderWidth / 2.0;
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    CGContextMoveToPoint(contextRef, width - halfBorderWidth, radius + halfBorderWidth);
    CGContextAddArcToPoint(contextRef, width - halfBorderWidth, height - halfBorderWidth, width - radius - halfBorderWidth, height - halfBorderWidth, radius);  // 右下角角度
    CGContextAddArcToPoint(contextRef, halfBorderWidth, height - halfBorderWidth, halfBorderWidth, height - radius - halfBorderWidth, radius); // 左下角角度
    CGContextAddArcToPoint(contextRef, halfBorderWidth, halfBorderWidth, width - halfBorderWidth, halfBorderWidth, radius); // 左上角
    CGContextAddArcToPoint(contextRef, width - halfBorderWidth, halfBorderWidth, width - halfBorderWidth, radius + halfBorderWidth, radius); // 右上角
    CGContextDrawPath(contextRef, kCGPathFillStroke);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//移除所有子视图
- (void)hk_removeAllSubviews {
    while (self.subviews.count) {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}
//获取View所在的ViewController
- (UIViewController*)hk_viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}
//设置背景图
- (void)hk_setBackgroundImage:(UIImage *)image
{
    UIGraphicsBeginImageContext(self.frame.size);
    [image drawInRect:self.bounds];
    UIImage *bgImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.backgroundColor = [UIColor colorWithPatternImage:bgImage];
}
//转化为Image对象
- (UIImage*)hk_toImage
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:ctx];
    UIImage* tImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return tImage;
}
- (void)hk_removeShadow{
    self.layer.shadowColor = [UIColor clearColor].CGColor;
    self.layer.shadowOpacity = 1;
    self.layer.shadowOffset = CGSizeZero;
    self.layer.cornerRadius = 0;
}
- (void)hk_addShadowWithColor: (UIColor *)color opacity: (CGFloat)opacity offset: (CGSize)size cornerRadius: (CGFloat)radius{
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowOffset = size;
    self.layer.cornerRadius = radius;
}
///添加渐变色(横向或竖向)
- (void)hk_addGradientColors:(NSArray*)gradientColors isVertical:(BOOL)vertical GradientFrame:(CGRect)frame {
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    if (gradientColors.count) {
        gradient.colors = gradientColors;
    }else {
        gradient.colors = [NSArray arrayWithObjects: (id)HKHexColor(0xFF403C3C).CGColor, (id)[HKHexColor(0xFF403C3C) colorWithAlphaComponent:0.5].CGColor, nil];
    }
    gradient.locations = @[@0,@1];
    gradient.startPoint = CGPointMake(0, 0);
    if (vertical) {
        gradient.endPoint = CGPointMake(0, 1);
    }else{
        gradient.endPoint = CGPointMake(1, 0);
    }
    gradient.frame = frame;
    self.layer.masksToBounds = YES;
    [self.layer addSublayer:gradient];
}
///添加渐变色-Frame跟父视图一样
- (void)hk_addGradientColors:(NSArray*)gradientColors isVertical:(BOOL)vertical {
    [self hk_addGradientColors:gradientColors isVertical:vertical GradientFrame:CGRectMake(0, 0, self.hk_width, self.hk_height)];
}
///添加渐变色(圆形斜向渐变)
- (void)hk_addObliqueGradientColors:(NSArray*)gradientColors GradientFrame:(CGRect)frame{
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    if (gradientColors.count) {
        gradient.colors = gradientColors;
    }else {
        gradient.colors = [NSArray arrayWithObjects: (id)HKHexColor(0xFF403C3C).CGColor, (id)[HKHexColor(0xFF403C3C) colorWithAlphaComponent:0.5].CGColor, nil];
    }
    gradient.locations = @[@0,@1];
    gradient.startPoint = CGPointMake(0.21, 0.21);
    gradient.endPoint = CGPointMake(0.79, 0.79);
    gradient.frame = frame;
    
    self.layer.masksToBounds = YES;
    [self.layer addSublayer:gradient];
}

- (void)hk_removeGradientLayers {
    for (CAGradientLayer * layer in self.layer.sublayers) {
        [layer removeFromSuperlayer];
    }
}
/**
 *  设置部分圆角(绝对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 */
- (void)hk_addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii {
    
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    self.layer.mask = shape;
}

/**
 *  设置部分圆角(相对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 *  @param rect    需要设置的圆角view的rect
 */
- (void)hk_addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii
                 viewRect:(CGRect)rect {
    
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    self.layer.mask = shape;
}

- (void)hk_addTapGestureWithTarget:(id)target action:(SEL)action {
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    //点击几次才算一次
    tap.numberOfTapsRequired = 1;//连点3次
    //用几根手指
    //tap.numberOfTouchesRequired = 2;
    [self addGestureRecognizer:tap];
}

- (void)hk_addPanGestureWithTarget:(id)target action:(SEL)action {
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:pan];
}

- (void)hk_addPinchGestureWithTarget:(id)target action:(SEL)action {
    UIPinchGestureRecognizer * pan = [[UIPinchGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:pan];
}

- (void)hk_addRotationGestureWithTarget:(id)target action:(SEL)action {
    UIRotationGestureRecognizer * pan = [[UIRotationGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:pan];
}

- (void)hk_addLongPressGestureWithTarget:(id)target action:(SEL)action withDuration:(NSInteger)duration{
    UILongPressGestureRecognizer * pan = [[UILongPressGestureRecognizer alloc] initWithTarget:target action:action];
    pan.minimumPressDuration = duration;//设置最小长按时间
    [self addGestureRecognizer:pan];
}

- (void)hk_addSwipeGestureWithTarget:(id)target action:(SEL)action withDirection:(UISwipeGestureRecognizerDirection)direction{
    /// UISwipeGestureRecognizerDirectionRight = 1 << 0, 从左向右滑动
    /// UISwipeGestureRecognizerDirectionLeft  = 1 << 1, 从右向左滑动
    /// UISwipeGestureRecognizerDirectionUp    = 1 << 2, 从下向上滑动
    /// UISwipeGestureRecognizerDirectionDown  = 1 << 3  从下向上滑动
    UISwipeGestureRecognizer * swip = [[UISwipeGestureRecognizer alloc] initWithTarget:target action:action];
    swip.direction = direction;
    [self addGestureRecognizer:swip];
}

@end
