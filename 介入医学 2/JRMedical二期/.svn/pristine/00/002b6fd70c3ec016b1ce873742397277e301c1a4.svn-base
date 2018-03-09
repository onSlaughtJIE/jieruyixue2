//
//  ExpertXinYiListVC.m
//  JRMedical
//
//  Created by a on 17/1/4.
//  Copyright © 2017年 idcby. All rights reserved.
//

#import "ExpertXinYiListVC.h"

#import "ExpertXinYiModel.h"
#import "MindWallCell.h"

#import "UITableView+EmpayData.h"

@interface ExpertXinYiListVC ()

@end

@implementation ExpertXinYiListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"心意墙";
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.backgroundColor = BG_Color;
    self.tableView.separatorColor = BG_Color;
    [self.tableView registerClass:[MindWallCell class] forCellReuseIdentifier:NSStringFromClass([MindWallCell class])];
    
    [self requestListDataArrray];
}

#pragma mark - 请求数据列表
- (void)requestListDataArrray {
    
    NSString *params = [NSString stringWithFormat:@"ZICBDYCCustomerID=%@",self.ID];
    NSString *url = @"api/Customer/CustomerUMoneyLst";
    
    [self showLoadding:@"正在加载" time:20];
    [self loadDataApi:url withParams:params refresh:RefreshTypeBoth model:ExpertXinYiModel.class];
}

#pragma mark - Table view datasource and delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataSource == nil) {
        [tableView tableViewDisplayWitMsg:@"" ifNecessaryForRowCount:self.dataSource.count];
    }
    else {
        [tableView tableViewDisplayWitMsg:@"暂无送心意信息!" ifNecessaryForRowCount:self.dataSource.count];
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ExpertXinYiModel *model = self.dataSource[indexPath.row];
    MindWallCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MindWallCell class]) forIndexPath:indexPath];
    [cell setModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExpertXinYiModel *model = self.dataSource[indexPath.row];
    CGRect contantWidth = [Utils getTextRectWithString:model.HearInfo withWidth:Width_Screen-84 withFontSize:16];
    return 85 + contantWidth.size.height;
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
