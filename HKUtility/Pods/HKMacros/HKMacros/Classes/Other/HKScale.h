//
//  HKScale.h
//  HKProject
//
//  Created by 胡锦涛 on 2018/7/26.
//  Copyright © 2018年 胡锦涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define HK_WIDTH 750.0
#define HK_HEIGHT 1334.0

/*1080标准-large*/
extern float scale_l;
extern CGFloat scale_lX;
extern CGFloat scale_lY;

/* 750标准-medium*/
extern CGFloat scale_m;
extern CGFloat scale_mX;
extern CGFloat scale_mY;

/*375x667标准-small*/
extern float scale_s;
extern CGFloat scale_sX;
extern CGFloat scale_sY;

@interface HKScale : NSObject
+ (HKScale *)shared;
+ (CGRect)vRect;//竖屏
+ (CGRect)lRect;//横屏
@end
