//
//  FillInOrderVC.m
//  JRMedical
//
//  Created by a on 16/12/19.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "FillInOrderVC.h"

#import "KMButton.h"

#import "OrderAddressCell.h"
#import "OrderShangPinCell.h"
#import "OrderFaPiaoTypeCell.h"
#import "OrderFaPiaoTitleCell.h"
#import "OrderFaPiaoContantCell.h"
#import "UBFillInOrderCell.h"
#import "MyAddressVC.h"
#import "MyAddressModel.h"
#import "PayOrderVC.h"

#import <YYKit.h>

@interface FillInOrderVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,OrderFaPiaoContantCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *botView;
@property (nonatomic, strong) UILabel *allPriceLab;
@property (nonatomic, strong) KMButton *settlement;

@property (nonatomic, strong) NSArray *faPiaoArray;

@end

@implementation FillInOrderVC {
    
    NSString *_ReceiptAddressID;//选取的收货地址 返回的主键ID
    CGFloat _PayMoneyAmount;//订单金额
    NSString *_InvoiceType; //0是公司 1是个人
    UITextField *_InvoiceHeader;//发票抬头
    NSString *_InvoiceDetail;//发票内容
    NSString *_CommodityLst;//商品内容
    
    NSDictionary *_ubDataDic;
    
    NSMutableArray *_comAry;
    
    BOOL _isSeleUB;
    
    BOOL _isKaiFaPiao;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"selectMyAddress" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"填写订单";
    
    _comAry = [NSMutableArray arrayWithCapacity:0];
    
    //选择地址传过来的数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectMyAddressClick:) name:@"selectMyAddress" object:nil];
    
    [self.view addSubview:self.tableView];
    
    if (self.commodityAry.count > 0) {
        NSDictionary *totalPrice = self.commodityAry[0];
        _PayMoneyAmount  = [totalPrice[@"totalPrice"] floatValue];
        self.allPriceLab.text = [NSString stringWithFormat:@"实付款 : ¥ %.2f",_PayMoneyAmount];
    }
    
    if (self.addressAry.count == 0 || self.addressAry == nil) {
        [self getAddressInfoData];//请求地址信息
    }
    
    [self getFaPiaoInfoData];//请求发票信息
    
    [self setBotView];
    
    [self getUBInfoData];//获取UB数据
}

