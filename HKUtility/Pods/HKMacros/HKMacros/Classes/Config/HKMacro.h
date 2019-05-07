//
//  HKMacro.h
//  HKProject
//
//  Created by 胡锦涛 on 2018/7/26.
//  Copyright © 2018年 胡锦涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include <sys/xattr.h>
#import "MyUUIDManager.h"

#pragma mark-实用宏定义
/** 屏幕宽高 */
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000 // 当前Xcode支持iOS8及以上
#define HK_DEVICE_BOUNDS ([UIScreen mainScreen].bounds)
#define HK_DEVICE_WIDTH ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.width)
#define HK_DEVICE_HEIGHT ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.height)
#define HK_DEVICE_SIZE ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?CGSizeMake([UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale,[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale):[UIScreen mainScreen].bounds.size)
#else
#define HK_DEVICE_BOUNDS ([UIScreen mainScreen].bounds)
#define HK_DEVICE_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define HK_DEVICE_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define HK_DEVICE_SIZE [UIScreen mainScreen].bounds.size
#endif


#define HK_FullWidth          MIN(HK_DEVICE_WIDTH, HK_DEVICE_HEIGHT)            //满屏宽 转屏的时候使用    取小的值
#define HK_FullHeight         MAX(HK_DEVICE_WIDTH, HK_SCREEN_HEIGHT)            //满屏高

#define HKViewX(control) (control.frame.origin.x)
#define HKViewY(control) (control.frame.origin.y)

#define HKViewWidth(view) CGRectGetWidth(view.frame)
#define HKViewHeight(view) CGRectGetHeight(view.frame)

#define HKViewMaxX(view) CGRectGetMaxX(view.frame)
#define HKViewMaxY(view) CGRectGetMaxY(view.frame)

#define HKViewMinX(view) CGRectGetMinX(view.frame)
#define HKViewMinY(view) CGRectGetMinY(view.frame)

#define HKViewMidX(view) CGRectGetMidX(view.frame)
#define HKViewMidY(view) CGRectGetMidY(view.frame)

/** 屏幕(设备)比例 */
#define scale_m(s) s*scale_m
#define scale_s_W   HK_DEVICE_WIDTH/375.0
#define scale_s_H   HK_DEVICE_HEIGHT/667.0

#pragma mark - UDID
/** MyUUID */
#define HK_MyUUID [MyUUIDManager getUUID]
/** UDID */
#define HK_UDID [[[UIDevice currentDevice] identifierForVendor] UUIDString]
/** MD5_UDID */
#define HK_MD5_UDID [UDID md5]

#pragma mark - 数据存储
/** 数据存储 */
#define HKUserDefaults [NSUserDefaults standardUserDefaults]
#define HKObjectForKey(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]
#define HKSetObject(object, key)                                                                                                 \
({                                                                                                                                             \
NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];                                                                          \
[defaults setObject:object forKey:key];                                                                                                    \
[defaults synchronize];                                                                                                                    \
})

/** Cookie */
#define HK_APPCookie [HKUserDefaults objectForKey:@"requestCookie"]
/** 通知 */
#define HKNotiCenter   [NSNotificationCenter defaultCenter]
/** Window */
#define HKMainWindow [(AppDelegate *)[UIApplication sharedApplication].delegate window]
#define HKKeyWindow  [[UIApplication sharedApplication] keyWindow]
#define HKFirstWindow [UIApplication sharedApplication].windows.firstObject
#define HKRootViewController HKFirstWindow.rootViewController
#define HKMainDelegate  ((AppDelegate *)[UIApplication sharedApplication].delegate)

#pragma mark-路径相关

/** FileManager */
#define HKFileManager  [NSFileManager defaultManager]
/** 获取沙盒Document路径 */
#define HKDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
/** 获取沙盒temp路径 */
#define HKTempPath NSTemporaryDirectory()
/** 获取沙盒Cache路径 */
#define HKCachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]
/** 判断某个路径是否存在 (BOOL) */
#define HKFileExistsAtPath(path) [[NSFileManager defaultManager] fileExistsAtPath:path]

#pragma mark - App详细信息
/** MainBundle */
#define HKBundle [NSBundle mainBundle]
/** APP版本号 */
#define HKShortVersion [[HKBundle infoDictionary] objectForKey:@"CFBundleShortVersionString"]
/** APP BUILD 版本号 */
#define HKBuildVersion [[HKBundle infoDictionary] objectForKey:@"CFBundleVersion"]
/** APP名字 */
#define HKDisplayName [[HKBundle infoDictionary] objectForKey:@"CFBundleDisplayName"]
/** 工程名(项目名称) */
#define HKProjectName [[HKBundle infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey]
/** 当前语言 */
#define HKLocalLanguage [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode]
/** 当前国家 */
#define HKLocalCountry [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode]

