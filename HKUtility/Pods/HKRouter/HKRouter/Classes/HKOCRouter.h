//
//  HKOCRouter.h
//  HKUtilities
//
//  Created by 胡锦涛 on 2018/11/11.
//  Copyright © 2018 胡锦涛. All rights reserved.
/*
 使用：
 1.创建一个类格式eg：Target_A
 2.声明一个方法eg：Action_
 3.调用此方法:
 UIViewController * vc = [[HKOCRouter shareInstance] hk_remotePerformWithUrl:@"hk://Index/getUserInfo"];
 Index为组件索引；getUserInfo为actionName；“:”冒号表示带参数.
 此方法是调用Target_Index类中，方法名为Action_getUserInfo方法
 */

#import <UIKit/UIKit.h>
///路由回调
typedef void (^HKOCRouterHandler)(NSDictionary *result);
NS_ASSUME_NONNULL_BEGIN

@interface HKOCRouter : UIView
//单例
+(instancetype)sharedInstance;

#pragma mark - 组件通信方法

///远程App调用入口-不带回调
+ (id)hk_remotePerformWithUrl:(NSString *)urlStr;

///远程App调用入口-带回调
+ (id)hk_remotePerformWithUrl:(NSString *)urlStr handler:(HKOCRouterHandler)handler;

///本地组件调用入口
+ (id)hk_localPerformTarget:(NSString *)targetName action:(NSString *)actionName param:(NSDictionary *)params shouldCacheTarget:(BOOL)shouldCacheTarget;

///释放CachedTarget
+ (void)hk_releaseCachedTargetWithTargetName:(NSString *)targetName;

@end

NS_ASSUME_NONNULL_END
