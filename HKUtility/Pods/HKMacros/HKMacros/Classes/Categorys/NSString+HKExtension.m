//
//  NSString+HKExtension.m
//  HKProject
//
//  Created by 胡锦涛 on 2018/7/26.
//  Copyright © 2018年 胡锦涛. All rights reserved.
//

#import "NSString+HKExtension.h"

static NSNumberFormatter *formatter;
static NSDateFormatter *dateformatter;

@implementation NSString (HKExtension)

-(NSString*)hkValue {
    return [self hkDValue:@""];
}

-(NSString *)hkDValue:(NSString*)d {
    if (self.length>0 && self) {
        return self;
    }else {
        return d.length ? d : @"";
    }
}
///获取系统当前的时间戳
+ (NSString *)hk_getTimeStamp
{
    //获取系统当前的时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
    // 转为字符型
    return timeString;
}

///获取当前标准时间（例子：2015-02-03 10:43）
+ (NSString *)hk_getStandTime
{
    NSDate * senddate=[NSDate date];
    [dateformatter setDateFormat:@"yyyyMMddHHmmss"];//yyyy-MM-dd HH:mm:ss
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    return locationString;
}

///时间戳，精确到秒
+ (NSString *)hk_miGuTimeStamp {
    NSDate *  senddate=[NSDate date];
    dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"yyyyMMddHHmmssSSS"];//yyyy-MM-dd HH:mm:ss
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    return locationString;
}

///字符串时间戳转日期(不包含生日🎂)
+ (NSString *)hk_replaceTimestamp:(NSString *)timestamp format:(NSString *)dateFormat{
    
    if ([timestamp isKindOfClass:[NSNumber class]]) {
        timestamp = [NSString stringWithFormat:@"%@",timestamp];
    }
    
    if (!timestamp.length) {
        return @"";
    }
    
    int index = 10;
    if ([timestamp hasPrefix:@"-"]) {
        index = 11;
    }
    NSString *t = timestamp.length>index?[timestamp substringToIndex:index]:timestamp;
    NSDate *  senddate = [NSDate dateWithTimeIntervalSince1970:[t doubleValue]];
    [dateformatter setDateFormat:dateFormat];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    return locationString;
}
///字符串时间戳转日期(生日🎂)
+ (NSString *)hk_replaceBirthday:(NSString *)timestamp format:(NSString *)dateFormat{
    
    if ([timestamp isKindOfClass:[NSNumber class]]) {
        timestamp = [NSString stringWithFormat:@"%@",timestamp];
    }
    if (!timestamp.length) {
        return @"";
    }
    NSString *t =[timestamp substringToIndex:timestamp.length-3];
    NSDate *  senddate = [NSDate dateWithTimeIntervalSince1970:[t doubleValue]];
    [dateformatter setDateFormat:dateFormat];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    return locationString;
}

///时间显示内容:时间戳转过去的时间
+(NSString *)hk_getDateDisplayString:(long long) miliSeconds{
    NSTimeInterval tempMilli = miliSeconds;
    NSTimeInterval seconds = tempMilli/1000.0;
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:seconds];
    NSCalendar *calendar = [ NSCalendar currentCalendar ];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear ;
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[ NSDate date ]];
    NSDateComponents *myCmps = [calendar components:unit fromDate:myDate];
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc ] init ];
    //2. 指定日历对象,要去取日期对象的那些部分.
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:myDate];
    if (nowCmps.year != myCmps.year) {
        dateFmt.dateFormat = @"yyyy-MM-dd hh:mm";
    } else {
        if (nowCmps.day==myCmps.day) {
            dateFmt.AMSymbol = @"上午";
            dateFmt.PMSymbol = @"下午";
            dateFmt.dateFormat = @"aaa hh:mm";
        } else if((nowCmps.day-myCmps.day)==1) {
            dateFmt.dateFormat = @"昨天";
        } else {
            if ((nowCmps.day-myCmps.day) <=7) {
                switch (comp.weekday) {
                    case 1: dateFmt.dateFormat = @"星期日"; break;
                    case 2: dateFmt.dateFormat = @"星期一"; break;
                    case 3: dateFmt.dateFormat = @"星期二"; break;
                    case 4: dateFmt.dateFormat = @"星期三"; break;
                    case 5: dateFmt.dateFormat = @"星期四"; break;
                    case 6: dateFmt.dateFormat = @"星期五"; break;
                    case 7: dateFmt.dateFormat = @"星期六"; break;
                    default: break;
                }
            }else {
                dateFmt.dateFormat = @"MM/dd hh:mm";
            }
        }
    }
    return [dateFmt stringFromDate:myDate];
}
+ (NSString *)hk_transformPastTime:(long long )pastTime{
    NSTimeInterval tempMilli = pastTime;
    NSTimeInterval seconds = tempMilli/1000.0;
    NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
    NSTimeInterval distanceTime = now - seconds;
    NSString * distanceStr;
    
    NSDate * beDate = [NSDate dateWithTimeIntervalSince1970:seconds];
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"HH:mm"];
    NSString * timeStr = [df stringFromDate:beDate];
    
    [df setDateFormat:@"dd"];
    NSString * nowDay = [df stringFromDate:[NSDate date]];
    NSString * lastDay = [df stringFromDate:beDate];
    
    NSInteger min = distanceTime/60;
    NSInteger hours = distanceTime/3600;
    NSInteger days = distanceTime/3600/24;
    if (distanceTime < 60) {
        distanceStr = @"刚刚";
    }
    else if (min < 60) {
        distanceStr = [NSString stringWithFormat:@"%ld分钟前",min];
    }
    else if (hours <24) {
        distanceStr = [NSString stringWithFormat:@"%ld小时前",hours];
    }
    else if(days==1 && [nowDay integerValue] != [lastDay integerValue]){
        if ([nowDay integerValue] - [lastDay integerValue] ==1 || ([lastDay integerValue] - [nowDay integerValue] > 10 && [nowDay integerValue] == 1)) {
            distanceStr = [NSString stringWithFormat:@"昨天 %@",timeStr];
        }else{
            [df setDateFormat:@"MM-dd HH:mm"];
            distanceStr = [df stringFromDate:beDate];
        }
    }else if(days==2 && [nowDay integerValue] != [lastDay integerValue]){
        if ([nowDay integerValue] - [lastDay integerValue] ==2) {
            distanceStr = [NSString stringWithFormat:@"昨天 %@",timeStr];
        }else{
            [df setDateFormat:@"MM-dd HH:mm"];
            distanceStr = [df stringFromDate:beDate];
        }
    }else{
        [df setDateFormat:@"yyyy-MM-dd HH:mm"];
        distanceStr = [df stringFromDate:beDate];
    }
    return distanceStr;
}

