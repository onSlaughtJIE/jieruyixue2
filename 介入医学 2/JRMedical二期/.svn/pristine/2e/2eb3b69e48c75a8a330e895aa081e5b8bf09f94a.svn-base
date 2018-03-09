//
//  MedicineRegistrationVC.m
//  JRMedical
//
//  Created by a on 16/12/6.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "MedicineRegistrationVC.h"
#import "KMButton.h"
#import "MedicineRegistrationCell.h"
#import "IQKeyboardManager.h"

@interface MedicineRegistrationVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MedicineRegistrationVC {
    
    UITextField *_phoneTF;
    UITextField *_nameTF;
    UITextField *_yiYuanTF;
    UITextField *_keShiTF;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    [_phoneTF endEditing:YES];
    [_nameTF endEditing:YES];
    [_yiYuanTF endEditing:YES];
    [_keShiTF endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"会议报名";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftAction:)];
    
    [self setNavBarButtonItem];//设置顶栏右侧按钮
    
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout.heightIs(Height_Screen-64).widthIs(Width_Screen);
}

#pragma mark - 点击返回键
- (void)leftAction:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 点击保存信息
- (void)navBarButtonItemClick {
    
    [_phoneTF endEditing:YES];
    [_nameTF endEditing:YES];
    [_yiYuanTF endEditing:YES];
    [_keShiTF endEditing:YES];
    
    if ([_nameTF.text isEqualToString:@""] || _nameTF.text == nil) {
        return [self showMessage:@"请输入真实姓名"];
    }
    
    if ([_phoneTF.text isEqualToString:@""] || _phoneTF.text == nil) {
        return [self showMessage:@"请输入手机号码"];
    }
    
    if ([_yiYuanTF.text isEqualToString:@""] || _yiYuanTF.text == nil) {
        _yiYuanTF.text = @"";
    }
    
    if ([_keShiTF.text isEqualToString:@""] || _keShiTF.text == nil) {
        _keShiTF.text = @"";
    }
    
    NSString *registUrl = @"api/News/AddMedicalCongressEnroll";
    NSString *datasStr = [NSString stringWithFormat:@"ZICBDYCMedicalCongressID=%@ZICBDYCPhone=%@ZICBDYCName=%@ZICBDYCHospital=%@ZICBDYCDepartment=%@", self.ID,_phoneTF.text, _nameTF.text, _yiYuanTF.text,_keShiTF.text, nil];
    
    [self showLoadding:@"正在提交" time:20];
    [self loadDataApi:registUrl withParams:datasStr block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"提交报名 - %@", modelData);
        if (isSuccess) {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"报名成功" message:@"" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"baoMingChengGong" object:nil userInfo:nil];
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertVC addAction:action];
            [self presentViewController:alertVC animated:YES completion:nil];
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

#pragma mark - Table view datasource and delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MedicineRegistrationCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MedicineRegistrationCell class]) forIndexPath:indexPath];
    [cell setIndexPath:indexPath];
    
    cell.rightTF.delegate = self;
    
    switch (indexPath.row) {
        case 0:
            cell.rightTF.text = (NSString *)[UserInfo getUserInfoValue:@"CustomerName"];
            _nameTF = cell.rightTF;
            break;
        case 1:
            cell.rightTF.text = (NSString *)[UserInfo getUserInfoValue:@"Phone"];
            _phoneTF = cell.rightTF;
            break;
        case 2:
            cell.rightTF.text = (NSString *)[UserInfo getUserInfoValue:@"HospitalName"];
            _yiYuanTF = cell.rightTF;
            break;
        case 3:
            cell.rightTF.text = (NSString *)[UserInfo getUserInfoValue:@"DepartmentName"];
            _keShiTF = cell.rightTF;
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
    return 0.0001;
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
        [_tableView registerClass:[MedicineRegistrationCell class] forCellReuseIdentifier:NSStringFromClass([MedicineRegistrationCell class])];
    }
    return  _tableView;
}

#pragma mark - 设置顶栏右侧按钮
- (void)setNavBarButtonItem {
    
    KMButton *imgBtn = [KMButton buttonWithType:UIButtonTypeSystem];
    imgBtn.spacing = 5;
    imgBtn.kMButtonType = KMButtonLeft;
    imgBtn.size = CGSizeMake(65, 44);
    imgBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [imgBtn setTitle:@"提交" forState:UIControlStateNormal];
    [imgBtn setImage:[UIImage imageNamed:@"fatiez"] forState:UIControlStateNormal];
    [imgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [imgBtn setTintColor:[UIColor whiteColor]];
    [imgBtn addTarget:self action:@selector(navBarButtonItemClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imgBtn];
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
