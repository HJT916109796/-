//
//  MyKeyChainManager.h
//  NetTest
//
//  Created by dev_mac_001 on 16/3/4.
//  Copyright © 2016年 dev_mac_001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyKeyChainManager : NSObject


+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service;

+ (void)save:(NSString *)service data:(id)data;

+ (id)load:(NSString *)service;

+ (void)delete:(NSString *)service;



@end
