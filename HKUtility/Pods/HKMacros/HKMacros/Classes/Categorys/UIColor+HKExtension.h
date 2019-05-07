//
//  UIColor+HKExtension.h
//  Pods
//
//  Created by 胡锦涛 on 2018/11/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (HKExtension)
//UIColor->颜色转字符串
- (NSString *) hk_hexStr;

//UIColor转 Uint32
- (UInt32) hk_hexUint32;

@end

NS_ASSUME_NONNULL_END
