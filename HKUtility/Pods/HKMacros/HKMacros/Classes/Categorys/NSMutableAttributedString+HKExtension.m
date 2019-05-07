//
//  NSMutableAttributedString+HKExtension.m
//  HKProject
//
//  Created by 胡锦涛 on 2018/8/6.
//  Copyright © 2018年 胡锦涛. All rights reserved.
//

#import "NSMutableAttributedString+HKExtension.h"
#import "HKScale.h"
@implementation NSMutableAttributedString (HKExtension)
///设置可变文字
+ (NSMutableAttributedString *)hk_addMixLabelAttributedStringWithText:(NSString *)accountText withTheLatter:(NSString *)latter withPrefixColor:(UIColor*)prefixColor withSuffixColor:(UIColor*)suffixColor withPrefixFont:(CGFloat)prefixFont withSuffixFont:(CGFloat)suffixFont  {
    if (!latter.length) {
        return nil;
    }
    NSRange range;
    NSMutableAttributedString *attributedString;
    attributedString  = [[NSMutableAttributedString alloc]initWithString:accountText];
    range = [accountText rangeOfString:latter];
    [attributedString addAttribute:NSForegroundColorAttributeName value:prefixColor range:NSMakeRange(0, range.location)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:prefixFont==0 ? 32*scale_m :prefixFont] range:NSMakeRange(0, range.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:suffixColor range:range];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:suffixFont==0 ? 32*scale_m :suffixFont] range:NSMakeRange(range.length, accountText.length-range.length)];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineSpacing = 5*scale_l;
    paragraphStyle.paragraphSpacing = 0;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, accountText.length)];
    return attributedString;
}
///设置可变文字
+ (NSMutableAttributedString *)hk_setAttributedText:(NSString *)attrText attributeFont:(CGFloat)attributeFont markText:(NSString *)markText shadowColor:(UIColor*)shadowColor {
    return [self hk_setAttributedText:attrText attributeFont:attributeFont markText:markText shadowColor:shadowColor markColor:nil];
}
+ (NSMutableAttributedString *)hk_setAttributedText:(NSString *)attrText attributeFont:(CGFloat)attributeFont markText:(NSString *)markText shadowColor:(UIColor*)shadowColor markColor:(UIColor*)markColor{
    
    NSRange range;
    NSMutableAttributedString *attributedString;
    if (!markText.length) {
        range.location = 0;
        range.length = markText.length;
    }else {
        range = [attrText rangeOfString:markText];
    }
    attributedString  = [[NSMutableAttributedString alloc]initWithString:attrText];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:attributeFont] range:NSMakeRange(range.location,range.length)];
    
    if (markColor) {
        [attributedString addAttribute:NSForegroundColorAttributeName value:markColor range:range];
        //attributedString重点备注: 此属性设置后，不能再设置textColor属性，否则，此属性会被覆盖
    }
    
    if (shadowColor) {
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowBlurRadius = 5.0;
        shadow.shadowColor = shadowColor;
        [attributedString addAttribute:NSShadowAttributeName value:shadow range:NSMakeRange(0, attrText.length)];
    }
    return attributedString;
}

- (CGSize)hk_boundingRectWithSize:(CGSize)size font:(UIFont*)font  lineSpacing:(CGFloat)lineSpacing
{
    NSMutableAttributedString *attributeString = self;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.length)];
    [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.length)];
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
    CGRect rect = [attributeString boundingRectWithSize:size options:options context:nil];
    
    //    NSLog(@"size:%@", NSStringFromCGSize(rect.size));
    
    //文本的高度减去字体高度小于等于行间距，判断为当前只有1行
    if ((rect.size.height - font.lineHeight) <= paragraphStyle.lineSpacing) {
//        if ([self containChinese:self]) {  //如果包含中文
            rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height-paragraphStyle.lineSpacing);
//        }
    }
    
    
    return rect.size;
}
@end
