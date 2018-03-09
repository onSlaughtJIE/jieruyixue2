//
//  MyPromotionPeopleVC.m
//  JRMedical
//
//  Created by a on 16/12/27.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "MyPromotionPeopleVC.h"

#import "MyAttentionCell.h"
#import "MyAttentionModel.h"
#import "ExpertDetailsVC.h"
#import "UITableView+EmpayData.h"

@interface MyPromotionPeopleVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MyPromotionPeopleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我推广的人";
    
    [self.view addSubview:self.tableView];
    
    [self showLoadding:@"正在加载" time:20];
    [self requestListDataArrray];
}

#pragma mark - 请求数据列表
- (void)requestListDataArrray {
    
    NSString *url = @"Api/Customer/MyGeneralizeList";
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
        [tableView tableViewDisplayWitMsg:@"暂无推荐信息!" ifNecessaryForRowCount:self.dataSource.count];
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
    
    if (model.IsRole) {
        ExpertDetailsVC *edVC = [ExpertDetailsVC new];
        edVC.title = model.CustomerName;
        edVC.model = model;
        [self.navigationController pushViewController:edVC animated:YES];
    }
    else {
        [self showMessage:@"该用户不是医师"];
    }
    
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width_Screen, Height_Screen-64) style:UITableViewStylePlain];
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
