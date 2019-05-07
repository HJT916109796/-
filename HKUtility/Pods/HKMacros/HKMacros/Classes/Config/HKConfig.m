//
//  HKConfig.m
//  HKProject
//
//  Created by 胡锦涛 on 2018/7/26.
//  Copyright © 2018年 胡锦涛. All rights reserved.
//

#import "HKConfig.h"
#import "HKScale.h"
#import "HKTool.h"

@implementation HKConfig
+ (void)launch{
    [HKScale shared];
    [HKTool shared];
}
@end
