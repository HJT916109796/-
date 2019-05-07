//
//  HKAlertView.m
//  CallShow
//
//  Created by 胡锦涛 on 2018/4/25.
//  Copyright © 2018年 胡锦涛. All rights reserved.
//

#import "HKAlertView.h"
#import "NSMutableAttributedString+HKExtension.h"
#import "HKPrefixHeader.h"

NSString *const HKAlertViewWillShowNotification     = @"HKAlertViewWillShowNotification";
NSString *const HKAlertViewDidShowNotification      = @"HKAlertViewDidShowNotification";
NSString *const HKAlertViewWillDismissNotification  = @"HKAlertViewWillDismissNotification";
NSString *const HKAlertViewDidDismissNotification   = @"HKAlertViewDidDismissNotification";

#pragma mark - HKAlertItem
@interface HKAlertItem : NSObject
/** 按钮标题 */
@property (nonatomic, copy) NSString *title;
/** 按钮风格 */
@property (nonatomic, assign) HKAlertViewButtonType type;
/** 对应按钮行动的处理 */
@property (nonatomic, copy) HKAlertViewHandler action;
@end
@implementation HKAlertItem
@end

#pragma mark - HKAlertWindow
@interface HKAlertWindow : UIWindow
/** Alert背景视图风格 */
@property (nonatomic, assign) HKAlertViewBackgroundStyle style;
@end
@implementation HKAlertWindow
- (instancetype)initWithFrame:(CGRect)frame andStyle:(HKAlertViewBackgroundStyle)style {
    if (self = [super initWithFrame:frame]) {
        self.style = style;
        self.opaque = NO;
        self.windowLevel = 1999.0; // 不重叠系统的Alert, Alert的层级.
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    switch (self.style) {
        case HKAlertViewBackgroundStyleGradient: {
            size_t locationsCount = 2; // unsigned long
            CGFloat locations[2] = {0.0f, 1.0f};
            CGFloat colors[8] = {0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.75f};
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, locationsCount);
            CGColorSpaceRelease(colorSpace);
            
            CGPoint center = CGPointMake(self.hk_width * 0.5, self.hk_height * 0.5);
            CGFloat radius = MIN(self.hk_width, self.hk_height) ;
            CGContextDrawRadialGradient (context, gradient, center, 0, center, radius, kCGGradientDrawsAfterEndLocation);
            CGGradientRelease(gradient);
            break;
        }
            
        case HKAlertViewBackgroundStyleSolid: {
            [[UIColor colorWithWhite:0 alpha:0.1] set];
            CGContextFillRect(context, self.bounds);
            break;
        }
    }
}

@end

#pragma mark - HKAlertView
@interface HKAlertView ()<CAAnimationDelegate>

/** 是否动画 */
@property (nonatomic, assign, getter = isAlertAnimating) BOOL alertAnimating;
/** 是否可见 */
@property (nonatomic, assign, getter = isVisible) BOOL visible;
/** 标题 */
@property (nonatomic, weak) UILabel *titleLabel;
/** 消息描述 */
@property (nonatomic, weak) UILabel *messageLabel;
/** 容器视图 */
@property (nonatomic, weak) UIView *containerView;
/** 存放行动items */
@property (nonatomic, strong) NSMutableArray *items;
/** 存放按钮 */
@property (nonatomic, strong) NSMutableArray *buttons;
/** 展示的背景Window */
@property (nonatomic, strong) HKAlertWindow *alertWindow;

@end
@implementation HKAlertView

- (instancetype)initWithAppearanceStyle:(HKAppearanceStyle)appearanceStyle
{
    self = [super init];
    if (self) {
        [HKAlertView useConfigWithIsMain:appearanceStyle];
        self.frame = HK_DEVICE_BOUNDS;
        [self setUpSubviews];
    }
    return self;
}