- (NSString*)hk_specificDate {
    //时间字符串格式 = @"20180807181944";
    if ([self length] > 11) {
        NSString * year = [self substringFromIndex:4];//年
        NSString * format = [year substringToIndex:(year.length -2)];//去掉秒
        NSString * month = [format substringToIndex:2];
        NSString * day = [format substringWithRange:NSMakeRange(month.length, 2)];
        NSString * hour = [format substringWithRange:NSMakeRange(4, 2)];
        NSString * min = [format substringFromIndex:6];
        return [NSString stringWithFormat:@"%@/%@ %@:%@",month,day,hour,min];
    }else {
        return @"未知";
    }
}

+ (NSString *)hk_uuid {
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];
    CFRelease(uuid_ref);
    CFRelease(uuid_string_ref);
    return [[uuid lowercaseString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
}
///时间转换时分秒
+ (NSString *)hk_convert:(CGFloat)time{
    int minute = time / 60;
    int second = time - minute * 60;
    NSString *minuteString;
    NSString *secondString;
    if(minute < 10){
        minuteString = [NSString stringWithFormat:@"0%d", minute];
    }else{
        minuteString = [NSString stringWithFormat:@"%d", minute];
    }
    if(second < 10){
        secondString = [NSString stringWithFormat:@"0%d", second];
    }else{
        secondString = [NSString stringWithFormat:@"%d", second];
    }
    return [NSString stringWithFormat:@"%@:%@", minuteString, secondString];
}
///设置日期显示格式：yyyy-MM 2018-08-09
+ (NSString*)hk_formatMonthDate:(NSDate *)date
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    return [formatter stringFromDate:date];
}

+ (NSString *)hk_removeFloatAllZero:(float)price
{
    NSString * outNumber = [NSString stringWithFormat:@"%@",@(price)];
    //    价格格式化显示
    formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    NSString *formatterString = [formatter stringFromNumber:[NSNumber numberWithFloat:[outNumber doubleValue]]];
    NSRange range = [formatterString rangeOfString:@"."]; //现获取要截取的字符串位置
    //NSLog(@"--------%lu",(unsigned long)range.length);
    if (range.length>0) {
        
        NSString * result = [formatterString substringFromIndex:range.location]; //截取字符串
        if (result.length>=4) {
            formatterString=[formatterString substringToIndex:formatterString.length-1];
        }
    }
    //NSLog(@"Formatted number string:%@",formatterString);
    return formatterString;
}

//URL 中有中文编码：
- (NSString*)hk_encodeValue
{
    NSCharacterSet *encode_set= [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *urlString_encode = [self stringByAddingPercentEncodingWithAllowedCharacters:encode_set];
    return urlString_encode;
}

//编码  URLEncodedString
-(NSString *)hk_URLEncodedString
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)self,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    NSString *result = [encodedString stringByRemovingPercentEncoding];
    return result;
#pragma clang diagnostic pop
    
}
//解码  URLDecodedString
-(NSString *)hk_URLDecodedString
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)self, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    decodedString =  [decodedString stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    return decodedString;
#pragma clang diagnostic pop
    
}
- (CGFloat)hk_getTextWidthWithFont:(UIFont *)font {
    return ceilf([self sizeWithAttributes:@{NSFontAttributeName:font}].width);
}
- (CGFloat)hk_widthForFont:(UIFont *)font {
    CGSize size = [self hk_sizeForFont:font size:CGSizeMake(HUGE, HUGE) mode:NSLineBreakByWordWrapping];
    return size.width;
}

- (CGFloat)hk_heightForFont:(UIFont *)font width:(CGFloat)width {
    CGSize size = [self hk_sizeForFont:font size:CGSizeMake(width, HUGE) mode:NSLineBreakByWordWrapping];
    return size.height;
}

- (CGSize)hk_sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode {
    CGSize result;
    if (!font) font = [UIFont systemFontOfSize:12];
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableDictionary *attr = [NSMutableDictionary new];
        attr[NSFontAttributeName] = font;
        if (lineBreakMode != NSLineBreakByWordWrapping) {
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineBreakMode = lineBreakMode;
            attr[NSParagraphStyleAttributeName] = paragraphStyle;
        }
        CGRect rect = [self boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:attr context:nil];
        result = rect.size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        result = [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
    return result;
}
/**
 * 计算文字高度，可以处理计算带行间距的
 */
- (CGSize)hk_boundingRectWithSize:(CGSize)size paragraphStyle:(NSMutableParagraphStyle *)paragraphStyle font:(UIFont*)font
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self];
    [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.length)];
    [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.length)];
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
    CGRect rect = [attributeString boundingRectWithSize:size options:options context:nil];
    
    //    NSLog(@"size:%@", NSStringFromCGSize(rect.size));
    
    //文本的高度减去字体高度小于等于行间距，判断为当前只有1行
    if ((rect.size.height - font.lineHeight) <= paragraphStyle.lineSpacing) {
        if ([self hk_containChinese:self]) {  //如果包含中文
            rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height-paragraphStyle.lineSpacing);
        }
    }
    return rect.size;
}

/**
 * 计算文字高度，可以处理计算带行间距的
 */
- (CGSize)hk_boundingRectWithSize:(CGSize)size font:(UIFont*)font  lineSpacing:(CGFloat)lineSpacing
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.length)];
    [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.length)];
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
    CGRect rect = [attributeString boundingRectWithSize:size options:options context:nil];
    
    //    NSLog(@"size:%@", NSStringFromCGSize(rect.size));
    
    //文本的高度减去字体高度小于等于行间距，判断为当前只有1行
    if ((rect.size.height - font.lineHeight) <= paragraphStyle.lineSpacing) {
        if ([self hk_containChinese:self]) {  //如果包含中文
            rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height-paragraphStyle.lineSpacing);
        }
    }
    
    
    return rect.size;
}

/**
 *  计算最大行数文字高度,可以处理计算带行间距的
 */
