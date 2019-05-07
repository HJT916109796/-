//
//  UIImageView+HKLoadImage.h
//  HKUtility
//
//  Created by 胡锦涛 on 2019/3/9.
//  Copyright © 2019 胡锦涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>
NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (HKLoadImage)
///加载图片UrlString兼容http和https
- (void)setImageWithURLStr:(NSString *)url placeholderImage:(UIImage *)placeholderImage;

///根据网络状态加载不同的image
- (void)hk_setOriginImage:(NSString *)originImageURL thumbnailImage:(NSString *)thumbnailImageURL placeholder:(UIImage *)placeholder completed:(SDExternalCompletionBlock)completedBlock;

///设置头像-circleImage
- (void)hk_setHeader:(NSString *)headerUrl placeHolderName:(NSString*)placeHolderName;
@end

NS_ASSUME_NONNULL_END