+(void)useConfigWithIsMain:(HKAppearanceStyle)appearanceStyle{
    
    if (self != [HKAlertView class]) return;
    HKAlertView *appearance = [self appearance]; // 设置整体默认外观
    appearance.viewBackgroundColor = [UIColor whiteColor];
    appearance.messageColor = HKHexString(@"#666666");
    appearance.titleFont = [UIFont boldSystemFontOfSize:40*scale_m];
    appearance.messageFont = HKBoldFont(34*scale_m);
    appearance.buttonFont = HKBoldFont(34*scale_m);
    appearance.defaultButtonTitleColor = HKHexString(@"#666666");
    appearance.cancelButtonTitleColor = HKHexString(@"#666666");
    appearance.transitionStyle = HKAlertViewTransitionStyleSlideFromBottom;
    appearance.cornerRadius = 18*scale_m;
    if (appearanceStyle==HKAppearanceStyle_CallShow) {
        //主色调,紫色
        appearance.titleColor = HKHexString(@"#834fac");
        appearance.destructiveButtonTitleColor = HKHexString(@"#834fac");
    }else if (appearanceStyle==HKAppearanceStyle_Security){
        //主色调,蓝色
        appearance.titleColor = HKHexString(@"#67BAFF");
        appearance.destructiveButtonTitleColor = HKHexString(@"#67BAFF");
    }else {
        //主色调,紫色
        appearance.titleColor = HKHexString(@"#834fac");
        appearance.destructiveButtonTitleColor = HKHexString(@"#834fac");
    }
}
+ (instancetype)showTitle:(NSString *)title andMessage:(NSString *)message
              ensureTitle:(NSString*)ensureTitle ensureHandler:(HKAlertViewHandler)ensureHandler {
    return  [HKAlertView showWithTitle:title andMessage:message cancelTitle:nil cancelHandler:nil ensureTitle:ensureTitle ensureHandler:ensureHandler];
}
/** CallShowStyle */
+ (instancetype)showWithTitle:(NSString *)title attributeMessage:(NSMutableAttributedString *)attributeMessage cancelTitle:(NSString *)cancelTitle cancelHandler:(HKAlertViewHandler)cancelHandler ensureTitle:(NSString*)ensureTitle ensureHandler:(HKAlertViewHandler)ensureHandler {
    return [[self alloc] showTitle:title attributeMessage:attributeMessage cancelTitle:cancelTitle cancelHandler:cancelHandler ensureTitle:ensureTitle ensureHandler:ensureHandler appearanceStyle:HKAppearanceStyle_CallShow];
}

+ (instancetype)showWithTitle:(NSString *)title andMessage:(NSString *)message cancelTitle:(NSString *)cancelTitle cancelHandler:(HKAlertViewHandler)cancelHandler ensureTitle:(NSString*)ensureTitle ensureHandler:(HKAlertViewHandler)ensureHandler {
     return [[self alloc] showTitle:title andMessage:message cancelTitle:cancelTitle cancelHandler:cancelHandler ensureTitle:ensureTitle ensureHandler:ensureHandler appearanceStyle:HKAppearanceStyle_CallShow];
}
/** SecurityStyle */
+ (instancetype)securityShowWithTitle:(NSString *)title attributeMessage:(NSMutableAttributedString *)attributeMessage cancelTitle:(NSString *)cancelTitle cancelHandler:(HKAlertViewHandler)cancelHandler ensureTitle:(NSString*)ensureTitle ensureHandler:(HKAlertViewHandler)ensureHandler {
    return [[self alloc] showTitle:title attributeMessage:attributeMessage cancelTitle:cancelTitle cancelHandler:cancelHandler ensureTitle:ensureTitle ensureHandler:ensureHandler appearanceStyle:HKAppearanceStyle_Security];
}

+ (instancetype)securityShowWithTitle:(NSString *)title andMessage:(NSString *)message cancelTitle:(NSString *)cancelTitle cancelHandler:(HKAlertViewHandler)cancelHandler ensureTitle:(NSString*)ensureTitle ensureHandler:(HKAlertViewHandler)ensureHandler {
    return [[self alloc] showTitle:title andMessage:message cancelTitle:cancelTitle cancelHandler:cancelHandler ensureTitle:ensureTitle ensureHandler:ensureHandler appearanceStyle:HKAppearanceStyle_Security];
}

