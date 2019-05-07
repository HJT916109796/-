//
//  HKToast.h
//  CallShow
//
//  Created by 胡锦涛 on 2018/6/14.
//  Copyright © 2018年 胡锦涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define DEFAULT_DISPLAY_DURATION 2.0f
/**
 [HKToast showWithText:@"中间显示" duration:5];
 [HKToast showWithText:@"距离上方50像素" topOffset:50 duration:5];
 [HKToast showWithText:@"文字很多的时候，我就会自动折行，最大宽度280像素" topOffset:100 duration:5];
 [HKToast showWithText:@"加入\\n也可以\n显示\n多\n行" topOffset:300 duration:5];
 [HKToast showWithText:@"距离下方3像素" bottomOffset:3 duration:5];
 */
#define HK_RETRY_MSG @"\n点击重试"
@interface HKToast : NSObject
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIButton *contentView;
@property (nonatomic, assign) CGFloat  duration;
+ (void)showWithText:(NSString *)text;
+ (void)showWithText:(NSString *)text
            duration:(CGFloat)duration;
+ (void)showWithText:(NSString *)text
           topOffset:(CGFloat)topOffset;
+ (void)showWithText:(NSString *)text
           topOffset:(CGFloat)topOffset
            duration:(CGFloat)duration;
+ (void)showWithText:(NSString *)text
        bottomOffset:(CGFloat)bottomOffset;
+ (void)showWithText:(NSString *)text
        bottomOffset:(CGFloat)bottomOffset
            duration:(CGFloat)duration;
@end
