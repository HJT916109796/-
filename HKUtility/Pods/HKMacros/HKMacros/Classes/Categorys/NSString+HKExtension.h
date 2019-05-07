//
//  NSString+HKExtension.h
//  HKProject
//
//  Created by 胡锦涛 on 2018/7/26.
//  Copyright © 2018年 胡锦涛. All rights reserved.
/*
 %@：字符串占位符
 %d:整型
 %ld:长整型
 %f:浮点型
 %c:char类型
 %%：%的占位符
 计算字符串长度：strlen(words[i])
 */

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,HKDateType) {
    HKDateType_Year,
    HKDateType_MonthDay,
    HKDateType_Hour,
    HKDateType_Min,
};

@interface NSString (HKExtension)
//字符串不为空
-(NSString*)hkValue;
-(NSString *)hkDValue:(NSString*)d;

#pragma mark---------时间戳相关------
///获取系统当前的时间戳
+ (NSString *)hk_getTimeStamp;

///获取当前标准时间（例子：2015-02-03 10:43）
+ (NSString *)hk_getStandTime;

///时间戳，精确到秒
+ (NSString *)hk_miGuTimeStamp;

///字符串时间戳转日期(不包含生日🎂)
+ (NSString *)hk_replaceTimestamp:(NSString *)timestamp format:(NSString *)dateFormat;

///字符串时间戳转日期(生日🎂)
+ (NSString *)hk_replaceBirthday:(NSString *)timestamp format:(NSString *)dateFormat;

///时间显示内容:时间戳转过去的时间
+(NSString *)hk_getDateDisplayString:(long long) miliSeconds;

///时间显示内容:时间戳转过去的时间
+ (NSString *)hk_transformPastTime:(long long )pastTime;

///时间戳格式 : @"20180807181944"
- (NSString*)hk_specificDate;

+ (NSString *)hk_uuid;//随机UUID

///时间转换时分秒
+ (NSString *)hk_convert:(CGFloat)time;

///设置日期显示格式：yyyy-MM 2018-08-09
+ (NSString*)hk_formatMonthDate:(NSDate *)date;

/////价格格式化显示
+ (NSString *)hk_removeFloatAllZero:(float)price;

//FIXME:字符串编码
///URL 中有中文编码：
- (NSString*)hk_encodeValue;
//编码  URLEncodedString
-(NSString *)hk_URLEncodedString;
//解码  URLDecodedString
-(NSString *)hk_URLDecodedString;

//计算字符串宽高
- (CGFloat)hk_getTextWidthWithFont:(UIFont *)font;
- (CGFloat)hk_widthForFont:(UIFont *)font;
- (CGFloat)hk_heightForFont:(UIFont *)font width:(CGFloat)width;

/*计算文字高度，可以处理计算带行间距的等属性*/
- (CGSize)hk_boundingRectWithSize:(CGSize)size paragraphStyle:(NSMutableParagraphStyle *)paragraphStyle font:(UIFont*)font;

/*计算文字高度，可以处理计算带行间距的*/
- (CGSize)hk_boundingRectWithSize:(CGSize)size font:(UIFont*)font  lineSpacing:(CGFloat)lineSpacing;

/*计算最大行数文字高度，可以处理计算带行间距的*/
- (CGFloat)hk_boundingRectWithSize:(CGSize)size font:(UIFont*)font  lineSpacing:(CGFloat)lineSpacing maxLines:(NSInteger)maxLines;

/*计算是否超过一行*/
- (BOOL)hk_isMoreThanOneLineWithSize:(CGSize)size font:(UIFont *)font lineSpaceing:(CGFloat)lineSpacing;

/*返回Text实际size*/
- (CGSize)hk_calculateRectWithSize:(CGSize)size andLabel:(UILabel *)label lineSpacing:(CGFloat)space;
#pragma mark - Emoji

/*Whether the receiver contains Apple Emoji (displayed in current version of iOS)*/
- (BOOL)hk_containsEmoji;
- (BOOL)hk_containsEmojiForSystemVersion:(double)systemVersion;

/**
 Returns a new UUID NSString
 e.g. "D1178E50-2A4D-4F1F-9BD3-F6AAB00E06B1"
 */
+ (NSString *)hk_stringWithUUID;

///去除空格
- (NSString *)hk_stringByTrim;

- (BOOL)hk_isNotBlank;

///判断字符串是否为空
- (BOOL)hk_isNull;

///字符串是否是URL
- (BOOL)hk_IsURL;

///字符串中最后一个链接(前提必须是链接字符串)
- (NSString *)hk_LastLink;

/**
 Returns YES if the target string is contained within the receiver.
 */
- (BOOL)hk_containsString:(NSString *)string;

/**
 Returns YES if the target CharacterSet is contained within the receiver.
 */
- (BOOL)hk_containsCharacterSet:(NSCharacterSet *)set;

/**
 Returns NSMakeRange(0, self.length).
 */
- (NSRange)hk_rangeOfAll;

//FIXME:日期，返回年月日字符串

- (NSString *)hk_yearStr;
- (NSString *)hk_monthStr;
- (NSString *)hk_hourStr;
- (NSString *)hk_minStr;

///截取字符串方法封装
- (NSString *)hk_subStringFrom:(NSString *)startString to:(NSString *)endString;

///判断是否是视频格式
- (BOOL)hk_isVideo;

///判断是否是纯汉字
- (BOOL)hk_isChinese;

///是否是银行卡号
- (BOOL)hk_isBankCard;

///判断是否含有汉字
- (BOOL)hk_includeChinese;

///设置正确的手机号格式
- (NSString *)hk_formatMdn;

///手机号加密显示:195****1645
- (NSString *)hk_safeMdn;

///为手机号添加空格
- (NSString *)hk_addBlankForMdn;

///过滤特殊字符
- (NSString *)hk_filterSpecialCharacter;

///粉丝数显示格式
- (NSString *)hk_fansCount;

///号码库显示格式:大于1万，除以1万；小于一万正常显示
- (NSString *)hk_numLibrary;

///价格处理：四舍五入保留一位小数
- (NSString *)hk_priceStr;

///处理价格，钱符号是小，钱数是大
- (NSMutableAttributedString *)hk_parseMoneyWithLargeFont:(UIFont *)largeFont smallFont:(UIFont *)smallFont;

///处理价格，整数部分大，小数部分小
- (NSMutableAttributedString *)hk_parsePriceWithLargerFont:(UIFont *)largeFont smallFont:(UIFont *)smallFont;

///格式化数字显示，添加逗号
- (NSString *)hk_formatNumbers;

//FIME:正则匹配

///验证是否是手机号
- (BOOL)hk_checkMdn;

///判断是否是手机号
- (BOOL)hk_isPhoneNum;

///是否是邮箱
+ (BOOL)hk_isEmail;

///是否是验证码
+ (BOOL)hk_isValidCode;

///十进制转十六进制
+(NSString *)hk_ToHex:(int)tmpid;

//十六进制字符串转 Uint32
- (UInt32)hk_hexUint32;

/*json字符串转NSDictionary*/
-(id)hk_jsonDictionary;

/*name = xxx & id = xxx 转 字典*/
-(id)hk_DictionaryComponentsSeparatedByString:(NSString *)componentsSeparat;

@end
