//
//  ServiceHistoryVC.m
//  JRMedical
//
//  Created by a on 16/12/26.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "ServiceHistoryVC.h"

#import "ServiceHistoryCell.h"
#import "MyAttentionModel.h"
#import "UITableView+EmpayData.h"

#import "ServicePingJiaVC.h"
#import "ExpertDetailsVC.h"

#import <YYKit.h>

@interface ServiceHistoryVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ServiceHistoryVC {
    
    NSInteger _curSelectRow;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pingJiaFuWuChengGong" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.view addSubview:self.tableView];
    
    //评价后改变数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pingJiaFuWuChengGongClick) name:@"pingJiaFuWuChengGong" object:nil];
    
    [self showLoadding:@"正在加载" time:20];
    [self requestListDataArrray];
}

- (void)pingJiaFuWuChengGongClick {
    MyAttentionModel *model = self.dataSource[_curSelectRow];
    model.IsEvaluation = YES;
    [self.tableView reloadRow:_curSelectRow inSection:0 withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - 请求数据列表
- (void)requestListDataArrray {
    
    NSString *url = @"Api/Customer/GetCustomerService";
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
        [tableView tableViewDisplayWitMsg:@"暂无服务信息!" ifNecessaryForRowCount:self.dataSource.count];
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyAttentionModel *model = self.dataSource[indexPath.row];
    ServiceHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ServiceHistoryCell class]) forIndexPath:indexPath];
    [cell setModel:model];
    
    [cell.pingJiaBtn bk_whenTapped:^{
        ServicePingJiaVC *serview = [ServicePingJiaVC new];
        serview.ID = model.ServiceID;
        _curSelectRow = indexPath.row;
        [self.navigationController pushViewController:serview animated:YES];
    }];
    
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
    MyAttentionModel *model = self.dataSource[indexPath.row];
    ExpertDetailsVC *edVC = [ExpertDetailsVC new];
    edVC.title = model.CustomerName;
    edVC.model = model;
    [self.navigationController pushViewController:edVC animated:YES];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, Width_Screen, Height_Screen-108) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 80, 0, 0);
        _tableView.backgroundColor = BG_Color;
        [_tableView registerClass:[ServiceHistoryCell class] forCellReuseIdentifier:NSStringFromClass([ServiceHistoryCell class])];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