- (instancetype)showTitle:(NSString *)title attributeMessage:(NSMutableAttributedString*)attributeMsg cancelTitle:(NSString *)cancelTitle cancelHandler:(HKAlertViewHandler)cancelHandler ensureTitle:(NSString*)ensureTitle ensureHandler:(HKAlertViewHandler)ensureHandler appearanceStyle:(HKAppearanceStyle)appearanceStyle{
    HKAlertView *alertView = [[[self class] alloc] initWithAppearanceStyle:appearanceStyle];
    alertView.backgroundStyle = HKAlertViewBackgroundStyleSolid;
    alertView.containerView.backgroundColor = HKRed;
    alertView.title = title;
    alertView.items = [[NSMutableArray alloc] init];
    [alertView addButtonWithTitle:cancelTitle type:HKAlertViewButtonTypeDefault handler:cancelHandler];
    [alertView addButtonWithTitle:ensureTitle type:HKAlertViewButtonTypeDestructive handler:ensureHandler];
    alertView.attributeMsg = attributeMsg;
    [alertView show];
    return alertView;
}

- (instancetype)showTitle:(NSString *)title andMessage:(NSString *)message cancelTitle:(NSString *)cancelTitle cancelHandler:(HKAlertViewHandler)cancelHandler ensureTitle:(NSString*)ensureTitle ensureHandler:(HKAlertViewHandler)ensureHandler appearanceStyle:(HKAppearanceStyle)appearanceStyle{
    HKAlertView *alertView = [[[self class] alloc] initWithAppearanceStyle:appearanceStyle];
    alertView.backgroundStyle = HKAlertViewBackgroundStyleSolid;
    alertView.containerView.backgroundColor = HKRed;
    alertView.title = title;
    alertView.message = message;
    alertView.items = [[NSMutableArray alloc] init];
    [alertView addButtonWithTitle:cancelTitle type:HKAlertViewButtonTypeDefault handler:cancelHandler];
    [alertView addButtonWithTitle:ensureTitle type:HKAlertViewButtonTypeDestructive handler:ensureHandler];
    [alertView show];
    return alertView;
}

- (void)addButtonWithTitle:(NSString *)title type:(HKAlertViewButtonType)type handler:(HKAlertViewHandler)handler {
    HKAlertItem *item = [[HKAlertItem alloc] init];
    item.title = title;
    item.type = type;
    item.action = handler;
    if (title.length > 0 && title != nil) {
        [self.items addObject:item];
    }
}

- (void)show {
    if (self.isVisible) return;
    if (self.isAlertAnimating) return;
    weak_Self(weakSelf)
    if (self.willShowHandler) {
        self.willShowHandler(weakSelf);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:HKAlertViewWillShowNotification object:self userInfo:nil];
    self.visible = YES;
    self.alertAnimating = YES;
    
    [self setupButtons]; // 设置按钮
    [self.alertWindow addSubview:self];
    [self.alertWindow makeKeyAndVisible];
    [self setSubviewsFrame]; // 布局
    [self transitionInCompletion:^{
        if (weakSelf.didShowHandler) {
            weakSelf.didShowHandler(weakSelf);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:HKAlertViewDidShowNotification object:weakSelf userInfo:nil];
        weakSelf.alertAnimating = NO;
    }];
}

- (void)dismissAnimated:(BOOL)animated {
    [self dismissAnimated:animated cleanup:YES];
}

- (void)dismissAnimated:(BOOL)animated cleanup:(BOOL)cleanup {
    BOOL isVisible = self.isVisible;
    
    weak_Self(weakSelf)
    if (self.isVisible) {
        if (self.willDismissHandler) {
            self.willDismissHandler(weakSelf);
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:HKAlertViewWillDismissNotification object:self userInfo:nil];
    }
    void (^dismissComplete)(void) = ^{
        weakSelf.visible = NO;
        weakSelf.alertAnimating =  NO;
        
        if (isVisible) {
            if (weakSelf.didDismissHandler) {
                weakSelf.didDismissHandler(weakSelf);
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:HKAlertViewDidDismissNotification object:weakSelf userInfo:nil];
        }
        [self removeView];
    };
    if (animated && isVisible) {
        self.alertAnimating =  YES;
        [self transitionOutCompletion:dismissComplete];
    } else {
        dismissComplete();
    }
}

