//
//  MyBalanceVC.m
//  JRMedical
//
//  Created by a on 16/11/9.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "MyBalanceVC.h"

#import "MyPayOrder.h"
#import "Order.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"

#import "MyBalanceDetailedListVC.h"

@interface MyBalanceVC ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *czView;
@property (nonatomic, strong) UIView *payTypeView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *alipayView;
@property (nonatomic, strong) UIView *weChatView;

@property (nonatomic, strong) UILabel *czMoneyLab;
@property (nonatomic, strong) UILabel *payTypeLab;
@property (nonatomic, strong) UILabel *alipayLab;
@property (nonatomic, strong) UILabel *alipayxLab;
@property (nonatomic, strong) UILabel *weChatLab;
@property (nonatomic, strong) UILabel *weChatxLab;

@property (nonatomic, strong) UITextField *czMoneyTF;

@property (nonatomic, strong) UIImageView *alipayImg;
@property (nonatomic, strong) UIImageView *alipayIcon;
@property (nonatomic, strong) UIImageView *weChatImg;
@property (nonatomic, strong) UIImageView *weChatIcon;

@property (nonatomic, strong) UIButton *surePayBtn;

@end

@implementation MyBalanceVC {
    
    NSInteger _payType;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAliPayCallBackInfo object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kWeixin_pay_result_success object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的余额";
    self.view.backgroundColor = BG_Color;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"明细" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarButtonItemClick)];
    
    // 接受支付宝支付回调结果的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(aliPayCallBack:) name:kAliPayCallBackInfo object:nil];
    // 接受微信支付回调结果的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weixin_pay_result_success:) name:kWeixin_pay_result_success object:nil];
    
    [self choicePayType];//选择支付方式
    [self initView];//初始化视图
}

#pragma mark - 查看明细
- (void)rightBarButtonItemClick {
    MyBalanceDetailedListVC *mbdlVC = [MyBalanceDetailedListVC new];
    [self.navigationController pushViewController:mbdlVC animated:YES];
}

// 支付宝回调  支付成功后 进入订单详情界面
- (void)aliPayCallBack:(NSNotification *)resultDic {
    
    NSLog(@"resultDic.userInfo - %@", resultDic.userInfo);
    
    NSString *codeStr = resultDic.userInfo[@"resultStatus"];
    
    if ([codeStr isEqualToString:@"9000"]) {
        [self showImage:SUCCESS_ICON time:1.5 message:@"充值成功"];
        self.czMoneyTF.text = @"";
    }
    else if ([codeStr isEqualToString:@"8000"]) {
        [self showMessage:@"正在处理中..."];
    }
    else if ([codeStr isEqualToString:@"4000"]) {
        [self showImage:FAIL_ICON time:1.5 message:@"充值失败"];
    }
    else if ([codeStr isEqualToString:@"6002"]) {
        [self showImage:FAIL_ICON time:1.5 message:@"网络连接出错"];
    }
    else if ([codeStr isEqualToString:@"6001"]) {
        [self showImage:FAIL_ICON time:1.5 message:@"取消充值"];
    }
    else {
        [self showImage:FAIL_ICON time:1.5 message:@"充值失败"];
    }
}

// 微信回调 支付成功后 进入订单详情界面
- (void)weixin_pay_result_success:(NSNotification *)sender {
    
    int code = [sender.object intValue];
    
    switch (code) {
        case 0:
        {
            [self showImage:SUCCESS_ICON time:1.5 message:@"充值成功"];
            self.czMoneyTF.text = @"";
        }
            break;
        case -2:
        {
            [self showImage:FAIL_ICON time:1.5 message:@"退出充值"];
        }
            break;
        default:
        {
            [self showImage:FAIL_ICON time:1.5 message:@"充值失败"];
        }
            break;
    }
}