- (CGFloat)hk_boundingRectWithSize:(CGSize)size font:(UIFont*)font  lineSpacing:(CGFloat)lineSpacing maxLines:(NSInteger)maxLines{
    
    if (maxLines <= 0) {
        return 0;
    }
    
    CGFloat maxHeight = font.lineHeight * maxLines + lineSpacing * (maxLines - 1);
    
    CGSize orginalSize = [self hk_boundingRectWithSize:size font:font lineSpacing:lineSpacing];
    
    if ( orginalSize.height >= maxHeight ) {
        return maxHeight;
    }else{
        return orginalSize.height;
    }
}

/**
 *  计算是否超过一行
 */
- (BOOL)hk_isMoreThanOneLineWithSize:(CGSize)size font:(UIFont *)font lineSpaceing:(CGFloat)lineSpacing{
    
    if ( [self hk_boundingRectWithSize:size font:font lineSpacing:lineSpacing].height > font.lineHeight  ) {
        return YES;
    }else{
        return NO;
    }
}
- (CGSize)hk_calculateRectWithSize:(CGSize)size andLabel:(UILabel *)label lineSpacing:(CGFloat)space
{
    NSMutableAttributedString *attibutesString = [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle *paraghStyle =[[NSMutableParagraphStyle alloc] init];
    [paraghStyle setLineSpacing:space];
    [attibutesString addAttribute:NSParagraphStyleAttributeName value:paraghStyle range:NSMakeRange(0, self.length)];
    label.attributedText = attibutesString;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    [label setContentMode:UIViewContentModeTop];
    NSDictionary *attribute = @{NSFontAttributeName:label.font,NSParagraphStyleAttributeName:paraghStyle};
    CGSize labelSize = [self boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return labelSize;
}
- (BOOL)hk_containsEmoji {
    return [self hk_containsEmojiForSystemVersion:[UIDevice currentDevice].systemVersion.doubleValue];
}

- (BOOL)hk_containsEmojiForSystemVersion:(double)systemVersion {
    // If detected, it MUST contains emoji; otherwise it MAY not contains emoji.
    static NSMutableCharacterSet *minSet8_3, *minSetOld;
    // If detected, it may contains emoji; otherwise it MUST NOT contains emoji.
    static NSMutableCharacterSet *maxSet;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        minSetOld = [NSMutableCharacterSet new];
        [minSetOld addCharactersInString:@"u2139\u2194\u2195\u2196\u2197\u2198\u2199\u21a9\u21aa\u231a\u231b\u23e9\u23ea\u23eb\u23ec\u23f0\u23f3\u24c2\u25aa\u25ab\u25b6\u25c0\u25fb\u25fc\u25fd\u25fe\u2600\u2601\u260e\u2611\u2614\u2615\u261d\u261d\u263a\u2648\u2649\u264a\u264b\u264c\u264d\u264e\u264f\u2650\u2651\u2652\u2653\u2660\u2663\u2665\u2666\u2668\u267b\u267f\u2693\u26a0\u26a1\u26aa\u26ab\u26bd\u26be\u26c4\u26c5\u26ce\u26d4\u26ea\u26f2\u26f3\u26f5\u26fa\u26fd\u2702\u2705\u2708\u2709\u270a\u270b\u270c\u270c\u270f\u2712\u2714\u2716\u2728\u2733\u2734\u2744\u2747\u274c\u274e\u2753\u2754\u2755\u2757\u2764\u2795\u2796\u2797\u27a1\u27b0\u27bf\u2934\u2935\u2b05\u2b06\u2b07\u2b1b\u2b1c\u2b50\u2b55\u3030\u303d\u3297\u3299\U0001f004\U0001f0cf\U0001f170\U0001f171\U0001f17e\U0001f17f\U0001f18e\U0001f191\U0001f192\U0001f193\U0001f194\U0001f195\U0001f196\U0001f197\U0001f198\U0001f199\U0001f19a\U0001f201\U0001f202\U0001f21a\U0001f22f\U0001f232\U0001f233\U0001f234\U0001f235\U0001f236\U0001f237\U0001f238\U0001f239\U0001f23a\U0001f250\U0001f251\U0001f300\U0001f301\U0001f302\U0001f303\U0001f304\U0001f305\U0001f306\U0001f307\U0001f308\U0001f309\U0001f30a\U0001f30b\U0001f30c\U0001f30d\U0001f30e\U0001f30f\U0001f310\U0001f311\U0001f312\U0001f313\U0001f314\U0001f315\U0001f316\U0001f317\U0001f318\U0001f319\U0001f31a\U0001f31b\U0001f31c\U0001f31d\U0001f31e\U0001f31f\U0001f320\U0001f330\U0001f331\U0001f332\U0001f333\U0001f334\U0001f335\U0001f337\U0001f338\U0001f339\U0001f33a\U0001f33b\U0001f33c\U0001f33d\U0001f33e\U0001f33f\U0001f340\U0001f341\U0001f342\U0001f343\U0001f344\U0001f345\U0001f346\U0001f347\U0001f348\U0001f349\U0001f34a\U0001f34b\U0001f34c\U0001f34d\U0001f34e\U0001f34f\U0001f350\U0001f351\U0001f352\U0001f353\U0001f354\U0001f355\U0001f356\U0001f357\U0001f358\U0001f359\U0001f35a\U0001f35b\U0001f35c\U0001f35d\U0001f35e\U0001f35f\U0001f360\U0001f361\U0001f362\U0001f363\U0001f364\U0001f365\U0001f366\U0001f367\U0001f368\U0001f369\U0001f36a\U0001f36b\U0001f36c\U0001f36d\U0001f36e\U0001f36f\U0001f370\U0001f371\U0001f372\U0001f373\U0001f374\U0001f375\U0001f376\U0001f377\U0001f378\U0001f379\U0001f37a\U0001f37b\U0001f37c\U0001f380\U0001f381\U0001f382\U0001f383\U0001f384\U0001f385\U0001f386\U0001f387\U0001f388\U0001f389\U0001f38a\U0001f38b\U0001f38c\U0001f38d\U0001f38e\U0001f38f\U0001f390\U0001f391\U0001f392\U0001f393\U0001f3a0\U0001f3a1\U0001f3a2\U0001f3a3\U0001f3a4\U0001f3a5\U0001f3a6\U0001f3a7\U0001f3a8\U0001f3a9\U0001f3aa\U0001f3ab\U0001f3ac\U0001f3ad\U0001f3ae\U0001f3af\U0001f3b0\U0001f3b1\U0001f3b2\U0001f3b3\U0001f3b4\U0001f3b5\U0001f3b6\U0001f3b7\U0001f3b8\U0001f3b9\U0001f3ba\U0001f3bb\U0001f3bc\U0001f3bd\U0001f3be\U0001f3bf\U0001f3c0\U0001f3c1\U0001f3c2\U0001f3c3\U0001f3c4\U0001f3c6\U0001f3c7\U0001f3c8\U0001f3c9\U0001f3ca\U0001f3e0\U0001f3e1\U0001f3e2\U0001f3e3\U0001f3e4\U0001f3e5\U0001f3e6\U0001f3e7\U0001f3e8\U0001f3e9\U0001f3ea\U0001f3eb\U0001f3ec\U0001f3ed\U0001f3ee\U0001f3ef\U0001f3f0\U0001f400\U0001f401\U0001f402\U0001f403\U0001f404\U0001f405\U0001f406\U0001f407\U0001f408\U0001f409\U0001f40a\U0001f40b\U0001f40c\U0001f40d\U0001f40e\U0001f40f\U0001f410\U0001f411\U0001f412\U0001f413\U0001f414\U0001f415\U0001f416\U0001f417\U0001f418\U0001f419\U0001f41a\U0001f41b\U0001f41c\U0001f41d\U0001f41e\U0001f41f\U0001f420\U0001f421\U0001f422\U0001f423\U0001f424\U0001f425\U0001f426\U0001f427\U0001f428\U0001f429\U0001f42a\U0001f42b\U0001f42c\U0001f42d\U0001f42e\U0001f42f\U0001f430\U0001f431\U0001f432\U0001f433\U0001f434\U0001f435\U0001f436\U0001f437\U0001f438\U0001f439\U0001f43a\U0001f43b\U0001f43c\U0001f43d\U0001f43e\U0001f440\U0001f442\U0001f443\U0001f444\U0001f445\U0001f446\U0001f447\U0001f448\U0001f449\U0001f44a\U0001f44b\U0001f44c\U0001f44d\U0001f44e\U0001f44f\U0001f450\U0001f451\U0001f452\U0001f453\U0001f454\U0001f455\U0001f456\U0001f457\U0001f458\U0001f459\U0001f45a\U0001f45b\U0001f45c\U0001f45d\U0001f45e\U0001f45f\U0001f460\U0001f461\U0001f462\U0001f463\U0001f464\U0001f465\U0001f466\U0001f467\U0001f468\U0001f469\U0001f46a\U0001f46b\U0001f46c\U0001f46d\U0001f46e\U0001f46f\U0001f470\U0001f471\U0001f472\U0001f473\U0001f474\U0001f475\U0001f476\U0001f477\U0001f478\U0001f479\U0001f47a\U0001f47b\U0001f47c\U0001f47d\U0001f47e\U0001f47f\U0001f480\U0001f481\U0001f482\U0001f483\U0001f484\U0001f485\U0001f486\U0001f487\U0001f488\U0001f489\U0001f48a\U0001f48b\U0001f48c\U0001f48d\U0001f48e\U0001f48f\U0001f490\U0001f491\U0001f492\U0001f493\U0001f494\U0001f495\U0001f496\U0001f497\U0001f498\U0001f499\U0001f49a\U0001f49b\U0001f49c\U0001f49d\U0001f49e\U0001f49f\U0001f4a0\U0001f4a1\U0001f4a2\U0001f4a3\U0001f4a4\U0001f4a5\U0001f4a6\U0001f4a7\U0001f4a8\U0001f4a9\U0001f4aa\U0001f4ab\U0001f4ac\U0001f4ad\U0001f4ae\U0001f4af\U0001f4b0\U0001f4b1\U0001f4b2\U0001f4b3\U0001f4b4\U0001f4b5\U0001f4b6\U0001f4b7\U0001f4b8\U0001f4b9\U0001f4ba\U0001f4bb\U0001f4bc\U0001f4bd\U0001f4be\U0001f4bf\U0001f4c0\U0001f4c1\U0001f4c2\U0001f4c3\U0001f4c4\U0001f4c5\U0001f4c6\U0001f4c7\U0001f4c8\U0001f4c9\U0001f4ca\U0001f4cb\U0001f4cc\U0001f4cd\U0001f4ce\U0001f4cf\U0001f4d0\U0001f4d1\U0001f4d2\U0001f4d3\U0001f4d4\U0001f4d5\U0001f4d6\U0001f4d7\U0001f4d8\U0001f4d9\U0001f4da\U0001f4db\U0001f4dc\U0001f4dd\U0001f4de\U0001f4df\U0001f4e0\U0001f4e1\U0001f4e2\U0001f4e3\U0001f4e4\U0001f4e5\U0001f4e6\U0001f4e7\U0001f4e8\U0001f4e9\U0001f4ea\U0001f4eb\U0001f4ec\U0001f4ed\U0001f4ee\U0001f4ef\U0001f4f0\U0001f4f1\U0001f4f2\U0001f4f3\U0001f4f4\U0001f4f5\U0001f4f6\U0001f4f7\U0001f4f9\U0001f4fa\U0001f4fb\U0001f4fc\U0001f500\U0001f501\U0001f502\U0001f503\U0001f504\U0001f505\U0001f506\U0001f507\U0001f508\U0001f509\U0001f50a\U0001f50b\U0001f50c\U0001f50d\U0001f50e\U0001f50f\U0001f510\U0001f511\U0001f512\U0001f513\U0001f514\U0001f515\U0001f516\U0001f517\U0001f518\U0001f519\U0001f51a\U0001f51b\U0001f51c\U0001f51d\U0001f51e\U0001f51f\U0001f520\U0001f521\U0001f522\U0001f523\U0001f524\U0001f525\U0001f526\U0001f527\U0001f528\U0001f529\U0001f52a\U0001f52b\U0001f52c\U0001f52d\U0001f52e\U0001f52f\U0001f530\U0001f531\U0001f532\U0001f533\U0001f534\U0001f535\U0001f536\U0001f537\U0001f538\U0001f539\U0001f53a\U0001f53b\U0001f53c\U0001f53d\U0001f550\U0001f551\U0001f552\U0001f553\U0001f554\U0001f555\U0001f556\U0001f557\U0001f558\U0001f559\U0001f55a\U0001f55b\U0001f55c\U0001f55d\U0001f55e\U0001f55f\U0001f560\U0001f561\U0001f562\U0001f563\U0001f564\U0001f565\U0001f566\U0001f567\U0001f5fb\U0001f5fc\U0001f5fd\U0001f5fe\U0001f5ff\U0001f600\U0001f601\U0001f602\U0001f603\U0001f604\U0001f605\U0001f606\U0001f607\U0001f608\U0001f609\U0001f60a\U0001f60b\U0001f60c\U0001f60d\U0001f60e\U0001f60f\U0001f610\U0001f611\U0001f612\U0001f613\U0001f614\U0001f615\U0001f616\U0001f617\U0001f618\U0001f619\U0001f61a\U0001f61b\U0001f61c\U0001f61d\U0001f61e\U0001f61f\U0001f620\U0001f621\U0001f622\U0001f623\U0001f624\U0001f625\U0001f626\U0001f627\U0001f628\U0001f629\U0001f62a\U0001f62b\U0001f62c\U0001f62d\U0001f62e\U0001f62f\U0001f630\U0001f631\U0001f632\U0001f633\U0001f634\U0001f635\U0001f636\U0001f637\U0001f638\U0001f639\U0001f63a\U0001f63b\U0001f63c\U0001f63d\U0001f63e\U0001f63f\U0001f640\U0001f645\U0001f646\U0001f647\U0001f648\U0001f649\U0001f64a\U0001f64b\U0001f64c\U0001f64d\U0001f64e\U0001f64f\U0001f680\U0001f681\U0001f682\U0001f683\U0001f684\U0001f685\U0001f686\U0001f687\U0001f688\U0001f689\U0001f68a\U0001f68b\U0001f68c\U0001f68d\U0001f68e\U0001f68f\U0001f690\U0001f691\U0001f692\U0001f693\U0001f694\U0001f695\U0001f696\U0001f697\U0001f698\U0001f699\U0001f69a\U0001f69b\U0001f69c\U0001f69d\U0001f69e\U0001f69f\U0001f6a0\U0001f6a1\U0001f6a2\U0001f6a3\U0001f6a4\U0001f6a5\U0001f6a6\U0001f6a7\U0001f6a8\U0001f6a9\U0001f6aa\U0001f6ab\U0001f6ac\U0001f6ad\U0001f6ae\U0001f6af\U0001f6b0\U0001f6b1\U0001f6b2\U0001f6b3\U0001f6b4\U0001f6b5\U0001f6b6\U0001f6b7\U0001f6b8\U0001f6b9\U0001f6ba\U0001f6bb\U0001f6bc\U0001f6bd\U0001f6be\U0001f6bf\U0001f6c0\U0001f6c1\U0001f6c2\U0001f6c3\U0001f6c4\U0001f6c5"];
        
        maxSet = minSetOld.mutableCopy;
        [maxSet addCharactersInRange:NSMakeRange(0x20e3, 1)]; // Combining Enclosing Keycap (multi-face emoji)
        [maxSet addCharactersInRange:NSMakeRange(0xfe0f, 1)]; // Variation Selector
        [maxSet addCharactersInRange:NSMakeRange(0x1f1e6, 26)]; // Regional Indicator Symbol Letter
        
        minSet8_3 = minSetOld.mutableCopy;
        [minSet8_3 addCharactersInRange:NSMakeRange(0x1f3fb, 5)]; // Color of skin
    });
    
    // 1. Most of string does not contains emoji, so test the maximum range of charset first.
    if ([self rangeOfCharacterFromSet:maxSet].location == NSNotFound) return NO;
    
    // 2. If the emoji can be detected by the minimum charset, return 'YES' directly.
    if ([self rangeOfCharacterFromSet:((systemVersion < 8.3) ? minSetOld : minSet8_3)].location != NSNotFound) return YES;
    
    // 3. The string contains some characters which may compose an emoji, but cannot detected with charset.
    // Use a regular expression to detect the emoji. It's slower than using charset.
    static NSRegularExpression *regexOld, *regex8_3, *regex9_0;
    static dispatch_once_t onceTokenRegex;
    dispatch_once(&onceTokenRegex, ^{
        regexOld = [NSRegularExpression regularExpressionWithPattern:@"(©️|®️|™️|〰️|🇨🇳|🇩🇪|🇪🇸|🇫🇷|🇬🇧|🇮🇹|🇯🇵|🇰🇷|🇷🇺|🇺🇸)" options:kNilOptions error:nil];
        regex8_3 = [NSRegularExpression regularExpressionWithPattern:@"(©️|®️|™️|〰️|🇦🇺|🇦🇹|🇧🇪|🇧🇷|🇨🇦|🇨🇱|🇨🇳|🇨🇴|🇩🇰|🇫🇮|🇫🇷|🇩🇪|🇭🇰|🇮🇳|🇮🇩|🇮🇪|🇮🇱|🇮🇹|🇯🇵|🇰🇷|🇲🇴|🇲🇾|🇲🇽|🇳🇱|🇳🇿|🇳🇴|🇵🇭|🇵🇱|🇵🇹|🇵🇷|🇷🇺|🇸🇦|🇸🇬|🇿🇦|🇪🇸|🇸🇪|🇨🇭|🇹🇷|🇬🇧|🇺🇸|🇦🇪|🇻🇳)" options:kNilOptions error:nil];
        regex9_0 = [NSRegularExpression regularExpressionWithPattern:@"(©️|®️|™️|〰️|🇦🇫|🇦🇽|🇦🇱|🇩🇿|🇦🇸|🇦🇩|🇦🇴|🇦🇮|🇦🇶|🇦🇬|🇦🇷|🇦🇲|🇦🇼|🇦🇺|🇦🇹|🇦🇿|🇧🇸|🇧🇭|🇧🇩|🇧🇧|🇧🇾|🇧🇪|🇧🇿|🇧🇯|🇧🇲|🇧🇹|🇧🇴|🇧🇶|🇧🇦|🇧🇼|🇧🇻|🇧🇷|🇮🇴|🇻🇬|🇧🇳|🇧🇬|🇧🇫|🇧🇮|🇰🇭|🇨🇲|🇨🇦|🇨🇻|🇰🇾|🇨🇫|🇹🇩|🇨🇱|🇨🇳|🇨🇽|🇨🇨|🇨🇴|🇰🇲|🇨🇬|🇨🇩|🇨🇰|🇨🇷|🇨🇮|🇭🇷|🇨🇺|🇨🇼|🇨🇾|🇨🇿|🇩🇰|🇩🇯|🇩🇲|🇩🇴|🇪🇨|🇪🇬|🇸🇻|🇬🇶|🇪🇷|🇪🇪|🇪🇹|🇫🇰|🇫🇴|🇫🇯|🇫🇮|🇫🇷|🇬🇫|🇵🇫|🇹🇫|🇬🇦|🇬🇲|🇬🇪|🇩🇪|🇬🇭|🇬🇮|🇬🇷|🇬🇱|🇬🇩|🇬🇵|🇬🇺|🇬🇹|🇬🇬|🇬🇳|🇬🇼|🇬🇾|🇭🇹|🇭🇲|🇭🇳|🇭🇰|🇭🇺|🇮🇸|🇮🇳|🇮🇩|🇮🇷|🇮🇶|🇮🇪|🇮🇲|🇮🇱|🇮🇹|🇯🇲|🇯🇵|🇯🇪|🇯🇴|🇰🇿|🇰🇪|🇰🇮|🇰🇼|🇰🇬|🇱🇦|🇱🇻|🇱🇧|🇱🇸|🇱🇷|🇱🇾|🇱🇮|🇱🇹|🇱🇺|🇲🇴|🇲🇰|🇲🇬|🇲🇼|🇲🇾|🇲🇻|🇲🇱|🇲🇹|🇲🇭|🇲🇶|🇲🇷|🇲🇺|🇾🇹|🇲🇽|🇫🇲|🇲🇩|🇲🇨|🇲🇳|🇲🇪|🇲🇸|🇲🇦|🇲🇿|🇲🇲|🇳🇦|🇳🇷|🇳🇵|🇳🇱|🇳🇨|🇳🇿|🇳🇮|🇳🇪|🇳🇬|🇳🇺|🇳🇫|🇲🇵|🇰🇵|🇳🇴|🇴🇲|🇵🇰|🇵🇼|🇵🇸|🇵🇦|🇵🇬|🇵🇾|🇵🇪|🇵🇭|🇵🇳|🇵🇱|🇵🇹|🇵🇷|🇶🇦|🇷🇪|🇷🇴|🇷🇺|🇷🇼|🇧🇱|🇸🇭|🇰🇳|🇱🇨|🇲🇫|🇻🇨|🇼🇸|🇸🇲|🇸🇹|🇸🇦|🇸🇳|🇷🇸|🇸🇨|🇸🇱|🇸🇬|🇸🇰|🇸🇮|🇸🇧|🇸🇴|🇿🇦|🇬🇸|🇰🇷|🇸🇸|🇪🇸|🇱🇰|🇸🇩|🇸🇷|🇸🇯|🇸🇿|🇸🇪|🇨🇭|🇸🇾|🇹🇼|🇹🇯|🇹🇿|🇹🇭|🇹🇱|🇹🇬|🇹🇰|🇹🇴|🇹🇹|🇹🇳|🇹🇷|🇹🇲|🇹🇨|🇹🇻|🇺🇬|🇺🇦|🇦🇪|🇬🇧|🇺🇸|🇺🇲|🇻🇮|🇺🇾|🇺🇿|🇻🇺|🇻🇦|🇻🇪|🇻🇳|🇼🇫|🇪🇭|🇾🇪|🇿🇲|🇿🇼)" options:kNilOptions error:nil];
    });
    
    NSRange regexRange = [(systemVersion < 8.3 ? regexOld : systemVersion < 9.0 ? regex8_3 : regex9_0) rangeOfFirstMatchInString:self options:kNilOptions range:NSMakeRange(0, self.length)];
    return regexRange.location != NSNotFound;
}