#pragma mark - Transitions动画
/**
 *  进入的动画
 */
- (void)transitionInCompletion:(void(^)(void))completion {
    switch (self.transitionStyle) {
        case HKAlertViewTransitionStyleFade: {
            self.containerView.alpha = 0;
            [UIView animateWithDuration:0.3 animations:^{
                self.containerView.alpha = 1;
            } completion:^(BOOL finished) {
                if (completion) {
                    completion();
                }
            }];
            break;
        }
        case HKAlertViewTransitionStyleSlideFromTop: {
            CGRect rect = self.containerView.frame;
            CGRect originalRect = rect;
            rect.origin.y = -HK_DEVICE_HEIGHT;
            self.containerView.frame = rect;
            
            [UIView animateWithDuration:0.3 animations:^{
                self.containerView.frame = originalRect;
            } completion:^(BOOL finished) {
                if (completion) {
                    completion();
                }
            }];
            break;
        }
        case HKAlertViewTransitionStyleSlideFromBottom: {
            CGRect rect = self.containerView.frame;
            CGRect originalRect = rect;
            rect.origin.y = HK_DEVICE_HEIGHT;
            self.containerView.frame = rect;
            
            [UIView animateWithDuration:0.3 animations:^{
                self.containerView.frame = originalRect;
            } completion:^(BOOL finished) {
                if (completion) {
                    completion();
                }
            }];
            break;
        }
        case HKAlertViewTransitionStyleSlideFromLeft: {
            CGRect rect = self.containerView.frame;
            CGRect originalRect = rect;
            rect.origin.x = -rect.size.width;
            self.containerView.frame = rect;
            
            [UIView animateWithDuration:0.3 animations:^{
                self.containerView.frame = originalRect;
            } completion:^(BOOL finished) {
                if (completion) {
                    completion();
                }
            }];
            break;
        }
        case HKAlertViewTransitionStyleSlideFromRight: {
            CGRect rect = self.containerView.frame;
            CGRect originalRect = rect;
            rect.origin.x = rect.size.width;
            self.containerView.frame = rect;
            
            [UIView animateWithDuration:0.3 animations:^{
                self.containerView.frame = originalRect;
            } completion:^(BOOL finished) {
                if (completion) {
                    completion();
                }
            }];
            break;
        }
        case HKAlertViewTransitionStyleBounce: {
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            animation.values = @[@(0.01), @(1.2), @(0.9), @(1)];
            animation.keyTimes = @[@(0), @(0.4), @(0.6), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = 0.5;
            animation.delegate = self;
            [animation setValue:completion forKey:@"handler"];
            [self.containerView.layer addAnimation:animation forKey:@"bouce"];
            break;
        }
        case HKAlertViewTransitionStyleDropDown: {
            CGFloat y = self.containerView.center.y;
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position.y"];
            animation.values = @[@(y - self.bounds.size.height), @(y + 20), @(y - 10), @(y)];
            animation.keyTimes = @[@(0), @(0.5), @(0.75), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = 0.4;
            animation.delegate = self;
            [animation setValue:completion forKey:@"handler"];
            [self.containerView.layer addAnimation:animation forKey:@"dropdown"];
            break;
        }
        default:
            break;
    }
}

/**
 *  消失的动画
 */
- (void)transitionOutCompletion:(void(^)(void))completion {
    switch (self.transitionStyle) {
        case HKAlertViewTransitionStyleSlideFromBottom: {
            CGRect rect = self.containerView.frame;
            rect.origin.y = HK_DEVICE_HEIGHT;
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.containerView.frame = rect;
            } completion:^(BOOL finished) {
                if (completion) {
                    completion();
                }
            }];
            break;
        }
        case HKAlertViewTransitionStyleSlideFromTop: {
            CGRect rect = self.containerView.frame;
            rect.origin.y = -rect.size.height;
            
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.containerView.frame = rect;
            } completion:^(BOOL finished) {
                if (completion) {
                    completion();
                }
            }];
            break;
        }
        case HKAlertViewTransitionStyleSlideFromLeft: {
            CGRect rect = self.containerView.frame;
            rect.origin.x = -rect.size.width;
            
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.containerView.frame = rect;
            } completion:^(BOOL finished) {
                if (completion) {
                    completion();
                }
            }];
            break;
        }
        case HKAlertViewTransitionStyleSlideFromRight: {
            CGRect rect = self.containerView.frame;
            rect.origin.x = rect.size.width;
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.containerView.frame = rect;
            } completion:^(BOOL finished) {
                if (completion) {
                    completion();
                }
            }];
            break;
        }
        case HKAlertViewTransitionStyleFade: {
            [UIView animateWithDuration:0.25 animations:^{
                self.containerView.alpha = 0;
            } completion:^(BOOL finished) {
                if (completion) {
                    completion();
                }
            }];
            break;
        }
        case HKAlertViewTransitionStyleBounce: {
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            animation.values = @[@(1), @(1.2), @(0.01)];
            animation.keyTimes = @[@(0), @(0.4), @(1)];
            animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            animation.duration = 0.35;
            animation.delegate = self;
            [animation setValue:completion forKey:@"handler"];
            [self.containerView.layer addAnimation:animation forKey:@"bounce"];
            
            self.containerView.transform = CGAffineTransformMakeScale(0.01, 0.01);
            break;
        }
        case HKAlertViewTransitionStyleDropDown: {
            CGPoint point = self.containerView.center;
            point.y += self.hk_height;
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.containerView.center = point;
                CGFloat angle = ((CGFloat)arc4random_uniform(100) - 50.f) / 100.f;
                self.containerView.transform = CGAffineTransformMakeRotation(angle);
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

#pragma mark - 布局
- (void)setSubviewsFrame {
    CGFloat margin = 20*scale_m;
    CGFloat containerViewW = HK_DEVICE_WIDTH-2*30*scale_m;
    /** 标题 */
    CGSize titleLabelSize = {0, 0};
    if (self.title.length > 0) {
        titleLabelSize = [self.title hk_boundingRectWithSize:CGSizeMake(containerViewW, MAXFLOAT) font:self.titleLabel.font lineSpacing:8*scale_m];
    }
    
    CGFloat titleLabelH = titleLabelSize.height;
    CGFloat titleLabelW = containerViewW;
    CGFloat titleLabelX = 30*scale_m;
    CGFloat titleLabelY = 2*margin;
    self.titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW-2*30*scale_m, titleLabelH);
    
    /** 消息描述 */
    CGSize messageLabelSize = {0, 0};
    if (self.attributeMsg.length > 0) {
        messageLabelSize = [self.attributeMsg hk_boundingRectWithSize:CGSizeMake(containerViewW-2*30*scale_m, MAXFLOAT) font:self.messageFont lineSpacing:8*scale_m];
    }else {
        if (self.message.length > 0) {
            messageLabelSize = [self.message hk_boundingRectWithSize:CGSizeMake(containerViewW-2*30*scale_m, MAXFLOAT) font:self.messageFont lineSpacing:8*scale_m];
        }
    }
    CGFloat messageLabelH = messageLabelSize.height;
    self.messageLabel.textAlignment = messageLabelH>18 ? NSTextAlignmentLeft : NSTextAlignmentCenter;
    CGFloat messageLabelW = containerViewW-2*30*scale_m;
    CGFloat messageLabelX = 30*scale_m;
    CGFloat messageLabelY = self.titleLabel.hk_bottom + 35*scale_m;
    self.messageLabel.frame = CGRectMake(messageLabelX, messageLabelY, messageLabelW, messageLabelH);
    /** 按钮 */
    CGFloat buttonH = 88*scale_m-2*15*scale_m;
    CGFloat buttonY = CGRectGetMaxY(self.messageLabel.frame) + 2*margin;
    if (self.items.count > 0) {
        //UIColor *lineColor = HKHexString(@"#f2f2f2");
        if (self.items.count == 2 && self.buttonsListStyle == HKAlertViewButtonsListStyleNormal) {
            //不带分割线
            CGFloat buttonW = containerViewW * 0.5-2*40*scale_m;
            CGFloat buttonX = 40*scale_m;
            UIButton *button = self.buttons[0];
            button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
            //添加圆角
            //button.layer.borderWidth = 2*scale_m;
            //button.layer.borderColor = HKHexString(@"#666666").CGColor;
            //[button setCornerRadious:button.height/2];
            [button hk_setEnlargeEdgeWithTop:20*scale_m right:20*scale_m bottom:20*scale_m left:20*scale_m];
            button = self.buttons[1];
            button.frame = CGRectMake(buttonW+buttonX+60*scale_m, buttonY, buttonW, buttonH);
            //添加圆角
            //button.layer.borderWidth = 2*scale_m;
            //button.layer.borderColor = HKHexString(@"#666666").CGColor;
            //[button setCornerRadious:button.height/2];
            [button hk_setEnlargeEdgeWithTop:20*scale_m right:20*scale_m bottom:20*scale_m left:20*scale_m];
             //带分割线
             //CGFloat buttonW = containerViewW * 0.5;
             //CGFloat buttonX = 0;
             //
             //UIButton *button = self.buttons[0];
             //button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
             //button = self.buttons[1];
             //button.frame = CGRectMake(buttonW, buttonY, buttonW, buttonH);
             //UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, buttonY, containerViewW, 2*scale_m)];
             //horizontalLine.backgroundColor = lineColor;
             //[self.containerView addSubview:horizontalLine];
             //UIView *verticaleLine = [[UIView alloc] initWithFrame:CGRectMake(buttonW, buttonY, 2*scale_m, buttonH)];
             //verticaleLine.backgroundColor = lineColor;
             //[self.containerView addSubview:verticaleLine];
        } else {
            for (NSUInteger i = 0; i < self.buttons.count; i++) {
                if (i > 0) {
                    buttonY += buttonH;
                }
                UIButton *button = self.buttons[i];
                button.frame = CGRectMake(249*scale_m, buttonY, HK_DEVICE_WIDTH-2*280*scale_m, 62*scale_m);
                //添加圆角
                //button.layer.borderWidth = 2*scale_m;
                //button.layer.borderColor = HKHexString(@"#666666").CGColor;
                //[button setCornerRadious:button.height/2];
                //[button setEnlargeEdgeWithTop:20*scale_m right:20*scale_m bottom:20*scale_m left:20*scale_m];
                 //带分割线
                //UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, buttonY, containerViewW, 1.0)];
                //horizontalLine.backgroundColor = lineColor;
                //[self.containerView addSubview:horizontalLine];
            }
        }
    }
    /** 容器视图 */
    CGFloat containerViewH = buttonY + buttonH + 50*scale_m;
    CGFloat containerViewX = 30*scale_m;
    CGFloat containerViewY = HK_DEVICE_HEIGHT - containerViewH - 30*scale_m;
    self.containerView.frame = CGRectMake(containerViewX, containerViewY, containerViewW, containerViewH);
    //self.containerView.backgroundColor = HKRed;
}

