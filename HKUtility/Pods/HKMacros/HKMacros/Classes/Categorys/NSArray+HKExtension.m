//
//  NSArray+HKExtension.m
//  HKProject
//
//  Created by 胡锦涛 on 2018/8/23.
//  Copyright © 2018年 胡锦涛. All rights reserved.
//

#import "NSArray+HKExtension.h"
#import "NSDictionary+HKExtension.h"

@implementation NSArray (HKExtension)
- (NSString *)hk_toXML
{
    __block NSMutableString *tempStr = [NSMutableString new];
    
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            
            [tempStr appendFormat:@"%@",obj];
            
        }else if ([obj isKindOfClass:[NSArray class]])
        {
            [tempStr appendFormat:@"%@",[obj hk_toXML]];
            
        }else if ([obj isKindOfClass:[NSDictionary class]])
        {
            [tempStr appendFormat:@"%@",[obj hk_toXML]];
        }
        
    }];
    return tempStr;
}
- (id)hk_safeObjectAtIndex:(NSInteger)index
{
    if ( index < 0 )
        return nil;
    
    if (index >= self.count)
        return nil;
    
    return [self objectAtIndex:index];
}
@end

@implementation NSMutableArray(HKExtension)
- (NSString *)hk_toXML
{
    __block NSMutableString *tempStr = [NSMutableString new];
    
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            
            [tempStr appendFormat:@"%@",obj];
            
        }else if ([obj isKindOfClass:[NSArray class]])
        {
            [tempStr appendFormat:@"%@",[obj hk_toXML]];
            
        }else if ([obj isKindOfClass:[NSDictionary class]])
        {
            [tempStr appendFormat:@"%@",[obj hk_toXML]];
        }
        
    }];
    return tempStr;
}
- (id)hk_safeObjectAtIndex:(NSInteger)index
{
    if ( index < 0 )
        return nil;
    
    if (index >= self.count)
        return nil;
    
    return [self objectAtIndex:index];
}

@end
