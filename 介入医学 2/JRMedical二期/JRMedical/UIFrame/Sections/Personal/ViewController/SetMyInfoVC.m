//
//  SetMyInfoVC.m
//  JRMedical
//
//  Created by a on 16/11/4.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "SetMyInfoVC.h"

#import "SetMyInfoCell.h"
#import "SetMyInfoCellHeaderView.h"

#import "VPImageCropperViewController.h"//图片处理类

#import "IQTextView.h"
#import "IQKeyboardManager.h"
#import "KMButton.h"
#import <YYKit.h>

#import "JRLoginViewController.h"

#define ORIGINAL_MAX_WIDTH 640.0f

@interface SetMyInfoVC ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UITextFieldDelegate,UITextViewDelegate,UIPickerViewDataSource, UIPickerViewDelegate,VPImageCropperDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (strong, nonatomic) UIPickerView *addressPicker;
@property (strong, nonatomic) UIPickerView *sexPicker;

@property (strong, nonatomic) NSMutableArray *provinceArray;
@property (strong, nonatomic) NSMutableArray *cityArray;

@end

@implementation SetMyInfoVC {
    
    UIImageView *_currUserPhotoImg;
    
    UITextField *_niChengTF;
    UITextField *_xingMingTF;
    UITextField *_xingBieTF;
    UITextField *_diQuTF;
    UITextField *_chuShengRiQiTF;
    IQTextView *_qianMingTF;
    
    UIImageView *_curID_Z_Img;
    UIImageView *_curID_F_Img;
    
    UILabel *_addrsssLab;
    UILabel *_sexLab;
    
    NSString *_provinceStr;
    NSString *_provinceID;
    NSString *_cityStr;
    NSString *_sexStr;
    NSDate *_timeDate;
    NSString *_photoAddress;
    
    NSInteger _imageType;
    
    NSString *_idcardaStr;
    NSString *_idcardbStr;
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
    self.title = @"我的资料";
    
    self.provinceArray = [NSMutableArray arrayWithCapacity:0];//省份数据源
    self.cityArray = [NSMutableArray arrayWithCapacity:0];//城市数据源
    
    {
        if ([UserInfo getUserInfoValue:@"UserPic"] != nil) {
            NSString *photo = (NSString *)[UserInfo getUserInfoValue:@"UserPic"];
            _photoAddress = photo;
        }
        else {
            _photoAddress = @"";
        }
        
        if ([UserInfo getUserInfoValue:@"IdentityPicJust"] != nil) {
            NSString *idcarda = (NSString *)[UserInfo getUserInfoValue:@"IdentityPicJust"];
            _idcardaStr = idcarda;
        }
        else {
            _idcardaStr = @"";
        }
        
        if ([UserInfo getUserInfoValue:@"IdentityPicBack"] != nil) {
            NSString *idcardb = (NSString *)[UserInfo getUserInfoValue:@"IdentityPicBack"];
            _idcardbStr = idcardb;
        }
        else {
            _idcardbStr = @"";
        }
        
        if ([UserInfo getUserInfoValue:@"Sex"] != nil) {
            NSString *sex = (NSString *)[UserInfo getUserInfoValue:@"Sex"];
            if ([sex integerValue] == 1) {
                _sexStr = @"男";
            }
            else {
                _sexStr = @"女";
            }
        }
        else {
            _sexStr = @"";
        }
        
        _provinceID = @"";
        if ([UserInfo getUserInfoValue:@"ProvinceName"] != nil) {
            NSString *province = (NSString *)[UserInfo getUserInfoValue:@"ProvinceName"];
            _provinceStr = province;
        }
        else {
            _provinceStr = @"";
        }
        
        if ([UserInfo getUserInfoValue:@"CityName"] != nil) {
            NSString *city = (NSString *)[UserInfo getUserInfoValue:@"CityName"];
            _cityStr = city;
        }
        else {
            _cityStr = @"";
        }
        
        if ([UserInfo getUserInfoValue:@"BirthDay"] != nil) {
            NSString *time = (NSString *)[UserInfo getUserInfoValue:@"BirthDay"];
            
            NSString *timeStr = [time stringByReplacingOccurrencesOfString:@"-" withString:@""];
            NSDateFormatter *dateForm = [[NSDateFormatter alloc] init];
            [dateForm setDateFormat:@"yyyyMMdd"];
            [dateForm setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] ];
            _timeDate = [dateForm dateFromString:timeStr];
            
        }
        else {
            _timeDate = nil;
        }
    }

    [self setNavBarButtonItem];//设置顶栏右侧按钮
    
    [self getProvinceData];//获取省份数据
        
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout
    .heightIs(Height_Screen-64)
    .widthIs(Width_Screen);
}