#pragma mark - 视图相关
- (void)setUpSubviews {
    /** 容器视图 */
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor whiteColor];
    containerView.layer.cornerRadius = self.cornerRadius;
    containerView.layer.masksToBounds = YES;
    [containerView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPressContainerView:)]];
    [self addSubview:containerView];
    self.containerView = containerView;
    
    /** 标题 */
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = self.titleFont;
    titleLabel.textColor = self.titleColor;
    //titleLabel.backgroundColor = HKRed;
    [self.containerView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    /** 消息描述 */
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.font = self.messageFont;
    messageLabel.textColor = self.messageColor;
    messageLabel.numberOfLines = 0;
    [self.containerView addSubview:messageLabel];
    self.messageLabel = messageLabel;
}

//滑动手势处理
- (void)panPressContainerView:(UIPanGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:self];
    UIButton *btn = [self buttonWithLocation:location];
    switch (recognizer.state) {
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            if (btn) {
                [self buttonAction:btn];
            }
            break;
        }
        default:
            break;
    }
}

//遍历手指触摸的点是否在按钮上
- (UIButton *)buttonWithLocation:(CGPoint)location {
    UIButton *btn = nil;
    for (int i = 0; i < self.buttons.count; i++) {
        UIButton *tempBtn = self.buttons[i];
        CGRect btnFrame = [tempBtn convertRect:tempBtn.bounds toView:self];
        if (CGRectContainsPoint(btnFrame, location)) {
            tempBtn.highlighted = YES;
            btn = tempBtn;
        } else {
            tempBtn.highlighted = NO;
        }
    }
    return btn ? btn : nil;
}

