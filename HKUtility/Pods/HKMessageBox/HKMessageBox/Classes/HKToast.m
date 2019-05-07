//
//  HKToast.m
//  CallShow
//
//  Created by 胡锦涛 on 2018/6/14.
//  Copyright © 2018年 胡锦涛. All rights reserved.
//

#import "HKToast.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "HKPrefixHeader.h"
#import "HKMessageBox.h"
@interface HKToast (private)

- (id)initWithText:(NSString *)text;
- (void)setDuration:(CGFloat) duration;

- (void)dismisToast;
- (void)toastTaped:(UIButton *)sender;

- (void)showAnimation;
- (void)hideAnimation;

- (void)show;
- (void)showFromTopOffset:(CGFloat) topOffset;
- (void)showFromBottomOffset:(CGFloat) bottomOffset;

@end
@implementation HKToast
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:[UIDevice currentDevice]];
}

- (id)initWithText:(NSString *)text{
    if (self = [super init]) {
        
        self.text = [text copy];
        
        UIFont *font = [UIFont boldSystemFontOfSize:34*scale_m];
        CGSize textSize = [text boundingRectWithSize:CGSizeMake(HK_DEVICE_WIDTH - 120 * scale_l, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width + 60*scale_s, MAX(textSize.height, 120*scale_l) + 12*scale_m)];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textColor = [UIColor whiteColor];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = font;
        textLabel.text = self.text;
        textLabel.numberOfLines = 0;
        
        self.contentView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, textLabel.frame.size.width, textLabel.frame.size.height)];
        self.contentView.layer.cornerRadius = 5.0f;
        self.contentView.layer.borderWidth = 1.0f;
        self.contentView.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
        self.contentView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7];
        [self.contentView addSubview:textLabel];
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.contentView addTarget:self
                        action:@selector(toastTaped:)
              forControlEvents:UIControlEventTouchDown];
        self.contentView.alpha = 0.0f;
        
        self.duration = DEFAULT_DISPLAY_DURATION;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(deviceOrientationDidChanged:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:[UIDevice currentDevice]];
    }
    return self;
}

- (void)deviceOrientationDidChanged:(NSNotification *)notify_{
    [self hideAnimation];
}

-(void)dismissToast{
    [self.contentView removeFromSuperview];
}

-(void)toastTaped:(UIButton *)sender{
    [self hideAnimation];
}

- (void)setDuration:(CGFloat) duration{
    _duration = duration;
}
-(void)showAnimation{
    [UIView beginAnimations:@"show" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.3];
    self.contentView.alpha = 1.0f;
    [UIView commitAnimations];
}
-(void)hideAnimation{
    [UIView beginAnimations:@"hide" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(dismissToast)];
    [UIView setAnimationDuration:0.3];
    self.contentView.alpha = 0.0f;
    [UIView commitAnimations];
}
- (void)show{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.contentView.center = window.center;
    [window  addSubview:self.contentView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:self.duration];
}
- (void)showFromTopOffset:(CGFloat) top{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.contentView.center = CGPointMake(window.center.x, top + self.contentView.frame.size.height/2);
    [window  addSubview:self.contentView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:self.duration];
}
- (void)showFromBottomOffset:(CGFloat) bottom{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.contentView.center = CGPointMake(window.center.x, window.frame.size.height-(bottom + self.contentView.frame.size.height/2));
    [window  addSubview:self.contentView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:self.duration];
}
+ (void)showWithText:(NSString *)text{
    [HKMessageBox showMessage:text];
}
+ (void)showWithText:(NSString *)text
            duration:(CGFloat)duration{
    HKToast *toast = [[HKToast alloc] initWithText:text] ;//
    [toast setDuration:duration];
    [toast show];
}
+ (void)showWithText:(NSString *)text
           topOffset:(CGFloat)topOffset{
    [HKToast showWithText:text  topOffset:topOffset duration:DEFAULT_DISPLAY_DURATION];
}

+ (void)showWithText:(NSString *)text
           topOffset:(CGFloat)topOffset
            duration:(CGFloat)duration{
    HKToast *toast = [[HKToast alloc] initWithText:text] ;
    [toast setDuration:duration];
    [toast showFromTopOffset:topOffset];
}
+ (void)showWithText:(NSString *)text
        bottomOffset:(CGFloat)bottomOffset{
    [HKToast showWithText:text  bottomOffset:bottomOffset duration:DEFAULT_DISPLAY_DURATION];
}
+ (void)showWithText:(NSString *)text
        bottomOffset:(CGFloat)bottomOffset
            duration:(CGFloat)duration{
    HKToast *toast = [[HKToast alloc] initWithText:text] ;
    [toast setDuration:duration];
    [toast showFromBottomOffset:bottomOffset];
}

@end
