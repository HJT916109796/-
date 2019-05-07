//
//  HKTool.m
//  HKProject
//
//  Created by 胡锦涛 on 2018/8/1.
//  Copyright © 2018年 胡锦涛. All rights reserved.
//

#import "HKTool.h"
#import <CoreLocation/CoreLocation.h>
#import <CommonCrypto/CommonDigest.h>
#include <sys/xattr.h>
#import <Accelerate/Accelerate.h>
#import "zlib.h"
#import "HKMacro.h"
//相册
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
//相机和麦克风
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
//通讯录
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
// 获取iOS内存使用情况
#import <sys/sysctl.h>
#import <mach/mach.h>

static NSString *_cacheDir;
@implementation HKTool
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString * homeDir = NSHomeDirectory();
        _cacheDir = [[NSString alloc] initWithFormat:@"%@/Library/cache", homeDir];
        NSFileManager* fileManager = [NSFileManager defaultManager];
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        __block NSError *error;
        void (^checkDir)(NSString *)=^(NSString *dir){
            if (![fileManager fileExistsAtPath:dir]) {
                BOOL createDirResult = [fileManager createDirectoryAtPath:dir withIntermediateDirectories:NO attributes:nil error:&error];
                if (createDirResult) {
                    setxattr([dir fileSystemRepresentation], attrName, &attrValue, sizeof(attrValue), 0, 0);
                }
            }
        };
        checkDir(_cacheDir);
    }
    return self;
}

+(instancetype)shared {
    static HKTool * tool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[self alloc] init];
    });
    return tool;
}
/// 获取当前设备可用内存(单位：MB）
- (double)availableMemory{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),HOST_VM_INFO,(host_info_t)&vmStats,&infoCount);
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    return ((vm_page_size *vmStats.free_count) / 1024.0) / 1024.0;
    
}

///获取当前任务所占用的内存（单位：MB）
- (double)usedMemory{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),TASK_BASIC_INFO,(task_info_t)&taskInfo,&infoCount);
    if (kernReturn != KERN_SUCCESS) {return NSNotFound;}
    return taskInfo.resident_size / 1024.0 / 1024.0;
    
}


///获取本地JSON并返回字典
+ (id )getLocalJsonFromArrayWithFileName:(NSString*)fileName  {
    //获取json文件保存的路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    //获取指定路径的data文件
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    //获取到json文件的跟数据（字典）
    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    return json;
}

///获取本地JSON并返回数组
+ (NSArray* )getLocalJsonFromArrayWithFileNameFileName:(NSString*)fileName withKey:(NSString*)key  {
    //获取json文件保存的路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    //获取指定路径的data文件
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    //获取到json文件的跟数据（字典）
    NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if ([json valueForKey:key]) {
         NSArray * resultArr = [json valueForKey:key];
        return resultArr;
    }
    return @[];
}
///WebView截取长图
+ (UIImage *)snapshotViewForWebView:(UIWebView*)webView withCapInsets:(UIEdgeInsets)capInsets {
    
    CGFloat scale = [UIScreen mainScreen].scale;
    
    CGSize boundsSize = webView.bounds.size;
    CGFloat boundsWidth = boundsSize.width;
    CGFloat boundsHeight = boundsSize.height;
    CGSize contentSize = webView.scrollView.contentSize;
    CGFloat contentHeight = contentSize.height;
    CGPoint offset = webView.scrollView.contentOffset;
    [webView.scrollView setContentOffset:CGPointMake(0, 0)];
    
    NSMutableArray *images = [NSMutableArray array];
    while (contentHeight > 0) {
        UIGraphicsBeginImageContextWithOptions(boundsSize, NO, [UIScreen mainScreen].scale);
        [webView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [images addObject:image];
        
        CGFloat offsetY = webView.scrollView.contentOffset.y;
        [webView.scrollView setContentOffset:CGPointMake(0, offsetY + boundsHeight)];
        contentHeight -= boundsHeight;
    }
    
    [webView.scrollView setContentOffset:offset];
    CGSize imageSize = CGSizeMake(contentSize.width * scale,
                                  contentSize.height * scale);
    UIGraphicsBeginImageContext(imageSize);
    [images enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL *stop) {
        [image drawInRect:CGRectMake(0,
                                     scale * boundsHeight * idx,
                                     scale * boundsWidth,
                                     scale * boundsHeight)];
    }];
    UIImage *fullImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView * snapshotView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, webView.scrollView.contentSize.width, webView.scrollView.contentSize.height)];
    
    snapshotView.image = [fullImage resizableImageWithCapInsets:capInsets];
    return snapshotView.image;
}

