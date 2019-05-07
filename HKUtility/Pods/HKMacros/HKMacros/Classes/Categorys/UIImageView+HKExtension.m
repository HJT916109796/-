//
//  UIImageView+HKExtension.m
//  HKMacros
//
//  Created by 胡锦涛 on 2019/5/4.
//

#import "UIImageView+HKExtension.h"
#import "UIImage+HKExtension.h"
@implementation UIImageView (HKExtension)
/*
 使用案例
 //五角星⭐️
 UIImageView *imageView1 = [UIImageView hk_maskImageViewWithFrame:CGRectMake((self.view.frame.size.width/2-100)/2, 210, 100, 100) imageName:@"LaunghImage3.png" maskImageName:@"shape_five"];
 imageView1.backgroundColor = [UIColor grayColor];
 [self.view addSubview:imageView1];
 
 //六边形
 UIImageView *imageView2 = [UIImageView hk_maskImageViewWithFrame:CGRectMake((self.view.frame.size.width/2-100)/2+self.view.frame.size.width/2, 210, 100, 100) imageName:@"LaunghImage4.png" maskImageName:@"shape_six"];
 imageView2.backgroundColor = [UIColor grayColor];
 [self.view addSubview:imageView2];
 */
+ (UIImageView *)hk_maskImageViewWithFrame:(CGRect)frame imageName:(NSString *)image maskImageName:(NSString *)mImage
{
    UIImage *maskimage = [UIImage hk_maskWithShowImage:[UIImage imageNamed:image] maskImage:[UIImage imageNamed:mImage]];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:maskimage];
    imageView.frame = frame;
    return imageView;
}

@end
