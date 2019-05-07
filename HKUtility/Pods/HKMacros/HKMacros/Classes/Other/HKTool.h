//
//  HKTool.h
//  HKProject
//
//  Created by 胡锦涛 on 2018/8/1.
//  Copyright © 2018年 胡锦涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,NetType) {
    NetType_NONE = 0,//无网络
    NetType_WIFI = 1,//WiFi网络
    NetType_4G = 2,//4G流量
};
@interface HKTool : NSObject

///获取本地JSON并返回字典
+ (id )getLocalJsonFromArrayWithFileName:(NSString*)fileName;

///获取本地JSON并返回数组
+ (NSArray* )getLocalJsonFromArrayWithFileNameFileName:(NSString*)fileName withKey:(NSString*)key;

///WebView截取长图
+ (UIImage *)snapshotViewForWebView:(UIWebView*)webView withCapInsets:(UIEdgeInsets)capInsets;

///为ImgView添加高斯模糊效果
+ (void)addGaussianBlurForImageView:(UIImageView*)bgImageV;

///通过设置颜色去除UISearchBar的灰色背景
+ (UIImage*)clearSearchImageWithColor:(UIColor*)color andHeight:(CGFloat)height;

///时间格式字符串比较大小
+(int)compareDate:(NSString*)date01 withDate:(NSString*)date02;

///获取当前VC
+ (UIViewController *)getCurrentVC;
+ (UIViewController *)getPresentedViewController;

//文件相关
/// 计算缓存大小
// 获取文件的大小
+ (CGFloat)getFileSize:(NSString *)path;
+ (void)getDataSize:(NSData*)data;
+ (CGFloat)calculateCacheSize;
/** 清除磁盘缓存 */
+(void)removeDiskCache;

//AVPlayer相关
//获取正在播放的URL
+(NSURL *)getPlayUrl:(AVPlayer *)player;
//获取视频URL大小
+ (void)getVideoUrlSize:(NSURL*)videoUrl;
/// 通过videoAsset 读取解析视频帧
+ (void)analysisVideoFramesWithVideoAsset:(AVURLAsset*)videoAsset  maxFrame:(UIView*)parentView completion:(void(^)(NSMutableArray*imgs))completion;
///通过视频URL解析视频帧
+ (void)analysisVideoFramesWithUrl:(NSURL*)videoUrl  maxFrame:(UIView*)parentView completion:(void(^)(NSMutableArray*imgs))completion;

//横竖屏：
+ (void)setOrientation:(UIInterfaceOrientation)orientation;

///HKTool单例
+(instancetype)shared;

//MARK:设备相关

///获取当前任务所占用的内存（单位：MB）
- (double)usedMemory;

/// 获取当前设备可用内存(单位：MB）
- (double)availableMemory;

@end
