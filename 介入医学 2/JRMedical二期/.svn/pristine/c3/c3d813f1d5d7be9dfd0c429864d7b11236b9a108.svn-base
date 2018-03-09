//
//  MedicalExchangeVC.m
//  JRMedical
//
//  Created by a on 16/12/19.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "MedicalExchangeVC.h"
#import "KMButton.h"

#import "OrderAddressCell.h"
#import "MedicalExchangeCell.h"
#import "MyAddressVC.h"
#import "MyAddressModel.h"
#import "GoodRootViewController.h"

#import "MyOrderRootVC.h"

#import <YYKit.h>

@interface MedicalExchangeVC ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *botView;
@property (nonatomic, strong) UILabel *allPriceLab;
@property (nonatomic, strong) KMButton *settlement;

@end

@implementation MedicalExchangeVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"selectMyAddress" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"商品兑换";
    
    //选择地址传过来的数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectMyAddressClick:) name:@"selectMyAddress" object:nil];
    
    [self.view addSubview:self.tableView];
    
    if (self.commodityAry.count > 0) {
        NSDictionary *totalPrice = self.commodityAry[0];
        self.allPriceLab.text = [NSString stringWithFormat:@"实付款 : %@U币",totalPrice[@"totalPrice"]];
    }
    
    if (self.addressAry.count == 0 || self.addressAry == nil) {
        [self getAddressInfoData];//请求地址信息
    }
    
    [self setBotView];
}

#pragma mark - 选择地址
- (void)selectMyAddressClick:(NSNotification *)sender {
    
    MyAddressModel *model = sender.userInfo[@"myAddressModel"];
    
    [self.addressAry removeAllObjects];
    
    NSDictionary *addressDic = @{@"ID":model.ID,
                                 @"DetailAddress":model.DetailAddress,
                                 @"ConsigneeName":model.ConsigneeName,
                                 @"Consigneephone":model.Consigneephone,
                                 @"OrderIndex":model.OrderIndex,
                                 @"Province":model.Province,
                                 @"City":model.City,
                                 @"County":model.County,
                                 @"IsDefault":@(model.IsDefault)};
    
    [self.addressAry addObject:addressDic];
    
    NSMutableDictionary *allInfoDic = [[NSMutableDictionary alloc] init];
    [allInfoDic setObject:self.addressAry forKey:@"AddressArray"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FillInOrderAddressArray" object:nil userInfo:allInfoDic];
    
    [self.tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - 立即兑换
- (void)postOrder {
    
    if (self.addressAry.count == 0) {
        return [self showMessage:@"请添加您的收货地址"];
    }
    
    NSDictionary *addressDataDic = self.addressAry[0];
    NSDictionary *commodityDataDic = self.commodityAry[0];
    
    NSString *params = [NSString stringWithFormat:@"ZICBDYCExchangeID=%@ZICBDYCReceiptAddressID=%@",commodityDataDic[@"ExchangeID"],addressDataDic[@"ID"]];
    NSString *url = @"api/CommodityInfo/CommodityExchange";
    
    NSLog(@"%@",params);
    
    [self showLoadding:@"" time:20];
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"立即兑换 - %@", modelData);
        if (isSuccess) {
            NSString *message = nil;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"商品兑换成功"
                                                                message:message
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
            [alertView show];
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

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    MyOrderRootVC *orderVc = [MyOrderRootVC new];
    orderVc.tagVC = 2;
    orderVc.payOrderTo = @"商品兑换";
    [self.navigationController pushViewController:orderVc animated:YES];
}

#pragma mark - 设置底部视图
- (void)setBotView {
    [self.view addSubview:self.botView];
    [self.botView addSubview:self.allPriceLab];
    [self.botView addSubview:self.settlement];
    
    self.botView.sd_layout.bottomEqualToView(self.view).widthIs(Width_Screen).heightIs(40);
    self.settlement.sd_layout.centerYEqualToView(self.botView).rightEqualToView(self.botView).widthIs(120).heightIs(40);
    self.allPriceLab.sd_layout.centerYEqualToView(self.botView).leftSpaceToView(self.botView,15).rightSpaceToView(self.settlement,15).heightIs(14);
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
        {
            OrderAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderAddressCell class]) forIndexPath:indexPath];
            if (self.addressAry.count > 0) {
                cell.emptyLab.hidden = YES;
                [cell setDataDic:self.addressAry[0]];
            }
            else {
                cell.emptyLab.hidden = NO;
            }
            return cell;
        }
            break;
        default:
        {
            MedicalExchangeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MedicalExchangeCell class]) forIndexPath:indexPath];
            [cell setDataAry:self.commodityAry];
            return cell;
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            return 85;
        }
            break;
        default:
        {
            return 120;
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {//更换地址
        MyAddressVC *myaddressVC = [MyAddressVC new];
        myaddressVC.from = 1000;
        [self.navigationController pushViewController:myaddressVC animated:YES];
    }
    else if (indexPath.section == 1) {//进入查看兑换商品详情
//        
//        NSDictionary *dataDic = self.commodityAry[0];
//        
//        GoodRootViewController *dvc = [[GoodRootViewController alloc]init];
//        dvc.commodityID = @"0";
//        dvc.exchangeID = dataDic[@"ExchangeID"];
//        dvc.from = 2000;//兑换商品
//        dvc.isShowTool = 100;//兑换商品  //但是 不展示
//        [self.navigationController pushViewController:dvc animated:YES];
    }
}

