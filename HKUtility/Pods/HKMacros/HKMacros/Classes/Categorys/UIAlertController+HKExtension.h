//
//  UIAlertController+HKExtension.h
//  HKMacros
//
//  Created by 胡锦涛 on 2019/5/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertController (HKExtension)
/** 系统中部弹出框 单键*/
+ (void)hk_alertWithTarget:(id)target
                     title:(NSString *)title
                   message:(NSString *)message
              confirmTitle:(NSString *)confirmTitle
                   handler:(void(^)(void))handler;
/** 系统中部弹出框 双键*/
+ (void)hk_alertWithTarget:(id)target
                     title:(NSString *)title
                   message:(NSString *)message
         cancelButtonTitle:(NSString *)cancelButtonTitle
             cancelHandler:(void(^)(void))cancelHandler
         ensureButtonTitle:(NSString *)ensureButtonTitle
             ensureHandler:(void(^)(void))ensureHandler;

/** Alert 任意多个按键 返回选中的 buttonIndex 和 buttonTitle */
+ (void)hk_presentAlertWithTarget:(id)target
                            title:(NSString *)title
                          message:(NSString *)message
                     actionTitles:(NSArray *)actionTitles
                   preferredStyle:(UIAlertControllerStyle)preferredStyle
                          handler:(void(^)(NSUInteger buttonIndex, NSString *buttonTitle))handler;

/** 系统中部文本弹出框 */
+ (void)hk_alertWithTextfiledTarget:(id)target
                              Title:(NSString *)title
                            Message:(NSString *)message
                        placeHolder:(NSString *)placeholder
                           isNumber:(BOOL)isNumber
                         confirmStr:(NSString *)confirmStr
                          cancleStr:(NSString *)cancleStr
                      confirmbBlock:(void(^)(id obj))confirmbBlock
                        cancelBlock:(void(^)(void))cancelBlock;



/** 系统底部弹出框 */
+ (void)hk_alertSheetWithTarget:(id)target
                          Title:(NSString *)title
                        Message:(NSString *)message
                     actionStr1:(NSString *)actionStr1
                     actionStr2:(NSString *)actionStr2
                         block1:(void(^)(id obj))block1
                         block2:(void(^)(id obj))block2;
@end

NS_ASSUME_NONNULL_END