- (HKAlertWindow *)alertWindow {
    if (!_alertWindow) {
        _alertWindow = [[HKAlertWindow alloc] initWithFrame:HK_DEVICE_BOUNDS andStyle:self.backgroundStyle];
        _alertWindow.alpha = 1.0;
    }
    return _alertWindow;
}

//设置按钮
- (void)setupButtons {
    self.buttons = [[NSMutableArray alloc] initWithCapacity:self.items.count];
    for (NSUInteger i = 0; i < self.items.count; i++) {
        UIButton *button = [self buttonForItemIndex:i];
        [self.buttons addObject:button];
        [self.containerView addSubview:button];
    }
}

- (UIButton *)buttonForItemIndex:(NSUInteger)index {
    HKAlertItem *item = self.items[index];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = index;
    button.titleLabel.font = self.buttonFont;
    button.titleLabel.textColor = self.defaultButtonTitleColor;
    button.adjustsImageWhenHighlighted = NO;
    [button setTitle:item.title forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage hk_imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    //[button setBackgroundImage:[UIImage hk_imageWithColor:RGB(230, 230, 230)] forState:UIControlStateHighlighted];
    switch (item.type) {
        case HKAlertViewButtonTypeCancel: {
            [button setTitleColor:self.cancelButtonTitleColor forState:UIControlStateNormal];
            [button setTitleColor:[self.cancelButtonTitleColor colorWithAlphaComponent:0.2] forState:UIControlStateHighlighted];
            break;
        }
        case HKAlertViewButtonTypeDestructive: {
            [button setTitleColor:self.destructiveButtonTitleColor forState:UIControlStateNormal];
            [button setTitleColor:[self.destructiveButtonTitleColor colorWithAlphaComponent:0.2] forState:UIControlStateHighlighted];
            break;
        }
        case HKAlertViewButtonTypeDefault: {
        default:
            [button setTitleColor:self.defaultButtonTitleColor forState:UIControlStateNormal];
            [button setTitleColor:[self.defaultButtonTitleColor colorWithAlphaComponent:0.2] forState:UIControlStateHighlighted];
            break;
        }
    }
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)removeView {
    self.alertWindow.alpha = 0;
    [self.alertWindow removeFromSuperview];
    self.alertWindow = nil;
    [self hk_removeAllSubviews];
    [self removeFromSuperview];
    [HKFirstWindow makeKeyAndVisible];
}

#pragma mark - 按钮点击的行动
- (void)buttonAction:(UIButton *)button {
    self.alertAnimating =  YES;
    HKAlertItem *item = self.items[button.tag];
    if (item.action) {
        item.action(self);
    }
    [self dismissAnimated:YES];
}

#pragma mark - 动画的代理
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    void(^completion)(void) = [anim valueForKeyPath:@"handler"];
    if (completion) {
        completion();
    }
}

