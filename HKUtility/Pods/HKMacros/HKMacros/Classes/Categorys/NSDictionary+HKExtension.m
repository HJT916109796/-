//
//  NSDictionary+HKExtension.m
//  HKProject
//
//  Created by 胡锦涛 on 2018/8/23.
//  Copyright © 2018年 胡锦涛. All rights reserved.
//

#import "NSDictionary+HKExtension.h"
#import "NSArray+HKExtension.h"
@implementation NSDictionary (HKExtension)

- (NSString *)hk_toXML
{
    __block NSMutableString *tempStr = [NSMutableString new];
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        [tempStr appendFormat:@"<%@>",key];
        
        if ([obj isKindOfClass:[NSString class]]) {
            [tempStr appendFormat:@"%@",obj];
        }else if ([obj isKindOfClass:[NSArray class]])
        {
            [tempStr appendFormat:@"%@",[obj hk_toXML]];
        }else if ([obj isKindOfClass:[NSDictionary class]])
        {
            [tempStr appendFormat:@"%@",[obj hk_toXML]];
        }
        
        [tempStr appendFormat:@"</%@>",key];
    }];
    return tempStr;
}

- (NSData *)hk_toJsonData
{
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    return jsonData;
}

// isKindOfClass:判断是否是当前类或者子类
// 生成属性代码 => 根据字典中所有key
-(void)hk_createPropertyCode
{
    NSMutableString *codes = [NSMutableString string];
    // 遍历字典
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
        
        NSString *code;
        if ([value isKindOfClass:[NSString class]]) {
            code = [NSString stringWithFormat:@"@property (nonatomic, strong) NSString *%@;",key];
        } else if ([value isKindOfClass:NSClassFromString(@"__NSCFBoolean")]) {
            code = [NSString stringWithFormat:@"@property (nonatomic, assign) BOOL %@;",key];
        } else if ([value isKindOfClass:[NSNumber class]]) {
            code = [NSString stringWithFormat:@"@property (nonatomic, assign) NSInteger %@;",key];
        } else if ([value isKindOfClass:[NSArray class]]) {
            code = [NSString stringWithFormat:@"@property (nonatomic, strong) NSArray *%@;",key];
        } else if ([value isKindOfClass:[NSDictionary class]]) {
            code = [NSString stringWithFormat:@"@property (nonatomic, strong) NSDictionary *%@;",key];
        }
        
        [codes appendFormat:@"\n%@\n",code];
        
    }];
    
    NSLog(@"%@",codes);
    
}

@end
