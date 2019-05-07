//
//  UIButton+HKExtension.h
//  HKProject
//
//  Created by 胡锦涛 on 2018/7/27.
//  Copyright © 2018年 胡锦涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#define defaultInterval 0.001  //默认时间间隔

typedef NS_ENUM(NSUInteger, ButtonEdgeInsetsStyle) {
    ButtonEdgeInsetsStyleImageLeft,
    ButtonEdgeInsetsStyleImageRight,
    ButtonEdgeInsetsStyleImageTop,
    ButtonEdgeInsetsStyleImageBottom
};

typedef void(^clickBlock)(void);

@interface UIButton (HKExtension)
/**设置点击时间间隔*/
@property (nonatomic, assign) NSTimeInterval timeInterval;
//FIXME:Runtime用法①给Category添加属性
/**点击回调**/
@property (nonatomic,copy) clickBlock click;
+ (UIButton*)hkCustom;
+ (UIButton*)hkCustomWithFrame:(CGRect)frame;
- (void)hk_layoutButtonWithEdgeInsetsStyle:(ButtonEdgeInsetsStyle)style imageTitlespace:(CGFloat)space;
- (void)hk_setFont:(UIFont*)hkFont;
- (void)hk_setNormalTitle:(NSString*)title;
- (void)hk_setSelectedTitle:(NSString*)title;
- (void)hk_setNormalTitleColor:(UIColor*)titleColor;
- (void)hk_setSelectedTitleColor:(UIColor*)titleColor;
- (void)hk_setNormalImageName:(NSString*)name;
- (void)hk_setSelectedImageName:(NSString*)name;
- (void)hk_setBorderWidth:(CGFloat)borderWidth borderColor:(UIColor*)borderColor;
- (void)hk_roundCorner;
- (void)hk_setCornerRadious:(CGFloat)cornerRadious;//如果需要剪切边框，此句需放到setBorderWidth之后
- (void)hk_addTarget:(id)vc withAction:(SEL)action;
/*设置水平居中/竖直居中*/
//contentHorizontalAlignment||contentVerticalAlignment
@end

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface HKRoundedButton : UIButton

@property (nonatomic, assign) IBInspectable NSUInteger style;
@property (nonatomic, assign) IBInspectable CGFloat hk_cornerRadious;

@end
