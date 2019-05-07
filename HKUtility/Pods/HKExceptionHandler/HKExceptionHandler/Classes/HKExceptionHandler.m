//
//  HKExceptionHandler.m
//  ZYExceptionDemo
//
//  Created by 胡锦涛 on 2018/7/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HKExceptionHandler.h"
#import <UIKit/UIKit.h>
#include <libkern/OSAtomic.h>
#include <execinfo.h>

//APP 名字
#define HKAppName [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
//APP build版本
#define HKAppBundleVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
//APP版本号
#define HKAppShortVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
@implementation HKExceptionHandler
+ (void)caughtExceptionHandler{
    //指定crash的处理方法。
    NSSetUncaughtExceptionHandler(& UncaughtExceptionHandler);
}
void UncaughtExceptionHandler(NSException *exception) {
    /**
     *  获取异常崩溃信息
     */
    //在这里创建一个接收crash的文件
    [HKExceptionHandler fileCreate];
    // 可以通过exception对象获取一些崩溃信息，我们就是通过这些崩溃信息来进行解析的，例如下面的symbols数组就是我们的崩溃堆栈。
    NSArray  *callStack = [exception callStackSymbols];
    
    NSString *reason = [exception reason];
    
    NSString *name = [exception name];
    
    NSString *dateString = getCurrentSysTime();
    
    NSString *systemName = [[UIDevice currentDevice] systemName];//系统
    
    NSString *deviceModel = [[UIDevice currentDevice] model];//设备
    
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    
    NSString *bundleIdentifier = infoDict[@"CFBundleIdentifier"];
    
    NSString* versionNum = [infoDict objectForKey:@"CFBundleShortVersionString"];
    
    NSMutableString *systemNameVersion = [[NSMutableString alloc] initWithFormat:@"%@ %@",[[UIDevice currentDevice] systemName],[[UIDevice currentDevice] systemVersion]];//手机系统版本
    //NSString *content = [NSString stringWithFormat:@"%@%@",callStack,systemNameVersion];
    NSString *content = [NSString stringWithFormat:@"\n\n\n========异常错误报告========\n错误时间:%@ 系统：%@ 设备:%@ 手机系统版本：%@ \n当前版本:%@ 当前唯一标示符:%@\n\n错误名称:%@\n错误原因:\n%@\ncallStackSymbols:\n%@\n\n========异常错误结束========\n",dateString,systemName,deviceModel,systemNameVersion,versionNum,bundleIdentifier,name,reason,[callStack componentsJoinedByString:@"\n"]];
    NSString *path = [HKExceptionHandler exceptionPath];
    
    NSFileHandle *outFile = [NSFileHandle fileHandleForWritingAtPath:path];
    
    //找到并定位到outFile的末尾位置(在此后追加文件)
    [outFile seekToEndOfFile];
    
    [outFile writeData:[content dataUsingEncoding:NSUTF8StringEncoding]];
    
    readFile(path);
    //关闭读写文件
    [outFile closeFile];
    
    //除了可以选择写到应用下的某个文件，通过后续处理将信息发送到服务器等
    //还可以选择调用发送邮件的的程序，发送信息到指定的邮件地址
    NSMutableString *mailUrl = [[NSMutableString alloc]init];
    //添加收件人
    NSArray *toRecipients = [NSArray arrayWithObject: @"Report@smanos.com"];
    [mailUrl appendFormat:@"mailto:%@", [toRecipients componentsJoinedByString:@","]];
    //添加抄送
    NSArray *ccRecipients = [NSArray arrayWithObjects:@"",nil];
    [mailUrl appendFormat:@"?cc=%@", [ccRecipients componentsJoinedByString:@","]];
    //添加密送
    NSArray *bccRecipients = [NSArray arrayWithObjects:@"", nil];
    [mailUrl appendFormat:@"&bcc=%@", [bccRecipients componentsJoinedByString:@","]];
    [mailUrl appendString:@"&subject=崩溃日志"];
    //添加邮件内容
    [mailUrl appendString:[NSString stringWithFormat:@"&body=%@", content]];
    NSString* email = [mailUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //#ifdef _DEBUG_LOG_
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:email]]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:email] options:@{} completionHandler:nil];
            } else {
                [[UIApplication sharedApplication] openURL: [NSURL URLWithString:email]];
            }
        });
    }
    //#endif
    //或者调用某个处理程序来处理这个信息
}
//读取文件
void readFile(NSString *path){
    NSLog(@"path%@",path);
    NSData * data = [NSData dataWithContentsOfFile:path];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"readFile读取的内容是：\n%@", str);
}
//创建文件
+ (void)fileCreate{
    NSString *path = [HKExceptionHandler exceptionPath];
    NSFileManager *manager =[NSFileManager defaultManager];
    //文件不存在时创建
    if (![manager fileExistsAtPath:path])
    {
        NSString *dateString = getCurrentSysTime();
        NSString *logStr = [NSString stringWithFormat:@"================\n文件创建时间：%@\n================",dateString];
        NSData *data = [logStr dataUsingEncoding:NSUTF8StringEncoding];
        
        [data writeToFile:path atomically:YES];
        
    }
}
//获取沙盒路径
NSString *applicationDocumentsDirectory() {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString * documentsDirectory  =[paths objectAtIndex:0];
    return documentsDirectory;
}
//异常路径:
+ (NSString *)exceptionPath{
    NSString *documents = [NSHomeDirectory()stringByAppendingPathComponent:@"Documents"];
    NSString * str = [NSString stringWithFormat:@"%@%@",HKAppName,getCurrentSysTime()];
    NSString *path = [documents stringByAppendingPathComponent:[str stringByAppendingString:@"exceptionHandler.txt"]];
    return path;
}
//获取当前时间
NSString *getCurrentSysTime()
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd HH:mm:ss"];
    NSString *strTime = [NSString stringWithFormat:@"%@", [formatter stringFromDate:date]];
    return strTime;
}
//获取调用堆栈
+ (NSArray *)backtrace
{
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack,frames);
    
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (int i=0;i<frames;i++)
    {
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    
    return backtrace;
}
//删除错误日志：
+(void)deleteAllLogs {
    NSString * homeDir = NSHomeDirectory();
    NSString * errorLogPath = [[NSString alloc] initWithFormat:@"%@/Documents", homeDir];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtPath:errorLogPath];
    NSString *filename;
    while (filename=[enumerator nextObject]) {
        [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@", errorLogPath, filename] error:nil];
    }
}
+ (NSUncaughtExceptionHandler*)getHandler

{
    return NSGetUncaughtExceptionHandler();
}
@end
