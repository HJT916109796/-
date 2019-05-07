//
//  HKSelectAlert.m
//  HKUtilities
//
//  Created by 胡锦涛 on 2018/11/16.
//  Copyright © 2018 胡锦涛. All rights reserved.
/*
 //使用案例
 HKSelectAlert *genderAlert = [[HKSelectAlert alloc]initWithFrame:self.view.bounds horizontalWith:@[@"本地相册",@"拍摄"] selIndex:1];
 genderAlert.selectBlock = ^(NSInteger index,NSString *title) {
 if (index==0) {
 //选择本地相册
 [self chooseLocalAlbum];
 }else if (index == 1){
 //拍摄
 [self shootVideo];
 }
 };
 [self.view addSubview:genderAlert];
 */

#import "HKSelectAlert.h"
#import "HKPrefixHeader.h"
#import "Masonry.h"
@interface HKSelectAlert()
@property (nonatomic, strong) UIControl *control;
@property (nonatomic, strong) NSArray *optionArr;
@property (nonatomic, assign) NSInteger index;
@end
@implementation HKSelectAlert
- (instancetype)initWithFrame:(CGRect)frame horizontalWith:(NSArray *)optionArr selIndex:(NSInteger)index{
    if (self = [super initWithFrame:frame]) {
        self.optionArr = optionArr;
        self.index = index;
        [self setupUIWithHorizontalSecurity:NO];
    }
    return self;
}
- (void)setupUIWithHorizontalSecurity:(BOOL)isSecurity{
    self.control = [[UIControl alloc]initWithFrame:self.frame];
    [self addSubview:self.control];
    self.control.backgroundColor = isSecurity ? [HKBlack colorWithAlphaComponent:0.6] : HKHexString(@"#881b1a26");
    [self.control addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *bgView = [[UIView alloc]init];
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(30*scale_m);
        make.bottom.right.equalTo(self).offset(-30*scale_m);
        make.height.mas_equalTo(153*scale_m);
    }];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 24*scale_m;
    bgView.backgroundColor = isSecurity ? HKWhite : HKHexString(@"#f9f7fb");
    
    for (int i = 0;i <self.optionArr.count;i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(65*scale_m +383*i*scale_m,62*scale_m , 160*scale_m, 36*scale_m)];
        btn.tag = 100+i;
        [btn.titleLabel setFont:HKBoldFont(36*scale_m)];
        [bgView addSubview:btn];
        [btn setTitle:self.optionArr[i] forState:UIControlStateNormal];
        if (i == 0) {
            [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        }else {
            [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        }
        [btn setTitleColor:HKHexString(@"#666666") forState:UIControlStateNormal];
        [btn setTitleColor:isSecurity ? HKHexColor(0xff4299FF) : HKHexString(@"#834fac") forState:UIControlStateSelected];
        [btn hk_addTarget:self withAction:@selector(btnClicked:)];
        if (i == self.index) {
            btn.selected = YES;
        }
    }
}
- (instancetype)initWithFrame:(CGRect)frame securityWith:(NSArray *)optionArr selIndex:(NSInteger)index{
    if (self = [super initWithFrame:frame]) {
        self.optionArr = optionArr;
        self.index = index;
        [self setupUIWithSecurity:YES];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame with:(NSArray *)optionArr selIndex:(NSInteger)index{
    if (self = [super initWithFrame:frame]) {
        self.optionArr = optionArr;
        self.index = index;
        [self setupUIWithSecurity:NO];
    }
    return self;
}

- (void)setupUIWithSecurity:(BOOL)isSecurity{
    self.control = [[UIControl alloc]initWithFrame:self.frame];
    [self addSubview:self.control];
    self.control.backgroundColor = isSecurity ? [HKBlack colorWithAlphaComponent:0.6] : HKHexString(@"#881b1a26");
    [self.control addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *bgView = [[UIView alloc]init];
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(30*scale_m);
        make.bottom.right.equalTo(self).offset(-30*scale_m);
        make.height.mas_equalTo(self.optionArr.count*88*scale_m + 2*26*scale_m);
    }];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 24*scale_m;
    bgView.backgroundColor = isSecurity ? HKWhite : HKHexString(@"#f9f7fb");
    
    for (int i = 0;i <self.optionArr.count;i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(40*scale_m, 26*scale_m+88*i*scale_m, HK_DEVICE_WIDTH-60*scale_m, 88*scale_m)];
        
        btn.tag = 100+i;
        [btn.titleLabel setFont:HKBoldFont(36*scale_m)];
        [btn setContentHorizontalAlignment:1];
        [bgView addSubview:btn];
        [btn setTitle:self.optionArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:HKBlack forState:UIControlStateNormal];
        [btn setTitleColor:isSecurity ? HKHexColor(0xff4299FF) : HKHexString(@"#834fac") forState:UIControlStateSelected];
        [btn hk_addTarget:self withAction:@selector(btnClicked:)];
        UIImageView *rightView = [[UIImageView alloc]initWithFrame:CGRectMake(597*scale_m, 44*scale_m, 29*scale_m, 20*scale_m)];
        rightView.image = [HKAssignBundleImage(@"HK_对号", @"HKSelectAlert.bundle") hkTintColor:isSecurity ? HKHexColor(0xff4299FF) : HKHexString(@"#834fac")];
        rightView.hidden = YES;
        [btn addSubview:rightView];
        if (i == self.index) {
            btn.selected = YES;
            rightView.hidden = NO;
        }
    }
}

- (void)btnClicked:(UIButton *)sender{
    if (self.selectBlock) {
        self.selectBlock(sender.tag-100,sender.titleLabel.text);
        [self remove];
    }
}
- (void)remove{
    [self removeFromSuperview];
}
@end
