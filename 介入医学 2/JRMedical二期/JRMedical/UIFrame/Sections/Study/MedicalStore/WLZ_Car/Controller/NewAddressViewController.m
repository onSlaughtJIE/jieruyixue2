//
//  NewAddressViewController.m
//  JRMedical
//
//  Created by apple on 16/6/23.
//  Copyright © 2016年 ZC. All rights reserved.
//

#import "NewAddressViewController.h"

@interface NewAddressViewController () <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTf;
@property (weak, nonatomic) IBOutlet UITextField *telTF;
@property (weak, nonatomic) IBOutlet UITextField *CityTf;
@property (weak, nonatomic) IBOutlet UITextField *streetTf;
@property (weak, nonatomic) IBOutlet UITextField *detailAddressTf;


@property (strong, nonatomic) UIView *maskView;
@property (strong, nonatomic) IBOutlet UIView *pickerBgView;
@property (strong, nonatomic) IBOutlet UIPickerView *myPicker;
- (IBAction)cancle:(id)sender;
- (IBAction)ensure:(id)sender;

//data
@property (strong, nonatomic) NSDictionary *pickerDic;
@property (strong, nonatomic) NSArray *provinceArray;
@property (strong, nonatomic) NSArray *cityArray;
@property (strong, nonatomic) NSArray *townArray;
@property (strong, nonatomic) NSArray *selectedArray;

- (IBAction)saveBtn:(id)sender;

@end

@implementation NewAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"_fromNumber - %ld", (long)_fromNumber);
    NSLog(@"_AddressID - %ld", (long)_AddressID);
    if (_fromNumber == 2333) {
        [self initView];
        self.title = @"编辑收货地址";
    }else {
        self.title = @"新增收货地址";

    }
    
    self.CityTf.delegate = self;
    self.CityTf.tag = 1001;
    self.telTF.delegate = self;
    self.nameTf.delegate = self;
    self.streetTf.delegate = self;
    self.detailAddressTf.delegate = self;
    
    [self.CityTf addTarget:self action:@selector(selectAddress:) forControlEvents:UIControlEventTouchDown];
    
    [self getPickerData];

    [self setPickerView];
    
}
// 编辑进来,页面初始化
- (void)initView {
    _nameTf.text = _addressModel.ConsigneeName;
    _telTF.text = _addressModel.Consigneephone;
    _detailAddressTf.text = _addressModel.DetailAddress;
    _CityTf.text = _addressModel.City;
    _streetTf.text = _addressModel.Subdistrict;
    
}

// 初始化pickerView
- (void)setPickerView {
    
    self.maskView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0;
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMyPicker)]];
    
    self.pickerBgView.width = Width_Screen;
    self.pickerBgView.top = self.view.frame.size.height;
    
    self.myPicker.delegate = self;
    self.myPicker.dataSource = self;

    
}

- (void)hideMyPicker {
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0;
        self.pickerBgView.top = self.view.frame.size.height;
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        [self.pickerBgView removeFromSuperview];
    }];
}

- (void)selectAddress:(UITextField *)sender {
    
    [self.view endEditing:YES];
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.pickerBgView];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0.3;
        self.pickerBgView.bottom = self.view.frame.size.height;
    }];
    
}

// pickerView 取消 确定
- (IBAction)cancle:(id)sender {
    
    [self hideMyPicker];
}

- (IBAction)ensure:(id)sender {
    
    self.CityTf.text = [NSString stringWithFormat:@"%@ %@ %@", [self.provinceArray objectAtIndex:[self.myPicker selectedRowInComponent:0]], [self.cityArray objectAtIndex:[self.myPicker selectedRowInComponent:1]], [self.townArray objectAtIndex:[self.myPicker selectedRowInComponent:2]]];
    
    [self hideMyPicker];
}

