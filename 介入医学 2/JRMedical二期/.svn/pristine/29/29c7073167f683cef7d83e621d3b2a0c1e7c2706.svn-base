//
//  MyUBDetailedListVC.m
//  JRMedical
//
//  Created by a on 16/12/20.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "MyUBDetailedListVC.h"

#import "MyUBDetailedListModel.h"
#import "MyUBDetailedListCell.h"

#import "UITableView+EmpayData.h"

@interface MyUBDetailedListVC ()

@end

@implementation MyUBDetailedListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"U币明细";
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 86, 0, 0);
    self.tableView.backgroundColor = BG_Color;
    [self.tableView registerClass:[MyUBDetailedListCell class] forCellReuseIdentifier:NSStringFromClass([MyUBDetailedListCell class])];
    
    [self requestListDataArrray];
}

#pragma mark - 请求数据列表
- (void)requestListDataArrray {
    NSString *url = @"api/Customer/CustomerURecord";
    NSString *params = @"";
    [self showLoadding:@"正在加载" time:20];
    [self loadDataApi:url withParams:params refresh:RefreshTypeBoth model:MyUBDetailedListModel.class];
}

#pragma mark - Table view datasource and delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataSource == nil) {
        [tableView tableViewDisplayWitMsg:@"" ifNecessaryForRowCount:self.dataSource.count];
    }
    else {
        [tableView tableViewDisplayWitMsg:@"暂无U币明细信息!" ifNecessaryForRowCount:self.dataSource.count];
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyUBDetailedListModel *model = self.dataSource[indexPath.row];
    
    MyUBDetailedListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyUBDetailedListCell class]) forIndexPath:indexPath];
    [cell setModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
