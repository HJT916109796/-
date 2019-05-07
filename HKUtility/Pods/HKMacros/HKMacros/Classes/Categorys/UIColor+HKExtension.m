//
//  UIColor+HKExtension.m
//  Pods
//
//  Created by 胡锦涛 on 2018/11/4.
//

#import "UIColor+HKExtension.h"
#import <objc/runtime.h>
@implementation UIColor (HKExtension)

//UIColor->颜色转字符串
- (NSString *) hk_hexStr{
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    //#%02lX%02lX%02lX
    return [NSString stringWithFormat:@"0xFF%02lX%02lX%02lX",
            lroundf(r * 255),
            lroundf(g * 255),
            lroundf(b * 255)];
}

//UIColor转 Uint32
- (UInt32) hk_hexUint32 {
    
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    //#%02lX%02lX%02lX
    NSString * hexString = [NSString stringWithFormat:@"0xFF%02lX%02lX%02lX",
                            lroundf(r * 255),
                            lroundf(g * 255),
                            lroundf(b * 255)];
    const char *hexChar = [hexString cStringUsingEncoding:NSUTF8StringEncoding];
    int hexNumber;
    sscanf(hexChar, "%x", &hexNumber);
    return (UInt32)hexNumber;
}
@end