+ (void)addGaussianBlurForImageView:(UIImageView*)bgImageV {
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, bgImageV.frame.size.width, bgImageV.frame.size.height);
    [bgImageV addSubview:effectView];
}

+ (UIImage*)clearSearchImageWithColor:(UIColor*)color andHeight:(CGFloat)height{
    
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    
    UIGraphicsBeginImageContext(r.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

+(int)compareDate:(NSString*)date01 withDate:(NSString*)date02{
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"mm:ss"];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:date01];
    dt2 = [df dateFromString:date02];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //date01比date02小
        case NSOrderedAscending: ci=1; break;
            //date01比date02大
        case NSOrderedDescending: ci=-1; break;
            //date01=date02
        case NSOrderedSame: ci=0; break;
        default: NSLog(@"erorr dates %@, %@", dt2, dt1); break;
    }
    return ci;
}

+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = nil;
    id nextResponder = nil;
    
    if ([window subviews].count) {
        frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    //判断是否有present出来的Controller
    UIViewController *topVC = [self getPresentedViewController];
    
    if ([result isEqual:topVC]) {
        if ([result isKindOfClass:[UITabBarController class]]) {
            return ((UINavigationController *)[(UITabBarController *)result selectedViewController]);
        }
        return result;
    }
    return topVC;
}
+ (UIViewController *)getPresentedViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    topVC = [self presentV:topVC];
    if ([topVC isKindOfClass:[UINavigationController class]]) {
        return [[(UINavigationController *)topVC viewControllers] lastObject];
    }
    return topVC;
}
+ (UIViewController *)presentV:(UIViewController *)v{
    
    if (v.presentedViewController) {
        return [self presentV:v.presentedViewController];
    }
    return v;
}
//文件相关
// 获取文件的大小
+ (CGFloat)getFileSize:(NSString *)path
{
    NSFileManager *fileManager = [[NSFileManager alloc] init] ;
    float filesize = -1.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];//获取文件的属性
        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        filesize = 1.0*size/1024;
    }
    return filesize;
}
+ (void)getDataSize:(NSData*)data {
    NSUInteger sizeM = data.length/1024.f/1024.f;
    NSLog(@"DATA大小为======%lu :M",(unsigned long)sizeM);
}
/// 计算缓存大小
+ (CGFloat)calculateCacheSize {
    CGFloat folderSize = 0.0;
    
    //获取路径
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES)firstObject];
    
    //获取所有文件的数组
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
    
    NSLog(@"文件数：%ld",files.count);
    
    for(NSString *path in files) {
        
        NSString*filePath = [cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@",path]];
        
        //累加
        folderSize += [[NSFileManager defaultManager]attributesOfItemAtPath:filePath error:nil].fileSize;
    }
    //转换为M为单位
    CGFloat sizeM = folderSize /1024.0/1024.0;
    return sizeM;
}
+(void)removeDiskCache {
    //===============清除缓存==============
    //获取路径
    NSString*cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES)objectAtIndex:0];
    //返回路径中的文件数组
    NSArray*files = [[NSFileManager defaultManager]subpathsAtPath:cachePath];
    NSLog(@"文件数：%ld",[files count]);
    for(NSString *p in files){
        NSError*error;
        NSString*path = [cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@",p]];
        if([[NSFileManager defaultManager]fileExistsAtPath:path])
        {
            BOOL isRemove = [[NSFileManager defaultManager]removeItemAtPath:path error:&error];
            if(isRemove) {
                NSLog(@"清除缓存成功");
                //这里发送一个通知给外界，外界接收通知，可以做一些操作（比如UIAlertViewController）
            }else{
                NSLog(@"清除缓存失败");
            }
        }
    }
}

