//
//  NSArray+HKExtension.h
//  HKProject
//
//  Created by 胡锦涛 on 2018/8/23.
//  Copyright © 2018年 胡锦涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (HKExtension)
- (NSString *)hk_toXML;

///防止数组越界，崩溃
- (id)hk_safeObjectAtIndex:(NSInteger)index;
@end

@interface NSMutableArray (HKExtension)
- (NSString *)hk_toXML;

///防止数组越界，崩溃
- (id)hk_safeObjectAtIndex:(NSInteger)index;
@end
