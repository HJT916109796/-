//
//  UIBarButtonItem+HKExtension.m
//  HKProject
//
//  Created by 胡锦涛 on 2018/7/31.
//  Copyright © 2018年 胡锦涛. All rights reserved.
//

#import "UIBarButtonItem+HKExtension.h"
#import "UIControl+HKExtension.h"
#import "UIButton+HKExtension.h"
#import "HKScale.h"
@implementation UIBarButtonItem (HKExtension)

+ (UIBarButtonItem *)hk_getBackItemWithImage:(UIImage *)img withTarget:(id)target action:(SEL)action{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:img forState:UIControlStateNormal];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [btn sizeToFit];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    btn.frame = CGRectMake(0, 0, 45, 40);
    backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return backItem;
}

+ (UIBarButtonItem *)hk_getBackItemWithImageName:(NSString *)imgName withTarget:(id)target action:(SEL)action{
    UIImage *image = [UIImage imageNamed:imgName];
    return [self hk_getBackItemWithImage:image withTarget:target action:action];
}

+ (UIBarButtonItem *)hk_getItemWithTitle:(NSString *)title withTarget:(id)target action:(SEL)action{
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [btn sizeToFit];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    btn.frame = CGRectMake(0, 0, 45, 40);
    [btn hk_setEnlargeEdgeWithTop:5 right:5 bottom:5 left:5];
    backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return backItem;
}

+ (UIBarButtonItem *)hk_getItemWithImage:(UIImage *)img withTarget:(id)target action:(SEL)action{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:img forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    btn.frame = CGRectMake(0, 0, 45, 40);
    [btn hk_setEnlargeEdgeWithTop:5 right:5 bottom:5 left:5];
    backItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return backItem;
}

+ (UIBarButtonItem *)hk_getItemWithImageName:(NSString *)imgName withTarget:(id)target action:(SEL)action{
    return [self hk_getItemWithImage:[UIImage imageNamed:imgName] withTarget:target action:action];
}

+ (UIBarButtonItem *)hk_itemWithimage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:highImage forState:UIControlStateHighlighted];
    [btn sizeToFit];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIView *containView = [[UIView alloc] initWithFrame:btn.bounds];
    [containView addSubview:btn];
    
    return [[UIBarButtonItem alloc] initWithCustomView:containView];
}

+ (UIBarButtonItem *)hk_itemWithimage:(UIImage *)image selImage:(UIImage *)selImage target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:selImage forState:UIControlStateSelected];
    [btn sizeToFit];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIView *containView = [[UIView alloc] initWithFrame:btn.bounds];
    [containView addSubview:btn];
    
    return [[UIBarButtonItem alloc] initWithCustomView:containView];
}

+ (UIBarButtonItem *)hk_backItemWithimage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action title:(NSString *)title{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:title forState:UIControlStateNormal];
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton setImage:highImage forState:UIControlStateHighlighted];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [backButton sizeToFit];
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return  [[UIBarButtonItem alloc] initWithCustomView:backButton];
}
@end