+ (NSString *)hk_stringWithUUID {
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return (__bridge_transfer NSString *)string;
}
- (NSString *)hk_stringByTrim {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:set];
}
- (BOOL)hk_isNotBlank {
    NSCharacterSet *blank = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSInteger i = 0; i < self.length; ++i) {
        unichar c = [self characterAtIndex:i];
        if (![blank characterIsMember:c]) {
            return YES;
        }
    }
    return NO;
}
- (BOOL)hk_isNull{
    if (self == nil || self == NULL) {
        return YES;
    }
    if ([self isKindOfClass:[NSNull class]]) {
        return YES;
    }
    NSString *str = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (str.length == 0) {
        return YES;
    }
    if ([self isEqualToString:@"(null)"] || [self isEqualToString:@"null"]) {
        return YES;
    }
    return NO;
}

///字符串是否是URL
- (BOOL)hk_IsURL {
    
    NSError *error;
    //可以识别url的正则表达式
    NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:self options:0 range:NSMakeRange(0, [self length])];
    NSMutableArray *linksArr=[[NSMutableArray alloc]init];
    
    for (NSTextCheckingResult *match in arrayOfAllMatches)
    {
        NSString* substringForMatch;
        substringForMatch = [self substringWithRange:match.range];
        [linksArr addObject:substringForMatch];
    }
    
    return linksArr.count > 0;
}

