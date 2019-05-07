//
//  HKOCRouter+HKModuleAActions.m
//  HKUtility
//
//  Created by 胡锦涛 on 2019/5/2.
//  Copyright © 2019 胡锦涛. All rights reserved.
//

#import "HKOCRouter+HKModuleAActions.h"
NSString * const kHKOCRouterTargetA = @"A";

#pragma mark - Method-List
NSString * const kHKRouterActionNativFetchDetailViewController = @"nativeFetchDetailViewController";
@implementation HKOCRouter (HKModuleAActions)

- (UIViewController *)viewControllerForDetail
{
    UIViewController *viewController = [HKOCRouter hk_localPerformTarget:kHKOCRouterTargetA action:kHKRouterActionNativFetchDetailViewController param:@{@"key":@"value"} shouldCacheTarget:NO];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        // view controller 交付出去之后，可以由外界选择是push还是present
        return viewController;
    } else {
        // 这里处理异常场景，具体如何处理取决于产品
        return [[UIViewController alloc] init];
    }
}
@end