#pragma mark - OrderFaPiaoContantCellDelegate
- (void)selectFoPiaoContantClick:(NSString *)invoiceDetail {
    _InvoiceDetail = invoiceDetail;//获取所选发票内容
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

#pragma mark - 提交订单
- (void)postOrder {
    
    if (self.addressAry.count == 0) {
        return [self showMessage:@"请添加您的收货地址"];
    }
    
    if (_isKaiFaPiao) {
        if ([_InvoiceHeader.text isEqualToString:@""] || _InvoiceHeader.text == nil) {
            return [self showMessage:@"请填写您的发票抬头"];
        }
    }
    
    [_comAry removeAllObjects];
    
    for (NSDictionary *dic in self.commodityAry) {
        NSString *string = [NSString stringWithFormat:@"%@,%@",dic[@"CommodityID"],dic[@"Num"]];
        [_comAry addObject:string];
    }
    
    //把数组转换成字符串
    _CommodityLst = [_comAry componentsJoinedByString:@";"];
    
    NSString *params = [NSString stringWithFormat:@"ZICBDYCReceiptAddressID=%@ZICBDYCPayMoneyAmount=%fZICBDYCIsInvoice=%dZICBDYCInvoiceType=%@ZICBDYCInvoiceHeader=%@ZICBDYCInvoiceDetail=%@ZICBDYCCommodityLst=%@ZICBDYCIsRatio=%d",_ReceiptAddressID,_PayMoneyAmount,_isKaiFaPiao,_InvoiceType,_InvoiceHeader.text,_InvoiceDetail,_CommodityLst,_isSeleUB];
    NSString *url = @"api/Order/CreateOrder";
    
    [self showLoadding:@"" time:20];
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"提交订单 - %@", modelData);
        if (isSuccess) {
            
            NSDictionary *orderDic = modelData[@"JsonData"];
            
            PayOrderVC *poVC = [PayOrderVC new];
            poVC.orderDic = orderDic;
            poVC.from = self.from;
            [self.navigationController pushViewController:poVC animated:YES];
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
    if (_ubDataDic.count > 0) {
        NSInteger ubNum = [_ubDataDic[@"UMoney"] integerValue];
        NSInteger ubPayNum = [_ubDataDic[@"UPrice"] integerValue];
        if (ubNum < ubPayNum) {
            return 6;
        }
        return 7;
    }
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0://地址信息
        {
            OrderAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderAddressCell class]) forIndexPath:indexPath];
            if (self.addressAry.count > 0) {
                cell.emptyLab.hidden = YES;
                
                NSDictionary *dataDic = self.addressAry[0];
                
                [cell setDataDic:dataDic];
                
                _ReceiptAddressID = dataDic[@"ID"];
            }
            else {
                cell.emptyLab.hidden = NO;
            }
            return cell;
        }
            break;
        case 1://商品数量
        {
            OrderShangPinCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderShangPinCell class]) forIndexPath:indexPath];
            [cell setDataAry:self.commodityAry];
            return cell;
        }
            break;
        case 2://是否开发票
        {
            UBFillInOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ubFillInOrderCell" forIndexPath:indexPath];
            cell.titleLab.text  = @"是否开发票";
//            cell.picImage.selected = NO;
            [cell.picImage setImage:[UIImage imageNamed:@"kuang"] forState:UIControlStateNormal];
            [cell.picImage setImage:[UIImage imageNamed:@"dui-on"] forState:UIControlStateSelected];
            
            [cell.selectClickView bk_whenTapped:^{
                cell.picImage.selected = !cell.picImage.selected;
                if (cell.picImage.selected) {
                    _isKaiFaPiao = YES;
                    [self.tableView reloadSection:3 withRowAnimation:UITableViewRowAnimationFade];
                    [self.tableView reloadSection:4 withRowAnimation:UITableViewRowAnimationFade];
                    [self.tableView reloadSection:5 withRowAnimation:UITableViewRowAnimationFade];
                }
                else {
                    _isKaiFaPiao = NO;
                    [self.tableView reloadSection:3 withRowAnimation:UITableViewRowAnimationFade];
                    [self.tableView reloadSection:4 withRowAnimation:UITableViewRowAnimationFade];
                    [self.tableView reloadSection:5 withRowAnimation:UITableViewRowAnimationFade];
                }
            }];
            
            return cell;
        }
            break;
        case 3://发票类型
        {
            if (_isKaiFaPiao) {
                OrderFaPiaoTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderFaPiaoTypeCell class]) forIndexPath:indexPath];
                
                _InvoiceType = @"1";//默认个人
                
                [cell.geRenBtn bk_whenTapped:^{//个人
                    
                    _InvoiceType = @"1";
                    
                    cell.geRenBtn.selected = YES;
                    cell.danWeiBtn.selected = NO;
                }];
                [cell.danWeiBtn bk_whenTapped:^{//单位
                    
                    _InvoiceType = @"0";
                    
                    cell.geRenBtn.selected = NO;
                    cell.danWeiBtn.selected = YES;
                }];
                return cell;
            }
            else {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
                cell.backgroundColor = BG_Color;
                return cell;
            }
        }
            break;
        case 4://发票抬头
        {
            if (_isKaiFaPiao) {
                OrderFaPiaoTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderFaPiaoTitleCell class]) forIndexPath:indexPath];
                cell.topInfoTF.delegate = self;
                _InvoiceHeader = cell.topInfoTF;
                return cell;
            }
            else {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
                cell.backgroundColor = BG_Color;
                return cell;
            }
        }
            break;
        case 5://发票内容
        {
            if (_isKaiFaPiao) {
                OrderFaPiaoContantCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderFaPiaoContantCell class]) forIndexPath:indexPath];
                if (self.faPiaoArray.count > 0) {
                    [cell setDataAry:self.faPiaoArray];
                    cell.delegate = self;
                    
                    //获取默认发票内容
                    NSDictionary *dataDic = self.faPiaoArray[0];
                    _InvoiceDetail = dataDic[@"Value"];
                }
                return cell;
            }
            else {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
                cell.backgroundColor = BG_Color;
                return cell;
            }
        }
            break;
        default://UB兑换
        {
            UBFillInOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ubFillInOrderCell" forIndexPath:indexPath];
            cell.titleLab.text  = [NSString stringWithFormat:@"可用多少%ldU币抵¥%.2f",[_ubDataDic[@"UPrice"] integerValue],[_ubDataDic[@"Umopoints"] floatValue]];
            cell.picImage.selected = NO;
            [cell.picImage setImage:[UIImage imageNamed:@"kuang"] forState:UIControlStateNormal];
            [cell.picImage setImage:[UIImage imageNamed:@"dui-on"] forState:UIControlStateSelected];
            
            [cell.selectClickView bk_whenTapped:^{
                cell.picImage.selected = !cell.picImage.selected;
                
                if (cell.picImage.selected) {
                    _isSeleUB = YES;
                    
                    
                    CGFloat price = [_ubDataDic[@"Umopoints"] floatValue];
                    NSDictionary *totalPrice = self.commodityAry[0];
                    CGFloat payPrice  = [totalPrice[@"totalPrice"] floatValue];
                    
                    _PayMoneyAmount = payPrice-price;
                    
                    self.allPriceLab.text = [NSString stringWithFormat:@"实付款 : ¥ %.2f",_PayMoneyAmount];
                }
                else {
                    _isSeleUB = NO;
                    
                    NSDictionary *totalPrice = self.commodityAry[0];
                    _PayMoneyAmount  = [totalPrice[@"totalPrice"] floatValue];
                    
                    self.allPriceLab.text = [NSString stringWithFormat:@"实付款 : ¥ %.2f",_PayMoneyAmount];
                }
                
            }];
            
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
        case 1:
        {
            return 120;
        }
            break;
        case 2:
        {
            return 55;
        }
            break;
        case 3:
        {
            if (_isKaiFaPiao) {
                return 118.4;
            }
            else {
                return 0.0001;
            }
        }
            break;
        case 4:
        {
            if (_isKaiFaPiao) {
                return 118.4;
            }
            else {
                return 0.0001;
            }
        }
            break;
        case 5:
        {
            CGFloat heightScreen;
            if (self.faPiaoArray.count <= 3) {
                heightScreen = 50;
            }
            else if (self.faPiaoArray.count >3 && self.faPiaoArray.count <= 6) {
                heightScreen = 110;
            }
            else {
                heightScreen = 170;
            }
            
            if (_isKaiFaPiao) {
                return 74.4+heightScreen;
            }
            else {
                return 0.0001;
            }
        }
            break;
        default:
        {
            return 55;
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    switch (section) {
        case 0:
        {
            return 10;
        }
            break;
        case 1:
        {
            return 10;
        }
            break;
        case 2:
        {
            return 10;
        }
            break;
        case 3:
        {
            if (_isKaiFaPiao) {
                return 10;
            }
            else {
                return 0.0001;
            }
        }
            break;
        case 4:
        {
            if (_isKaiFaPiao) {
                return 10;
            }
            else {
                return 0.0001;
            }
        }
            break;
        case 5:
        {
            if (_isKaiFaPiao) {
                return 10;
            }
            else {
                return 0.0001;
            }
        }
            break;
        default:
        {
            return 10;
        }
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        MyAddressVC *myaddressVC = [MyAddressVC new];
        myaddressVC.from = 1000;
        [self.navigationController pushViewController:myaddressVC animated:YES];
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

#pragma mark - 获取UB信息
- (void)getUBInfoData {
    
    [_comAry removeAllObjects];
    
    for (NSDictionary *dic in self.commodityAry) {
        NSString *string = [NSString stringWithFormat:@"%@,%@",dic[@"CommodityID"],dic[@"Num"]];
        [_comAry addObject:string];
    }
    
    //把数组转换成字符串
    _CommodityLst = [_comAry componentsJoinedByString:@";"];
    
    NSString *params = [NSString stringWithFormat:@"ZICBDYCCommodityLst=%@",_CommodityLst];
    NSString *url = @"api/Order/OrderAmount";
    
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"获取UB信息 - %@", modelData);
        if (isSuccess) {
            _ubDataDic = modelData[@"JsonData"];
            
            [self.tableView reloadData];
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

#pragma mark - 获取发票信息
- (void)getFaPiaoInfoData {
    
    NSString *params = @"";
    NSString *url = @"api/Order/InvoiceDetail";
    
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"获取发票信息 - %@", modelData);
        if (isSuccess) {
            self.faPiaoArray = modelData[@"JsonData"];
            [self.tableView reloadSection:4 withRowAnimation:UITableViewRowAnimationNone];
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
        _tableView.separatorColor  = BG_Color;
        _tableView.backgroundColor = BG_Color;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [_tableView registerClass:[OrderAddressCell class] forCellReuseIdentifier:NSStringFromClass([OrderAddressCell class])];
        [_tableView registerClass:[OrderShangPinCell class] forCellReuseIdentifier:NSStringFromClass([OrderShangPinCell class])];
        [_tableView registerClass:[OrderFaPiaoTypeCell class] forCellReuseIdentifier:NSStringFromClass([OrderFaPiaoTypeCell class])];
        [_tableView registerClass:[OrderFaPiaoTitleCell class] forCellReuseIdentifier:NSStringFromClass([OrderFaPiaoTitleCell class])];
        [_tableView registerClass:[OrderFaPiaoContantCell class] forCellReuseIdentifier:NSStringFromClass([OrderFaPiaoContantCell class])];
        [_tableView registerNib:[UINib nibWithNibName:@"UBFillInOrderCell" bundle:nil] forCellReuseIdentifier:@"ubFillInOrderCell"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
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
        [_settlement setTitle:@"提交订单" forState:UIControlStateNormal];
        _settlement.titleLabel.font = [UIFont systemFontOfSize:14];
        [_settlement addTarget:self action:@selector(postOrder) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settlement;
}
- (UILabel *)allPriceLab {
    if (!_allPriceLab) {
        _allPriceLab = [UILabel new];
        _allPriceLab.text = @"实付款 : ¥ 0.00";
        _allPriceLab.font = [UIFont systemFontOfSize:14];
        _allPriceLab.textColor = RGB(232, 78, 64);
        _allPriceLab.textAlignment = NSTextAlignmentCenter;
    }
    return _allPriceLab;
}

#pragma mark - UITextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