///字符串中最后一个链接(前提必须是链接字符串)
- (NSString *)hk_LastLink {
    NSError *error;
    //可以识别url的正则表达式
    NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:self options:0 range:NSMakeRange(0, [self length])];
    NSMutableArray *linksArr=[[NSMutableArray alloc]init];
    
    for (NSTextCheckingResult *match in arrayOfAllMatches)
    {
        NSString* substringForMatch;
        substringForMatch = [self substringWithRange:match.range];
        [linksArr addObject:substringForMatch];
    }
    if (linksArr.count > 0) {
        return [linksArr lastObject];
    }
    return @"" ;
}

- (BOOL)hk_containsString:(NSString *)string {
    if (string == nil) return NO;
    return [self rangeOfString:string].location != NSNotFound;
}

- (BOOL)hk_containsCharacterSet:(NSCharacterSet *)set {
    if (set == nil) return NO;
    return [self rangeOfCharacterFromSet:set].location != NSNotFound;
}

- (NSRange)hk_rangeOfAll {
    return NSMakeRange(0, self.length);
}

#pragma mark---------年月日------
-(NSString *)hk_yearStr {
    return [self hk_formattime:self withFormatType:HKDateType_Year];
    return nil;
}
-(NSString *)hk_monthStr {
    return [self hk_formattime:self withFormatType:HKDateType_MonthDay];
    return nil;
}
-(NSString *)hk_hourStr {
    return [self hk_formattime:self withFormatType:HKDateType_Hour];
    return nil;
}
-(NSString *)hk_minStr {
    return [self hk_formattime:self withFormatType:HKDateType_Min];
    return nil;
}
- (NSString *)hk_formattime:(NSString *)str withFormatType:(HKDateType)type
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    switch (type) {
        case HKDateType_Year: {
            [dateFormatter setDateFormat:@"yyyy年"];
            break;
        }
        case HKDateType_MonthDay: {
            [dateFormatter setDateFormat:@"MM月dd日"];
            break;
        }
        case HKDateType_Hour: {
            [dateFormatter setDateFormat:@"HH:mm:ss"];
            break;
        }
        case HKDateType_Min: {
            [dateFormatter setDateFormat:@"HH:mm"];
            break;
        }
        default: {
            break;
        }
    }
    NSString *currentDateStr = [dateFormatter stringFromDate:[self hk_convertDateFromString:str]];
    return currentDateStr;
}

