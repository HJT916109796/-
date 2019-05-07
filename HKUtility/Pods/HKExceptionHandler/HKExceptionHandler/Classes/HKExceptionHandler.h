//
//  HKExceptionHandler.h
//  ZYExceptionDemo
//
//  Created by 胡锦涛 on 2018/7/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKExceptionHandler : NSObject
+ (void)caughtExceptionHandler;
//删除错误日志：
+(void)deleteAllLogs;
#define ExceptionHandler [HKExceptionHandler caughtExceptionHandler];
@end
