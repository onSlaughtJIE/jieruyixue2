//
//  VideoSpecialListVC.m
//  JRMedical
//
//  Created by a on 16/11/16.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "VideoSpecialListVC.h"

#import "VideoSpecialTableCell.h"
#import "VideoSpecialDetailListVC.h"
#import "VideoSpecialListModel.h"
#import "UITableView+EmpayData.h"

@interface VideoSpecialListVC ()

@end

@implementation VideoSpecialListVC

- (instancetype)initWithStyle:(UITableViewStyle)style {
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.separatorColor = BG_Color;
    self.tableView.backgroundColor = BG_Color;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    [self.tableView registerClass:[VideoSpecialTableCell class] forCellReuseIdentifier:NSStringFromClass([VideoSpecialTableCell class])];
    
    UIView *footView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, Width_Screen, 75))];
    self.tableView.tableFooterView = footView;
    
    [self requestListDataArrray];//请求数据列表
}

#pragma mark - 请求数据列表
- (void)requestListDataArrray {
    
    NSString *url = @"api/News/SpecialInfoList";
    NSString *params = @"";

    [self showLoadding:@"正在加载" time:20];
    [self loadDataApi:url withParams:params refresh:RefreshTypeBoth model:VideoSpecialListModel.class];
}

#pragma mark - Table view datasource and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.dataSource == nil) {
        [tableView tableViewDisplayWitMsg:@"" ifNecessaryForRowCount:self.dataSource.count];
    }
    else {
        [tableView tableViewDisplayWitMsg:@"暂无相关专题信息!" ifNecessaryForRowCount:self.dataSource.count];
    }
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VideoSpecialListModel *model = self.dataSource[indexPath.section];
    
    VideoSpecialTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([VideoSpecialTableCell class]) forIndexPath:indexPath];
    [cell setModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    CGFloat cellHeight = (Width_Screen-20)/16*9+70;
    CGFloat cellHeight = (Width_Screen-20)/16*9+47;
    return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001;
}

#pragma mark  点击cell的响应的代理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoSpecialListModel *model = self.dataSource[indexPath.section];
    VideoSpecialDetailListVC *vSpecialDetailList = [[VideoSpecialDetailListVC alloc] init];
    vSpecialDetailList.model = model;
    [self.navigationController pushViewController:vSpecialDetailList animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
