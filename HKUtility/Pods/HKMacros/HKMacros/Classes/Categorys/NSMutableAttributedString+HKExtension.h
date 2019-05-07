//
//  NSMutableAttributedString+HKExtension.h
//  HKProject
//
//  Created by 胡锦涛 on 2018/8/6.
//  Copyright © 2018年 胡锦涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (HKExtension)
///UILabel设置可变文字
+ (NSMutableAttributedString *)hk_addMixLabelAttributedStringWithText:(NSString *)accountText withTheLatter:(NSString *)latter withPrefixColor:(UIColor*)prefixColor withSuffixColor:(UIColor*)suffixColor withPrefixFont:(CGFloat)prefixFont withSuffixFont:(CGFloat)suffixFont;
///NSMutableAttributedString 设置可变属性
+ (NSMutableAttributedString *)hk_setAttributedText:(NSString *)attrText attributeFont:(CGFloat)attributeFont markText:(NSString *)markText shadowColor:(UIColor*)shadowColor;
+ (NSMutableAttributedString *)hk_setAttributedText:(NSString *)attrText attributeFont:(CGFloat)attributeFont markText:(NSString *)markText shadowColor:(UIColor*)shadowColor markColor:(UIColor*)markColor;
- (CGSize)hk_boundingRectWithSize:(CGSize)size font:(UIFont*)font  lineSpacing:(CGFloat)lineSpacing;
@end
