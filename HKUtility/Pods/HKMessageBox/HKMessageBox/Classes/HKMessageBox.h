//
//  HKMessageBox.h
//  CallShow
//
//  Created by 胡锦涛 on 2018/6/13.
//  Copyright © 2018年 胡锦涛. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, HKMessageBoxTag) {
    HKMessageBoxTagBack = 7000,
};
typedef void(^OnDismissBlock) (HKMessageBoxTag index);

typedef NS_ENUM(NSInteger, HKMessageBoxOption) {
    HKMessageBoxOptionDismissOnOutside = 1<<4,
    HKMessageBoxOptionIndicatorMask = 0xF,
    HKMessageBoxOptionIndicatorNone = 0,
    HKMessageBoxOptionIndicatorAbove = 1,
    HKMessageBoxOptionToast = 2,
};
extern CGFloat afterDelay;
@interface HKMessageBox : UIView
@property (nonatomic, strong) UIView *msgPanel;
+(HKMessageBox *)sharedInstance;
+ (void) showMessage:(NSString *) message;
+ (void) showLoadingText:(NSString *) message;
+ (void) showSuccessMessage:(NSString *)result placeholder:(NSString *)placeholder;
- (void) showMessage:(NSString *) message afterDelay:(float)time ;
- (void) showMessage:(NSString *) message;
- (void) showUpdatingText:(NSString *) message;
- (void) startAnimating;
- (void) stopAnimating;
+ (void) beginLoading:(NSString *) message bottomOffsset:(CGFloat)bottom;
+ (void) dismiss;
@end
