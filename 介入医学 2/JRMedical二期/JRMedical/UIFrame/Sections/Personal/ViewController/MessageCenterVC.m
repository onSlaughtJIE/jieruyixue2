//
//  MessageCenterVC.m
//  JRMedical
//
//  Created by a on 16/12/21.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "MessageCenterVC.h"

#import "MessageCenterModel.h"
#import "MessageCenterCell.h"

#import "UITableView+EmpayData.h"

@interface MessageCenterVC ()

@end

@implementation MessageCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"消息中心";
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.backgroundColor = BG_Color;
    [self.tableView registerClass:[MessageCenterCell class] forCellReuseIdentifier:NSStringFromClass([MessageCenterCell class])];
    
    [self requestListDataArrray];
}

#pragma mark - 请求数据列表
- (void)requestListDataArrray {
    NSString *url = @"api/Customer/NoticeInfoLst";
    NSString *params = @"";
    [self showLoadding:@"正在加载" time:20];
    [self loadDataApi:url withParams:params refresh:RefreshTypeBoth model:MessageCenterModel.class];
}

#pragma mark - Table view datasource and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.dataSource == nil) {
        [tableView tableViewDisplayWitMsg:@"" ifNecessaryForRowCount:self.dataSource.count];
    }
    else {
        [tableView tableViewDisplayWitMsg:@"暂无任何消息信息!" ifNecessaryForRowCount:self.dataSource.count];
    }
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageCenterModel *model = self.dataSource[indexPath.section];
    
    MessageCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MessageCenterCell class]) forIndexPath:indexPath];
    [cell setModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
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
