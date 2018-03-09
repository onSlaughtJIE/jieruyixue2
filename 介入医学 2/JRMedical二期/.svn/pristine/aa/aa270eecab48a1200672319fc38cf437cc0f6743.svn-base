//
//  ExpertPingJiaListVC.m
//  JRMedical
//
//  Created by a on 17/1/4.
//  Copyright © 2017年 idcby. All rights reserved.
//

#import "ExpertPingJiaListVC.h"

#import "ExpertPingJiaModel.h"
#import "UserPingJiaCell.h"

#import "UITableView+EmpayData.h"

@interface ExpertPingJiaListVC ()

@end

@implementation ExpertPingJiaListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"用户评价";
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.backgroundColor = BG_Color;
    self.tableView.separatorColor = BG_Color;
    [self.tableView registerClass:[UserPingJiaCell class] forCellReuseIdentifier:NSStringFromClass([UserPingJiaCell class])];
    
    [self requestListDataArrray];
}

#pragma mark - 请求数据列表
- (void)requestListDataArrray {
    
    NSString *params = [NSString stringWithFormat:@"ZICBDYCCustomerID=%@",self.ID];
    NSString *url = @"api/Customer/CustomerEvaluateLst";
    
    [self showLoadding:@"正在加载" time:20];
    [self loadDataApi:url withParams:params refresh:RefreshTypeBoth model:ExpertPingJiaModel.class];
}

#pragma mark - Table view datasource and delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataSource == nil) {
        [tableView tableViewDisplayWitMsg:@"" ifNecessaryForRowCount:self.dataSource.count];
    }
    else {
        [tableView tableViewDisplayWitMsg:@"暂无用户评价信息!" ifNecessaryForRowCount:self.dataSource.count];
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ExpertPingJiaModel *model = self.dataSource[indexPath.row];
    UserPingJiaCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UserPingJiaCell class]) forIndexPath:indexPath];
    [cell setModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExpertPingJiaModel *model = self.dataSource[indexPath.row];
    CGRect contantWidth = [Utils getTextRectWithString:model.Content withWidth:Width_Screen-84 withFontSize:16];
    return 118 + contantWidth.size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
