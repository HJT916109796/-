//
//  HKOCRouter.m
//  HKUtilities
//
//  Created by 胡锦涛 on 2018/11/11.
//  Copyright © 2018 胡锦涛. All rights reserved.
//

#import "HKOCRouter.h"

NSString * const kHKRouterParamsKeySwiftTargetModuleName = @"kHKRouterParamsKeySwiftTargetModuleName";
@interface HKOCRouter ()
@property (nonatomic, strong) NSMutableDictionary *cachedTarget;
@end
static HKOCRouter * mediator = nil;
@implementation HKOCRouter
+(instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mediator = [[HKOCRouter alloc] init];
    });
    return mediator;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mediator = [super allocWithZone:zone];
    });
    return mediator;
}
/*
 scheme://[target]/[action]?[params]
 url sample:
 aaa://targetA/actionB?id=1234
 */
+ (id)hk_remotePerformWithUrl:(NSString *)urlStr {
    return [[HKOCRouter sharedInstance] hk_remotePerformWithUrl:urlStr];
}

+ (id)hk_remotePerformWithUrl:(NSString *)urlStr handler:(HKOCRouterHandler)handler {
    return [[HKOCRouter sharedInstance] hk_remotePerformWithUrl:urlStr handler:handler];
}

+ (id)hk_localPerformTarget:(NSString *)targetName action:(NSString *)actionName param:(NSDictionary *)params shouldCacheTarget:(BOOL)shouldCacheTarget {
    return [[HKOCRouter sharedInstance] hk_localPerformTarget:targetName action:actionName param:params shouldCacheTarget:shouldCacheTarget];
}

+ (void)hk_releaseCachedTargetWithTargetName:(NSString *)targetName {
    [[HKOCRouter sharedInstance] hk_releaseCachedTargetWithTargetName:targetName];
}
- (id)hk_remotePerformWithUrl:(NSString *)urlStr {
    return [self hk_remotePerformWithUrl:urlStr handler:nil];
}

- (id)hk_remotePerformWithUrl:(NSString *)urlStr handler:(HKOCRouterHandler)handler{
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *urlString = [url query];
    //切割字符串
    for (NSString *param in [urlString componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        id firstEle = [elts firstObject];
        id lastEle = [elts lastObject];
        if (firstEle && lastEle) {
            [params setObject:lastEle forKey:firstEle];
        }
    }
    
    // 这里这么写主要是出于安全考虑，防止黑客通过远程方式调用本地模块。
    NSString *actionName = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    if ([actionName hasPrefix:@"native"]) {
        return @(NO);
    }
    
    id result = [self hk_localPerformTarget:url.host action:actionName param:params shouldCacheTarget:NO];
    if (handler) {
        if (result) {
            handler(@{@"result":result});
        } else {
            handler(nil);
        }
    }
    return result;
    
}

- (id)hk_localPerformTarget:(NSString *)targetName action:(NSString *)actionName param:(NSDictionary *)params shouldCacheTarget:(BOOL)shouldCacheTarget{
    //这个目标的类名字符串
    NSString *swiftModuleName = params[kHKRouterParamsKeySwiftTargetModuleName];
    
    // generate target
    NSString *targetClassString = nil;
    if (swiftModuleName.length > 0) {
        targetClassString = [NSString stringWithFormat:@"%@.Target_%@", swiftModuleName, targetName];
    } else {
        targetClassString = [NSString stringWithFormat:@"Target_%@", targetName];
    }
    NSObject *target = self.cachedTarget[targetClassString];
    if (target == nil) {
        Class targetClass = NSClassFromString(targetClassString);
        target = [[targetClass alloc] init];
    }
    
    // generate action
    NSString *actionString = [NSString stringWithFormat:@"Action_%@:", actionName];
    SEL action = NSSelectorFromString(actionString);
    
    if (target == nil) {
        // 这里是处理无响应请求的地方之一，这个demo做得比较简单，如果没有可以响应的target，就直接return了。实际开发过程中是可以事先给一个固定的target专门用于在这个时候顶上，然后处理这种请求的
        [self noTargetActionResponseWithTargetString:targetClassString selectorString:actionString originParams:params];
        return nil;
    }
    
    if (shouldCacheTarget) {
        self.cachedTarget[targetClassString] = target;
    }
    
    if ([target respondsToSelector:action]) {
        return [self safePerformAction:action target:target params:params];
    } else {
        // 这里是处理无响应请求的地方，如果无响应，则尝试调用对应target的notFound方法统一处理
        SEL action = NSSelectorFromString(@"notFound:");
        if ([target respondsToSelector:action]) {
            return [self safePerformAction:action target:target params:params];
        } else {
            // 这里也是处理无响应请求的地方，在notFound都没有的时候，这个demo是直接return了。实际开发过程中，可以用前面提到的固定的target顶上的。
            [self noTargetActionResponseWithTargetString:targetClassString selectorString:actionString originParams:params];
            [self.cachedTarget removeObjectForKey:targetClassString];
            return nil;
        }
    }
}

- (void)hk_releaseCachedTargetWithTargetName:(NSString *)targetName
{
    NSString *targetClassString = [NSString stringWithFormat:@"Target_%@", targetName];
    [self.cachedTarget removeObjectForKey:targetClassString];
}


#pragma mark - private methods
- (void)noTargetActionResponseWithTargetString:(NSString *)targetString selectorString:(NSString *)selectorString originParams:(NSDictionary *)originParams
{
    SEL action = NSSelectorFromString(@"Action_response:");
    NSObject *target = [[NSClassFromString(@"Target_NoTargetAction") alloc] init];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"originParams"] = originParams;
    params[@"targetString"] = targetString;
    params[@"selectorString"] = selectorString;
    
    [self safePerformAction:action target:target params:params];
}

//通过对象调用指定的方法
- (id)safePerformAction:(SEL)action target:(NSObject *)target params:(NSDictionary *)params
{
    NSMethodSignature* methodSig = [target methodSignatureForSelector:action];
    if(methodSig == nil) {
        return nil;
    }
    const char* retType = [methodSig methodReturnType];
    
    if (strcmp(retType, @encode(void)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        return nil;
    }
    
    if (strcmp(retType, @encode(NSInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        NSInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(BOOL)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        BOOL result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(CGFloat)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        CGFloat result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(NSUInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        NSUInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [target performSelector:action withObject:params];
#pragma clang diagnostic pop
}

#pragma mark - getters and setters
- (NSMutableDictionary *)cachedTarget
{
    if (_cachedTarget == nil) {
        _cachedTarget = [[NSMutableDictionary alloc] init];
    }
    return _cachedTarget;
}
@end
