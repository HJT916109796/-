//
//  HKMessageBox.m
//  CallShow
//
//  Created by 胡锦涛 on 2018/6/13.
//  Copyright © 2018年 胡锦涛. All rights reserved.
//

#import "HKMessageBox.h"
#import "HKPrefixHeader.h"

#define MWIDTH  HK_DEVICE_WIDTH-2*60*scale_l

CGFloat afterDelay = 2.0f;
CGFloat duration = 1.0f;

@implementation HKMessageBox
{
    BOOL _dismissOnOutside;//点击遮罩层是否关闭对话框
    UILabel *msgTextView;
    UIView *indicatorView;
    UIActivityIndicatorView *aniView;
    OnDismissBlock _dismissBlock;
}
@synthesize msgPanel;
static HKMessageBox *sharedMessageBox;
+(HKMessageBox *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMessageBox = [[HKMessageBox alloc] init];
    });
    return sharedMessageBox;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMessageBox = [super allocWithZone:zone];
    });
    return sharedMessageBox;
}
- (id)init
{
    self = [super init];
    if (self) {
        CGRect mainRect = [[UIScreen mainScreen] bounds];
        [self setFrame:mainRect];
        UIColor *bgColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        [self setBackgroundColor:bgColor];
        [self setTag:HKMessageBoxTagBack];
        
        CGRect rect;
        rect.origin.x = 60*scale_l;
        rect.origin.y = 0;
        rect.size.width = HK_DEVICE_HEIGHT-2*60*scale_l;
        rect.size.height = HK_DEVICE_HEIGHT;
        msgPanel = [[UIView alloc]initWithFrame:rect];
        [msgPanel setBackgroundColor:HKHexColor(0xFFffffff)];
        [[msgPanel layer] setCornerRadius:10*scale_l];
        [[msgPanel layer] setMasksToBounds:YES];
        [self addSubview:msgPanel];
        
        rect.size.height = HK_DEVICE_HEIGHT;
        rect.origin.x = 60*scale_l;
        rect.origin.y = 60*scale_l;
        rect.size.width = MWIDTH;
        
        //进度指示器
        rect.origin.x=rect.origin.y=0;
        //图片名称要写全称
        UIImage *aniImage = HKAssignBundleImage(@"加载_ProgressView",@"HKMessageBox.bundle");
        rect.size=[aniImage size];
        aniView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 60*scale_l, 60*scale_l)];
        aniView.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
        indicatorView = [[UIView alloc] initWithFrame:rect];
        [indicatorView addSubview:aniView];
        [aniView setCenter:[indicatorView center]];
        [indicatorView setHidden:YES];
        [msgPanel addSubview:indicatorView];
        
        rect.origin.x = 60*scale_l;
        rect.origin.y = rect.size.height;
        rect.size.height = -1;
        msgTextView = [[UILabel alloc] initWithFrame:rect];
        msgTextView.numberOfLines = 0;
        msgTextView.textAlignment = NSTextAlignmentLeft;
        msgTextView.characterSpace=2;//字间距
        msgTextView.lineSpace=2;//行间距
        msgTextView.textColor = HKHexColor(0xFF999999);
        msgTextView.font = [UIFont systemFontOfSize:44*scale_l];
        [UILabel hk_changeSpaceForLabel:msgTextView withLineSpace:100*scale_l WordSpace:10*scale_l WithAttributeFontSize:44*scale_l];
        //msgTextView.backgroundColor = HKRed;
        [msgPanel addSubview:msgTextView];
    }
    return self;
}
+ (void) showLoadingWithText:(NSString *)text{
    [self showLoadingWithText:text bottomOffsset:0 option:HKMessageBoxOptionIndicatorAbove];
}
+ (void) showLoadingWithText:(NSString *)text  bottomOffsset:(CGFloat)bottom option:(HKMessageBoxOption)option{
    HKMessageBox *messageBox = [HKMessageBox sharedInstance];
    [messageBox showMessageBoxWithMessage:text bottomOffsset:bottom option:option OnDismiss:nil];
}
- (void)showMessageBoxWithMessage:(id) message
                    bottomOffsset:(CGFloat)bottom
                           option:(HKMessageBoxOption)option
                        OnDismiss:(OnDismissBlock)dismissBlock
{
    if (dismissBlock) {
        _dismissBlock = [dismissBlock copy];
    }
    _dismissOnOutside = (option&HKMessageBoxOptionDismissOnOutside)==HKMessageBoxOptionDismissOnOutside;
    HKMessageBoxOption indicatorOption = option&HKMessageBoxOptionIndicatorMask;
    //设置面板大小
    [msgTextView setUserInteractionEnabled:NO];
    if ([message isKindOfClass:[NSString class]]) {
        [msgTextView setText:message];
        msgTextView.textAlignment = NSTextAlignmentCenter;
        [self defaultPanelBackGroundColor];
    }
    CGRect rect = CGRectZero;
    //指示动画
    [msgPanel addSubview:indicatorView];
    if (indicatorOption==HKMessageBoxOptionIndicatorAbove) {
        [indicatorView setHidden:NO];
        msgTextView.textAlignment = NSTextAlignmentCenter;
        CGSize labSize =  [msgTextView hk_getLableSizeWithMaxWidth:MWIDTH];
        rect.size.width = labSize.width+2*60*scale_l;
        rect.size.height = labSize.height +60*scale_l+60*scale_l;
        [self startAnimating];
    }else if (indicatorOption==HKMessageBoxOptionToast){
        [indicatorView setHidden:YES];
        [indicatorView removeFromSuperview];
        CGSize labSize =  [msgTextView hk_getLableSizeWithMaxWidth:MWIDTH];
        rect.size.width = labSize.width+2*60*scale_l;
        rect.size.height = labSize.height + 2*30*scale_l;
        msgTextView.textAlignment = NSTextAlignmentCenter;
    }
    [msgPanel setFrame:rect];
    msgPanel.center = CGPointMake(HK_DEVICE_WIDTH/2, HK_DEVICE_HEIGHT/2);
    
    //正文内容
    rect.origin.y=0;
    msgTextView.textColor = [UIColor blackColor];
    [self progressViewBackGroundColor];
    if (indicatorOption==HKMessageBoxOptionIndicatorAbove) {
        [indicatorView setCenter:CGPointMake(msgPanel.hk_width/2, 60*scale_l)];
        CGSize labSize =  [msgTextView hk_getLableSizeWithMaxWidth:MWIDTH];
        rect.size.width = labSize.width+2*60*scale_l;
        rect.size.height = labSize.height+60*scale_l+60*scale_l;
        [msgTextView setFrame:rect];
        [msgTextView setHk_centerY:50*scale_l+rect.size.height/2];
    }else if (indicatorOption==HKMessageBoxOptionToast){
        rect.origin.x=20*scale_l;
        rect.origin.y=30*scale_l;
        CGSize labSize =  [msgTextView hk_getLableSizeWithMaxWidth:MWIDTH];
        rect.size.width = msgPanel.hk_width - 40*scale_l;
        rect.size.height = labSize.height;
        [msgTextView setFrame:rect];
    }
    [msgTextView setNeedsDisplay];
    //动画
    [[msgPanel layer] removeAllAnimations];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (bottom>0) {
        self.msgPanel.center = CGPointMake(window.center.x, window.frame.size.height-(bottom+ self.msgPanel.frame.size.height/2));
    }
    [window addSubview:self];
}
- (void)progressViewBackGroundColor {
    [self setBackgroundColor:[UIColor clearColor]];
    msgTextView.textColor = [UIColor whiteColor];
    msgPanel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
}
- (void)defaultPanelBackGroundColor{
    [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.7]];
    msgTextView.textAlignment = NSTextAlignmentLeft;
    msgPanel.backgroundColor = [UIColor whiteColor];
}
+ (void)dismiss
{
    [[self sharedInstance] dismissMessageBox];
}
- (void)dismissMessageBox
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![self->indicatorView isHidden]) {
            [self stopAnimating];
            [self->indicatorView setHidden:YES];
        }
        NSArray *childs = [self->msgTextView subviews];
        if (childs&&[childs count]) {
            for (UIView *view in childs) {
                [view removeFromSuperview];
            }
        }
        [self removeFromSuperview];
    });
    
}
- (void)startAnimating
{
    if (![indicatorView isHidden]) {
        [aniView startAnimating];
        UIView *aniView = [[indicatorView subviews] firstObject];
        CABasicAnimation* rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI*2.0f];
        rotationAnimation.duration = duration;
        rotationAnimation.repeatCount = HUGE_VALF;
        [[aniView layer] addAnimation:rotationAnimation forKey:@"transform.rotation.z"];
    }
}
- (void)stopAnimating
{
    if (![indicatorView isHidden]) {
        [aniView stopAnimating];
        UIView *aniView = [[indicatorView subviews] firstObject];
        [[aniView layer] removeAllAnimations];
    }
}

