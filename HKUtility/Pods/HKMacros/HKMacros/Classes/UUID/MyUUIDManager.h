//
//  MyUUIDManager.h
//  NetTest
//
//  Created by dev_mac_001 on 16/3/4.
//  Copyright © 2016年 dev_mac_001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyUUIDManager : NSObject

/**
 增/改
 */
+(void)saveUUID:(NSString *)uuid;
/**
 查
 */
+(NSString *)getUUID;
/**
 删
 */
+(void)deleteUUID;

@end
