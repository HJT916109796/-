//
//  UITextField+HKExtension.m
//  HKProject
//
//  Created by 胡锦涛 on 2018/8/28.
//  Copyright © 2018年 胡锦涛. All rights reserved.
//

#import "UITextField+HKExtension.h"
#import "UIView+HKExtension.h"
#import "HKMacro.h"
#import <objc/message.h>

@implementation UITextField (HKExtension)
+ (void)load
{
    // setPlaceholder
    Method setPlaceholderMethod = class_getInstanceMethod(self, @selector(setPlaceholder:));
    Method setHk_PlaceholderMethod = class_getInstanceMethod(self, @selector(setHk_Placeholder:));
    method_exchangeImplementations(setPlaceholderMethod, setHk_PlaceholderMethod);
}
- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    
    // 给成员属性赋值 runtime给系统的类添加成员属性
    // 添加成员属性
    objc_setAssociatedObject(self, @"placeholderColor", placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // 获取占位文字label控件
    UILabel *placeholderLabel = [self valueForKey:@"placeholderLabel"];
    
    // 设置占位文字颜色
    placeholderLabel.textColor = placeholderColor;
}


- (UIColor *)placeholderColor
{
    return objc_getAssociatedObject(self, @"placeholderColor");
}

// 设置占位文字
// 设置占位文字颜色
- (void)setHk_Placeholder:(NSString *)placeholder
{
    [self setHk_Placeholder:placeholder];
    
    self.placeholderColor = self.placeholderColor;
}
- (void)hk_addLeftDistance:(CGFloat)distance{
    UILabel * leftView = [[UILabel alloc] initWithFrame:CGRectMake(0,0,distance,self.hk_height)];
    leftView.backgroundColor = [UIColor clearColor];
    self.leftView  = leftView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

- (void)hk_addCompleteAccessoryViewWithTarget:(id)target Selector:(SEL)sel{
    //设置添加图片的按钮  //定义一个toolBar
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, HK_DEVICE_WIDTH, 44)];
    topView.backgroundColor = [UIColor clearColor];
    //设置style
    [topView setBarStyle:UIBarStyleDefault];
    //定义两个flexibleSpace的button，放在toolBar上，这样完成按钮就会在最左边
    UIBarButtonItem * buttonBlank = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * buttonBlank2 = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * commentRetract =[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:target action:sel];
    //在toolBar上加上这些按钮
    NSArray * buttonsArray = [NSArray arrayWithObjects:buttonBlank,buttonBlank2,commentRetract,nil];
    [topView setItems:buttonsArray];
    self.inputAccessoryView = topView;
}
///setTextFiedMaxLimit setTextFiedMaxLimit:kMAXTAGLIMIT withString:text
- (void)hk_setMaxLimit:(NSInteger)limit withString:(NSString *)str{
    if (str.length > limit)
    {
        NSRange rangeRange = [str rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, limit)];
        self.text = [str substringWithRange:rangeRange];
    }
}

///设置TextField赋值显示
- (void)hk_setMaxTextLimit:(NSInteger)limit withString:(NSMutableString *)string  {
    if (string.length>limit) {
        NSString * str = [string substringFromIndex:limit];
        NSRange  range = NSMakeRange(limit, str.length);
        [string deleteCharactersInRange:range];
    }
    self.text = string;
}
@end

@implementation UITextView (HKExtension)

- (void)hk_addCompleteAccessoryViewWithTarget:(id)target Selector:(SEL)sel{
    //设置添加图片的按钮  //定义一个toolBar
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, HK_DEVICE_WIDTH, 44)];
    topView.backgroundColor = [UIColor clearColor];
    //设置style
    [topView setBarStyle:UIBarStyleDefault];
    //定义两个flexibleSpace的button，放在toolBar上，这样完成按钮就会在最左边
    UIBarButtonItem * buttonBlank = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * buttonBlank2 = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * commentRetract =[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:target action:sel];
    //在toolBar上加上这些按钮
    NSArray * buttonsArray = [NSArray arrayWithObjects:buttonBlank,buttonBlank2,commentRetract,nil];
    [topView setItems:buttonsArray];
    self.inputAccessoryView = topView;
}
///setTextViewMaxLimit setTextFiedMaxLimit:kMAXTAGLIMIT withString:text
- (void)hk_setMaxLimit:(NSInteger)limit withString:(NSString *)str{
    if (str.length > limit)
    {
        NSRange rangeRange = [str rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, limit)];
        self.text = [str substringWithRange:rangeRange];
    }
}

///设置TextView赋值显示
- (void)hk_setMaxTextLimit:(NSInteger)limit withString:(NSMutableString *)string  {
    if (string.length>limit) {
        NSString * str = [string substringFromIndex:limit];
        NSRange  range = NSMakeRange(limit, str.length);
        [string deleteCharactersInRange:range];
    }
    self.text = string;
}
@end