#pragma mark - setter方法
- (void)setTitle:(NSString *)title {
    if (_title == title) return;
    
    _title = title;
    self.titleLabel.text = title;
}

-(void)setAttributeMsg:(NSMutableAttributedString *)attributeMsg {
    if (_attributeMsg == attributeMsg) return;
    _attributeMsg = attributeMsg;
    self.messageLabel.attributedText = attributeMsg;
}

- (void)setMessage:(NSString *)message {
    if (_message == message) return;
    _message = message;
    self.messageLabel.text = message;
}

- (void)setViewBackgroundColor:(UIColor *)viewBackgroundColor {
    if (_viewBackgroundColor == viewBackgroundColor) return;
    _viewBackgroundColor = viewBackgroundColor;
    self.containerView.backgroundColor = viewBackgroundColor;
}

- (void)setTitleFont:(UIFont *)titleFont {
    if (_titleFont == titleFont) return;
    _titleFont = titleFont;
    self.titleLabel.font = titleFont;
}

- (void)setMessageFont:(UIFont *)messageFont {
    if (_messageFont == messageFont) return;
    _messageFont = messageFont;
    self.messageLabel.font = messageFont;
}

- (void)setTitleColor:(UIColor *)titleColor {
    if (_titleColor == titleColor) return;
    _titleColor = titleColor;
    self.titleLabel.textColor = titleColor;
}

