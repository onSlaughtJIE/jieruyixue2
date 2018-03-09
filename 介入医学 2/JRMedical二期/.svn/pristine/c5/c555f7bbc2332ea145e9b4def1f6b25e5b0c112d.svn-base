//
//  JRRegistViewController.m
//  JRMedical
//
//  Created by apple on 16/5/11.
//  Copyright © 2016年 ZC. All rights reserved.
//

#import "JRRegistViewController.h"
#import "HTMLViewController.h"

#import "IQKeyboardManager.h"

@interface JRRegistViewController ()<UITextFieldDelegate>
{
    NSTimer * _timer ;
    NSInteger  _secondsCountDown;
    BOOL _isAgree;
    NSString *_baseString;
    NSString *_base64ImageID;
    NSString *_SmsCode;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tiJiaoBtnTopHeight;

@property (weak, nonatomic) IBOutlet UILabel *agreeLab;
@property (weak, nonatomic) IBOutlet UIButton *agreeRedLab;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *picCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *picCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTF;
@property (weak, nonatomic) IBOutlet UITextField *passWordTF;
@property (weak, nonatomic) IBOutlet UITextField *ensurePassTF;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *yaoQingCodeTF;

- (IBAction)agreeBtnClick:(id)sender; // 同意隐私协议
- (IBAction)sendCodeBtnClick:(id)sender; // 发送验证码
- (IBAction)registBtnClick:(id)sender; // 注册
- (IBAction)xieyiBtnClick:(id)sender;
- (IBAction)picCodeClick:(id)sender;

@end

@implementation JRRegistViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    [self.phoneTF endEditing:YES];
    [self.picCodeTF endEditing:YES];
    [self.verifyCodeTF endEditing:YES];
    [self.passWordTF endEditing:YES];
    [self.ensurePassTF endEditing:YES];
    [self.yaoQingCodeTF endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BG_Color;
    
    _SmsCode =@"000000";

    if ([self.navigationItem.title isEqualToString:@"忘记密码"] || [self.navigationItem.title isEqualToString:@"修改密码"]) {
        [_registBtn setTitle:@"提交" forState:(UIControlStateNormal)];
        
        self.agreeLab.hidden = YES;
        self.agreeRedLab.hidden = YES;
        self.agreeBtn.hidden = YES;
        self.yaoQingCodeTF.hidden = YES;
        
        self.tiJiaoBtnTopHeight.constant = -20.f;
    }

    [self initDelegateAndOther];
    
    // 获取图片密码
    [self getPicCodeFromNet];
}

- (void)getPicCodeFromNet {
    
    NSString *getUrlStr = @"api/Public/GetImageCode";
    
    [BaseNetwork getLoadDataApi:getUrlStr block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"获取图片密码 - %@", modelData);
        if (isSuccess) {
        
            NSDictionary *jsonData = modelData[@"JsonData"];
            _baseString = jsonData[@"Base64StringImage"];
            _base64ImageID = jsonData[@"ImgID"];
            NSLog(@"_base64ImageID - %@", _base64ImageID);
            NSData *decodedImageData = [[NSData alloc] initWithBase64EncodedString:_baseString options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *decodedImage    = [UIImage imageWithData:decodedImageData];
            [self.picCodeBtn setBackgroundImage:decodedImage forState:(UIControlStateNormal)];
            
            
        }
        else {
            
            if (code == 999) {
                NSLog(@"服务器错误 code = 999");
                [self showMessage:@"服务器错误!"];
                return ;
            }
            
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

//设置 textfield 代理
- (void)initDelegateAndOther {
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_back"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftBarButtonItemClick)];
    
    [_phoneTF addTarget:self action:@selector(limitTextlength:) forControlEvents:UIControlEventEditingChanged];
    
    [_sendCodeBtn setUserInteractionEnabled:NO];
    [_sendCodeBtn setBackgroundColor:[UIColor lightGrayColor]];
    
    [_registBtn setUserInteractionEnabled:NO];
    [_registBtn setBackgroundColor:[UIColor lightGrayColor]];
    
    [_agreeBtn setImage:[[UIImage imageNamed:@"dui-on"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:(UIControlStateNormal)];
    _isAgree = YES;
    
    _phoneTF.delegate = self;
    _verifyCodeTF.delegate = self;
    _picCodeTF.delegate = self;
    _passWordTF.delegate = self;
    _ensurePassTF.delegate = self;
    _yaoQingCodeTF.delegate = self;
    
    _phoneTF.returnKeyType = UIReturnKeyDone;
    _phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    
    _verifyCodeTF.returnKeyType = UIReturnKeyDone;
    _verifyCodeTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _verifyCodeTF.keyboardType = UIKeyboardTypeNumberPad;
    
    _picCodeTF.returnKeyType = UIReturnKeyDone;
    _picCodeTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _picCodeTF.keyboardType = UIKeyboardTypeNumberPad;
    
    _passWordTF.returnKeyType = UIReturnKeyDone;
    _passWordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passWordTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    _ensurePassTF.returnKeyType = UIReturnKeyDone;
    _ensurePassTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _ensurePassTF.returnKeyType = UIKeyboardTypeNumbersAndPunctuation;
    
    _yaoQingCodeTF.returnKeyType = UIReturnKeyDone;
    _yaoQingCodeTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _yaoQingCodeTF.returnKeyType = UIKeyboardTypeNumbersAndPunctuation;
}

#pragma mark - Btn Action
#pragma mark - 协议书
- (IBAction)xieyiBtnClick:(id)sender {
    HTMLViewController * htmlVC = [[HTMLViewController alloc] init];
    htmlVC.urlStr = @"Admin/APPDoc/RegDoc";
    htmlVC.title = @"隐私协议";
    [self.navigationController pushViewController:htmlVC animated:YES];
}

// 刷新图片码
- (IBAction)picCodeClick:(id)sender {
    
    
    [self getPicCodeFromNet];
    
}

#pragma mark 是否同意 用户协议
- (IBAction)agreeBtnClick:(id)sender {
    if (_isAgree == NO) {
        [sender setImage:[[UIImage imageNamed:@"dui-on"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:(UIControlStateNormal)];
        
    }else {
        [sender setImage:[[UIImage imageNamed:@"kuang"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:(UIControlStateNormal)];
    }
    _isAgree = !_isAgree;
}
#pragma mark 发送验证码
- (IBAction)sendCodeBtnClick:(id)sender {
    
    if ([Utils isBlankString:_phoneTF.text]==YES) {
        [self showMessage:@"请输入您的手机号"];
    }
    else if ([Utils isBlankString:_picCodeTF.text]) {
        [self showMessage:@"请先输入图片码"];
    }
    else{
        UIButton * btn  = (UIButton*)sender;
        [self getCaptcha];
        
        btn.userInteractionEnabled = NO;
        _secondsCountDown = 120;
        _timer  = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeNumber) userInfo:nil repeats:YES];
    }
}

//获取验证码的计时
- (void)changeNumber {
    _secondsCountDown --;
    _sendCodeBtn.titleLabel.text = [NSString stringWithFormat:@"%lds",(long)_secondsCountDown];
    [_sendCodeBtn setTitle: [NSString stringWithFormat:@"%lds",(long)_secondsCountDown] forState:UIControlStateNormal];
    if (_secondsCountDown == 0) {
        [_sendCodeBtn setTitle: [NSString stringWithFormat:@"重新获取"] forState:UIControlStateNormal];
        _sendCodeBtn.userInteractionEnabled = YES;
        [_timer invalidate];
    }
}

-(void)getCaptcha{

    NSString *getUrlStr = [NSString stringWithFormat:@"%@api/Public/GetVerificationCode?ImgID=%@&code=%@&phone=%@",Server_Int_Url, _base64ImageID, _picCodeTF.text, _phoneTF.text];
    
//    [self showLoadding:@"正在获取验证码" time:20];
//    
//    NSLog(@" _picCodeTF.text - %@", _picCodeTF.text);
//
//    NSDictionary *paraDic = @{@"ImgID":_base64ImageID,@"code":_picCodeTF.text,@"phone":_phoneTF.text};
//    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", nil];
//    [manager POST:getUrlStr parameters:paraDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
//    {
//        NSLog(@"responseObject ---- %@", responseObject);
//        if ([responseObject[@"success"] integerValue] == 1) {
//            
//        } else {
//            [self showMessage:@""];
//        }
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//        NSLog(@"%@", error.description);
//    }];

    // get请求
    [BaseNetwork getLoadDataApi:getUrlStr block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        
        NSLog(@"modelData - %@", modelData);
        
        if (modelData) {
            if ([modelData[@"Success"] integerValue] == 1) {
                
                [self showMessage:@"获取验证码成功"];
                NSDictionary *dic = modelData[@"JsonData"];
                _SmsCode = dic[@"SmsCode"];
                NSLog(@"_SmsCode - %@", _SmsCode);
                
            } else {
                
                [self showMessage:modelData[@"Msg"]];
            }

        } else {
            
            [self showMessage:@"服务器错误"];
        }
        
        
    }];
}

#pragma mark - 注册按钮 / 提交修改 点击事件
- (IBAction)registBtnClick:(id)sender {

    [_phoneTF endEditing:YES];
    [_picCodeTF endEditing:YES];
    [_passWordTF endEditing:YES];
    [_ensurePassTF endEditing:YES];
    [_verifyCodeTF endEditing:YES];
    [_yaoQingCodeTF endEditing:YES];
    
    if ([_registBtn.currentTitle isEqualToString:@"注册"]) { // 用户注册
        
        
        
        if ([Utils isBlankString:_phoneTF.text] == YES) {
            [self showMessage:@"请输入您的手机号"];
            return;
        }
        if ([Utils isBlankString:_verifyCodeTF.text] == YES) {
            [self showMessage:@"请输入验证码"];
            return;
        }
        if ([_SmsCode isEqualToString:_verifyCodeTF.text] == NO) {
            [self showMessage:@"验证码错误,请重新输入"];
            return;
        }
        if ([Utils isBlankString:_passWordTF.text] == YES) {
            [self showMessage:@"请输入密码"];
            return;
        }
        if ([Utils isBlankString:_passWordTF.text] == YES) {
            [self showMessage:@"请输入确认密码"];
            return;
        }
        if ([_passWordTF.text isEqualToString:_ensurePassTF.text] == NO) {
            [self showMessage:@"密码输入不一致,请检查"];
            return;
        }
        if ([Utils isBlankString:_yaoQingCodeTF.text] == YES) {
            _yaoQingCodeTF.text = @"";
        }
        
        if ([self.navigationItem.title isEqualToString:@"用户注册"]) {
            if (_isAgree == NO) {
                [self showMessage:@"请勾选服务协议"];
                return;
            }
        }
        
        NSString *city = NSUserDf_Get(kCity);
        if (city == nil) {
            city = @"";
        }
        
        NSString *province = NSUserDf_Get(kProvince);
        if (province == nil) {
            province = @"";
        }
        
        NSString *registUrl = @"api/Customer/CreateCustomer";
        NSString *datasStr = [NSString stringWithFormat:@"ZICBDYCPhone=%@ZICBDYCPwd=%@ZICBDYCSmsCode=%@ZICBDYCInvitePhone=%@ZICBDYCProvinceName=%@ZICBDYCCityName=%@", _phoneTF.text, _ensurePassTF.text, _verifyCodeTF.text,_yaoQingCodeTF.text,province,city, nil];

        [self showLoadding:@"" time:20];
        [self loadDataApi:registUrl withParams:datasStr block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
            NSLog(@"注册 - %@", modelData);
            if (isSuccess) {
                [self showImage:SUCCESS_ICON time:1 message:@"注册成功"];
                [self performSelector:@selector(SuccessBack) withObject:nil afterDelay:1.5];
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
    else if ([_registBtn.currentTitle isEqualToString:@"提交"]) { // 忘记密码
        
        if ([Utils isBlankString:_phoneTF.text] == YES) {
            [self showMessage:@"请输入您的手机号"];
            return;
        }
        if ([Utils isBlankString:_verifyCodeTF.text] == YES) {
            [self showMessage:@"请输入验证码"];
            return;
        }
        if ([_SmsCode isEqualToString:_verifyCodeTF.text] == NO) {
            [self showMessage:@"验证码错误,请重新输入"];
            return;
        }
        if ([Utils isBlankString:_passWordTF.text] == YES) {
            [self showMessage:@"请输入密码"];
            return;
        }
        if ([Utils isBlankString:_passWordTF.text] == YES) {
            [self showMessage:@"请输入确认密码"];
            return;
        }
        if ([_passWordTF.text isEqualToString:_ensurePassTF.text] == NO) {
            [self showMessage:@"密码输入不一致,请检查"];
            return;
        }
        
        NSString *registUrl;
        
        if ([self.navigationItem.title isEqualToString:@"忘记密码"]) {
            registUrl = @"api/Customer/UpadtePassword";
        }
        else if([self.navigationItem.title isEqualToString:@"修改密码"]) {
            registUrl = @"api/Customer/ModifyCustomer";
        }
        
        NSString *datasStr = [NSString stringWithFormat:@"ZICBDYCPhone=%@ZICBDYCPwd=%@ZICBDYCSmsCode=%@", _phoneTF.text, _ensurePassTF.text, _verifyCodeTF.text, nil];
        
        [self showLoadding:@"" time:20];
        [self loadDataApi:registUrl withParams:datasStr block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
            
            if ([self.navigationItem.title isEqualToString:@"忘记密码"]) {
                NSLog(@"忘记密码 - %@", modelData);
            }
            else if([self.navigationItem.title isEqualToString:@"修改密码"]) {
                NSLog(@"修改密码 - %@", modelData);
            }
            
            if (isSuccess) {
                [self showImage:SUCCESS_ICON time:1 message:@"修改成功"];
                [self performSelector:@selector(SuccessBack) withObject:nil afterDelay:1.5];
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

- (void)SuccessBack {
    if (_fromMySetup == 41001) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:^{
            
            if ([self.navigationItem.title isEqualToString:@"修改密码"] == NO) {
                // 可以把注册成功的手机号传过去
                self.passTelNumBer(_phoneTF.text);
            }
        }];
    }
}

#pragma mark -
#pragma mark 手机号码输入长度限制
- (void)limitTextlength:(UITextField *)textField
{
    if ([textField.text length]>10) {
        textField.text=[textField.text substringToIndex:11];
        [_sendCodeBtn setUserInteractionEnabled:YES];
        [_sendCodeBtn setBackgroundColor:Main_Color];
        
        [_registBtn setUserInteractionEnabled:YES];
        [_registBtn setBackgroundColor:Main_Color];
    }
    else {
        [_sendCodeBtn setUserInteractionEnabled:NO];
        [_sendCodeBtn setBackgroundColor:[UIColor lightGrayColor]];
        
        [_registBtn setUserInteractionEnabled:NO];
        [_registBtn setBackgroundColor:[UIColor lightGrayColor]];
    }
    
}

#pragma mark--
#pragma mark          UITextFildDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

//点击nav左键 取消返回
- (void)leftBarButtonItemClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