#pragma mark - 确认支付
- (void)surePayBtnClick {
    
    if ([self.czMoneyTF.text isEqualToString:@""] || self.czMoneyTF.text == nil) {
        return [self showMessage:@"请输入充值金额"];
    }
    
    NSString *url;
    if (_payType == 100) {//支付宝
        url = @"api/MallsInfo/CZAliPay";
    }
    else if (_payType == 200) {//微信
        url = @"api/MallsInfo/CZWxPay";
    }
    
    NSString *params = [NSString stringWithFormat:@"ZICBDYCAmount=%f",[self.czMoneyTF.text floatValue]];
    
    [self showLoadding:@"" time:20];
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        
        if (_payType == 100) {//支付宝
            NSLog(@"支付宝支付 - %@", modelData);
        }
        else if (_payType == 200) {//微信
            NSLog(@"微信支付 - %@", modelData);
        }
        
        if (isSuccess) {
            
            if (_payType == 100) {//支付宝
                [self alipayPay:modelData[@"JsonData"]];
            }
            else if (_payType == 200) {//微信
                [self weChatPay:modelData[@"JsonData"]];
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

#pragma mark - 选择支付方式
- (void)choicePayType {

    //选择支付方式  默认为支付宝支付
    _payType = 100;
    
    //支付宝
    [self.alipayView bk_whenTapped:^{
        _payType = 100;
        self.alipayImg.image = [UIImage imageNamed:@"duidui"];
        self.weChatImg.image = [UIImage imageNamed:@"weixuan"];
    }];
    
    //微信支付
    [self.weChatView bk_whenTapped:^{
        _payType = 200;
        self.alipayImg.image = [UIImage imageNamed:@"weixuan"];
        self.weChatImg.image = [UIImage imageNamed:@"duidui"];
    }];
}

#pragma mark - 微信支付
- (void)weChatPay:(NSDictionary *)dic {
    //构造支付请求
    PayReq *request   = [[PayReq alloc]init];
    request.partnerId = [dic objectForKey:@"partnerid"];
    request.prepayId  = [dic objectForKey:@"prepayid"];
    request.package   = [dic objectForKey:@"packages"];
    request.nonceStr  = [dic objectForKey:@"noncestr"];
    request.timeStamp = [[dic objectForKey:@"timestamp"]intValue];
    request.sign = [dic objectForKey:@"sign"];
    [WXApi sendReq:request];
}

#pragma mark - 支付宝支付
- (void)alipayPay:(NSDictionary *)dic {
    MyPayOrder * payOrder = [[MyPayOrder alloc] init];
    payOrder.tradeNO =  dic[@"OrderNO"];
    payOrder.seller = @"3378128098@qq.com";
    payOrder.partner = @"2088421318655339";
    payOrder.totalMoney = [NSString stringWithFormat:@"%.2f", [self.czMoneyTF.text floatValue]];
    payOrder.privateKey = @"MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAKaSYIA6++s8RKWV6z1QF78RwcDquw7slnjXK16ZAFPSbUW6STwaZIbZiHVJ9UowI06TDLI1nMpkRn69bLZfLyzlTOjwHITx0qUa2sm7AbHkJJGFxrVvsd7djK765kUT1bF6Y7X5ryhkcmG3S/rBB4EBxyR/97KfJ8Y3O1ya0vA9AgMBAAECgYAxO04+WDChBD0d28OdaZC7Llpf1IDZFmAa8y2kVgBcxfL6CuceVoajvKOyVtuiw7uLu7ai7WmcACs9xmrdNCDS39bTSGou6IFJXyZXWwkylYbJHZzbKPmJkKEz8zhyF2p8tXDXKGf0+oaKGKtWIL1tYqwtLBmgmByNNcVzmyfo2QJBANxzboVt1640I7oY3YXGF6Oit9kF7Rpmfksm2MNEE+tYySgamJBwJiqLdvwUWH9IxwdFfm7ooTjBAupPFfNCSS8CQQDBbrp5GF0IMi+ke1CAZmAkvCAxGgJGlrP9tEE2BBTFdrG2axluBATqenSkCxxZHgp27jxpaZ3yG/DrPuLdBKpTAkBsZ2rqvAf6RvNmmMGd/bo0IljrpGliuRHTnMesxbZR3bgVO3bYV/28oBYjgVG/TadpYPf6S/Sztt3bIIa3t1nLAkAC9ptMt57VPU+ViX4WOXtHlMo5dliKlEx1molVNoLK86KNVN6y3MTmgrG+wZzRkLBAWi36v294Ag2SzQfUsvmZAkB0LN/P6BQOGi24VTTVeK1Z1vW2r3zO3hb4yEzSExbdJJ92KW+Bs97n0VQfMh49O+7+gYmjneOYbIgJAMw3Jyr/";
    [self aliPayFor:payOrder];
}
#pragma mark 调取支付宝支付
- (void)aliPayFor:(MyPayOrder *)getOrder
{
    //partner和seller获取失败,提示
    if ([[getOrder partner] length] == 0 ||
        [[getOrder seller] length] == 0 ||
        [[getOrder privateKey] length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = getOrder.partner;
    order.sellerID = getOrder.seller;
    order.outTradeNO = getOrder.tradeNO; //订单ID（由商家自行制定）
    order.subject = @"介入医学充值服务"; //商品标题
    order.body = @"余额充值"; //商品描述
    order.totalFee = getOrder.totalMoney; //商品价格
    order.notifyURL = [NSString stringWithFormat:@"%@AlipayNotify/CZIndex",Server_Int_Url]; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showURL = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"jieruyixue";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(getOrder.privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            
            NSString *codeStr = [resultDic objectForKey:@"resultStatus"];
            
            NSLog(@"resultDic === %@",resultDic);
            
            if ([codeStr isEqualToString:@"9000"]) {
                [self showImage:SUCCESS_ICON time:1.5 message:@"充值成功"];
                self.czMoneyTF.text = @"";
            }
            else if ([codeStr isEqualToString:@"8000"]) {
                [self showMessage:@"正在处理中..."];
            }
            else if ([codeStr isEqualToString:@"4000"]) {
                [self showImage:FAIL_ICON time:1.5 message:@"充值失败"];
            }
            else if ([codeStr isEqualToString:@"6002"]) {
                [self showImage:FAIL_ICON time:1.5 message:@"网络连接出错"];
            }
            else if ([codeStr isEqualToString:@"6001"]) {
                [self showImage:FAIL_ICON time:1.5 message:@"取消了订单"];
            }
            else {
                [self showImage:FAIL_ICON time:1.5 message:@"充值失败"];
            }
            
            NSURL *myUrl = [NSURL URLWithString:@"jieruyixue"];
            if([[UIApplication sharedApplication] canOpenURL:myUrl]){
                [[UIApplication sharedApplication] openURL:myUrl];
            }
        }];
    }
}

#pragma mark - 初始化视图
- (void)initView {
    [self.view addSubview:self.czMoneyLab];
    [self.view addSubview:self.czView];
    [self.czView addSubview:self.czMoneyTF];
    [self.view addSubview:self.payTypeLab];
    [self.view addSubview:self.payTypeView];
    [self.payTypeView addSubview:self.alipayImg];
    [self.payTypeView addSubview:self.alipayIcon];
    [self.payTypeView addSubview:self.alipayLab];
    [self.payTypeView addSubview:self.alipayxLab];
    [self.payTypeView addSubview:self.alipayView];
    [self.payTypeView addSubview:self.lineView];
    [self.payTypeView addSubview:self.weChatImg];
    [self.payTypeView addSubview:self.weChatIcon];
    [self.payTypeView addSubview:self.weChatLab];
    [self.payTypeView addSubview:self.weChatxLab];
    [self.payTypeView addSubview:self.weChatView];
    [self.view addSubview:self.surePayBtn];
    
    self.czMoneyLab.sd_layout.topSpaceToView(self.view,30).leftSpaceToView(self.view,15).heightIs(18).widthIs(80);
    self.czView.sd_layout.topSpaceToView(self.czMoneyLab,15).leftSpaceToView(self.view,15).rightSpaceToView(self.view,15).heightIs(45);
    self.czMoneyTF.sd_layout.leftSpaceToView(self.czView,10).rightSpaceToView(self.czView,10).heightIs(50);
    self.payTypeLab.sd_layout.topSpaceToView(self.czView,40).leftSpaceToView(self.view,15).heightIs(18).widthIs(80);
    self.payTypeView.sd_layout.topSpaceToView(self.payTypeLab,15).leftSpaceToView(self.view,15).rightSpaceToView(self.view,15).heightIs(130.7);
    self.alipayImg.sd_layout.topSpaceToView(self.payTypeView,24).leftSpaceToView(self.payTypeView,15).heightIs(17).widthIs(17);
    self.alipayIcon.sd_layout.topSpaceToView(self.payTypeView,17.5).leftSpaceToView(self.alipayImg,30).heightIs(30).widthIs(30);
    self.alipayLab.sd_layout.topSpaceToView(self.payTypeView,15.5).leftSpaceToView(self.alipayIcon,15).rightSpaceToView(self.payTypeView,15).heightIs(18);
    self.alipayxLab.sd_layout.topSpaceToView(self.alipayLab,2).leftSpaceToView(self.alipayIcon,15).rightSpaceToView(self.payTypeView,15).heightIs(14);
    self.alipayView.sd_layout.topEqualToView(self.payTypeView).leftEqualToView(self.payTypeView).rightEqualToView(self.payTypeView).heightIs(65);
    self.lineView.sd_layout.centerYEqualToView(self.payTypeView).leftEqualToView(self.payTypeView).rightEqualToView(self.payTypeView).heightIs(0.7);
    self.weChatImg.sd_layout.topSpaceToView(self.lineView,24).leftSpaceToView(self.payTypeView,15).heightIs(17).widthIs(17);
    self.weChatIcon.sd_layout.topSpaceToView(self.lineView,17.5).leftSpaceToView(self.alipayImg,30).heightIs(30).widthIs(30);
    self.weChatLab.sd_layout.topSpaceToView(self.lineView,15.5).leftSpaceToView(self.weChatIcon,15).rightSpaceToView(self.payTypeView,15).heightIs(18);
    self.weChatxLab.sd_layout.topSpaceToView(self.weChatLab,2).leftSpaceToView(self.weChatIcon,15).rightSpaceToView(self.payTypeView,15).heightIs(14);
    self.weChatView.sd_layout.topSpaceToView(self.lineView,0).leftEqualToView(self.payTypeView).rightEqualToView(self.payTypeView).heightIs(65);
    self.surePayBtn.sd_layout.topSpaceToView(self.payTypeView,25).leftSpaceToView(self.view,15).rightSpaceToView(self.view,15).heightIs(45);
}

#pragma mark - 懒加载
- (UIView *)czView {
    if (!_czView) {
        _czView = [UIView new];
        _czView.backgroundColor = [UIColor whiteColor];
        _czView.clipsToBounds = YES;
        _czView.layer.cornerRadius = 5;
    }
    return _czView;
}
- (UIView *)payTypeView {
    if (!_payTypeView) {
        _payTypeView = [UIView new];
        _payTypeView.backgroundColor = [UIColor whiteColor];
        _payTypeView.clipsToBounds = YES;
        _payTypeView.layer.cornerRadius = 5;
    }
    return _payTypeView;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = BG_Color;
    }
    return _lineView;
}
- (UIView *)alipayView {
    if (!_alipayView) {
        _alipayView = [UIView new];
        _alipayView.userInteractionEnabled = YES;
    }
    return _alipayView;
}
- (UIView *)weChatView {
    if (!_weChatView) {
        _weChatView = [UIView new];
        _weChatView.userInteractionEnabled = YES;
    }
    return _weChatView;
}
- (UILabel *)czMoneyLab {
    if (!_czMoneyLab) {
        _czMoneyLab = [UILabel new];
        _czMoneyLab.text = @"充值金额";
        _czMoneyLab.font = [UIFont systemFontOfSize:16];
    }
    return _czMoneyLab;
}
- (UILabel *)payTypeLab {
    if (!_payTypeLab) {
        _payTypeLab = [UILabel new];
        _payTypeLab.text = @"支付方式";
        _payTypeLab.font = [UIFont systemFontOfSize:16];
    }
    return _payTypeLab;
}
- (UILabel *)alipayLab {
    if (!_alipayLab) {
        _alipayLab = [UILabel new];
        _alipayLab.text = @"支付宝";
        _alipayLab.font = [UIFont systemFontOfSize:16];
    }
    return _alipayLab;
}
- (UILabel *)alipayxLab {
    if (!_alipayxLab) {
        _alipayxLab = [UILabel new];
        _alipayxLab.text = @"推荐支付宝用户使用";
        _alipayxLab.textColor = HuiText_Color;
        _alipayxLab.font = [UIFont systemFontOfSize:13];
    }
    return _alipayxLab;
}
- (UILabel *)weChatLab {
    if (!_weChatLab) {
        _weChatLab = [UILabel new];
        _weChatLab.text = @"微信支付";
        _weChatLab.font = [UIFont systemFontOfSize:16];
    }
    return _weChatLab;
}
- (UILabel *)weChatxLab {
    if (!_weChatxLab) {
        _weChatxLab = [UILabel new];
        _weChatxLab.text = @"请在手机上安装5.0以上微信";
        _weChatxLab.textColor = HuiText_Color;
        _weChatxLab.font = [UIFont systemFontOfSize:13];
    }
    return _weChatxLab;
}
- (UITextField *)czMoneyTF {
    if (!_czMoneyTF) {
        _czMoneyTF = [UITextField new];
        _czMoneyTF.backgroundColor = [UIColor whiteColor];
        _czMoneyTF.placeholder = @"请输入充值金额";
        _czMoneyTF.font = [UIFont systemFontOfSize:16];
        _czMoneyTF.returnKeyType = UIReturnKeyDone;
        _czMoneyTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _czMoneyTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _czMoneyTF.delegate = self;
    }
    return _czMoneyTF;
}
- (UIImageView *)alipayImg {
    if (!_alipayImg) {
        _alipayImg = [UIImageView new];
        _alipayImg.image = [UIImage imageNamed:@"duidui"];
    }
    return _alipayImg;
}
- (UIImageView *)weChatImg {
    if (!_weChatImg) {
        _weChatImg = [UIImageView new];
        _weChatImg.image = [UIImage imageNamed:@"weixuan"];
    }
    return _weChatImg;
}
- (UIImageView *)alipayIcon {
    if (!_alipayIcon) {
        _alipayIcon = [UIImageView new];
        _alipayIcon.image = [UIImage imageNamed:@"zhifubao23"];
    }
    return _alipayIcon;
}
- (UIImageView *)weChatIcon {
    if (!_weChatIcon) {
        _weChatIcon = [UIImageView new];
        _weChatIcon.image = [UIImage imageNamed:@"weixin"];
    }
    return _weChatIcon;
}
- (UIButton *)surePayBtn {
    if (!_surePayBtn) {
        _surePayBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_surePayBtn setTitle:@"确认支付" forState:UIControlStateNormal];
        [_surePayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _surePayBtn.backgroundColor = RGB(205, 32, 28);
        _surePayBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _surePayBtn.clipsToBounds = YES;
        _surePayBtn.layer.cornerRadius = 5;
        [_surePayBtn addTarget:self action:@selector(surePayBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _surePayBtn;
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
