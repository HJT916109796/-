//
//  UIBarButtonItem+HKExtension.h
//  HKProject
//
//  Created by 胡锦涛 on 2018/7/31.
//  Copyright © 2018年 胡锦涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (HKExtension)

//BackItem带返回按钮
+ (UIBarButtonItem *)hk_getBackItemWithImage:(UIImage *)img withTarget:(id)target action:(SEL)action;

//BackItem带返回按钮
+ (UIBarButtonItem *)hk_getBackItemWithImageName:(NSString *)imgName withTarget:(id)target action:(SEL)action;

+ (UIBarButtonItem *)hk_getItemWithTitle:(NSString *)title withTarget:(id)target action:(SEL)action;

+ (UIBarButtonItem *)hk_getItemWithImage:(UIImage *)img withTarget:(id)target action:(SEL)action;

+ (UIBarButtonItem *)hk_getItemWithImageName:(NSString *)imgName withTarget:(id)target action:(SEL)action;

// 快速创建UIBarButtonItem
+ (UIBarButtonItem *)hk_itemWithimage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action;

+ (UIBarButtonItem *)hk_itemWithimage:(UIImage *)image selImage:(UIImage *)selImage target:(id)target action:(SEL)action;

+ (UIBarButtonItem *)hk_backItemWithimage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action title:(NSString *)title;
@end
