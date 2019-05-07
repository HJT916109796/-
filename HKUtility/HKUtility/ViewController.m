//
//  ViewController.m
//  HKUtility
//
//  Created by 胡锦涛 on 2019/3/9.
//  Copyright © 2019 胡锦涛. All rights reserved.
//

#import "ViewController.h"
#import "HKAlertView.h"
#import "HKTransitionTool.h"
#import "HKExceptionHandler.h"
#import "HKMessageBox.h"
#import "HKSelectAlert.h"

//组件化通信
#import "HKOCRouter.h"
#import <HandyFrame/UIView+LayoutMethods.h>
#import "HKOCRouter+HKModuleAActions.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@end
NSString * const kCellIdentifier = @"kCellIdentifier";
@implementation ViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self.tableView fill];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        UIViewController *viewController = [[HKOCRouter sharedInstance] viewControllerForDetail];
        // 获得view controller之后，在这种场景下，到底push还是present，其实是要由使用者决定的，mediator只要给出view controller的实例就好了
        [self presentViewController:viewController animated:YES completion:nil];
    }
    
    if (indexPath.row == 1) {
        UIViewController *viewController =[[HKOCRouter sharedInstance] viewControllerForDetail];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    if (indexPath.row == 2) {
        // 这种场景下，很明显是需要被present的，所以不必返回实例，mediator直接present了
        [HKOCRouter hk_remotePerformWithUrl:@"hk://A/getUserInfo" handler:^(NSDictionary *result) {
            
        }];
    }
    
    if (indexPath.row == 3) {
        // 这种场景下，参数有问题，因此需要在流程中做好处理
    }
    
}

#pragma mark - getters and setters
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    }
    return _tableView;
}

- (NSArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = @[@"present detail view controller",
                        @"push detail view controller",
                        @"present image",
                        ];
    }
    return _dataSource;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    HKSelectAlert *genderAlert = [[HKSelectAlert alloc]initWithFrame:self.view.bounds horizontalWith:@[@"本地相册",@"拍摄"] selIndex:1];
    genderAlert.selectBlock = ^(NSInteger index,NSString *title) {
        if (index==0) {
            //选择本地相册
            
        }else if (index == 1){
            //拍摄
           
        }
    };
    [self.view addSubview:genderAlert];
}

@end
