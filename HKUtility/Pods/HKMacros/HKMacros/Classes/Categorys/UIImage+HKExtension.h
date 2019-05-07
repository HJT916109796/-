//
//  UIImage+HKExtension.h
//  HKProject
//
//  Created by 胡锦涛 on 2018/7/27.
//  Copyright © 2018年 胡锦涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HKExtension)

/*始终保持图片原有的状态，不使用Tint Color渲染*/
+(UIImage *)hk_noRenderingImageName:(NSString *)imageName;

/// 返回一张抗锯齿图片
// 本质：在图片生成一个透明为1的像素边框
- (UIImage *)hk_imageAntialias;

///UIImage切圆角
- (UIImage *)hk_setCornerRadius:(CGFloat)c;
- (UIImage *)hk_circleImage;

+ (UIImage *)hk_circleImageNamed:(NSString *)name;
+ (UIImage*)hk_maskWithShowImage:(UIImage *)sImage maskImage:(UIImage*)mImage;

/** 获取视频缩略图，本地视频，网络视频都可以用 */
+ (UIImage*)hk_thumbnailImageForVideo:(NSURL *)videoURL;

/** UIImage 加载网络图片 */
+ (UIImage*)hk_getImageWithUrl:(NSString*)url;

/** 生成二维码图片：通过设置字符串和size */
+ (UIImage *)hk_creatQRCodeWithString:(NSString *)string size:(CGSize)size;

/*改变图片的主题颜色*/
+(UIImage *)hk_createImageWithColor:(UIColor *)color;
+ (UIImage *)hk_createImageWithColor:(UIColor*)color fromImage:(UIImage*)sourceImage;

/** UIImage图片添加文字水印 */
+ (UIImage *)hk_waterMarkImageName:(NSString *)imgName waterText:(NSString*)content  textPoint:(CGPoint)point attributedString:(NSDictionary * )attributed;

/** UIImage图片添加Logo水印 */
+ (UIImage *)hk_waterMarkImageName:(NSString *)imgName logoImageName:(NSString *)logoImageName logoFrame:(CGRect)logoFrame;

/** 生成一张带有边框的圆形图片 带有边框的图片切圆角 */
+ (UIImage *)hk_imageName:(NSString *)imgName border:(CGFloat)borderW borderColor:(UIColor*)borderColor;

/*返回base64字符串*/
- (NSString *)hk_base64String;
+ (UIImage *)hk_imageWithBase64String:(NSString *)base64Str;

/*修正图片位置*/
- (UIImage *)hk_fixImageOrientation;

/*缩放到指定大小*/
- (UIImage *)hk_resizeImageWithSize:(CGSize)newSize;

/*图片圆形裁剪*/
- (UIImage *)hk_ovalClip;

/*等比例缩放*/
+ (UIImage*)hk_imageCompressWithSimple:(UIImage*)image scale:(float)scale;
///加载组件化私有库图片 name格式:group.png bundleName格式: HKTool.bundle
+ (instancetype)hk_imgWithName:(NSString *)name bundle:(NSString *)bundleName targetClass:(Class)targetClass;
/*Create image*/
+ (UIImage *)hk_imageWithSmallGIFData:(NSData *)data scale:(CGFloat)scale;
+ (UIImage *)hk_imageWithColor:(UIColor *)color;
+ (UIImage *)hk_imageWithColor:(UIColor *)color size:(CGSize)size;
///通过设置颜色去除UISearchBar的灰色背景
+ (UIImage*)hk_getImageWithColor:(UIColor*)color andHeight:(CGFloat)height;

/*图片是否有Alpha通道*/
- (BOOL)hk_hasAlphaChannel;

/*修改旋转后的图片*/
- (UIImage *)hkRotate:(CGFloat)radians fitSize:(BOOL)fitSize;
- (UIImage *)hkRotateLeft90;
- (UIImage *)hkRotateRight90;
- (UIImage *)hkRotate180;

/*垂直翻转图像*/
- (UIImage *)hkFlipVertical;

/*水平翻转图像*/
- (UIImage *)hkFlipHorizontal;

#pragma mark - 图片效果
///创建高斯模糊效果的背景
+(UIImage*)hk_createBlurBackground:(UIImage*)image blurRadius:(CGFloat)blurRadius;
+ (UIImage *)hk_blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;

/**
 Tint the image in alpha channel with the given color..
 */
- (UIImage *)hkTintColor:(UIColor *)color;

/**
 Returns a grayscaled image.
 */
- (UIImage *)hkGrayscale;

/**
 Applies a blur effect to this image. Suitable for blur any content.
 */
- (UIImage *)hkBlurSoft;

/**
 Applies a blur effect to this image. Suitable for blur any content except pure white.
 (same as iOS Control Panel)
 */
- (UIImage *)hkBlurLight;

/**
 Applies a blur effect to this image. Suitable for displaying black text.
 (same as iOS Navigation Bar White)
 */
- (UIImage *)hkBlurExtraLight;

/**
 Applies a blur effect to this image. Suitable for displaying white text.
 (same as iOS Notification Center)
 */
- (UIImage *)hkBlurDark;

@end
