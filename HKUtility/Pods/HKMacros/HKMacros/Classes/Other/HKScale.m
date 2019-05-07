//
//  HKScale.m
//  HKProject
//
//  Created by 胡锦涛 on 2018/7/26.
//  Copyright © 2018年 胡锦涛. All rights reserved.
//

#import "HKScale.h"
//_pRect竖屏尺寸、_lRect横屏尺寸
static CGRect _vRect,_lRect;
static float _scale_lX;
static float _scale_sX;
static float _scale_mX;

float scale_s    =0.0f;
float uiScale    =0.0f;
float scale_l  =0.0f;
CGFloat scale_lX = 0.0f;
CGFloat scale_lY = 0.0f;
CGFloat scale_sX = 0.0f;
CGFloat scale_sY = 0.0f;
CGFloat scale_m = 0.0f;
CGFloat scale_mX = 0.0f;
CGFloat scale_mY = 0.0f;
@implementation HKScale
+ (HKScale *)shared
{
    static dispatch_once_t  onceToken;
    static HKScale * _sharedInstance;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}
- (id)init {
    
    if (self=[super init]) {

        _lRect = [[UIScreen mainScreen] bounds];
        if (_lRect.size.height>_lRect.size.width) {
            CGFloat temp = _lRect.size.width;
            _lRect.size.width = _lRect.size.height;
            _lRect.size.height = temp;
        }
        _vRect.size.width = _lRect.size.height;
        _vRect.size.height = _lRect.size.width;
        
        _scale_lX = (1080.0/_vRect.size.width);
        scale_l = 1/_scale_lX;
        
        _scale_sX   = (375.0/_vRect.size.width);
        scale_s = 1/_scale_sX;
        
        _scale_mX  = (HK_WIDTH/_vRect.size.width);
        scale_m = 1/_scale_mX;
        
        scale_mX = (HK_WIDTH/_vRect.size.width);
        scale_lX  = (1080.0/_vRect.size.width);
        scale_sX    = (375.0/_vRect.size.width);
        
        scale_mY   = (float)_vRect.size.height/HK_HEIGHT;
        scale_lY = (float) _vRect.size.height / 1920.0;
    }
    return self;
}
+ (CGRect)vRect {
    return _vRect;
}
+ (CGRect)lRect {
    return _lRect;
}
@end
