
//
//  UIImageView+HKLoadImage.m
//  HKUtility
//
//  Created by 胡锦涛 on 2019/3/9.
//  Copyright © 2019 胡锦涛. All rights reserved.
//

#import "UIImageView+HKLoadImage.h"
#import "UIImage+HKExtension.h"
#import <AFNetworkReachabilityManager.h>
#import "SDWebImage.h"
#import <UIImageView+WebCache.h>
#import "HKMacro.h"
@implementation UIImageView (HKLoadImage)
- (void)setImageWithURLStr:(NSString *)url placeholderImage:(UIImage *)placeholderImage
{
    if (placeholderImage == nil) {
        placeholderImage = [UIImage hk_createImageWithColor:HKGray];
    }
    if ([url containsString:@"https"]) {
        [self sd_setImageWithURL:[NSURL URLWithString:url]  placeholderImage:placeholderImage options:SDWebImageAllowInvalidSSLCertificates];
    }else {
        [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholderImage];
    }
    
}
- (void)hk_setOriginImage:(NSString *)originImageURL thumbnailImage:(NSString *)thumbnailImageURL placeholder:(UIImage *)placeholder completed:(SDExternalCompletionBlock)completedBlock
{
    // 根据网络状态来加载图片
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    
    // 获得原图（SDWebImage的图片缓存是用图片的url字符串作为key）
    UIImage *originImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:originImageURL];
    if (originImage) { // 原图已经被下载过
        [self sd_setImageWithURL:[NSURL URLWithString:originImageURL] placeholderImage:placeholder completed:completedBlock];
    } else { // 原图并未下载过
        if (mgr.isReachableViaWiFi) {
            [self sd_setImageWithURL:[NSURL URLWithString:originImageURL] placeholderImage:placeholder completed:completedBlock];
        } else if (mgr.isReachableViaWWAN) {
            // 3G\4G网络下时候要下载原图
            BOOL downloadOriginImageWhen3GOr4G = YES;
            if (downloadOriginImageWhen3GOr4G) {
                [self sd_setImageWithURL:[NSURL URLWithString:originImageURL] placeholderImage:placeholder completed:completedBlock];
            } else {
                [self sd_setImageWithURL:[NSURL URLWithString:thumbnailImageURL] placeholderImage:placeholder completed:completedBlock];
            }
        } else { // 没有可用网络
            UIImage *thumbnailImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:thumbnailImageURL];
            if (thumbnailImage) { // 缩略图已经被下载过
                [self sd_setImageWithURL:[NSURL URLWithString:thumbnailImageURL] placeholderImage:placeholder completed:completedBlock];
            } else { // 没有下载过任何图片
                // 占位图片;
                [self sd_setImageWithURL:nil placeholderImage:placeholder completed:completedBlock];
            }
        }
    }
}

- (void)hk_setHeader:(NSString *)headerUrl placeHolderName:(NSString*)placeHolderName
{
    NSString * imgName = placeHolderName.length > 0 ? placeHolderName : @"defaultUserIcon";
    UIImage *placeholder = [UIImage hk_circleImageNamed:imgName];
    [self sd_setImageWithURL:[NSURL URLWithString:headerUrl] placeholderImage:placeholder options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        // 图片下载失败，直接返回，按照它的默认做法
        if (!image) return;
        self.image = [image hk_circleImage];
    }];
    
}
@end
