//
//  UISearchBar+Extension.m
//  HireKnight
//
//  Created by 胡锦涛 on 2017/10/31.
//  Copyright © 2017年 胡锦涛. All rights reserved.
//

#import "UISearchBar+Extension.h"

@implementation UISearchBar (Extension)
-(void)hk_setLeftPlaceholder:(NSString *)placeholder {
    self.placeholder = placeholder;
    
    SEL centerSelector = NSSelectorFromString([NSString stringWithFormat:@"%@%@", @"setCenter", @"Placeholder:"]);
    if ([self respondsToSelector:centerSelector]) {
        BOOL centeredPlaceholder = NO;
        NSMethodSignature *signature = [[UISearchBar class] instanceMethodSignatureForSelector:centerSelector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:centerSelector];
        [invocation setArgument:&centeredPlaceholder atIndex:2];
        [invocation invoke];
    }
}
-(void)hk_setCenterPlaceholder:(NSString *)placeholder {
    self.placeholder = placeholder;
    
    SEL leftSelector = NSSelectorFromString([NSString stringWithFormat:@"%@%@", @"setLeft", @"Placeholder:"]);
    if ([self respondsToSelector:leftSelector]) {
        BOOL centeredPlaceholder = NO;
        NSMethodSignature *signature = [[UISearchBar class] instanceMethodSignatureForSelector:leftSelector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:leftSelector];
        [invocation setArgument:&centeredPlaceholder atIndex:0];
        [invocation invoke];
    }
}
@end