#pragma mark - 点击保存信息
- (void)navBarButtonItemClick {
    [_xingMingTF endEditing:YES];
    [_niChengTF endEditing:YES];
    [_qianMingTF endEditing:YES];
    
    NSString *sexNumStr;
    if ([_xingBieTF.text isEqualToString:@"女"]) {
        sexNumStr = @"0";
    }
    else {
        sexNumStr = @"1";
    }
    
    NSString *params = [NSString stringWithFormat:@"ZICBDYCCustomerName=%@ZICBDYCSex=%@ZICBDYCBirthDay=%@ZICBDYCSignature=%@ZICBDYCNickName=%@ZICBDYCUserPic=%@ZICBDYCIdentityPicJust=%@ZICBDYCIdentityPicBack=%@ZICBDYCProvinceName=%@ZICBDYCCityName=%@",_xingMingTF.text,sexNumStr,_chuShengRiQiTF.text,_qianMingTF.text,_niChengTF.text,_photoAddress,_idcardaStr,_idcardbStr,_provinceStr,_cityStr];
    
    NSLog(@"%@",params);
    
    NSString *url = @"api/Customer/ModifyCustomerBaseInfo";
    
    [self showLoadding:@"正在保存" time:20];
    
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"保存用户信息请求返回数据--------%@",modelData);
        if (isSuccess) {
            NSDictionary *dic = modelData[@"JsonData"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"detailViewRefresh" object:nil];
            
            NSString *message = nil;
            
            if ([dic[@"UMoney"] integerValue] > 0) {
                message = [NSString stringWithFormat:@"获得%ld个U币!", (long)[dic[@"UMoney"] integerValue]];
            }
            
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
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view datasource and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SetMyInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SetMyInfoCell class]) forIndexPath:indexPath];
    [cell setIndexPath:indexPath];
    
    cell.rightTF.delegate = self;
    cell.rightTV.delegate = self;
    
    switch (indexPath.row) {
        case 0:
            _niChengTF = cell.rightTF;
            break;
        case 1:
            _xingMingTF = cell.rightTF;
            break;
        case 2:
        {
            _xingBieTF = cell.rightTF;
        }
            break;
        case 3:
        {
            _diQuTF = cell.rightTF;
        }
            break;
        case 4:
        {
            _chuShengRiQiTF = cell.rightTF;
        }
            break;
        case 5:
            _qianMingTF = cell.rightTV;
            break;
        case 6:
        {
            
            [cell.id_Z_Img bk_whenTapped:^{
                
                [_xingMingTF endEditing:YES];
                [_niChengTF endEditing:YES];
                [_qianMingTF endEditing:YES];
                
                _curID_Z_Img = cell.id_Z_Img;
                //身份证正面
                [self selectImageAlertController:200];
            }];
            [cell.id_F_Img bk_whenTapped:^{
                
                [_xingMingTF endEditing:YES];
                [_niChengTF endEditing:YES];
                [_qianMingTF endEditing:YES];
                
                _curID_F_Img = cell.id_F_Img;
                //身份证反面
                [self selectImageAlertController:300];
            }];
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 5) {
        return 120;
    }
    else if (indexPath.row == 6) {
        return 120;
    }
    else {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 151;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 2:
            [self selectSexClick];//性别
            break;
        case 3:
            [self selectAddressClick];//地址
            break;
        case 4:
            [self selectDateClick];//出生年月
            break;
        default:
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    SetMyInfoCellHeaderView *headerView = [[SetMyInfoCellHeaderView alloc] initWithFrame:self.tableView.tableHeaderView.frame];
    
    NSString *userDic = (NSString *)[UserInfo getUserInfoValue:@"UserPic"];
    
    if ([Utils isBlankString:userDic] == NO) {
        [headerView.userPhotoImg sd_setImageWithURL:[NSURL URLWithString:userDic] placeholderImage:[UIImage imageNamed:@"mtou"]];
    }

    [headerView.userPhotoImg bk_whenTapped:^{
        
        [_xingMingTF endEditing:YES];
        [_niChengTF endEditing:YES];
        [_qianMingTF endEditing:YES];
        
        _currUserPhotoImg = headerView.userPhotoImg;
        
        [self selectImageAlertController:100];
    }];
    
    return headerView;
}

- (void)selectImageAlertController:(NSInteger)tag {
    
    _imageType = tag;
    
    NSString *titleStr = @"";
    
    if (tag == 100) {
        titleStr = @"请选择头像更换方式";
    }
    else if (tag == 200) {
        titleStr = @"请选择身份证照片更换方式";
    }
    else {
        titleStr = @"请选择身份证照片更换方式";
    }
    
    //设置头像
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:titleStr message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                if (tag == 100) {
                    controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
                }
                else {
                    controller.cameraDevice = UIImagePickerControllerCameraDeviceRear;
                }
                
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
    }];
    
    UIAlertAction *cancelAction2 = [UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
    }];
    
    UIAlertAction *cancelAction3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:cancelAction];
    [alertController addAction:cancelAction2];
    [alertController addAction:cancelAction3];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - 选择出生年月
