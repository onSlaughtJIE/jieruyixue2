//
//  DaiPingJiaOrder.m
//  JRMedical
//
//  Created by a on 16/12/22.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "DaiPingJiaOrder.h"

#import "OrderPingJiaCell.h"
#import "OrderPingJiaModel.h"
#import "PostPingJiaVC.h"
#import "OrderDetailVC.h"

#import "UITableView+EmpayData.h"

@interface DaiPingJiaOrder ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DaiPingJiaOrder

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BianJiOrderDetail" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BianJiOrderDetailClick) name:@"BianJiOrderDetail" object:nil];
    
    [self.view addSubview:self.tableView];
    
    [self requestListDataArrray];
}

- (void)BianJiOrderDetailClick {
    [self requestListDataArrray];
}

#pragma mark - 请求数据列表
- (void)requestListDataArrray {
    
    NSString *url = @"api/Customer/GetOrderDetailLst";
    NSString *params = @"";
    
    self.pageSize = 10;//一次加载8条数据
    self.tableType = 1;//TableView表类
    self.baseTableView = self.tableView;//将本类表 赋值给父类去操作
    [self showLoadding:@"" time:20];
    [self loadDataApi:url withParams:params refresh:RefreshTypeBoth model:OrderPingJiaModel.class];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.dataSource == nil) {
        [tableView tableViewDisplayWitMsg:@"" ifNecessaryForRowCount:self.dataSource.count];
    }
    else {
        [tableView tableViewDisplayWitMsg:@"暂无待评价订单信息!" ifNecessaryForRowCount:self.dataSource.count];
    }
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OrderPingJiaModel *model = [self.dataSource objectAtIndex:indexPath.section];
    
    OrderPingJiaCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderPingJiaCell" forIndexPath:indexPath];
    
    [cell setModel:model];
    
    [cell.pingJiaoBtn bk_whenTapped:^{
        PostPingJiaVC *postPJVC = [PostPingJiaVC new];
        postPJVC.ID = model.DetailID;
        postPJVC.CommodityID = model.CommodityID;
        [self.navigationController pushViewController:postPJVC animated:YES];
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

#pragma mark  点击cell的响应的代理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OrderPingJiaModel *model = [self.dataSource objectAtIndex:indexPath.section];
    OrderDetailVC *odVC = [OrderDetailVC new];
    odVC.orderNO = model.OrderNO;
    [self.navigationController pushViewController:odVC animated:YES];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, Width_Screen, Height_Screen-108) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor  = [UIColor clearColor];
        _tableView.backgroundColor = BG_Color;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [_tableView registerNib:[UINib nibWithNibName:@"OrderPingJiaCell" bundle:nil] forCellReuseIdentifier:@"orderPingJiaCell"];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
