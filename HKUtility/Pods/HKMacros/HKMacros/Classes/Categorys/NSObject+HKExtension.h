//
//  NSObject+HKExtension.h
//  HKProject
//
//  Created by 胡锦涛 on 2018/9/14.
//  Copyright © 2018年 胡锦涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (HKExtension)

///字典转模型
+(id)hk_objectWithKeyValues:(NSDictionary *)aDictionary;

///模型转字典
-(NSDictionary *)hk_keyValuesWithObject;

///添加UIView到Window上
- (void)hk_addSubviewToWindow:(UIView*)subView;

/// 自动打印属性字符串
+ (void)hk_printDict:(NSDictionary *)dict;

/// 字典转模型
+ (instancetype)hk_modelWithDict:(NSDictionary *)dict;

/// 方法替换
+ (void)hk_changeSel:(SEL)sel toSel:(SEL)tosel;
@end
