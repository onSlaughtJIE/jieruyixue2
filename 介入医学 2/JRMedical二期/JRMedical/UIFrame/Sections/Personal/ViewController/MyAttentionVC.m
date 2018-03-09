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

@interface MyAttentionVC ()

@end

@implementation MyAttentionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的关注";

//    [self.editButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
//    [self.editButtonItem setTitle:@"左滑取消关注"];
//    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 80, 0, 0);
    self.tableView.backgroundColor = BG_Color;
    [self.tableView registerClass:[MyAttentionCell class] forCellReuseIdentifier:NSStringFromClass([MyAttentionCell class])];
    
    [self requestListDataArrray];
}

#pragma mark - 请求数据列表
- (void)requestListDataArrray {
    NSString *url = @"api/Customer/GetCustomerFollowLst";
    NSString *params = @"";
    [self showLoadding:@"正在加载" time:10];
    [self loadDataApi:url withParams:params refresh:RefreshTypeBoth model:MyAttentionModel.class];
}

#pragma mark - nav右按钮
//- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
//    [super setEditing:editing animated:animated];
//    [self.navigationItem setHidesBackButton:editing animated:YES];
//    if (editing) {
//         [self.editButtonItem setTitle:@"完成"];
//    }
//    else {//点击完成按钮
//         [self.editButtonItem setTitle:@"左滑取消关注"];
//    }
//}

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
        NSString *params = [NSString stringWithFormat:@"ZICBDYCCustomerID=%@",model.ConcernedCustomer];
        NSString *url = @"api/Customer/CancelCustomerFollow";
        [self showLoadding:@"" time:10];
        
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
                }
                else{
                    [self showMessage:[NSString stringWithFormat:@"请求失败 #%d",code]];
                }
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