- (NSDate*) hk_convertDateFromString:(NSString*)uiDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *date=[formatter dateFromString:uiDate];
    return date;
}

//判断是否包含中文
- (BOOL)hk_containChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){
            return YES;
        }
    }
    return NO;
}

//截取字符串方法封装
- (NSString *)hk_subStringFrom:(NSString *)startString to:(NSString *)endString {
    
    NSRange startRange = [self rangeOfString:startString];
    NSRange endRange = [self rangeOfString:endString];
    NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
    return [self substringWithRange:range];
}

- (BOOL)hk_isChinese
{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

- (BOOL)hk_isBankCard
{
    if(self.length==0){
        return NO;
    }
    NSString *digitsOnly = @"";
    char c;
    for (int i = 0; i < self.length; i++)    {
        c = [self characterAtIndex:i];
        if (isdigit(c)){
            digitsOnly =[digitsOnly stringByAppendingFormat:@"%c",c];
        }
    }
    int sum = 0;
    int digit = 0;
    int addend = 0;
    BOOL timesTwo = false;
    for (NSInteger i = digitsOnly.length - 1; i >= 0; i--)    {
        digit = [digitsOnly characterAtIndex:i] - '0';
        if (timesTwo){
            addend = digit * 2;
            if (addend > 9) {
                addend -= 9;
            }
        }
        else {
            addend = digit;
        }
        sum += addend;
        timesTwo = !timesTwo;
    }
    int modulus = sum % 10;
    return modulus == 0;
}

-(BOOL)hk_isVideo {
    if ([self containsString:@"mov"]||[self containsString:@"mp4"]) {
        return YES;
    }else {
        return NO;
    }
}

- (BOOL)hk_includeChinese
{
    for(int i=0; i< [self length];i++)
    {
        int a =[self characterAtIndex:i];
        if( a >0x4e00&& a <0x9fff){
            return YES;
        }
    }
    return NO;
}

- (NSString *)hk_formatMdn {
    NSString *phone = self;
    if ([phone hasPrefix:@"+"]) {
        phone = [phone substringFromIndex:3];
    }
    if ([phone containsString:@"-"]) {
        phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    return phone;
}

- (NSString *)hk_safeMdn{
    NSString * resultMdn;
    if (self.length) {
        NSMutableString * phoneStr = self.mutableCopy;
        NSRange tempRange = NSMakeRange(3, 4);
        [phoneStr replaceCharactersInRange:tempRange withString:@"****"];
        resultMdn = [NSString stringWithFormat:@"%@",phoneStr];
    }else {
        resultMdn = @"";
    }
    return resultMdn;
}
/** 为手机号添加空格 */
- (NSString *)hk_addBlankForMdn {
    NSMutableString *phone = [NSMutableString stringWithString:self];
    [phone insertString:@" " atIndex:3];
    [phone insertString:@" " atIndex:8];
    return phone;
}
- (NSString *)hk_filterSpecialCharacter{
    NSString *string = @"";
    string = [self stringByReplacingOccurrencesOfString:@"-"withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" "withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"+86"withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"("withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@")"withString:@""];
    string = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
    if ([string hasPrefix:@"86"]) {
        string = [self substringWithRange:NSMakeRange(2, [self length]-2)];
    }
    return string;
}

/*json字符串转NSDictionary*/
-(id)hk_jsonDictionary {
    if (self == nil) {
        return nil;
    }
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err = nil;
    id dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                             options:NSJSONReadingMutableContainers
                                               error:&err];
    if(err) {
        return nil;
    }
    return dic;
}
///粉丝数显示格式
- (NSString *)hk_fansCount {
    NSString *resultStr = nil;
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:self];
    NSString *devisor;
    NSString *resultUnit = @"";
    NSInteger nfloat = [self integerValue];
    
    if (nfloat/1000<1) {
        devisor = @"1";
        resultUnit = @"";
    }else if (nfloat/10000<1){
        devisor = @"1000";
        resultUnit = @"k";
    }else{
        devisor = @"10000";
        resultUnit = @"w";
    }
    NSDecimalNumber *divisorNumber = [NSDecimalNumber decimalNumberWithString:devisor];
    NSDecimalNumber *resultDec = [decNumber decimalNumberByDividingBy:divisorNumber];
    NSString *tempStr = [NSString stringWithFormat:@"%.2f",[resultDec floatValue]];
    resultStr = [NSString stringWithFormat:@"%@%@",@([tempStr integerValue]),resultUnit];
    return resultStr;
}
- (NSString *)hk_numLibrary{
    NSString *resultStr = nil;
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:self];
    NSString *devisor;
    NSString *resultUnit = @"";
    NSInteger nfloat = [self integerValue];
    
    if (nfloat/1000<1) {
        devisor = @"1";
        resultUnit = @"";
    }else if (nfloat/10000<1){
        devisor = @"1000";
        resultUnit = @"k";
    }else{
        devisor = @"10000";
        resultUnit = @"w";
    }
    NSDecimalNumber *divisorNumber = [NSDecimalNumber decimalNumberWithString:devisor];
    NSDecimalNumber *resultDec = [decNumber decimalNumberByDividingBy:divisorNumber];
    NSString *tempStr = [NSString stringWithFormat:@"%.2f",[resultDec floatValue]];
    resultStr = [NSString stringWithFormat:@"%@%@",@([tempStr integerValue]),resultUnit];
    return resultStr;
}