#pragma mark - 获取默认地址信息
- (void)getAddressInfoData {
    
    NSString *params = [NSString stringWithFormat:@"ZICBDYCOpeType=%@",@"IsDefault"];
    NSString *url = @"api/MallsInfo/ReceiptAddressLst";
    
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"获取默认地址信息 - %@", modelData);
        if (isSuccess) {
            NSArray *dataAry = modelData[@"JsonData"];
            self.addressAry = [NSMutableArray arrayWithArray:dataAry];
            [self.tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
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

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width_Screen, Height_Screen-104) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor  = [UIColor whiteColor];
        _tableView.backgroundColor = BG_Color;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [_tableView registerClass:[OrderAddressCell class] forCellReuseIdentifier:NSStringFromClass([OrderAddressCell class])];
        [_tableView registerClass:[MedicalExchangeCell class] forCellReuseIdentifier:NSStringFromClass([MedicalExchangeCell class])];
    }
    return _tableView;
}
- (UIView *)botView {
    if (!_botView) {
        _botView = [UIView new];
        _botView.backgroundColor = BG_Color;
        _botView.layer.shadowColor = RGB(100, 100, 100).CGColor;//阴影颜色
        _botView.layer.shadowOffset = CGSizeMake(0 , 1);//偏移距离
        _botView.layer.shadowOpacity = 0.5;//不透明度
        _botView.layer.shadowRadius = 3.0;//半径
    }
    return _botView;
}
- (KMButton *)settlement {
    if (!_settlement) {
        _settlement = [KMButton buttonWithType:UIButtonTypeCustom];
        _settlement.backgroundColor = RGB(232, 78, 64);
        _settlement.spacing = 5;
        _settlement.margin = 20;
        _settlement.kMButtonType = KMButtonLeft;
        [_settlement setImage:[UIImage imageNamed:@"qiandaijiesuan"] forState:UIControlStateNormal];
        [_settlement setTitle:@"立即兑换" forState:UIControlStateNormal];
        _settlement.titleLabel.font = [UIFont systemFontOfSize:14];
        [_settlement addTarget:self action:@selector(postOrder) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settlement;
}
- (UILabel *)allPriceLab {
    if (!_allPriceLab) {
        _allPriceLab = [UILabel new];
        _allPriceLab.text = @"实付款 : 0.00U币";
        _allPriceLab.font = [UIFont systemFontOfSize:14];
        _allPriceLab.textColor = RGB(232, 78, 64);
        _allPriceLab.textAlignment = NSTextAlignmentCenter;
    }
    return _allPriceLab;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
