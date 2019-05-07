//
//  HKLogModel.m
//  HKMacros
//
//  Created by 胡锦涛 on 2019/3/9.
//

#import "HKLogModel.h"
#import <objc/runtime.h>

@implementation HKLogModel
///特殊字符、空、null过滤
-(void)setValue:(id)value forKey:(NSString *)key
{
    
    if ([value isKindOfClass:[NSNumber class]]) {
        value = [NSString stringWithFormat:@"%@",value];
    }else if ([value isKindOfClass:[NSNull class]]){
        value = @"";
    }else if ([value isKindOfClass:[NSString class]]){
        if ([(NSString *)value containsString:@"<null>"]) {
            value = @"";
        }
    }
    [super setValue:value forKey:key];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
///Model打印

- (NSString *)description {
    return [self descriptionWithLocale:[NSLocale systemLocale]
                                indent:0];
}

- (NSString *)debugDescription {
    return [self descriptionWithLocale:[NSLocale systemLocale]
                                indent:0];
}

- (NSString *)descriptionWithLocale:(id)locale
                             indent:(NSUInteger)level {
    uint count;
    Class cls = [self class];
    NSMutableString *mStr = [NSMutableString string];
    NSMutableString *tab = [NSMutableString stringWithString:@""];
    for (int index = 0; index < level; index ++) {
        [tab appendString:@"\t"];
    }
    [mStr appendString:@"<!--\n"];
    while (![NSStringFromClass(cls) isEqualToString:@"HKLogModel"]) {
        objc_property_t *properties = class_copyPropertyList(cls, &count);
        for (int index = 0; index < count; index ++) {
            NSString *lastSymbol = index + 1 == count ? @"" : @";";
            objc_property_t property = properties[index];
            NSString *name = @(property_getName(property));
            id value = [self valueForKey:name];
            if ([value respondsToSelector:@selector(descriptionWithLocale:indent:)]) {
                [mStr appendFormat:@"\t%@%@ = %@%@\n",
                 tab,
                 name,
                 [value descriptionWithLocale:locale indent:level + 1],
                 lastSymbol];
            }else {
                [mStr appendFormat:@"\t%@%@ = %@%@\n",
                 tab,
                 name,
                 value,
                 lastSymbol];
            }
        }
        free(properties);
        cls = [cls superclass];
    }
    [mStr appendFormat:@"%@--!>",tab];
    return [NSString stringWithFormat:@"<%@ : %p> %@",
            NSStringFromClass([self class]),
            self,
            mStr];
}
@end

#pragma mark NSArray Description
@implementation NSArray (HKNSArrayLog)
- (NSString *)descriptionWithLocale:(id)locale
                             indent:(NSUInteger)level {
    NSMutableString *mStr = [NSMutableString string];
    NSMutableString *tab = [NSMutableString stringWithString:@""];
    for (int index = 0; index < level; index ++) {
        [tab appendString:@"\t"];
    }
    [mStr appendString:@"(\n"];
    for (int index = 0; index < self.count; index ++) {
        NSString *lastSymbol = (self.count == index + 1) ? @"":@",";
        id value = self[index];
        if ([value respondsToSelector:@selector(descriptionWithLocale:indent:)]) {
            [mStr appendFormat:@"\t%@%@%@\n",
             tab,
             [value descriptionWithLocale:locale indent:level + 1],
             lastSymbol];
        } else {
            [mStr appendFormat:@"\t%@%@%@\n",
             tab,
             value,
             lastSymbol];
        }
    }
    [mStr appendFormat:@"%@)",tab];
    return mStr;
}

- (NSString *)debugDescription {
    return [self descriptionWithLocale:[NSLocale systemLocale]];
}
@end


#pragma mark NSDictionary Description
@implementation NSDictionary (HKNSDictionaryLog)
- (NSString *)descriptionWithLocale:(id)locale
                             indent:(NSUInteger)level {
    NSMutableString *mStr = [NSMutableString string];
    NSMutableString *tab = [NSMutableString stringWithString:@""];
    for (int index = 0; index < level; index++) {
        [tab appendString:@"\t"];
    }
    [mStr appendString:@"{\n"];
    NSArray *allKeys = self.allKeys;
    for (int index = 0; index < allKeys.count; index++) {
        id value = self[allKeys[index]];
        NSString *lastSymbol = (allKeys.count == index + 1) ? @"":@";";
        if ([value respondsToSelector:@selector(descriptionWithLocale:indent:)]) {
            [mStr appendFormat:@"\t%@%@ = %@%@\n",
             tab,
             allKeys[index],
             [value descriptionWithLocale:locale indent:level + 1],
             lastSymbol];
        }else {
            [mStr appendFormat:@"\t%@%@ = %@%@\n",
             tab,
             allKeys[index],
             value,
             lastSymbol];
        }
    }
    [mStr appendFormat:@"%@}",tab];
    return mStr;
}

- (NSString *)debugDescription {
    return [self descriptionWithLocale:[NSLocale systemLocale]];
}
@end


#pragma mark NSSet Description
@implementation NSSet (HKNSSetDescription)
- (NSString *)descriptionWithLocale:(id)locale
                             indent:(NSUInteger)level {
    NSMutableString *mStr = [NSMutableString string];
    NSMutableString *tab = [NSMutableString stringWithString:@""];
    for (int index = 0; index <level; index ++) {
        [tab appendString:@"\t"];
    }
    [mStr appendString:@"{(\n"];
    for (id value in [self allObjects]) {
        NSString *lastSymbol = [value isEqual:[[self allObjects] lastObject]] ? @"" : @",";
        if ([value respondsToSelector:@selector(descriptionWithLocale:indent:)]) {
            [mStr appendFormat:@"\t%@%@%@\n",
             tab,
             [value descriptionWithLocale:locale indent:level + 1],
             lastSymbol];
        } else {
            [mStr appendFormat:@"\t%@%@%@\n",
             tab,
             value,
             lastSymbol];
        }
    }
    [mStr appendFormat:@"%@)}",tab];
    return mStr;
}

- (NSString *)debugDescription {
    return [self descriptionWithLocale:[NSLocale systemLocale]];
}
@end
