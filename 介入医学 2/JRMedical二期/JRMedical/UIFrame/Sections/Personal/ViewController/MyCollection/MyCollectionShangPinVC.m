//
//  MyCollectionShangPinVC.m
//  JRMedical
//
//  Created by a on 16/12/22.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "MyCollectionShangPinVC.h"

#import "MerchandiseListModel.h"
#import "GoodListTableViewCell.h"
#import "UITableView+EmpayData.h"

#import "GoodRootViewController.h"

@interface MyCollectionShangPinVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MyCollectionShangPinVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cleanCollectionShangPing" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = BG_Color;
    
    //进入详情点击收藏按钮后的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanCollectionShangPingClick) name:@"cleanCollectionShangPing" object:nil];
    
    [self.view addSubview:self.tableView];
    
    [self showLoadding:@"正在加载" time:20];
    [self requestListDataArrray];
}

#pragma mark - //进入详情点击收藏按钮后的通知
- (void)cleanCollectionShangPingClick {
    self.isStartRefresh = YES;
    [self requestListDataArrray];
}

#pragma mark - 请求数据列表
- (void)requestListDataArrray {
    
    NSString *url = @"api/Customer/MyCollectionLst";
    NSString *params = [NSString stringWithFormat:@"ZICBDYCType=%@",@"Product"];
    
    self.pageSize = 10;//一次加载8条数据
    self.tableType = 1;//TableView表类
    self.baseTableView = self.tableView;//将本类表 赋值给父类去操作
    [self loadDataApi:url withParams:params refresh:RefreshTypeBoth model:MerchandiseListModel.class];
}

#pragma mark - Table view datasource and delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataSource == nil) {
        [tableView tableViewDisplayWitMsg:@"" ifNecessaryForRowCount:self.dataSource.count];
    }
    else {
        [tableView tableViewDisplayWitMsg:@"您还没有收藏任何商品信息!" ifNecessaryForRowCount:self.dataSource.count];
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MerchandiseListModel *model = self.dataSource[indexPath.row];
    
    GoodListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell setModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
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
    MerchandiseListModel *model = self.dataSource[indexPath.row];
    GoodRootViewController *rootVC = [[GoodRootViewController alloc] init];
    rootVC.commodityID = model.CommodityID;//商品id
    rootVC.exchangeID = @"0";//兑换id
    rootVC.from = 1000;
    rootVC.isShowTool = 300;
    [self.navigationController pushViewController:rootVC animated:YES];
}

#pragma mark  表的删除代理方法 --- 取消关注
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"取消收藏";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // //左滑删除
        MerchandiseListModel *model = self.dataSource[indexPath.row];
        NSString *params = [NSString stringWithFormat:@"ZICBDYCCommodityID=%@",model.CommodityID];
        NSString *url = @"api/CommodityInfo/CollectionCommodity";
        
        [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
            NSLog(@"取消收藏 - %@", modelData);
            if (isSuccess) {
                [self.dataSource removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
            else {
                NSString *msg  = [modelData objectForKey:@"Msg"];
                if (msg!=nil && ![msg isEqual:@""]) {
                    [self showMessage:msg];
                }
                else {
                    [self showMessage:[NSString stringWithFormat:@"请求失败 #%d",code]];
                }
            }
        }];
        
    }
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, Width_Screen, Height_Screen-108) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = BG_Color;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 105, 0, 0);
        [_tableView registerNib:[UINib nibWithNibName:@"GoodListTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