- (void)selectDateClick {

    UIDatePicker *picker = [[UIDatePicker alloc]init];
    picker.datePickerMode = UIDatePickerModeDate;
    
    if (_timeDate != nil) {
        picker.date = _timeDate;
    }
    else {
        NSDate *date = [NSDate date];
        picker.date = date;
    }

    picker.frame = CGRectMake(0, 40, Width_Screen-20, 200);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSDate *date = picker.date;
        
        _chuShengRiQiTF.text = [date stringWithFormat:@"yyyy-MM-dd"];
        
    }];
    
    UIAlertAction *cancelAction2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController.view addSubview:picker];
    
    [alertController addAction:cancelAction];
    [alertController addAction:cancelAction2];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - 选择地址
- (void)selectAddressClick {
    
    if (self.provinceArray.count > 0) {
        if ([_provinceStr isEqualToString:@""]) {
            NSDictionary *provinceData = self.provinceArray[0];
            _provinceStr = provinceData[@"Name"];
            _provinceID = provinceData[@"ID"];
            [self.addressPicker selectRow:0 inComponent:0 animated:YES];
            [self getCityData:provinceData[@"ID"]];
        }
        else {
            [self getCityData:_provinceID];
        }
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        _diQuTF.text = [NSString stringWithFormat:@"%@ %@",_provinceStr,_cityStr];
    }];
    
    UIAlertAction *cancelAction2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController.view addSubview:self.addressPicker];
    
    [alertController addAction:cancelAction];
    [alertController addAction:cancelAction2];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - 选择性别
- (void)selectSexClick {
    
    if ([_sexStr isEqualToString:@"男"] || [_sexStr isEqualToString:@""]) {
        [self.sexPicker selectRow:0 inComponent:0 animated:YES];
    }
    else {
        [self.sexPicker selectRow:1 inComponent:0 animated:YES];
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        _xingBieTF.text = _sexStr;
    }];
    
    UIAlertAction *cancelAction2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController.view addSubview:self.sexPicker];
    
    [alertController addAction:cancelAction];
    [alertController addAction:cancelAction2];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UIPicker Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (pickerView == self.addressPicker) {
        return 2;
    }
    else {
        return 1;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == self.addressPicker) {
        if (component == 0) {
            return self.provinceArray.count;
        }
        else {
            return self.cityArray.count;
        }
    }
    else {
        return 2;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row
          forComponent:(NSInteger)component reusingView:(UIView *)view {

    if (pickerView == self.addressPicker) {
        _addrsssLab = view ? (UILabel *) view : [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 150.0f, 25.0f)];
        _addrsssLab.backgroundColor = [UIColor clearColor];
        _addrsssLab.textAlignment = NSTextAlignmentCenter;
        [_addrsssLab setFont:[UIFont boldSystemFontOfSize:16]];
        if (component == 0) {
            NSDictionary *provinceData = self.provinceArray[row];
            _addrsssLab.text = provinceData[@"Name"];
        }
        else {
            NSDictionary *provinceData = self.cityArray[row];
            _addrsssLab.text = provinceData[@"Name"];
        }
        return _addrsssLab;
    }
    else {
        _sexLab = view ? (UILabel *) view : [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 30.0f)];
        _sexLab.backgroundColor = [UIColor clearColor];
        _sexLab.textAlignment = NSTextAlignmentCenter;
        [_sexLab setFont:[UIFont boldSystemFontOfSize:20]];
        if (row == 0) {
            _sexLab.text = @"男";
        }
        else {
            _sexLab.text = @"女";
        }
        return _sexLab;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 150;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (pickerView == self.addressPicker) {
        if (component == 0) {
            NSDictionary *provinceData = self.provinceArray[row];
            _provinceStr = provinceData[@"Name"];
            [self getCityData:provinceData[@"ID"]];
        }
        else {
            NSDictionary *cityData = self.cityArray[row];
            _cityStr = cityData[@"Name"];
        }
    }
    else {
        if (row == 0) {
            _sexStr = @"男";
        }
        else {
            _sexStr = @"女";
        }
    }
}

