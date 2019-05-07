//
//  Target_A.h
//  HKUtility
//
//  Created by 胡锦涛 on 2019/5/2.
//  Copyright © 2019 胡锦涛. All rights reserved.
/*
 //组件化通信
 #import "HKOCRouter.h"
 #import <HandyFrame/UIView+LayoutMethods.h>
 #import "HKOCRouter+HKModuleAActions.h"
 
 //使用
 UIViewController *viewController = [[HKOCRouter sharedInstance] viewControllerForDetail];
 // 获得view controller之后，在这种场景下，到底push还是present，其实是要由使用者决定的，mediator只要给出view controller的实例就好了
 [self presentViewController:viewController animated:YES completion:nil];
 
 UIViewController *viewController =[[HKOCRouter sharedInstance] viewControllerForDetail];
 [self.navigationController pushViewController:viewController animated:YES];
 
 // 这种场景下，很明显是需要被present的，所以不必返回实例，mediator直接present了
 [HKOCRouter hk_remotePerformWithUrl:@"hk://A/getUserInfo" handler:^(NSDictionary *result) {
 }];

 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Target_A : NSObject
- (void)Action_getUserInfo:(NSDictionary *)params;
- (UIViewController *)Action_nativeFetchDetailViewController:(NSDictionary *)params;
@end

NS_ASSUME_NONNULL_END
