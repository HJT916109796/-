//
//  UITextField+HKExtension.h
//  HKProject
//
//  Created by 胡锦涛 on 2018/8/28.
//  Copyright © 2018年 胡锦涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (HKExtension)

///placeholderColor
@property UIColor *placeholderColor;

///UITextField添加LeftView距离
- (void)hk_addLeftDistance:(CGFloat)distance;

///UITextField右上角添加完成按钮
- (void)hk_addCompleteAccessoryViewWithTarget:(id)target Selector:(SEL)sel;

///setTextFiedMaxLimit设置textField最大限制 kMAXTAGLIMIT withString:text
- (void)hk_setMaxLimit:(NSInteger)limit withString:(NSString *)str;

///设置TextField赋值显示
- (void)hk_setMaxTextLimit:(NSInteger)limit withString:(NSMutableString *)string;
@end

@interface UITextView (HKExtension)

///UITextField右上角添加完成按钮
- (void)hk_addCompleteAccessoryViewWithTarget:(id)target Selector:(SEL)sel;

///setTextViewMaxLimit setTextFiedMaxLimit:kMAXTAGLIMIT withString:text
- (void)hk_setMaxLimit:(NSInteger)limit withString:(NSString *)str;

///设置TextView赋值显示
- (void)hk_setMaxTextLimit:(NSInteger)limit withString:(NSMutableString *)string;
@end
