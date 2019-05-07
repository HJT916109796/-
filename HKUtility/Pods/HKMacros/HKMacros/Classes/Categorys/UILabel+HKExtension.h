//
//  UILabel+HKExtension.h
//  HKProject
//
//  Created by 胡锦涛 on 2018/7/26.
//  Copyright © 2018年 胡锦涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TapActionDelegate <NSObject>
@optional
/**
 *  TapActionDelegate
 *
 *  @param string  点击的字符串
 *  @param range   点击的字符串range
 *  @param index 点击的字符在数组中的index
 */
- (void)tapReturnString:(NSString *)string
                  range:(NSRange)range
                  index:(NSInteger)index;
@end

@interface AttributeModel : NSObject

@property (nonatomic, copy) NSString *str;

@property (nonatomic, assign) NSRange range;

@end

@interface UILabel (HKExtension)

@property (nonatomic,assign)CGFloat characterSpace;//字间距
@property (nonatomic,assign)CGFloat lineSpace;//行间距
@property (nonatomic,copy)NSString *keywords;//关键字
@property (nonatomic,strong)UIFont *keywordsFont;
@property (nonatomic,strong)UIColor *keywordsColor;
//下划线
@property (nonatomic,copy)NSString *underlineStr;
@property (nonatomic,strong)UIColor *underlineColor;

/// 快速创建Label
+ (UILabel *)hk_labelWithFrame: (CGRect)frame
                       font: (UIFont *)font
                      color: (UIColor *)color
                    content: (NSString *)content;

- (CGSize)hk_getActualSize:(CGSize)size font:(UIFont *)font;

/**
 *  计算label宽高，必须调用
 *
 *  @param maxWidth 最大宽度
 *
 *  @return label的size
 */
- (CGSize)hk_getLableSizeWithMaxWidth:(CGFloat)maxWidth;

/**
 *  改变行间距和字间距
 */
+ (void)hk_changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace WithAttributeFontSize:(float)attributeFontSize;
//uilabel 文字顶部对齐
- (void)hk_alignTop;
- (void)hk_alignBottom;

#pragma mark - 给Label添加点击事件

/**
 *  是否打开点击效果，默认是打开
 */
@property (nonatomic, assign) BOOL enabledTapEffect;

/**
 *  给文本添加点击事件Block回调
 *
 *  @param strings  需要添加的字符串数组
 *  @param tapClick 点击事件回调
 */
- (void)tapActionWithBlcokStrings:(NSArray <NSString *> *)strings
                  tapClicked:(void (^) (NSString *string , NSRange range , NSInteger index))tapClick;

/**
 *  给文本添加点击事件delegate回调
 *
 *  @param strings  需要添加的字符串数组
 *  @param delegate delegate
 */
- (void)tapActionWithDelegaeStrings:(NSArray <NSString *> *)strings
                    delegate:(id <TapActionDelegate> )delegate;
@end