- (IBAction)saveBtn:(id)sender {
    
    [SVProgressHUD show];
    
    /*
    NSString *url = [[NSString alloc] init];
    NSString *datasStr = [[NSString alloc] init];
    if (_fromNumber == 2333) {
        url = [NSString stringWithFormat:@"%@/API/MallsInfo/EditReceiptAddress", UrlStr];
        datasStr = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@ZICBDYCProvince=%@ZICBDYCCity=%@ZICBDYCCounty=%@ZICBDYCSubdistrict=%@ZICBDYCDetailAddress=%@ZICBDYCConsigneeName=%@ZICBDYCConsigneephone=%@ZICBDYCOrderIndex=%@ZICBDYCID=%ld", kPrefixPara, UserDefaultsGet(kDevIdentityInfo), kDevSysInfo, kDevTypeInfo, kIMEI, _CityTf.text, _CityTf.text, _CityTf.text, _streetTf.text, _detailAddressTf.text, _nameTf.text, _telTF.text, @1, (long)_AddressID, nil];
        
    }else {
        url = [NSString stringWithFormat:@"%@/API/MallsInfo/AddReceiptAddress", UrlStr];
        datasStr = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@ZICBDYCProvince=%@ZICBDYCCity=%@ZICBDYCCounty=%@ZICBDYCSubdistrict=%@ZICBDYCDetailAddress=%@ZICBDYCConsigneeName=%@ZICBDYCConsigneephone=%@ZICBDYCOrderIndex=%@", kPrefixPara, UserDefaultsGet(kDevIdentityInfo), kDevSysInfo, kDevTypeInfo, kIMEI, _CityTf.text, _CityTf.text, _CityTf.text, _streetTf.text, _detailAddressTf.text, _nameTf.text, _telTF.text, @1, nil];
    }
    
    NSString *DataEncrypt = [TWDes encryptWithContent:datasStr type:kDesType key:kDesKey];
    
    // 调接口需要的两个参数
    NSDictionary *paraDic = @{kAccessTokenInfo:UserDefaultsGet(kAccessTokenInfo), kDatas:DataEncrypt};
    
    [Tool postWithPath:url params:paraDic success:^(id JSON) {
        // NSLog(@" // 收货地址添加 --  %@", JSON);
        if ([JSON[@"Success"] integerValue] == 1) {

            if (_fromNumber == 2333) {
                [SVProgressHUD dismissWithSuccess:@"编辑收货地址成功"];
                _fromNumber = 0;
                
                [self.navigationController popViewControllerAnimated:YES];
                
            } else {
                 [SVProgressHUD dismissWithSuccess:@"添加收货地址成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }else {
            [SVProgressHUD dismissWithError:JSON[@"Msg"]];
          
        }
    
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
         NSLog(@"error - %@", error);
    }];
     
     */
}



#pragma mark - get data
- (void)getPickerData {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"];
    self.pickerDic = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.provinceArray = [self.pickerDic allKeys];
    self.selectedArray = [self.pickerDic objectForKey:[[self.pickerDic allKeys] objectAtIndex:0]];
    
    if (self.selectedArray.count > 0) {
        self.cityArray = [[self.selectedArray objectAtIndex:0] allKeys];
    }
    
    if (self.cityArray.count > 0) {
        self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:0]];
    }
    
//    NSLog(@"省 - %@", self.provinceArray);
//    NSLog(@"市 - %@", self.cityArray);
//    NSLog(@"区 - %@", self.townArray);
    
    
}

#pragma mark - UIPicker Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinceArray.count;
    } else if (component == 1) {
        return self.cityArray.count;
    } else {
        return self.townArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [self.provinceArray objectAtIndex:row];
    } else if (component == 1) {
        return [self.cityArray objectAtIndex:row];
    } else {
        return [self.townArray objectAtIndex:row];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return 110;
    } else if (component == 1) {
        return 100;
    } else {
        return 110;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.selectedArray = [self.pickerDic objectForKey:[self.provinceArray objectAtIndex:row]];
        if (self.selectedArray.count > 0) {
            self.cityArray = [[self.selectedArray objectAtIndex:0] allKeys];
        } else {
            self.cityArray = nil;
        }
        if (self.cityArray.count > 0) {
            self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:0]];
        } else {
            self.townArray = nil;
        }
    }
    [pickerView selectedRowInComponent:1];
    [pickerView reloadComponent:1];
    [pickerView selectedRowInComponent:2];
    
    if (component == 1) {
        if (self.selectedArray.count > 0 && self.cityArray.count > 0) {
            self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:row]];
        } else {
            self.townArray = nil;
        }
        [pickerView selectRow:1 inComponent:2 animated:YES];
    }
    
    [pickerView reloadComponent:2];
}


#pragma mark - UITextFiled Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (textField.tag == 1001) {
        return NO;
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