#pragma mark - 获取省份数据
- (void)getProvinceData {
    
    NSString *params = @"";
    NSString *url = @"api/System/SysProvince";
    
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"获取省份 - %@", modelData);
        if (isSuccess) {
            [self.provinceArray removeAllObjects];
            
            NSArray *dataAry = modelData[@"JsonData"];
            
            self.provinceArray  = [NSMutableArray arrayWithArray:dataAry];
            
            [self.addressPicker reloadComponent:0];
            
            if ([_provinceStr isEqualToString:@""]) {
                NSDictionary *provinceData = self.provinceArray[0];
                _provinceStr = provinceData[@"Name"];
                _provinceID = provinceData[@"ID"];
            }
            else {
                for (int i = 0 ; i < self.provinceArray.count ; i ++) {
                    NSDictionary *provinceData = self.provinceArray[i];
                    if ([provinceData[@"Name"] isEqualToString:_provinceStr]) {
                        _provinceID = provinceData[@"ID"];
                        [self.addressPicker selectRow:i inComponent:0 animated:YES];
                    }
                }
            }
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

#pragma mark - 获取城市数据
- (void)getCityData:(NSString *)provinceID {
    
    NSString *params = [NSString stringWithFormat:@"ZICBDYCProvinceID=%@",provinceID];
    NSString *url = @"api/System/SysCity";
    
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"获取城市 - %@", modelData);
        if (isSuccess) {
            [self.cityArray removeAllObjects];
            self.cityArray  = [NSMutableArray arrayWithArray:modelData[@"JsonData"]];
            
            [self.addressPicker reloadComponent:1];
            
            if (self.cityArray.count > 0) {
                if ([_cityStr isEqualToString:@""]) {
                    NSDictionary *cityData = self.cityArray[0];
                    _cityStr = cityData[@"Name"];
                }
                else {
                    
                    NSString *curCity = _cityStr;
                    
                    for (int i = 0 ; i < self.cityArray.count ; i ++) {
                        NSDictionary *cityData = self.cityArray[i];
                        
                        if ([cityData[@"Name"] isEqualToString:curCity]) {
                            _cityStr = cityData[@"Name"];
                            return [self.addressPicker selectRow:i inComponent:1 animated:YES];
                        }
                        else {
                            NSDictionary *cityData = self.cityArray[0];
                            _cityStr = cityData[@"Name"];
                            [self.addressPicker selectRow:0 inComponent:1 animated:YES];
                        }
                    }
                }
            }
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
- (UIPickerView *)addressPicker {
    if (!_addressPicker) {
        _addressPicker = [UIPickerView new];
        _addressPicker.showsSelectionIndicator=YES;
        _addressPicker.dataSource = self;
        _addressPicker.delegate = self;
        _addressPicker.frame = CGRectMake(0, 40, Width_Screen-20, 200);
    }
    return  _addressPicker;
}

- (UIPickerView *)sexPicker {
    if (!_sexPicker) {
        _sexPicker = [UIPickerView new];
        _sexPicker.showsSelectionIndicator=YES;
        _sexPicker.dataSource = self;
        _sexPicker.delegate = self;
        _sexPicker.frame = CGRectMake(0, 40, Width_Screen-20, 120);
    }
    return  _sexPicker;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor  = RGB(230, 230, 230);
        _tableView.backgroundColor = BG_Color;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [_tableView registerClass:[SetMyInfoCell class] forCellReuseIdentifier:NSStringFromClass([SetMyInfoCell class])];
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
    [imgBtn setTitle:@"保存" forState:UIControlStateNormal];
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

#pragma mark - 更新用户头像
#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    
    switch (_imageType) {
        case 100:
            _currUserPhotoImg.image = editedImage;
            break;
        case 200:
            _curID_Z_Img.image = editedImage;
            break;
        case 300:
            _curID_F_Img.image = editedImage;
            break;
        default:
            break;
    }
    
    NSData *imageData = UIImageJPEGRepresentation(editedImage, 0.01);
    NSString *strBase64 = [imageData base64EncodedString];
    
    NSString *url = [NSString stringWithFormat:@"%@Public/UploadImg",Server_Web_Url];
    NSString *paraStr = kTotalEncryptionInfo(@"");
    NSString *Datas = [TWDes encryptWithContent:paraStr type:kDesType key:kDesKey];
    NSString *token = [UserInfo getAccessToken];
    // 调接口需要的两个参数
    NSDictionary *paraDic = @{@"Token":token, kDatas:Datas,@"ImgBase64":strBase64};
    
    [self showLoadding:@"" time:20];
    
    [HYBNetworking configRequestType:kHYBRequestTypePlainText];
    [HYBNetworking postWithUrl:url
                        params:paraDic
                       success:^(id response) {
                           
                           [self.hud hide:YES];
                           
                           NSDictionary *responseObject = response;
                           
                           NSLog(@"提交图片 - responseObject - %@---%@", responseObject, responseObject[@"Msg"]);
                           
                           if ([responseObject[@"Success"] integerValue] == 1) {

                               NSDictionary *dic = responseObject[@"JsonData"];
                               
                               switch (_imageType) {
                                   case 100:
                                   {
                                       _photoAddress = dic[@"ImgUri"];
                                       [_currUserPhotoImg  sd_setImageWithURL:[NSURL URLWithString:dic[@"WebSiteUri"]] placeholderImage:[UIImage imageNamed:@"mtou"]];
                                   }
                                       break;
                                   case 200:
                                   {
                                       _idcardaStr = dic[@"ImgUri"];
                                       [_curID_Z_Img sd_setImageWithURL:[NSURL URLWithString:dic[@"WebSiteUri"]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
                                   }
                                       break;
                                   case 300:
                                   {
                                       _idcardbStr = dic[@"ImgUri"];
                                       [_curID_F_Img sd_setImageWithURL:[NSURL URLWithString:dic[@"WebSiteUri"]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
                                   }
                                       break;
                                   default:
                                       break;
                               }
                           }
                           else {
                               [self showMessage:responseObject[@"Msg"]];
                               
                               if ([responseObject[@"Code"] integerValue] == 3) {
                                   
                                   [UserInfo removeAccessToken];//移除token
                                   [UserInfo removeDevIdentity];//移除单点登录
                                   NSUserDf_Set(kNoLogin,JRIsLogin);//修改登录状态
                                   NSUserDf_Remove(kDoctor);//移除是否是医师信息
                                   [UserInfo removeUserInfo];//移除用户信息
                                   EMError *error = [[EMClient sharedClient] logout:YES];
                                   if (!error) {
                                       NSLog(@"环信退出成功");
                                   }
                                   NSUserDf_Set(nil, kHXName);
                                   NSUserDf_Set(nil, kHXPwd);
                                   dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5/*延迟执行时间*/ * NSEC_PER_SEC));
                                   dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                                       JRLoginViewController *loginVC = [[JRLoginViewController alloc] init];
                                       loginVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                                       [self presentViewController:loginVC animated:YES completion:nil];
                                   });
                                   
                                   return ;
                               }
                           }
                       }
                          fail:^(NSError *error) {
                              NSLog(@"%@",error);
                              [self showMessage:@"服务器开小差了~请稍后再试"];
                          }];
    
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // present the cropper view controller
        VPImageCropperViewController *imgCropperVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgCropperVC.delegate = self;
        [self presentViewController:imgCropperVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
