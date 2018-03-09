//
//  NewsListVC.m
//  JRMedical
//
//  Created by a on 16/11/15.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "NewsListVC.h"

#import "NewsCell.h"
#import "LearnWebController.h"

#import "PublicNewsListModel.h"
#import "UITableView+EmpayData.h"

@interface NewsListVC ()

@end

@implementation NewsListVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefreshDataAfterSortingss" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
    self.tableView.backgroundColor = BG_Color;
    [self.tableView registerClass:[NewsCell class] forCellReuseIdentifier:NSStringFromClass([NewsCell class])];
    
    //选择分类下的分类后刷新数据的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDataAfterSortingssClick:) name:@"RefreshDataAfterSortingss" object:nil];
    
    //请求新闻资讯列表
    [self requestListDataArrray];
}

#pragma mark - //选择分类下的分类后刷新数据的通知
- (void)refreshDataAfterSortingssClick:(NSNotification *)sender {
    
    NSInteger tag = self.vcTag - 1000;
    
    NSArray *stringArray = sender.userInfo[@"LableValueLstStringss"];
    
    self.LableValueLst = stringArray[tag];
    
    NSArray *typeArray = sender.userInfo[@"typeListAry"];
    
    NSDictionary *dic = typeArray[tag];
    
    self.groupCode = dic[@"GroupCode"];
    self.valueString = dic[@"Value"];
    
    NSString *url = @"api/News/ItemList";
    NSString *params = [NSString stringWithFormat:@"ZICBDYCGroupCode=%@ZICBDYCTypeCode=%@ZICBDYCLableValueLst=%@",self.groupCode,self.valueString,self.LableValueLst];
    
    [self loadDataApi:url withParams:params refresh:RefreshTypeBoth model:PublicNewsListModel.class];
}

#pragma mark - 请求数据列表
- (void)requestListDataArrray {
    
    NSString *url = @"api/News/ItemList";
    NSString *params = [NSString stringWithFormat:@"ZICBDYCGroupCode=%@ZICBDYCTypeCode=%@ZICBDYCLableValueLst=%@",self.groupCode,self.valueString,self.LableValueLst];
    
    [self showLoadding:@"正在加载" time:20];
    [self loadDataApi:url withParams:params refresh:RefreshTypeBoth model:PublicNewsListModel.class];
}

#pragma mark - Table view datasource and delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataSource == nil) {
        [tableView tableViewDisplayWitMsg:@"" ifNecessaryForRowCount:self.dataSource.count];
    }
    else {
        [tableView tableViewDisplayWitMsg:@"暂无相关资讯信息!" ifNecessaryForRowCount:self.dataSource.count];
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PublicNewsListModel *mode = self.dataSource[indexPath.row];
    
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NewsCell class]) forIndexPath:indexPath];
    [cell setModel:mode];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
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
    PublicNewsListModel *model = self.dataSource[indexPath.row];
    LearnWebController *webVC = [[LearnWebController alloc] init];
    webVC.model = model;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
