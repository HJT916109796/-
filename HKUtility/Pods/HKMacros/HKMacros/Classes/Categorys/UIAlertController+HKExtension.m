//
//  UIAlertController+HKExtension.m
//  HKMacros
//
//  Created by 胡锦涛 on 2019/5/7.
//

#import "UIAlertController+HKExtension.h"

#define HK_MAX_NAME_LENGTH 10  //昵称的长度

@implementation UIAlertController (HKExtension)
/** 系统中部弹出框 单键*/
+ (void)hk_alertWithTarget:(id)target
                          title:(NSString *)title
                      message:(NSString *)message
                 confirmTitle:(NSString *)confirmTitle
                      handler:(void(^)(void))handler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        if (handler) {
            handler();
        }
    }];
    
    [alert addAction:cancelAction];
    [target presentViewController:alert animated:YES completion:nil];
}
/** 系统中部弹出框 双键*/
+ (void)hk_alertWithTarget:(id)target
                         title:(NSString *)title
                       message:(NSString *)message
             cancelButtonTitle:(NSString *)cancelButtonTitle
                 cancelHandler:(void(^)(void))cancelHandler
             ensureButtonTitle:(NSString *)ensureButtonTitle
                 ensureHandler:(void(^)(void))ensureHandler {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              if (cancelHandler) {
                                                                  cancelHandler();
                                                              }
                                                          }];
    
    [alert addAction:defaultAction];
    UIAlertAction* otherAction = [UIAlertAction actionWithTitle:ensureButtonTitle style:UIAlertActionStyleDestructive
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            if (ensureHandler) {
                                                                ensureHandler();
                                                            }
                                                        }];
    [alert addAction:otherAction];
    [target presentViewController:alert animated:YES completion:nil];
}
/** Alert 任意多个按键 返回选中的 buttonIndex 和 buttonTitle */
+ (void)hk_presentAlertWithTarget:(id)target
                            title:(NSString *)title
                          message:(NSString *)message
                     actionTitles:(NSArray *)actionTitles
                   preferredStyle:(UIAlertControllerStyle)preferredStyle
                          handler:(void(^)(NSUInteger buttonIndex, NSString *buttonTitle))handler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        handler(0, @"取消");
    }];
    [alert addAction:cancelAction];
    
    for (int i = 0; i < actionTitles.count; i ++) {
        
        UIAlertAction *confimAction = [UIAlertAction actionWithTitle:actionTitles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            handler((i + 1), actionTitles[i]);
        }];
        [alert addAction:confimAction];
    }
    
    [target presentViewController:alert animated:YES completion:nil];
}
/** 系统中部文本弹出框 */
+ (void)hk_alertWithTextfiledTarget:(id)target
                              Title:(NSString *)title
                            Message:(NSString *)message
                        placeHolder:(NSString *)placeholder
                           isNumber:(BOOL)isNumber
                         confirmStr:(NSString *)confirmStr
                          cancleStr:(NSString *)cancleStr
                      confirmbBlock:(void(^)(id obj))confirmbBlock
                        cancelBlock:(void(^)(void))cancelBlock {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = placeholder;
        if (isNumber) {
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [textField addTarget:[UIAlertController new] action:@selector(tfdValueChanged:) forControlEvents:UIControlEventEditingChanged];
    }];
    UIAlertAction *action1;
    if (confirmStr.length > 0) {
        action1 = [UIAlertAction actionWithTitle:confirmStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (confirmbBlock) {
                UITextField *tfd = alertController.textFields.firstObject;
                confirmbBlock(tfd.text);
            }
        }];
        [alertController addAction:action1];
    }
    if (cancleStr.length > 0) {
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:cancleStr style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancle];
    }
    [target presentViewController:alertController animated:YES completion:nil];
}



/** 系统底部弹出框 */
+ (void)hk_alertSheetWithTarget:(id)target
                          Title:(NSString *)title
                        Message:(NSString *)message
                     actionStr1:(NSString *)actionStr1
                     actionStr2:(NSString *)actionStr2
                         block1:(void(^)(id obj))block1
                         block2:(void(^)(id obj))block2 {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1, *action2;
    if (actionStr1) {
        action1 = [UIAlertAction actionWithTitle:actionStr1 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (block1) {
                block1(action.title);
            }
        }];
        [alertController addAction:action1];
    }
    if (actionStr2) {
        action2 = [UIAlertAction actionWithTitle:actionStr2 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (block2) {
                block2(action.title);
            }
        }];
        [alertController addAction:action2];
    }
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancle];
    [target presentViewController:alertController animated:YES completion:nil];
}
#pragma mark -
#pragma mark - action ---> textfield

- (void)tfdValueChanged:(UITextField *)sender {
    NSString *toBeString = sender.text;
    //获取高亮部分
    UITextRange *selectedRange = [sender markedTextRange];
    UITextPosition *position = [sender positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position) {
        if (toBeString.length > HK_MAX_NAME_LENGTH) {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:HK_MAX_NAME_LENGTH];
            if (rangeIndex.length == 1) {
                sender.text = [toBeString substringToIndex:HK_MAX_NAME_LENGTH];
            }else {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, HK_MAX_NAME_LENGTH)];
                sender.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}
- (void)dealloc {
    NSLog(@">>>>alert dealloc");
}


@end
