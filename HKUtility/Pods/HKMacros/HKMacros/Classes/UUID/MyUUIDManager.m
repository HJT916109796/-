//
//  MyUUIDManager.m
//  NetTest
//
//  Created by dev_mac_001 on 16/3/4.
//  Copyright © 2016年 dev_mac_001. All rights reserved.
//

#import "MyUUIDManager.h"

#import "MyKeyChainManager.h"

@implementation MyUUIDManager

static NSString * const KEY_IN_KEYCHAIN = @"com.myuuid.uuid";


+(void)saveUUID:(NSString *)uuid{
    if (uuid && uuid.length > 0) {
        [MyKeyChainManager save:KEY_IN_KEYCHAIN data:uuid];
    }
}


+(NSString *)getUUID{
    //先获取keychain里面的UUID字段，看是否存在
    NSString *uuid = (NSString *)[MyKeyChainManager load:KEY_IN_KEYCHAIN];
    
    //如果不存在则为首次获取UUID，所以获取保存。
    if (!uuid || uuid.length == 0) {
        CFUUIDRef puuid = CFUUIDCreate( nil );
        
        CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
        
        uuid = [NSString stringWithFormat:@"%@", uuidString];
        
        [self saveUUID:uuid];
        
        CFRelease(puuid);
        
        CFRelease(uuidString);
    }
    
    return uuid;
}



+(void)deleteUUID{
    [MyKeyChainManager delete:KEY_IN_KEYCHAIN];
}


@end