- (void)setMessageColor:(UIColor *)messageColor {
    if (_messageColor == messageColor) return;
    _messageColor = messageColor;
    if (self.attributeMsg.length>0) {
        return;
    }
   self.messageLabel.textColor = messageColor;
}

- (void)setButtonFont:(UIFont *)buttonFont {
    if (_buttonFont == buttonFont) return;
    _buttonFont = buttonFont;
    for (UIButton *button in self.buttons) {
        button.titleLabel.font = buttonFont;
    }
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    if (_cornerRadius == cornerRadius) return;
    _cornerRadius = cornerRadius;
    self.containerView.layer.cornerRadius = cornerRadius;
}

- (void)setDefaultButtonTitleColor:(UIColor *)defaultButtonTitleColor {
    if (_defaultButtonTitleColor == defaultButtonTitleColor) return;
    _defaultButtonTitleColor = defaultButtonTitleColor;
    [self setColor:defaultButtonTitleColor toButtonsOfType:HKAlertViewButtonTypeDefault];
}

- (void)setCancelButtonTitleColor:(UIColor *)cancelButtonTitleColor {
    if (_cancelButtonTitleColor == cancelButtonTitleColor) return;
    _cancelButtonTitleColor = cancelButtonTitleColor;
    [self setColor:cancelButtonTitleColor toButtonsOfType:HKAlertViewButtonTypeCancel];
}

- (void)setDestructiveButtonTitleColor:(UIColor *)destructiveButtonTitleColor {
    if (_destructiveButtonTitleColor == destructiveButtonTitleColor) return;
    _destructiveButtonTitleColor = destructiveButtonTitleColor;
    [self setColor:destructiveButtonTitleColor toButtonsOfType:HKAlertViewButtonTypeDestructive];
}
/** 设置默认按钮图片和状态 */
- (void)setDefaultButtonImage:(UIImage *)defaultButtonImage forState:(UIControlState)state {
    [self setButtonImage:defaultButtonImage forState:state andButtonType:HKAlertViewButtonTypeDefault];
}

- (void)setCancelButtonImage:(UIImage *)cancelButtonImage forState:(UIControlState)state {
    [self setButtonImage:cancelButtonImage forState:state andButtonType:HKAlertViewButtonTypeCancel];
}

- (void)setDestructiveButtonImage:(UIImage *)destructiveButtonImage forState:(UIControlState)state {
    [self setButtonImage:destructiveButtonImage forState:state andButtonType:HKAlertViewButtonTypeDestructive];
}

- (void)setButtonImage:(UIImage *)image forState:(UIControlState)state andButtonType:(HKAlertViewButtonType)type {
    for (NSUInteger i = 0; i < self.items.count; i++) {
        HKAlertItem *item = self.items[i];
        if(item.type == type) {
            UIButton *button = self.buttons[i];
            if (state == UIControlStateSelected) {
                state = UIControlStateHighlighted;
            }
            [button setBackgroundImage:image forState:state];
        }
    }
}

- (void)setColor:(UIColor *)color toButtonsOfType:(HKAlertViewButtonType)type {
    for (NSUInteger i = 0; i < self.items.count; i++) {
        HKAlertItem *item = self.items[i];
        if(item.type == type) {
            UIButton *button = self.buttons[i];
            [button setTitleColor:color forState:UIControlStateNormal];
            [button setTitleColor:[color colorWithAlphaComponent:0.2] forState:UIControlStateHighlighted];
        }
    }
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
