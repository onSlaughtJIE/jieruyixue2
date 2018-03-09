//
//  MyAttentionVC.m
//  JRMedical
//
//  Created by a on 16/11/11.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "MyAttentionVC.h"

#import "MyAttentionCell.h"
#import "MyAttentionModel.h"
#import "UITableView+EmpayData.h"
#import "ExpertDetailsVC.h"

#import "JRLoginViewController.h"

@interface MyAttentionVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MyAttentionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];

    [self showLoadding:@"正在加载" time:20];
    [self requestListDataArrray];
}

#pragma mark - 请求数据列表
- (void)requestListDataArrray {
    
    NSString *url = @"api/Customer/GetCustomerFollowLst";
    NSString *params = @"";
    
    self.pageSize = 10;//一次加载8条数据
    self.tableType = 1;//TableView表类
    self.baseTableView = self.tableView;//将本类表 赋值给父类去操作
    [self loadDataApi:url withParams:params refresh:RefreshTypeBoth model:MyAttentionModel.class];
}

#pragma mark - Table view datasource and delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataSource == nil) {
        [tableView tableViewDisplayWitMsg:@"" ifNecessaryForRowCount:self.dataSource.count];
    }
    else {
        [tableView tableViewDisplayWitMsg:@"暂无关注信息!" ifNecessaryForRowCount:self.dataSource.count];
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyAttentionModel *model = self.dataSource[indexPath.row];
    MyAttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyAttentionCell class]) forIndexPath:indexPath];
    [cell setModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 78;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001;
}

#pragma mark  点击cell的响应的代理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyAttentionModel *model = self.dataSource[indexPath.row];
    ExpertDetailsVC *edVC = [ExpertDetailsVC new];
    edVC.title = model.CustomerName;
    edVC.model = model;
    [self.navigationController pushViewController:edVC animated:YES];
}

#pragma mark  表的删除代理方法 --- 取消关注
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"取消关注";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // //左滑删除
        MyAttentionModel *model = self.dataSource[indexPath.row];
        NSString *params = [NSString stringWithFormat:@"ZICBDYCCustomerID=%@",model.CustomerID];
        NSString *url = @"api/Customer/CancelCustomerFollow";
        [self showLoadding:@"" time:20];
        
        [BaseNetwork postLoadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
            [self.hud hide:YES];
            NSLog(@"取消关注- %@", modelData);
            if (isSuccess) {
                // //左滑删除
                [self.dataSource removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
            else {
                if (code == 999) {
                    [self showMessage:@"服务器开小差了~请稍后再试"];
                    return ;
                }
                NSString *msg  = [modelData objectForKey:@"Msg"];
                if (msg!=nil && ![msg isEqual:@""]) {
                    [self showMessage:msg];
                    if (code == 3) {
                        
                        [UserInfo removeAccessToken];//移除token
                        [UserInfo removeDevIdentity];//移除单点登录
                        NSUserDf_Set(kNoLogin,JRIsLogin);//修改登录状态
                        NSUserDf_Remove(kDoctor);//移除是否是医师信息
                        [UserInfo removeUserInfo];//移除用户信息
                        EMError *error = [[EMClient sharedClient] logout:YES];
                        if (!error) {
                            NSLog(@"环信退出成功");
                        }
                        NSUserDf_Set(nil, kHXName);
                        NSUserDf_Set(nil, kHXPwd);
                        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5/*延迟执行时间*/ * NSEC_PER_SEC));
                        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                            JRLoginViewController *loginVC = [[JRLoginViewController alloc] init];
                            loginVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                            [self presentViewController:loginVC animated:YES completion:nil];
                        });
                        
                        return ;
                    }
                }
                else{
                    [self showMessage:[NSString stringWithFormat:@"请求失败 #%d",code]];
                }
            }
        }];
    }
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, Width_Screen, Height_Screen-108) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 80, 0, 0);
        _tableView.backgroundColor = BG_Color;
        [_tableView registerClass:[MyAttentionCell class] forCellReuseIdentifier:NSStringFromClass([MyAttentionCell class])];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
