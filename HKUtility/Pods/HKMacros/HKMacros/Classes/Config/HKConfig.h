//
//  HKConfig.h
//  HKProject
//
//  Created by 胡锦涛 on 2018/7/26.
//  Copyright © 2018年 胡锦涛. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark---------调试相关------

///App启动相关
#define HK_LAUNCH_VIDEO 1

#pragma mark --------------------- 调试相关----------------------
/*
 0 是交付环境  审核账号:账号18868442556  密码:432254
 1 是线上环境
 2 是测试环境
 3 是开发环境
 开发，测试，预交付，预生产，生产
 开发就是开发环境，测试就是我们自己的测试环境，交付就是我们自己的线上环境，预生产就是咪咕的测试环境，生产就是咪咕线上环境
 */
//是否测试环境
#define HK_DEV_STATE          2

#if HK_DEV_STATE == 0
//MARK:交付环境
#define HK_SERVER_URL_PREFIX           @"https://218.207.208.22:5500/api-call-show-ios/"

#elif HK_DEV_STATE == 1
//MARK:线上环境
#define HK_SERVER_URL_PREFIX           @"https://118.31.107.214:5502/api-call-show-ios/"

#elif HK_DEV_STATE == 2
//MARK:测试环境
#define HK_SERVER_URL_PREFIX           @"https://47.98.254.147:5502/api-call-show-ios/"

#else
//MARK:开发环境
#define HK_SERVER_URL_PREFIX           @"https://172.27.36.230:5555/api-call-show-ios/"   //陈慧

#endif

#pragma mark---------请求API相关------

/**
 * 登录
 */
#define HK_SERVER_LOGIN [HK_SERVER_URL_PREFIX stringByAppendingString:@"login"]


#pragma mark---------APPSTORE 相关------
//请求 AppStore版本号
/*
 http://itunes.apple.com/lookup?id= + 你的ID
 上线的时候会给你一个ID 你在iTunes connect里建APP的时候  你的a地址
 get请求就行，你看下它返回给你的结果从中间拿到版本号
 */
//APPStore地址 APPID 958468571
#define HK_APPID @"XXX"
#define HK_BUNDLEID @"XXX"
#define HK_APPSTORE_URL @"itms-apps://itunes.apple.com/cn/app/id958468571?mt=8"
//评分界面
#define HK_APPSTORE_SOTRE_URL @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1030776145"

#pragma mark---------友盟相关------
//UM_APPKEY
#define HU_MENG_APPKEY  @"XXXX"
/*UM微信相关*/
#define HK_WX_APP_ID @"XXX"
#define HK_WX_APP_SCHEME WX_APP_ID
#define HK_WX_APP_SECRET @"XXXX"
/*UMQQ相关*/
#define HK_QQ_APP_ID @"XXX"
#define HK_QQ_APP_SCHEME @"tencent"QQ_APP_ID
#define HK_QQ_APP_SECRET @"XXXX"
/*UM新浪相关*/
#define HK_SINA_APP_ID @"XXX"
#define HK_SINA_APP_SECRET @"XXXX"
#define HK_SINA_APP_REDIRECTURL @"http://app2.xingbook.com/weibo/auth.do"

#pragma mark---------其他------
#define HK_SPLIT @","
#define HK_SERVICE_SPERATOR @"`"
#define HK_APP_SCHEME @"HK"

@interface HKConfig : NSObject
///启动配置项(比例等)
+ (void)launch;
@end