//默认left
+ (void) showMessage:(NSString *) message{
    [[HKMessageBox sharedInstance] showMessage:message];
}

+ (void) showSuccessMessage:(NSString *)result placeholder:(NSString *)placeholder{
    [[HKMessageBox sharedInstance] showMessage:result ? result : placeholder afterDelay:afterDelay];
}
+ (void) showLoadingText:(NSString *) message{
    [[HKMessageBox sharedInstance] showLoadingText:message];
}
+ (void)beginLoading:(NSString *) message bottomOffsset:(CGFloat)bottom{
    [[HKMessageBox sharedInstance] beginLoading:message bottomOffsset:bottom];
}
- (void) beginLoading:(NSString *) message bottomOffsset:(CGFloat)bottom {
    [self showMessageBoxWithMessage:message bottomOffsset:bottom option:HKMessageBoxOptionIndicatorAbove OnDismiss:nil];
}
- (void) showLoadingText:(NSString *) message {
    [self showMessageBoxWithMessage:message bottomOffsset:0 option:HKMessageBoxOptionIndicatorAbove OnDismiss:nil];
    if (time > 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self stopAnimating];
            [self dismissMessageBox];
        });
    }
}
- (void) showUpdatingText:(NSString *) message {
    [self showMessageBoxWithMessage:message bottomOffsset:0 option:HKMessageBoxOptionIndicatorAbove OnDismiss:nil];
}
- (void) showMessage:(NSString *) message afterDelay:(float)time {
    [self showMessageBoxWithMessage:message bottomOffsset:0 option:HKMessageBoxOptionToast OnDismiss:nil];
    if (time > 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissMessageBox];
        });
    }
}
- (void) showMessage:(NSString *) message{
    [self showMessageBoxWithMessage:message bottomOffsset:0 option:HKMessageBoxOptionToast OnDismiss:nil];
    if (time > 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(afterDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissMessageBox];
        });
    }
}
#pragma ---- Touch Event ----
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    NSInteger tag = [[touch view] tag];
    if (tag == HKMessageBoxTagBack) {
        if (_dismissOnOutside) {
            if (_dismissBlock) {
                _dismissBlock(tag);
            }
            [self dismissMessageBox];
        }
    }
}

@end
