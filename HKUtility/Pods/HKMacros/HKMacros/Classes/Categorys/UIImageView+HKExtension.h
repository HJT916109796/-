//
//  UIImageView+HKExtension.h
//  HKMacros
//
//  Created by 胡锦涛 on 2019/5/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (HKExtension)
///用户头像非圆形？不用怕，用个mask就行
+ (UIImageView *)hk_maskImageViewWithFrame:(CGRect)frame imageName:(NSString *)image maskImageName:(NSString *)mImage;
@end

NS_ASSUME_NONNULL_END