///价格处理：四舍五入保留一位小数
- (NSString *)hk_priceStr {
    float a = 1412.244019;
    NSLog(@"a is %f", a); //output a is 1412.244019
    a = [[NSString stringWithFormat:@"%.2f", a] floatValue];
    NSLog(@"a is %f", a); //output a is 1412.239990
    //您是否尝试过这个？
    CGFloat val = 37.777779;
    CGFloat rounded_down = floorf(val * 100) / 100; /* Result: 37.77 */
    CGFloat nearest = floorf(val * 100 + 0.5) / 100; /* Result: 37.78 */
    CGFloat rounded_up = ceilf(val * 100) / 100;  /* Result: 37.78 */
    NSLog(@"rounded_down:%.1f\nnearest:%.1f\nrounded_up:%.1f",rounded_down,nearest,rounded_up);
    return [NSString stringWithFormat:@"%f",nearest];
}
/** 处理价格，钱符号是小，钱数是大 */
- (NSMutableAttributedString *)hk_parseMoneyWithLargeFont:(UIFont *)largeFont smallFont:(UIFont *)smallFont {
    if (self.length == 0) {
        return [[NSMutableAttributedString alloc] initWithString:@""];
    }
    //符号
    NSString *symbol = [self substringWithRange:NSMakeRange(0, 1)];
    NSString *number = [self substringWithRange:NSMakeRange(1, self.length - 1)];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:symbol attributes:@{NSFontAttributeName:smallFont}];
    [str appendAttributedString:[[NSMutableAttributedString alloc] initWithString:number attributes:@{NSFontAttributeName:largeFont}]];
    return str;
}

