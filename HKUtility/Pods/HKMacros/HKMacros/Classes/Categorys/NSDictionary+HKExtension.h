//
//  NSDictionary+HKExtension.h
//  HKProject
//
//  Created by 胡锦涛 on 2018/8/23.
//  Copyright © 2018年 胡锦涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (HKExtension)

///字典转XML
- (NSString *)hk_toXML;

///字典转JsonData
- (NSData *)hk_toJsonData;

///生成属性代码 => 根据字典中所有key
- (void)hk_createPropertyCode;

@end
