//
//  UIControl+HKExtension.h
//  HKProject
//
//  Created by 胡锦涛 on 2018/7/27.
//  Copyright © 2018年 胡锦涛. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^HKClickActionBlock) ( id obj);
@interface UIControl (HKExtension)
- (void)hk_addBlock:(HKClickActionBlock)clickBlock for:(UIControlEvents)event;
- (void)hk_setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;
@end