/** 处理价格，整数部分大，小数部分小 */
- (NSMutableAttributedString *)hk_parsePriceWithLargerFont:(UIFont *)largeFont smallFont:(UIFont *)smallFont {
    NSString *roundStr = [NSString stringWithFormat:@"%.2lf",roundf([self floatValue] * 100) / 100.];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[roundStr componentsSeparatedByString:@"."]];
    if (arr.count == 2) {
        NSString *tempStr = arr[1];
        if (tempStr.length < 2) {
            tempStr = [NSString stringWithFormat:@"%@0",tempStr];
            [arr replaceObjectAtIndex:1 withObject:tempStr];
        }else {
            tempStr = [tempStr substringWithRange:NSMakeRange(0, 2)];
            [arr replaceObjectAtIndex:1 withObject:tempStr];
        }
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:arr[0] attributes:@{NSFontAttributeName:largeFont}];
        [str appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"." attributes:@{NSFontAttributeName:largeFont}]];
        NSAttributedString *smallStr = [[NSAttributedString alloc] initWithString:arr[1] attributes:@{NSFontAttributeName:smallFont}];
        [str appendAttributedString:smallStr];
        return str;
    }
    return [[NSMutableAttributedString alloc] initWithString:@""];
}
- (NSString *)hk_formatNumbers{
    NSString *str = [self substringWithRange:NSMakeRange(self.length%3, self.length-self.length%3)];
    NSString *strs = [self substringWithRange:NSMakeRange(0, self.length%3)];
    for (int  i =0; i < str.length; i =i+3) {
        NSString *sss = [str substringWithRange:NSMakeRange(i, 3)];
        strs = [strs stringByAppendingString:[NSString stringWithFormat:@",%@",sss]];
    }
    if ([[strs substringWithRange:NSMakeRange(0, 1)] isEqualToString:@","]) {
        strs = [strs substringWithRange:NSMakeRange(1, strs.length-1)];
    }
    return strs;
}

- (BOOL)hk_isPhoneNum {
    NSString *phone = self;
    BOOL result;
    //判断手机号是否合法
    NSString *PhoneNumRegex = @"^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89]){8}$";
    NSPredicate *PhoneNumTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PhoneNumRegex];
    result=[PhoneNumTest evaluateWithObject:phone];
    if (phone.length == 11 && result) {
        return YES;
    }
    return NO;
}

/**
 * 验证是否是手机号
 */
- (BOOL)hk_checkMdn
{
    if (self&&[self length]) {
        NSPredicate *mdnTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^1[34578]\\d{9}$"];
        return [mdnTest evaluateWithObject:self];
    } else {
        return NO;
    }
}

+ (BOOL)hk_isEmail
{
    if (self) {
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"];
        return [emailTest evaluateWithObject:self];
    } else {
        return NO;
    }
}

+ (BOOL)hk_isValidCode
{
    if (self) {
        NSPredicate *codeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^\\d{4,6}$"];
        return [codeTest evaluateWithObject:self];
    } else {
        return NO;
    }
}

///十进制转十六进制
+(NSString *)hk_ToHex:(int)tmpid
{
    NSString *endtmp=@"";
    NSString *nLetterValue;
    NSString *nStrat;
    int ttmpig=tmpid%16;
    int tmp=tmpid/16;
    switch (ttmpig)
    {
        case 10:
            nLetterValue =@"A";break;
        case 11:
            nLetterValue =@"B";break;
        case 12:
            nLetterValue =@"C";break;
        case 13:
            nLetterValue =@"D";break;
        case 14:
            nLetterValue =@"E";break;
        case 15:
            nLetterValue =@"F";break;
        default:nLetterValue=[[NSString alloc]initWithFormat:@"%i",ttmpig];
            
    }
    switch (tmp)
    {
        case 10:
            nStrat =@"A";break;
        case 11:
            nStrat =@"B";break;
        case 12:
            nStrat =@"C";break;
        case 13:
            nStrat =@"D";break;
        case 14:
            nStrat =@"E";break;
        case 15:
            nStrat =@"F";break;
        default:nStrat=[[NSString alloc]initWithFormat:@"%i",tmp];
            
    }
    endtmp=[[NSString alloc]initWithFormat:@"%@%@",nStrat,nLetterValue];
    return endtmp;
}

//十六进制字符串转 Uint32
- (UInt32)hk_hexUint32{
    
    const char *hexChar = [self cStringUsingEncoding:NSUTF8StringEncoding];
    
    int hexNumber;
    
    sscanf(hexChar, "%x", &hexNumber);
    
    return (UInt32)hexNumber;
}
/*name = xxx & id = xxx 转 字典*/
-(id)hk_DictionaryComponentsSeparatedByString:(NSString *)componentsSeparat{
    
    if (!componentsSeparat) {
        componentsSeparat = @"";
    }
    NSArray *a = [self componentsSeparatedByString:componentsSeparat];
    NSMutableDictionary *dict = @{}.mutableCopy;
    for (NSString *s in a) {
        NSArray *a1 = [s componentsSeparatedByString:@"="];
        [dict setValue:[a1 lastObject] forKey:[a1 firstObject]];
    }
    return dict;
}

@end
