//
//  Target_A.m
//  HKUtility
//
//  Created by 胡锦涛 on 2019/5/2.
//  Copyright © 2019 胡锦涛. All rights reserved.
//

#import "Target_A.h"
#import "DemoModuleADetailViewController.h"
@implementation Target_A
- (void)Action_getUserInfo:(NSDictionary *)params {
    [HKMessageBox showMessage:@"Coming"];
}
- (UIViewController *)Action_nativeFetchDetailViewController:(NSDictionary *)params
{
    // 因为action是从属于ModuleA的，所以action直接可以使用ModuleA里的所有声明
    DemoModuleADetailViewController *viewController = [[DemoModuleADetailViewController alloc] init];
    viewController.valueLabel.text = params[@"key"];
    return viewController;
}
@end