#pragma mark - 设备其他信息
/** 判断是否为iPhone */
#define HKIsIPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
/** 判断是否为iPad */
#define HKIsIPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
/** 设备其他信息 */
#define HKDevice [UIDevice currentDevice]
#define HKDeviceName HKDevice.name                           // 设备名称
#define HKDeviceModel HKDevice.model                         // 设备类型
#define HKDeviceLocalizedModel HKDevice.localizedModel       // 本地化模式
#define HKDeviceSystemName HKDevice.systemName               // 系统名字
#define HKDeviceSystemVersion HKDevice.systemVersion         // 系统版本
#define HKDeviceOrientation HKDevice.orientation             // 设备朝向
//#define HKDeviceUUID HKDevice.identifierForVendor.UUIDString // UUID // 使用苹果不让上传App Store!!!
#define HKiPhone ([HKDeviceModel rangeOfString:@"iPhone"].length > 0)
#define HKIsPod ([HKDeviceModel rangeOfString:@"iPod"].length > 0)
#define HKiPad (HKDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad)

#pragma mark-循环引用

/** 弱引用 */
#define HKWeakSelf __weak typeof(self) weakSelf = self;
#define HKWeak_Self __weak typeof(weakSelf) weak_Self = weakSelf;
/** 强引用 */
#define HKStrongSelf __strong typeof(weakSelf) self = weakSelf;
#define HKStrong_Self  __strong typeof(weak_Self) wSelf = weak_Self;
/** 修饰Self */
#define weak_Self(weakSelf) __weak typeof(self)weakSelf = self;
#define strong_Self(strongSelf) __strong typeof(weakSelf)strongSelf = weakSelf; if (!strongSelf) return;

#pragma mark-字体相关
/***  普通字体 */
#define HKFont(size) [UIFont systemFontOfSize:size]
/***  粗体 */
#define HKBoldFont(size) [UIFont boldSystemFontOfSize:size]
/*** 自定义字体 */
#define HKCustomFont(font) [UIFont fontWithName:@"Oswald" size:font]

#pragma mark-导航相关
/** 手机设备判断 */
/** 适配iPhone XS Max 的高度为896 */
#define HK_IPHONEX  ([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.height == 896)
//#define IPHONEX ((HK_DEVICE_WIDTH == 375) && (HK_SCREEN_HEIGHT == 812))
#define HK_IPHONE4S ((HK_DEVICE_WIDTH == 320) && (HK_SCREEN_HEIGHT == 480))
#define HK_IPHONE5S ((HK_DEVICE_WIDTH == 320) && (HK_SCREEN_HEIGHT == 568))
#define HK_IPHONE6S ((HK_DEVICE_WIDTH == 375) && (HK_SCREEN_HEIGHT == 667))
#define HK_IPHONE6P ((HK_DEVICE_WIDTH == 414) && (HK_SCREEN_HEIGHT == 736))

#define HK_NO_NAV_HEIGHT  (HK_IPHONEX ? 24 : 0)
#define HK_NO_TAB_HEIGHT  (HK_IPHONEX ? 34 : 0)
#define HK_STATUSBAR_HEIGHT (HK_IPHONEX ? 44.f:20.f)
#define HK_NAVBAR_HEIGHT (HK_IPHONEX ? 88.f : 64.f)
#define HK_TABBAR_HEIGHT (HK_IPHONEX ? 49.f+34.f : 49.f)
#define HK_StatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height
#define HK_SafeAreaTopHeight ((HK_SCREEN_HEIGHT >= 812.0) && [[UIDevice currentDevice].model isEqualToString:@"iPhone"] ? 88 : 64)
#define HK_SafeAreaBottomHeight ((HK_SCREEN_HEIGHT >= 812.0) && [[UIDevice currentDevice].model isEqualToString:@"iPhone"]  ? 30 : 0)

#pragma mark-设备型号和系统

/** 检查系统版本 */
#define HKSYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define HKSYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define HKSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define HKSYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define HKSYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

/** iOS系统版本 */
#define HK_Version(a) [[[UIDevice currentDevice]systemVersion] floatValue] == a
#define HK_IOS7_OR_LATER  ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define HK_IOS8_OR_LATER  ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define HK_IOS9_OR_LATER  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#define HK_IOS10_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)
#define HK_IOS11_OR_LATER ([UIDevice currentDevice].systemVersion.floatValue >= 11.0f)
#define HK_IOS12_OR_LATER ([UIDevice currentDevice].systemVersion.floatValue >= 12.0f)

