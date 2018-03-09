//
//  ModifyPhoneNumberVC.m
//  JRMedical
//
//  Created by a on 16/12/22.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "ModifyPhoneNumberVC.h"

#import "IQKeyboardManager.h"
#import "JRLoginViewController.h"

@interface ModifyPhoneNumberVC ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *picCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *picCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *modifyPhoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeBtn;

@end

@implementation ModifyPhoneNumberVC {
    
    NSTimer * _timer ;
    NSInteger  _secondsCountDown;
    BOOL _isAgree;
    NSString *_baseString;
    NSString *_base64ImageID;
    NSString *_SmsCode;
}

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
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = BG_Color;
    
    _SmsCode =@"000000";
    
    [self initDelegateAndOther];
    
    // 获取图片密码
    [self getPicCodeFromNet];
}

// 刷新图片码
- (IBAction)picCodeBtnClick:(id)sender {
    [self getPicCodeFromNet];
}

//修改手机号
- (IBAction)postModifyPhoneNumber:(id)sender {
    [_phoneTF endEditing:YES];
    [_picCodeTF endEditing:YES];
    [_verifyCodeTF endEditing:YES];
    
    if ([Utils isBlankString:_phoneTF.text] == YES) {
        [self showMessage:@"请输入您修改的手机号"];
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
    
    NSString *registUrl = @"api/Customer/UpdatePhone";
    NSString *datasStr = [NSString stringWithFormat:@"ZICBDYCPhone=%@ZICBDYCSmsCode=%@", _phoneTF.text, _verifyCodeTF.text, nil];
    
    [self showLoadding:@"" time:20];
    [self loadDataApi:registUrl withParams:datasStr block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"修改手机号 - %@", modelData);
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

- (void)SuccessBack {
    [UserInfo removeAccessToken];//移除token
    [UserInfo removeDevIdentity];//移除单点登录
    
    NSUserDf_Set(kNoLogin,JRIsLogin);//修改登录状态
    NSUserDf_Remove(kDoctor);//移除是否是医师信息
    
    //    NSUserDf_Remove(kUserPic);//移除用户头像地址
    
    NSUserDf_Remove(kHXName);//移除环信用户名
    NSUserDf_Remove(kHXPwd);//移除环信密码
    
    [UserInfo removeUserInfo];//移除用户信息
    
    [self showLoadding:@"" time:1];
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self.hud hide:YES];
        JRLoginViewController *loginVC = [[JRLoginViewController alloc] init];
        loginVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:loginVC animated:YES completion:nil];
    });
}

#pragma mark - 获取图片密码
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

//获取验证码
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

//获取验证码
-(void)getCaptcha{
    
    NSString *getUrlStr = [NSString stringWithFormat:@"%@api/Public/GetVerificationCode?ImgID=%@&code=%@&phone=%@",Server_Int_Url, _base64ImageID, _picCodeTF.text, _phoneTF.text];
    
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

//设置 textfield 代理
- (void)initDelegateAndOther {
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_back"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftBarButtonItemClick)];
    
    [_phoneTF addTarget:self action:@selector(limitTextlength:) forControlEvents:UIControlEventEditingChanged];
    
    [_sendCodeBtn setUserInteractionEnabled:NO];
    [_sendCodeBtn setBackgroundColor:[UIColor lightGrayColor]];
    
    [_modifyPhoneBtn setUserInteractionEnabled:NO];
    [_modifyPhoneBtn setBackgroundColor:[UIColor lightGrayColor]];
    
    _phoneTF.delegate = self;
    _verifyCodeTF.delegate = self;
    _picCodeTF.delegate = self;
    
    _phoneTF.returnKeyType = UIReturnKeyDone;
    _phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    
    _verifyCodeTF.returnKeyType = UIReturnKeyDone;
    _verifyCodeTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _verifyCodeTF.keyboardType = UIKeyboardTypeNumberPad;
    
    _picCodeTF.returnKeyType = UIReturnKeyDone;
    _picCodeTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _picCodeTF.keyboardType = UIKeyboardTypeNumberPad;
}

#pragma mark -
#pragma mark 手机号码输入长度限制
- (void)limitTextlength:(UITextField *)textField {
    
    if ([textField.text length]>10) {
        textField.text=[textField.text substringToIndex:11];
        [_sendCodeBtn setUserInteractionEnabled:YES];
        [_sendCodeBtn setBackgroundColor:Main_Color];
        
        [_modifyPhoneBtn setUserInteractionEnabled:YES];
        [_modifyPhoneBtn setBackgroundColor:Main_Color];
    }
    else {
        [_sendCodeBtn setUserInteractionEnabled:NO];
        [_sendCodeBtn setBackgroundColor:[UIColor lightGrayColor]];
        
        [_modifyPhoneBtn setUserInteractionEnabled:NO];
        [_modifyPhoneBtn setBackgroundColor:[UIColor lightGrayColor]];
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
