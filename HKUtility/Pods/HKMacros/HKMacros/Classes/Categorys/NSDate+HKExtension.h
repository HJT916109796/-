//
//  NSDate+HKExtension.h
//  HKProject
//
//  Created by 胡锦涛 on 2018/8/14.
//  Copyright © 2018年 胡锦涛. All rights reserved.
//

#import <Foundation/Foundation.h>

#define D_MINUTE      60
#define D_HOUR        3600
#define D_DAY         86400
#define D_WEEK        604800
#define D_YEAR        31556926

@interface NSDate (HKExtension)

///设置过去的时间(几年前)
+ (NSDate *)hk_pastYear:(NSInteger)pastYear;

///获取当前的时间
+ (NSString *)hk_currentDate ;

///按指定格式获取当前的时间
+ (NSString *)currentDateStringWithFormat:(NSString *)formatterStr;

+ (NSCalendar *) hk_currentCalendar;

// Relative dates from the current date
+ (NSDate *) hk_dateTomorrow;
+ (NSDate *) hk_dateYesterday;
+ (NSDate *) hk_dateWithDaysFromNow: (NSInteger) days;
+ (NSDate *) hk_dateWithDaysBeforeNow: (NSInteger) days;
+ (NSDate *) hk_dateWithHoursFromNow: (NSInteger) dHours;
+ (NSDate *) hk_dateWithHoursBeforeNow: (NSInteger) dHours;
+ (NSDate *) hk_dateWithMinutesFromNow: (NSInteger) dMinutes;
+ (NSDate *) hk_dateWithMinutesBeforeNow: (NSInteger) dMinutes;

// Short string utilities
- (NSString *) stringWithDateStyle: (NSDateFormatterStyle) dateStyle timeStyle: (NSDateFormatterStyle) timeStyle;
- (NSString *) stringWithFormat: (NSString *) format;
@property (nonatomic, readonly) NSString *shortString;
@property (nonatomic, readonly) NSString *shortDateString;
@property (nonatomic, readonly) NSString *shortTimeString;
@property (nonatomic, readonly) NSString *mediumString;
@property (nonatomic, readonly) NSString *mediumDateString;
@property (nonatomic, readonly) NSString *mediumTimeString;
@property (nonatomic, readonly) NSString *longString;
@property (nonatomic, readonly) NSString *longDateString;
@property (nonatomic, readonly) NSString *longTimeString;

// Comparing dates
- (BOOL) hk_isEqualToDateIgnoringTime: (NSDate *) aDate;

- (BOOL) hk_isToday;
- (BOOL) hk_isTomorrow;
- (BOOL) hk_isYesterday;

- (BOOL) hk_isSameWeekAsDate: (NSDate *) aDate;
- (BOOL) hk_isThisWeek;
- (BOOL) hk_isNextWeek;
- (BOOL) hk_isLastWeek;

- (BOOL) hk_isSameMonthAsDate: (NSDate *) aDate;
- (BOOL) hk_isThisMonth;
- (BOOL) hk_isNextMonth;
- (BOOL) hk_isLastMonth;

- (BOOL) hk_isSameYearAsDate: (NSDate *) aDate;
- (BOOL) hk_isThisYear;
- (BOOL) hk_isNextYear;
- (BOOL) hk_isLastYear;

- (BOOL) hk_isEarlierThanDate: (NSDate *) aDate;
- (BOOL) hk_isLaterThanDate: (NSDate *) aDate;

- (BOOL) hk_isInFuture;
- (BOOL) hk_isInPast;

// Date roles
/** 是否是工作日 */
- (BOOL) hk_isTypicallyWorkday;
/** 是否是周末 */
- (BOOL) hk_isTypicallyWeekend;

// Decomposing dates
@property (readonly) NSInteger hk_nearestHour;
@property (readonly) NSInteger hk_hour;
@property (readonly) NSInteger hk_minute;
@property (readonly) NSInteger hk_seconds;
@property (readonly) NSInteger hk_day;
@property (readonly) NSInteger hk_month;
@property (readonly) NSInteger hk_week;
@property (readonly) NSInteger hk_weekday;
@property (readonly) NSInteger hk_nthWeekday; // e.g. 2nd Tuesday of the month == 2
@property (readonly) NSInteger hk_year;

@end
