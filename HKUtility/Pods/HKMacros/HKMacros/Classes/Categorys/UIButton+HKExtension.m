//
//  UIButton+HKExtension.m
//  HKProject
//
//  Created by 胡锦涛 on 2018/7/27.
//  Copyright © 2018年 胡锦涛. All rights reserved.
//

#import "UIButton+HKExtension.h"
#import "UIView+HKExtension.h"
#import <objc/runtime.h>
@interface UIButton()
/**bool 类型 YES 不允许点击   NO 允许点击   设置是否执行点UI方法*/
@property (nonatomic, assign) BOOL isIgnoreEvent;
@end
static const void *associatedKey = "associatedKey";
@implementation UIButton (HKExtension)

//Category中的属性，只会生成setter和getter方法，不会生成成员变量
-(void)setClick:(clickBlock)click {
    objc_setAssociatedObject(self, associatedKey, click, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self removeTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    if (click) {
        [self addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(clickBlock)click {
    return objc_getAssociatedObject(self, associatedKey);
}

- (void)buttonClick {
    if (self.click) {
        self.click();
    }
}
+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL selA = @selector(sendAction:to:forEvent:);
        SEL selB = @selector(mySendAction:to:forEvent:);
        Method methodA =   class_getInstanceMethod(self,selA);
        Method methodB = class_getInstanceMethod(self, selB);
        //将 methodB的实现 添加到系统方法中 也就是说 将 methodA方法指针添加成 方法methodB的  返回值表示是否添加成功
        BOOL isAdd = class_addMethod(self, selA, method_getImplementation(methodB), method_getTypeEncoding(methodB));
        //添加成功了 说明 本类中不存在methodB 所以此时必须将方法b的实现指针换成方法A的，否则 b方法将没有实现。
        if (isAdd) {
            class_replaceMethod(self, selB, method_getImplementation(methodA), method_getTypeEncoding(methodA));
        }else{
            //添加失败了 说明本类中 有methodB的实现，此时只需要将 methodA和methodB的IMP互换一下即可。
            method_exchangeImplementations(methodA, methodB);
        }
    });
}

- (NSTimeInterval)timeInterval
{
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}

- (void)setTimeInterval:(NSTimeInterval)timeInterval
{
    objc_setAssociatedObject(self, @selector(timeInterval), @(timeInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}
//当我们按钮点击事件 sendAction 时  将会执行  mySendAction
- (void)mySendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    if ([NSStringFromClass(self.class) isEqualToString:@"UIButton"] || [NSStringFromClass(self.class) isEqualToString:@"XBShowButton"]) {
        
        self.timeInterval =self.timeInterval ==0 ?defaultInterval:self.timeInterval;
        if (self.isIgnoreEvent){
            return;
        }else if (self.timeInterval > 0){
            [self performSelector:@selector(resetState) withObject:nil afterDelay:self.timeInterval];
        }
    }
    //此处 methodA和methodB方法IMP互换了，实际上执行 sendAction；所以不会死循环
    self.isIgnoreEvent = YES;
    [self mySendAction:action to:target forEvent:event];
}
//runtime 动态绑定 属性
- (void)setIsIgnoreEvent:(BOOL)isIgnoreEvent{
    // 注意BOOL类型 需要用OBJC_ASSOCIATION_RETAIN_NONATOMIC 不要用错，否则set方法会赋值出错
    objc_setAssociatedObject(self, @selector(isIgnoreEvent), @(isIgnoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)isIgnoreEvent{
    //_cmd == @select(isIgnore); 和set方法里一致
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (void)resetState{
    [self setIsIgnoreEvent:NO];
}
- (void)hk_layoutButtonWithEdgeInsetsStyle:(ButtonEdgeInsetsStyle)style imageTitlespace:(CGFloat)space {
    CGFloat imageViewWidth = CGRectGetWidth(self.imageView.frame);
    CGFloat labelWidth = CGRectGetWidth(self.titleLabel.frame);
    
    if (labelWidth == 0) {
        CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
        labelWidth  = titleSize.width;
    }
    
    CGFloat imageInsetsTop = 0.0f;
    CGFloat imageInsetsLeft = 0.0f;
    CGFloat imageInsetsBottom = 0.0f;
    CGFloat imageInsetsRight = 0.0f;
    
    CGFloat titleInsetsTop = 0.0f;
    CGFloat titleInsetsLeft = 0.0f;
    CGFloat titleInsetsBottom = 0.0f;
    CGFloat titleInsetsRight = 0.0f;
    
    switch (style) {
        case ButtonEdgeInsetsStyleImageRight:
        {
            space = space * 0.5;
            
            imageInsetsLeft = labelWidth + space;
            imageInsetsRight = -imageInsetsLeft;
            
            titleInsetsLeft = - (imageViewWidth + space);
            titleInsetsRight = -titleInsetsLeft;
        }
            break;
            
        case ButtonEdgeInsetsStyleImageLeft:
        {
            space = space * 0.5;
            
            imageInsetsLeft = -space;
            imageInsetsRight = -imageInsetsLeft;
            
            titleInsetsLeft = space;
            titleInsetsRight = -titleInsetsLeft;
        }
            break;
        case ButtonEdgeInsetsStyleImageBottom:
        {
            CGFloat imageHeight = CGRectGetHeight(self.imageView.frame);
            CGFloat labelHeight = CGRectGetHeight(self.titleLabel.frame);
            CGFloat buttonHeight = CGRectGetHeight(self.frame);
            CGFloat boundsCentery = (imageHeight + space + labelHeight) * 0.5;
            
            CGFloat centerX_button = CGRectGetMidX(self.bounds); // bounds
            CGFloat centerX_titleLabel = CGRectGetMidX(self.titleLabel.frame);
            CGFloat centerX_image = CGRectGetMidX(self.imageView.frame);
            
            CGFloat imageBottomY = CGRectGetMaxY(self.imageView.frame);
            CGFloat titleTopY = CGRectGetMinY(self.titleLabel.frame);
            
            imageInsetsTop = buttonHeight - (buttonHeight * 0.5 - boundsCentery) - imageBottomY;
            imageInsetsLeft = centerX_button - centerX_image;
            imageInsetsRight = - imageInsetsLeft;
            imageInsetsBottom = - imageInsetsTop;
            
            titleInsetsTop = (buttonHeight * 0.5 - boundsCentery) - titleTopY;
            titleInsetsLeft = -(centerX_titleLabel - centerX_button);
            titleInsetsRight = - titleInsetsLeft;
            titleInsetsBottom = - titleInsetsTop;
            
        }
            break;
        case ButtonEdgeInsetsStyleImageTop:
        {
            CGFloat imageHeight = CGRectGetHeight(self.imageView.frame);
            CGFloat labelHeight = CGRectGetHeight(self.titleLabel.frame);
            CGFloat buttonHeight = CGRectGetHeight(self.frame);
            CGFloat boundsCentery = (imageHeight + space + labelHeight) * 0.5;
            
            CGFloat centerX_button = CGRectGetMidX(self.bounds); // bounds
            CGFloat centerX_titleLabel = CGRectGetMidX(self.titleLabel.frame);
            CGFloat centerX_image = CGRectGetMidX(self.imageView.frame);
            
            CGFloat imageTopY = CGRectGetMinY(self.imageView.frame);
            CGFloat titleBottom = CGRectGetMaxY(self.titleLabel.frame);
            
            imageInsetsTop = (buttonHeight * 0.5 - boundsCentery) - imageTopY;
            imageInsetsLeft = centerX_button - centerX_image;
            imageInsetsRight = - imageInsetsLeft;
            imageInsetsBottom = - imageInsetsTop;
            
            titleInsetsTop = buttonHeight - (buttonHeight * 0.5 - boundsCentery) - titleBottom;
            titleInsetsLeft = -(centerX_titleLabel - centerX_button);
            titleInsetsRight = - titleInsetsLeft;
            titleInsetsBottom = - titleInsetsTop;
        }
            break;
            
        default:
            break;
    }
    
    self.imageEdgeInsets = UIEdgeInsetsMake(imageInsetsTop, imageInsetsLeft, imageInsetsBottom, imageInsetsRight);
    self.titleEdgeInsets = UIEdgeInsetsMake(titleInsetsTop, titleInsetsLeft, titleInsetsBottom, titleInsetsRight);
}
+ (UIButton*)hkCustom {
    return [self buttonWithType:UIButtonTypeCustom];
}
+ (UIButton*)hkCustomWithFrame:(CGRect)frame {
    UIButton * btn = [self buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    return btn;
}
- (void)hk_setFont:(UIFont*)hkFont {
    self.titleLabel.font = hkFont;
}
- (void)hk_setNormalTitle:(NSString*)title {
    [self setTitle:title forState:UIControlStateNormal];
}
- (void)hk_setSelectedTitle:(NSString*)title {
    [self setTitle:title forState:UIControlStateSelected];
}
- (void)hk_setNormalTitleColor:(UIColor*)titleColor {
    [self setTitleColor:titleColor forState:UIControlStateNormal];
}
- (void)hk_setSelectedTitleColor:(UIColor*)titleColor {
    [self setTitleColor:titleColor forState:UIControlStateSelected];
}
- (void)hk_setNormalImageName:(NSString*)name {
    [self setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
}
- (void)hk_setSelectedImageName:(NSString*)name {
    [self setImage:[UIImage imageNamed:name] forState:UIControlStateSelected];
}
- (void)hk_setBorderWidth:(CGFloat)borderWidth borderColor:(UIColor*)borderColor {
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = borderColor.CGColor;
}
- (void)hk_roundCorner {
    self.layer.cornerRadius = self.hk_height/2;
    self.layer.masksToBounds = YES;
}
- (void)hk_setCornerRadious:(CGFloat)cornerRadious {
    self.layer.cornerRadius = cornerRadious;
    self.layer.masksToBounds = YES;
}
- (void)hk_addTarget:(id)vc withAction:(SEL)action{
    [self addTarget:vc action:action forControlEvents:UIControlEventTouchUpInside];
}
@end

@implementation HKRoundedButton


- (void)makeCorner {
    UIRectCorner corners;
    
    switch ( self.style )
    {
        case 0:
            corners = UIRectCornerBottomLeft;
            break;
        case 1:
            corners = UIRectCornerBottomRight;
            break;
        case 2:
            corners = UIRectCornerTopLeft;
            break;
        case 3:
            corners = UIRectCornerTopRight;
            break;
        case 4:
            corners = UIRectCornerBottomLeft | UIRectCornerBottomRight;
            break;
        case 5:
            corners = UIRectCornerTopLeft | UIRectCornerTopRight;
            break;
        case 6:
            corners = UIRectCornerBottomLeft | UIRectCornerTopLeft;
            break;
        case 7:
            corners = UIRectCornerBottomRight | UIRectCornerTopRight;
            break;
        case 8:
            corners = UIRectCornerBottomRight | UIRectCornerTopRight | UIRectCornerTopLeft;
            break;
        case 9:
            corners = UIRectCornerBottomRight | UIRectCornerTopRight | UIRectCornerBottomLeft;
            break;
        default:
            corners = UIRectCornerAllCorners;
            break;
    }
    
    _hk_cornerRadious = _hk_cornerRadious ?: 10.0;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(_hk_cornerRadious, _hk_cornerRadious)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame         = self.bounds;
    maskLayer.path          = maskPath.CGPath;
    self.layer.mask         = maskLayer;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUIOnce];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupUIOnce];
    }
    return self;
}


- (void)setupUIOnce
{
    [self makeCorner];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeCorner];
}

@end

