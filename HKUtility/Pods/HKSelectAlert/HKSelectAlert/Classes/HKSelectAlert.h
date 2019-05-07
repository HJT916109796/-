//
//  HKSelectAlert.h
//  HKUtilities
//
//  Created by 胡锦涛 on 2018/11/16.
//  Copyright © 2018 胡锦涛. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HKSelectAlert : UIView
/** 竖直初始化 */
- (instancetype)initWithFrame:(CGRect)frame with:(NSArray *)optionArr selIndex:(NSInteger)index;
- (instancetype)initWithFrame:(CGRect)frame securityWith:(NSArray *)optionArr selIndex:(NSInteger)index;
/** 水平初始化 */
- (instancetype)initWithFrame:(CGRect)frame horizontalWith:(NSArray *)optionArr selIndex:(NSInteger)index;
typedef void(^selectBlock)(NSInteger index ,NSString *title);
@property (nonatomic, copy) selectBlock selectBlock;
@end

NS_ASSUME_NONNULL_END
