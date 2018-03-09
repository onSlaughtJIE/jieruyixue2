//
//  AddNewAddressVC.m
//  JRMedical
//
//  Created by a on 16/12/16.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "AddNewAddressVC.h"
#import "AddNewAddressCell.h"
#import "IQKeyboardManager.h"
#import "AddressViewController.h"

@interface AddNewAddressVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation AddNewAddressVC {
    
    UITextField *_xingMingTF;
    UITextField *_phoneTF;
    UITextField *_diQuTF;
    UITextField *_detailAddressTF;
    
    NSString *_province;
    NSString *_city;
    NSString *_area;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"selectAddressNotification" object:nil];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.from == 1000) {
        self.title = @"编辑收货地址";
    }
    else {
        self.title = @"新建收货地址";
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarButtonItemClick)];
    
    //选择地址后的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectAddressNotificationClick:) name:@"selectAddressNotification" object:nil];
    
    [self.view addSubview:self.tableView];
}

- (void)selectAddressNotificationClick:(NSNotification *)sender {
    
    _province = sender.userInfo[@"ProvinceAddress"];
    _city = sender.userInfo[@"CityAddress"];
    _area = sender.userInfo[@"AreaAddress"];
    
    if ([_province isEqualToString:_city]) {
        _diQuTF.text = [NSString stringWithFormat:@"%@%@",_province,_area];
    }
    else {
        _diQuTF.text = [NSString stringWithFormat:@"%@%@%@",_province,_city,_area];
    }
}

#pragma mark - 保存信息
- (void)rightBarButtonItemClick {
    
    [_xingMingTF endEditing:YES];
    [_phoneTF endEditing:YES];
    [_detailAddressTF endEditing:YES];
    
    if ([_xingMingTF.text isEqualToString:@""]) {
        return [self showMessage:@"请输入您的真实姓名"];
    }
    if ([_phoneTF.text isEqualToString:@""]) {
        return [self showMessage:@"请输入您的手机号码"];
    }
    if ([_diQuTF.text isEqualToString:@""]) {
        return [self showMessage:@"请选择您的所在地区"];
    }
    if ([_detailAddressTF.text isEqualToString:@""]) {
        return [self showMessage:@"请输入您的详细地址"];
    }
    
    if ([_province isEqualToString:_city]) {
        _city = @"";
    }
    
    NSString *url;
    NSString *params;
    if (self.from == 1000) {//修改
        url = @"api/MallsInfo/EditReceiptAddress";
        params = [NSString stringWithFormat:@"ZICBDYCID=%@ZICBDYCProvince=%@ZICBDYCCity=%@ZICBDYCCounty=%@ZICBDYCSubdistrict=%@ZICBDYCDetailAddress=%@ZICBDYCConsigneeName=%@ZICBDYCConsigneephone=%@ZICBDYCOrderIndex=%@",self.model.ID,_province,_city,_area,@"",_detailAddressTF.text,_xingMingTF.text,_phoneTF.text,@"0"];
    }
    else {//新加
        url = @"api/MallsInfo/AddReceiptAddress";
        params = [NSString stringWithFormat:@"ZICBDYCProvince=%@ZICBDYCCity=%@ZICBDYCCounty=%@ZICBDYCSubdistrict=%@ZICBDYCDetailAddress=%@ZICBDYCConsigneeName=%@ZICBDYCConsigneephone=%@ZICBDYCOrderIndex=%@",_province,_city,_area,@"",_detailAddressTF.text,_xingMingTF.text,_phoneTF.text,@"0"];
    }

    [self showLoadding:@"正在保存" time:20];
    
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"保存用户信息请求返回数据--------%@",modelData);
        if (isSuccess) {
            NSString *message = nil;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"保存成功"
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
            }else{
                [self showMessage:[NSString stringWithFormat:@"请求失败 #%d",code]];
            }
        }
    }];
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addReceiptAddress" object:nil userInfo:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor  = RGB(230, 230, 230);
        _tableView.backgroundColor = BG_Color;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [_tableView registerClass:[AddNewAddressCell class] forCellReuseIdentifier:NSStringFromClass([AddNewAddressCell class])];
    }
    return  _tableView;
}

#pragma mark - Table view datasource and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AddNewAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AddNewAddressCell class]) forIndexPath:indexPath];

    [cell setIndexPath:indexPath];
    
    if (self.from == 1000) {
        [cell setModel:self.model];
        
        _province = self.model.Province;//编辑修改时复制  非新加
        _city = self.model.City;
        _area = self.model.County;
        
    }
    
    cell.rightTF.delegate = self;
    
    switch (indexPath.row) {
        case 0:
            _xingMingTF = cell.rightTF;
            break;
        case 1:
            _phoneTF = cell.rightTF;
            break;
        case 2:
            _diQuTF = cell.rightTF;
            break;
        case 3:
            _detailAddressTF = cell.rightTF;
            break;
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        AddressViewController *selectAddressVC = [AddressViewController new];
        UINavigationController *naVC = [[UINavigationController alloc]initWithRootViewController:selectAddressVC];
        [self presentViewController:naVC animated:YES completion:nil];
    }
}

#pragma mark - UITextFildDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