#pragma mark - iOS空数组/对象处理
/** 字符串是否为空 */
#define HK_StringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
/** 数组是否为空 */
#define HK_ArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
/** 字典是否为空 */
#define HK_DictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)
/** 是否是空对象 */
#define HK_ObjectIsEmpty(_object) (_object == nil \|| [_object isKindOfClass:[NSNull class]] \|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

/** 判断是真机还是模拟器 */
#if TARGET_OS_IPHONE
// iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
// iPhone Simulator
#endif

//iOS11适配
#define  HK_AdjustsContentInsets(scrollView)                                                                                                   \
if (IOS11_OR_LATER) {                                                                                                              \
do {                                                                                                                                \
_Pragma("clang diagnostic push")                                                                                                \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")                                                             \
if ([UIScrollView instancesRespondToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {                    \
[scrollView   performSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:") withObject:@(2)];            \
}                                                                                                                               \
_Pragma("clang diagnostic pop")                                                                                                 \
} while (0);                                                                                                                     \
}else {                                                                                                              \
do {                                                                                                                                \
_Pragma("clang diagnostic push")                                                                                                \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")                                                             \
self.automaticallyAdjustsScrollViewInsets = NO;                                                                                                                          \
_Pragma("clang diagnostic pop")                                                                                                 \
} while (0);                                                                                                                     \
}                                                                                                                                      \
\

#define HK_SafeAreaInsets if (@available(iOS 11.0, *)) {self.additionalSafeAreaInsets = UIEdgeInsetsZero;} else {}

#pragma mark---------常用颜色设置------

#define HKHexColor(argb) [[UIColor alloc] initWithRed:((argb&0xFF0000)>>16)/255.0f green:((argb&0xFF00)>>8)/255.0f blue:(argb&0xFF)/255.0f alpha:(argb>>24)/255.0f]
/** color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式 */
#define HKHexString(hex) [HKMacro colorWithHexString:(hex)]
#define HKHexStringAlpha(hex,alpha) [HKMacro colorWithHexString:(hex) alpha:(alpha)]
#define HKRGBA(R,G,B,A) ([UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A])
#define HKRGB(R,G,B) ([UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0])
/** 随机色 */
#define HKRANDOM_COLOR     [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1]

#pragma mark - 其他颜色
/** App主题颜色 */
#define COLOR_MAIN     HKHexColor(0xFF403C3C)
#define HK_WHITECOLOR  HKHexColor(0xFFffffff)
#define HK_COLOR_MIGU  HKHexColor(0xFF55C9C4)

#define HKWhite           [UIColor whiteColor]
#define HKBlack           [UIColor blackColor]
#define HKDarkGray        [UIColor darkGrayColor]
#define HKLightGray       [UIColor lightGrayColor]
#define HKGray            [UIColor grayColor]
#define HKRed             [UIColor redColor]
#define HKGreen           [UIColor greenColor]
#define HKBlue            [UIColor blueColor]
#define HKCyan            [UIColor cyanColor]
#define HKYellow          [UIColor yellowColor]
#define HKMagenta         [UIColor magentaColor]
#define HKOrange          [UIColor orangeColor]
#define HKPurple          [UIColor purpleColor]
#define HKBrown           [UIColor brownColor]
#define HKClear           [UIColor clearColor]
#define HKRandomFlat      [UIColor randomFlatColor]


#pragma mark---------其他------
///判断手机号是否合法
#define HKValidPhoneNum(PhoneNum) \
({\
BOOL result;\
NSString *PhoneNumRegex = @"^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\\d{8}$";\
NSPredicate *PhoneNumTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PhoneNumRegex];\
result=[PhoneNumTest evaluateWithObject:PhoneNum];\
result;\
})

///判断身份证号是否合法
#define HKValidIDNum(idNum) \
({\
BOOL result;\
NSString *idNumRegex = @"(^[1-9]\d{5}(18|19|([23]\d))\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx])|([1−9]\d5\d2((0[1−9])|(10|11|12))(([0−2][1−9])|10|20|30|31)\d2[0−9Xx])";\
NSPredicate *PhoneNumTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", idNumRegex];\
result=[PhoneNumTest evaluateWithObject:idNum];\
result;\
})

///Extern用法
#ifdef __cplusplus
#define HK_EXTERN        extern "C" __attribute__((visibility ("default")))
#else
#define HK_EXTERN            extern __attribute__((visibility ("default")))
#endif

///网络状态:
#define HKNetState [HKUserDefaults valueForKey:@"currentNetworkState"]
/** 快速获取图片 */
#define HKUIImage(imageName) [UIImage imageNamed:imageName]
#define HKBundleImage(source,type) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:source ofType:type]]
///私有库图片加载 格式:kAssignBundleImage(<#imgName#>,<#bundleName#>)
#define HKAssignBundleImage(imgName,bundleName) [UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:[NSString stringWithFormat:@"%@@%zdx.png", imgName,[[NSString stringWithFormat:@"%f",[[UIScreen mainScreen] scale]] integerValue]] ofType:nil inDirectory:bundleName]]
//#define HKAssignBundleImage(imgName,bundleName) [UIImage imageWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:imgName ofType:nil inDirectory:bundleName]]

/** 快速获取NSURL */
#define HKURL(string) [NSURL URLWithString: string]
/** 请求数据写成json */
// #filename -> "filename"
// @#filename -> @"filename"
#define HKAFNWriteToPlist(filename) [responseObject writeToFile:[NSString stringWithFormat:@"/Users/MengYu/Desktop/%@.plist", @#filename] atomically:YES];
/** 清除定时器 */
#define HKClearTimer(t) if(t){[t invalidate];t=nil;}
#pragma mark - 角度与弧度转化
/** 由角度获取弧度 */
#define HKDegreesToRadian(x) (M_PI * (x) / 180.0)
/** 由弧度获取角度 */
#define HKRadianToDegrees(radian) (radian*180.0)/(M_PI)
/** 清除空格 */
#define TRIM(s) [s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]

#pragma mark - 圆角相关
/*圆角相关*/
#define HKROUNDRECT(r) r.origin.x=ceilf(r.origin.x);r.origin.y=ceilf(r.origin.y);r.size.width=ceilf(r.size.width);r.size.height=ceilf(r.size.height);
#define HKROUNDSIZE(s) s.width=ceilf(s.width);s.height=ceilf(s.height);
#define HKROUNDPOINT(p) p.x=ceilf(p.x);p.y=ceilf(p.y);
#define HKROUNDVIEW(v) CALayer *layer=[v layer];[layer setCornerRadius:[v frame].size.width/2];[layer setMasksToBounds:YES];

// View 圆角和加边框
#define HKBorderRadius(View, Radius)\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];]

#pragma mark - 线程相关
/** safe thread(同步) */
#define hk_dispatch_main_sync_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}
/** safe thread(异步) */
#define hk_dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

/** 写入visitor */
#define HKWriteVisitor(visitor)\
({\
NSDictionary *dic = [visitor toDictionary];\
NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];\
[defaults setObject:dic forKey:@"visitor"];\
[defaults synchronize];\
})

#define HKReadVisitor()\
({\
NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];\
NSDictionary *dic = [defaults objectForKey:@"visitor"];\
Visitor *visitor = [[Visitor alloc] initWithDictionary:dic error:nil];\
(visitor);\
})

#pragma mark-ARC-MRC混编

#ifndef RL
#if __has_feature(objc_arc)
#define RL(__o) if(__o){__o=nil;}
#define L(__o) __o=nil;
#else
#define RL(__o) if(__o){[__o release];__o=nil;}
#define L(__o) [__o release];__o=nil;
#endif
#endif

//Block定义
typedef void(^HKBlock)(void);
typedef void(^HKButtonClick)(UIButton *btn);
typedef void(^HKCompleteBlock)(BOOL completed);

//日志输出定义

// 解决调试日志函数调用风险
#ifdef DEBUG //调试
#define NSLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define NSLog(...)
#define debugMethod()
#endif

//XBLog
#ifdef DEBUG
#define XBLog(fmt,...) NSLog((@"%s [Line %d] " fmt),__PRETTY_FUNCTION__,__LINE__,##__VA_ARGS__)
#else
#define XBLog(...)
#endif

#ifdef DEBUG
//调试状态
#define HK_String [NSString stringWithFormat:@"%s", __FILE__].lastPathComponent
#define HKLog(...) printf("%s: %s 第%d行: %s\n\n",[[HKMacro currentDate] UTF8String], [HK_String UTF8String] ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);

#else
//发布状态
#define HKLog(...)
#endif

#define BLOCK_EXEC(block, ...) if (block) { block(__VA_ARGS__); };

#ifdef DEBUG
#define debugLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define debugLog(...)
#define debugMethod()
#endif

@interface HKMacro : NSObject
//获取当前时间
+ (NSString *)currentDate;
+ (UIColor *)colorWithRGBHex:(UInt32)hex;
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;//带透明度
//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHexString:(NSString *)color;
@end
