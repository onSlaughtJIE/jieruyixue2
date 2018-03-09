//
//  OrderDetailVC.m
//  JRMedical
//
//  Created by a on 16/12/23.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "OrderDetailVC.h"

#import "OrderAddressCell.h"
#import "OrderShangPinCell.h"
#import "PayOrderVC.h"
#import "OrderFaPiaoCell.h"
#import "OrderPriceInfoCell.h"
#import "HTMLViewController.h"

#import "PayOrderVC.h"

#import <YYKit.h>

@interface OrderDetailVC ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *botView;

@property (nonatomic, strong) NSDictionary *dataDic;

@end

@implementation OrderDetailVC {
    UIButton *sure;
    UIButton *cancel;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"payOrderDetailReturn" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"订单详情";
    
    [self.view addSubview:self.tableView];
    
    //支付后的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payOrderDetailReturnClick) name:@"payOrderDetailReturn" object:nil];
    
    [self getOrderDetailData];//请求订单详情
}

- (void)payOrderDetailReturnClick {
    
    self.botView.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BianJiOrderDetail" object:nil userInfo:nil];
    [self getOrderDetailData];//请求订单详情
}

- (void)setBotView {
    
    [self.view addSubview:self.botView];
    self.botView.sd_layout.bottomEqualToView(self.view).widthIs(Width_Screen).heightIs(60);
    
    sure = [UIButton buttonWithType:UIButtonTypeSystem];
    sure.userInteractionEnabled = YES;
    sure.layer.borderColor = Main_Color.CGColor;
    sure.layer.borderWidth = 1;
    sure.clipsToBounds = YES;
    sure.layer.cornerRadius = 5;
    [sure setTitleColor:Main_Color forState:UIControlStateNormal];
    [self.botView addSubview:sure];
    sure.sd_layout.centerYEqualToView(self.botView).rightSpaceToView(self.botView,10).widthIs(80).heightIs(40);
    
    cancel = [UIButton buttonWithType:UIButtonTypeSystem];
    cancel.userInteractionEnabled = YES;
    
    cancel.layer.borderColor = BG_Color.CGColor;
    cancel.layer.borderWidth = 1;
    cancel.clipsToBounds = YES;
    cancel.layer.cornerRadius = 5;
    [cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.botView addSubview:cancel];
    cancel.sd_layout.centerYEqualToView(self.botView).rightSpaceToView(sure,10).widthIs(80).heightIs(40);
    
    NSInteger state = [self.dataDic[@"OrderState"] integerValue];
    
    if (state == 1) {
        [sure setTitle:@"付款" forState:(UIControlStateNormal)];
        [cancel setTitle:@"取消订单" forState:(UIControlStateNormal)];
        
        [sure bk_whenTapped:^{
            NSDictionary *orderDic = @{@"PayPrice":self.dataDic[@"PayMoneyAmount"],@"OrderNO":self.dataDic[@"OrderNO"]};
            
            PayOrderVC *poVC = [PayOrderVC new];
            poVC.orderDic = orderDic;
            poVC.from = @"订单详情";
            [self.navigationController pushViewController:poVC animated:YES];
        }];
        
        [cancel bk_whenTapped:^{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"取消订单"
                                                                message:@"您确认要取消这条订单么?"
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"确认",nil];
            alertView.tag = 1000;
            [alertView show];
        }];
    }
    else if (state == 3) {
        
        [sure setTitle:@"确认收货" forState:(UIControlStateNormal)];
        [cancel setTitle:@"查看物流" forState:(UIControlStateNormal)];
        
        [sure bk_whenTapped:^{
            NSString *params = [NSString stringWithFormat:@"ZICBDYCOrderID=%@",self.dataDic[@"OrderID"]];
            NSString *url = @"api/Customer/AffirmConsignee";
            
            [self showLoadding:@"" time:20];
            
            [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSObject *modelData) {
                
                NSDictionary *dataDic = (NSDictionary *)modelData;
                NSLog(@"确认收货--------%@",dataDic);
                if (isSuccess) {
                    [self showMessage:@"收货成功"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"BianJiOrderDetail" object:nil userInfo:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else {
                    NSString *msg  = [dataDic objectForKey:@"Msg"];
                    if (msg!=nil && ![msg isEqual:@""]) {
                        [self showMessage:msg];
                    }else{
                        [self showMessage:[NSString stringWithFormat:@"请求失败 #%d",code]];
                    }
                }
            }];
        }];
        
        [cancel bk_whenTapped:^{
            HTMLViewController * htmlVC = [[HTMLViewController alloc] init];
            htmlVC.urlStr = self.dataDic[@"ExpressUrl"];
            htmlVC.title = @"查看物流";
            [self.navigationController pushViewController:htmlVC animated:YES];
        }];
    }
    else if (state == 4) {
        
        sure.hidden = YES;
        [cancel setTitle:@"删除订单" forState:(UIControlStateNormal)];
        cancel.sd_layout.centerYEqualToView(self.botView).rightSpaceToView(self.botView,10).widthIs(80).heightIs(40);
        
        [cancel bk_whenTapped:^{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"删除订单"
                                                                message:@"您确认要删除这条订单么?"
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"确认",nil];
            alertView.tag = 2000;
            [alertView show];
        }];
    }
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            NSString *params = [NSString stringWithFormat:@"ZICBDYCOrderNO=%@",self.dataDic[@"OrderNO"]];
            NSString *url = @"api/Customer/CancelOrder";
            
            [self showLoadding:@"正在取消" time:20];
            
            [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSObject *modelData) {
                
                NSDictionary *dataDic = (NSDictionary *)modelData;
                NSLog(@"取消订单--------%@",dataDic);
                if (isSuccess) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"BianJiOrderDetail" object:nil userInfo:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else {
                    NSString *msg  = [dataDic objectForKey:@"Msg"];
                    if (msg!=nil && ![msg isEqual:@""]) {
                        [self showMessage:msg];
                    }else{
                        [self showMessage:[NSString stringWithFormat:@"请求失败 #%d",code]];
                    }
                }
            }];
        }
    }
    else if (alertView.tag == 2000) {
            if (buttonIndex == 1) {
            NSString *params = [NSString stringWithFormat:@"ZICBDYCOrderNO=%@",self.dataDic[@"OrderNO"]];
            NSString *url = @"api/Order/DeleteOrder";
            
            [self showLoadding:@"" time:20];
            
            [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSObject *modelData) {
                
                NSDictionary *dataDic = (NSDictionary *)modelData;
                NSLog(@"删除订单--------%@",dataDic);
                if (isSuccess) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"BianJiOrderDetail" object:nil userInfo:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else {
                    NSString *msg  = [dataDic objectForKey:@"Msg"];
                    if (msg!=nil && ![msg isEqual:@""]) {
                        [self showMessage:msg];
                    }else{
                        [self showMessage:[NSString stringWithFormat:@"请求失败 #%d",code]];
                    }
                }
            }];
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0://地址信息
        {
            OrderAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderAddressCell class]) forIndexPath:indexPath];
            if (self.dataDic.count > 0) {
                [cell setDataDic:self.dataDic];
            }
            return cell;
        }
            break;
        case 1://商品数量
        {
            OrderShangPinCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderShangPinCell class]) forIndexPath:indexPath];
            
            if (self.dataDic.count > 0) {
                NSArray *array = self.dataDic[@"LstOrderDetail"];
                NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:array];
                [cell setDataAry:mutableArray];
            }
            
            return cell;
        }
            break;
        case 2://支付方式
        {
            if ([self.dataDic[@"PayTypeName"] isEqualToString:@"U币兑换"]) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
                cell.backgroundColor = [UIColor clearColor];
                return cell;
            }
            else {
                OrderFaPiaoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderFaPiaoCell" forIndexPath:indexPath];
                if (self.dataDic.count > 0) {
                    [cell setDataDic:self.dataDic];
                }
                return cell;
            }
            
        }
            break;
        default://商品总额
        {
            OrderPriceInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderPriceInfoCell" forIndexPath:indexPath];
            if (self.dataDic.count > 0) {
                [cell setDataDic:self.dataDic];
            }
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
            if ([self.dataDic[@"PayTypeName"] isEqualToString:@"U币兑换"]) {
                return 0.0001;
            }
            else {
                if ([self.dataDic[@"IsInvoice"] integerValue] == 0) {
                    return 44;
                }
                else {
                    return 133;
                }
            }
        }
            break;
        default:
        {
            return 75;
        }
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *header = [UIView new];
    header.backgroundColor = [UIColor whiteColor];
    
    UILabel *payTypeLab = [UILabel new];
    payTypeLab.font = [UIFont systemFontOfSize:14];
    [header addSubview:payTypeLab];
    payTypeLab.sd_layout.centerYEqualToView(header).leftSpaceToView(header,10).widthIs(200).heightIs(14);
    
    UILabel *rightLab = [UILabel new];
    rightLab.font = [UIFont systemFontOfSize:14];
    rightLab.textAlignment = NSTextAlignmentRight;
    [header addSubview:rightLab];
    rightLab.sd_layout.centerYEqualToView(header).rightSpaceToView(header,10).widthIs(120).heightIs(14);
    
    if (section == 0) {
        payTypeLab.text = [NSString stringWithFormat:@"订单号 : %@",self.dataDic[@"OrderNO"]];
        rightLab.hidden = YES;
        return header;
    }
    else if (section == 1) {
        header.hidden = YES;
        return header;
    }
    else if (section == 2) {
        payTypeLab.text = @"支付方式";
        rightLab.text = self.dataDic[@"PayTypeName"];
        return header;
    }
    else {
        payTypeLab.text = @"商品总额";
        rightLab.textColor = RGB(214, 34, 25);
        if ([self.dataDic[@"PayTypeName"] isEqualToString:@"U币兑换"]) {
            rightLab.text = [NSString stringWithFormat:@"%ldU币",[self.dataDic[@"PayUAmount"] integerValue]];
        }
        else {
            rightLab.text = [NSString stringWithFormat:@"¥%@",self.dataDic[@"PayMoneyAmount"]];
        }
        return header;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 0.0001;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - 获取订单详情
- (void)getOrderDetailData {
    
    NSString *params = [NSString stringWithFormat:@"ZICBDYCOrderNO=%@",self.orderNO];
    NSString *url = @"api/Order/OrderDetail";
    [self showLoadding:@"正在加载" time:20];
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"获取订单详情 - %@", modelData);
        if (isSuccess) {

            self.dataDic = [NSMutableDictionary dictionaryWithDictionary:modelData[@"JsonData"]];
            
            NSInteger state = [self.dataDic[@"OrderState"] integerValue];
            if (state == 2) {
                self.tableView.frame = CGRectMake(0, 0, Width_Screen, Height_Screen-64);
            }
            else {
                [self setBotView];
                self.tableView.frame = CGRectMake(0, 0, Width_Screen, Height_Screen-124);
            }
            
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

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width_Screen, Height_Screen-124) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor  = BG_Color;
        _tableView.backgroundColor = BG_Color;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [_tableView registerClass:[OrderAddressCell class] forCellReuseIdentifier:NSStringFromClass([OrderAddressCell class])];
        [_tableView registerClass:[OrderShangPinCell class] forCellReuseIdentifier:NSStringFromClass([OrderShangPinCell class])];
        [_tableView registerNib:[UINib nibWithNibName:@"OrderFaPiaoCell" bundle:nil] forCellReuseIdentifier:@"orderFaPiaoCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"OrderPriceInfoCell" bundle:nil] forCellReuseIdentifier:@"orderPriceInfoCell"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}
- (UIView *)botView {
    if (!_botView) {
        _botView = [UIView new];
        _botView.backgroundColor = [UIColor whiteColor];
        _botView.layer.shadowColor = RGB(100, 100, 100).CGColor;//阴影颜色
        _botView.layer.shadowOffset = CGSizeMake(0 , 1);//偏移距离
        _botView.layer.shadowOpacity = 0.5;//不透明度
        _botView.layer.shadowRadius = 3.0;//半径
    }
    return _botView;
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