//AVPlayer相关
+(NSURL *)getPlayUrl:(AVPlayer *)player{
    // get current asset
    AVAsset *currentPlayerAsset = player.currentItem.asset;
    // make sure the current asset is an AVURLAsset
    if (![currentPlayerAsset isKindOfClass:AVURLAsset.class]) return nil;
    // return the NSURL
    return [(AVURLAsset *)currentPlayerAsset URL];
}
+ (void)getVideoUrlSize:(NSURL*)videoUrl {
    NSData* videoData = [NSData
                         dataWithContentsOfFile:
                         [[videoUrl absoluteString]
                          stringByReplacingOccurrencesOfString:
                          @"file://"
                          withString:
                          @""]];
    NSUInteger sizeM = videoData.length/1024.f/1024.f;
    NSLog(@"视频大小为======%lu :M",(unsigned long)sizeM);
}
/// 通过videoAsset 读取解析视频帧
+ (void)analysisVideoFramesWithVideoAsset:(AVURLAsset*)videoAsset  maxFrame:(UIView*)parentView completion:(void(^)(NSMutableArray*imgs))completion {
    // 获取总视频的长度 = 总帧数 / 每秒的帧数
    long videoSumTime = videoAsset.duration.value / videoAsset.duration.timescale;
    
    // 创建AVAssetImageGenerator对象
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc]initWithAsset:videoAsset];
    generator.maximumSize = parentView.frame.size;
    generator.appliesPreferredTrackTransform = YES;
    generator.requestedTimeToleranceBefore = kCMTimeZero;
    generator.requestedTimeToleranceAfter = kCMTimeZero;
    
    // 添加需要帧数的时间集合
    int perFrameTime;
    NSMutableArray * framesArray = [NSMutableArray array];
    if (videoSumTime > 15) {
        //大于15秒的视频只截取15帧
        perFrameTime = (int)videoSumTime / 15 ;
    }else{
        perFrameTime = 1;
    }
    for (int i = 0; i < videoSumTime; i+=perFrameTime) {
        CMTime time = CMTimeMake(i *videoAsset.duration.timescale , videoAsset.duration.timescale);
        NSValue *value = [NSValue valueWithCMTime:time];
        [framesArray addObject:value];
    }
    
    NSMutableArray *imgArray = [NSMutableArray array];
    __block long count = 0;
    [generator generateCGImagesAsynchronouslyForTimes:framesArray completionHandler:^(CMTime requestedTime, CGImageRef img, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
        if (result == AVAssetImageGeneratorSucceeded) {
            
            NSLog(@"%ld",count);
            UIImage * image = [UIImage imageWithCGImage:img];
            [imgArray addObject:image];
            count++;
            if (imgArray.count==framesArray.count){
                completion(imgArray);
            }
        }
        
        if (result == AVAssetImageGeneratorFailed) {
            NSLog(@"Failed with error: %@", [error localizedDescription]);
        }
        
        if (result == AVAssetImageGeneratorCancelled) {
            NSLog(@"AVAssetImageGeneratorCancelled");
        }
    }];
}
///通过视频URL解析视频帧
+ (void)analysisVideoFramesWithUrl:(NSURL*)videoUrl  maxFrame:(UIView*)parentView completion:(void(^)(NSMutableArray*imgs))completion {
    
    // 初始化asset对象
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *videoAsset = [[AVURLAsset alloc]initWithURL:videoUrl options:opts];
    // 获取总视频的长度 = 总帧数 / 每秒的帧数
    long long videoSumTime = videoAsset.duration.value / videoAsset.duration.timescale;
    //NSLog(@"videoAsset.duration.value       %lld,  videoAsset.duration.timescale,%d", videoAsset.duration.value, videoAsset.duration.timescale);
    // 创建AVAssetImageGenerator对象
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc]initWithAsset:videoAsset];
    generator.maximumSize = parentView.frame.size;
    generator.appliesPreferredTrackTransform = YES;
    generator.requestedTimeToleranceBefore = kCMTimeZero;
    generator.requestedTimeToleranceAfter = kCMTimeZero;
    // 添加需要帧数的时间集合
    int perFrameTime;
    NSMutableArray * framesArray = [NSMutableArray array];
    if (videoSumTime > 15) {
        //大于15秒的视频只截取15帧
        perFrameTime = (int)videoSumTime / 15 ;
    }else{
        perFrameTime = 1;
    }
    for (int i = 0; i < videoSumTime; i+=perFrameTime) {
        CMTime time = CMTimeMake(i *videoAsset.duration.timescale , videoAsset.duration.timescale);
        NSValue *value = [NSValue valueWithCMTime:time];
        [framesArray addObject:value];
    }
    NSMutableArray *imgArray = [NSMutableArray array];
    __block long count = 0;
    [generator generateCGImagesAsynchronouslyForTimes:framesArray completionHandler:^(CMTime requestedTime, CGImageRef img, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
        if (result == AVAssetImageGeneratorSucceeded) {
            
            NSLog(@"%ld",count);
            UIImage * image = [UIImage imageWithCGImage:img];
            [imgArray addObject:image];
            count++;
            if (imgArray.count==framesArray.count){
                completion(imgArray);
            }
        }
        if (result == AVAssetImageGeneratorFailed) {
            NSLog(@"Failed with error: %@", [error localizedDescription]);
        }
        if (result == AVAssetImageGeneratorCancelled) {
            NSLog(@"AVAssetImageGeneratorCancelled");
        }
    }];
}

//横竖屏：
+ (void)setOrientation:(UIInterfaceOrientation)orientation {
    //UIInterfaceOrientationPortrait
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}
@end
