//
//  PayOrderVC.m
//  JRMedical
//
//  Created by a on 16/12/20.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "PayOrderVC.h"

#import "MyPayOrder.h"
#import "Order.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"

#import "MyOrderRootVC.h"

@interface PayOrderVC ()

@property (nonatomic, strong) UIView *payTypeView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *line2View;
@property (nonatomic, strong) UIView *line3View;
@property (nonatomic, strong) UIView *line4View;
@property (nonatomic, strong) UIView *alipayView;
@property (nonatomic, strong) UIView *weChatView;
@property (nonatomic, strong) UIView *yueView;

@property (nonatomic, strong) UILabel *payTypeLab;
@property (nonatomic, strong) UILabel *priceLab;
@property (nonatomic, strong) UILabel *alipayLab;
@property (nonatomic, strong) UILabel *alipayxLab;
@property (nonatomic, strong) UILabel *weChatLab;
@property (nonatomic, strong) UILabel *weChatxLab;
@property (nonatomic, strong) UILabel *yueLab;
@property (nonatomic, strong) UILabel *yuexLab;
@property (nonatomic, strong) UILabel *totalPriceLab;

@property (nonatomic, strong) UIImageView *alipayImg;
@property (nonatomic, strong) UIImageView *alipayIcon;
@property (nonatomic, strong) UIImageView *weChatImg;
@property (nonatomic, strong) UIImageView *weChatIcon;
@property (nonatomic, strong) UIImageView *yueImg;
@property (nonatomic, strong) UIImageView *yueIcon;

@property (nonatomic, strong) UIButton *surePayBtn;

@end

@implementation PayOrderVC {
    
    NSInteger _payType;
    
    NSString *_OrderNO;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAliPayCallBackInfo object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kWeixin_pay_result_success object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"收银台";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 接受支付宝支付回调结果的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(aliPayCallBack:) name:kAliPayCallBackInfo object:nil];
    // 接受微信支付回调结果的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weixin_pay_result_success:) name:kWeixin_pay_result_success object:nil];
    
    self.priceLab.text = [NSString stringWithFormat:@"¥ %.2f",[self.orderDic[@"PayPrice"] floatValue]];//订单金额
    _OrderNO = self.orderDic[@"OrderNO"];//订单号
    
    [self choicePayType];//选择支付方式
    [self initView];//初始化视图
}

// 支付宝回调  支付成功后 进入订单详情界面
- (void)aliPayCallBack:(NSNotification *)resultDic {
    
    NSLog(@"resultDic.userInfo - %@", resultDic.userInfo);
    
    NSString *codeStr = resultDic.userInfo[@"resultStatus"];
    
    if ([codeStr isEqualToString:@"9000"]) {
        [self showImage:SUCCESS_ICON time:1.5 message:@"支付成功"];
        
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5/*延迟执行时间*/ * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            
            if ([self.from isEqualToString:@"购物车"] || [self.from isEqualToString:@"商品详情"]) {
                MyOrderRootVC *orderVc = [MyOrderRootVC new];
                orderVc.tagVC = 2;
                orderVc.payOrderTo = self.from;
                [self.navigationController pushViewController:orderVc animated:YES];
            }
            else if ([self.from isEqualToString:@"订单列表"]) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else if ([self.from isEqualToString:@"订单详情"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"payOrderDetailReturn" object:nil userInfo:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }

        });

    }
    else if ([codeStr isEqualToString:@"8000"]) {
        [self showMessage:@"正在处理中..."];
    }
    else if ([codeStr isEqualToString:@"4000"]) {
        [self showImage:FAIL_ICON time:1.5 message:@"支付失败"];
    }
    else if ([codeStr isEqualToString:@"6002"]) {
        [self showImage:FAIL_ICON time:1.5 message:@"网络连接出错"];
    }
    else if ([codeStr isEqualToString:@"6001"]) {
        [self showImage:FAIL_ICON time:1.5 message:@"取消支付"];
    }
    else {
        [self showImage:FAIL_ICON time:1.5 message:@"支付失败"];
    }
}

// 微信回调 支付成功后 进入订单详情界面
- (void)weixin_pay_result_success:(NSNotification *)sender {
    
    int code = [sender.object intValue];
    
    switch (code) {
        case 0:
        {
            [self showImage:SUCCESS_ICON time:1.5 message:@"支付成功"];
            
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5/*延迟执行时间*/ * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                
                if ([self.from isEqualToString:@"购物车"] || [self.from isEqualToString:@"商品详情"]) {
                    MyOrderRootVC *orderVc = [MyOrderRootVC new];
                    orderVc.tagVC = 2;
                    orderVc.payOrderTo = self.from;
                    [self.navigationController pushViewController:orderVc animated:YES];
                }
                else if ([self.from isEqualToString:@"订单列表"]) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else if ([self.from isEqualToString:@"订单详情"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"payOrderDetailReturn" object:nil userInfo:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            });
        }
            break;
        case -2:
        {
            [self showImage:FAIL_ICON time:1.5 message:@"退出支付"];
        }
            break;
        default:
        {
            [self showImage:FAIL_ICON time:1.5 message:@"支付失败"];
        }
            break;
    }
}

#pragma mark - 确认支付
- (void)surePayBtnClick {
    
    switch (_payType) {
        case 100://余额支付
            [self yuEPay];
            break;
        case 200://支付宝支付
            [self alipayPay];
            break;
        case 300://微信支付
            [self weChatPay];
            break;
        default:
            break;
    }
}

#pragma mark - 选择支付方式
- (void)choicePayType {
    
    //选择支付方式  默认为余额支付
    _payType = 100;
    
    //微信支付
    [self.yueView bk_whenTapped:^{
        _payType = 100;
        self.yueImg.image = [UIImage imageNamed:@"duidui"];
        self.alipayImg.image = [UIImage imageNamed:@"weixuan"];
        self.weChatImg.image = [UIImage imageNamed:@"weixuan"];
    }];
    
    //支付宝
    [self.alipayView bk_whenTapped:^{
        _payType = 200;
        self.yueImg.image = [UIImage imageNamed:@"weixuan"];
        self.alipayImg.image = [UIImage imageNamed:@"duidui"];
        self.weChatImg.image = [UIImage imageNamed:@"weixuan"];
    }];
    
    //微信支付
    [self.weChatView bk_whenTapped:^{
        _payType = 300;
        self.yueImg.image = [UIImage imageNamed:@"weixuan"];
        self.alipayImg.image = [UIImage imageNamed:@"weixuan"];
        self.weChatImg.image = [UIImage imageNamed:@"duidui"];
    }];
}

#pragma mark - 余额支付
- (void)yuEPay {
    
    NSString *params = [NSString stringWithFormat:@"ZICBDYCOrderNO=%@",_OrderNO];
    NSString *url = @"api/MallsInfo/BalanceOrderPay";
    [self showLoadding:@"" time:20];
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"余额支付 - %@", modelData);
        if (isSuccess) {
            [self showImage:SUCCESS_ICON time:1.5 message:@"支付成功"];
             
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5/*延迟执行时间*/ * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                
                if ([self.from isEqualToString:@"购物车"] || [self.from isEqualToString:@"商品详情"]) {
                    MyOrderRootVC *orderVc = [MyOrderRootVC new];
                    orderVc.tagVC = 2;
                    orderVc.payOrderTo = self.from;
                    [self.navigationController pushViewController:orderVc animated:YES];
                }
                else if ([self.from isEqualToString:@"订单列表"]) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else if ([self.from isEqualToString:@"订单详情"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"payOrderDetailReturn" object:nil userInfo:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            });
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

#pragma mark - 微信支付
- (void)weChatPay {
    NSString *params = [NSString stringWithFormat:@"ZICBDYCOrderNO=%@",_OrderNO];
    NSString *url = @"api/MallsInfo/WxOrderPay";
    [self showLoadding:@"" time:20];
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"微信支付 - %@", modelData);
        if (isSuccess) {
            NSDictionary *dic = modelData[@"JsonData"];
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

#pragma mark - 支付宝支付
- (void)alipayPay {
    MyPayOrder * payOrder = [[MyPayOrder alloc] init];
    payOrder.tradeNO =  _OrderNO;
    payOrder.seller = @"3378128098@qq.com";
    payOrder.partner = @"2088421318655339";
    payOrder.totalMoney = [NSString stringWithFormat:@"%.2f", [self.orderDic[@"PayPrice"] floatValue]];
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
    order.subject = @"介入医学商品购买"; //商品标题
    order.body = @"医学商城"; //商品描述
    order.totalFee = getOrder.totalMoney; //商品价格
    order.notifyURL = [NSString stringWithFormat:@"%@AlipayNotify/Index",Server_Int_Url]; //回调URL
    
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
                
                [self showImage:SUCCESS_ICON time:1.5 message:@"支付成功"];

                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5/*延迟执行时间*/ * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    
                    if ([self.from isEqualToString:@"购物车"] || [self.from isEqualToString:@"商品详情"]) {
                        MyOrderRootVC *orderVc = [MyOrderRootVC new];
                        orderVc.tagVC = 2;
                        orderVc.payOrderTo = self.from;
                        [self.navigationController pushViewController:orderVc animated:YES];
                    }
                    else if ([self.from isEqualToString:@"订单列表"]) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    else if ([self.from isEqualToString:@"订单详情"]) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"payOrderDetailReturn" object:nil userInfo:nil];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                });
            }
            else if ([codeStr isEqualToString:@"8000"]) {
                [self showMessage:@"正在处理中..."];
            }
            else if ([codeStr isEqualToString:@"4000"]) {
                [self showImage:FAIL_ICON time:1.5 message:@"支付失败"];
            }
            else if ([codeStr isEqualToString:@"6002"]) {
                [self showImage:FAIL_ICON time:1.5 message:@"网络连接出错"];
            }
            else if ([codeStr isEqualToString:@"6001"]) {
                [self showImage:FAIL_ICON time:1.5 message:@"取消支付"];
            }
            else {
                [self showImage:FAIL_ICON time:1.5 message:@"支付失败"];
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
    
    NSString *yue =  (NSString *)[UserInfo getUserInfoValue:@"AccountMoney"];
    if (yue == nil) {
        self.totalPriceLab.text = @"* * *";
    }
    else {
        self.totalPriceLab.text = [NSString stringWithFormat:@"¥ %.2f",[yue floatValue]];
    }
    
    [self.view addSubview:self.payTypeLab];
    [self.view addSubview:self.priceLab];
    [self.view addSubview:self.yueView];
    [self.yueView addSubview:self.totalPriceLab];
    [self.yueView addSubview:self.line4View];
    [self.yueView addSubview:self.yueImg];
    [self.yueView addSubview:self.yueIcon];
    [self.yueView addSubview:self.yueLab];
    [self.yueView addSubview:self.yuexLab];
    [self.view addSubview:self.payTypeView];
    [self.payTypeView addSubview:self.alipayImg];
    [self.payTypeView addSubview:self.alipayIcon];
    [self.payTypeView addSubview:self.alipayLab];
    [self.payTypeView addSubview:self.alipayxLab];
    [self.payTypeView addSubview:self.alipayView];
    [self.payTypeView addSubview:self.lineView];
    [self.payTypeView addSubview:self.line2View];
    [self.payTypeView addSubview:self.line3View];
    [self.payTypeView addSubview:self.weChatImg];
    [self.payTypeView addSubview:self.weChatIcon];
    [self.payTypeView addSubview:self.weChatLab];
    [self.payTypeView addSubview:self.weChatxLab];
    [self.payTypeView addSubview:self.weChatView];
    [self.view addSubview:self.surePayBtn];
    
    self.payTypeLab.sd_layout.topSpaceToView(self.view,15).leftSpaceToView(self.view,15).heightIs(18).widthIs(80);
    self.priceLab.sd_layout.topSpaceToView(self.view,15).leftSpaceToView(self.payTypeLab,15).rightSpaceToView(self.view,15).heightIs(18);
    self.yueView.sd_layout.topSpaceToView(self.payTypeLab,15).leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).heightIs(66);
    self.line4View.sd_layout.topEqualToView(self.yueView).leftEqualToView(self.yueView).rightEqualToView(self.yueView).heightIs(0.7);
    self.yueImg.sd_layout.centerYEqualToView(self.yueView).leftSpaceToView(self.yueView,15).heightIs(17).widthIs(17);
    self.yueIcon.sd_layout.centerYEqualToView(self.yueView).leftSpaceToView(self.yueImg,30).heightIs(30).widthIs(30);
    self.yueLab.sd_layout.topSpaceToView(self.yueView,15.5).leftSpaceToView(self.yueIcon,15).widthIs(66).heightIs(18);
    self.totalPriceLab.sd_layout.topSpaceToView(self.yueView,17.5).leftSpaceToView(self.yueLab,5).rightSpaceToView(self.yueView,15).heightIs(14);
    self.yuexLab.sd_layout.topSpaceToView(self.yueLab,2).leftSpaceToView(self.yueIcon,15).rightSpaceToView(self.yueView,15).heightIs(14);
    self.payTypeView.sd_layout.topSpaceToView(self.yueView,0).leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).heightIs(130.7);
    self.alipayImg.sd_layout.topSpaceToView(self.payTypeView,24).leftSpaceToView(self.payTypeView,15).heightIs(17).widthIs(17);
    self.alipayIcon.sd_layout.topSpaceToView(self.payTypeView,17.5).leftSpaceToView(self.alipayImg,30).heightIs(30).widthIs(30);
    self.alipayLab.sd_layout.topSpaceToView(self.payTypeView,15.5).leftSpaceToView(self.alipayIcon,15).rightSpaceToView(self.payTypeView,15).heightIs(18);
    self.alipayxLab.sd_layout.topSpaceToView(self.alipayLab,2).leftSpaceToView(self.alipayIcon,15).rightSpaceToView(self.payTypeView,15).heightIs(14);
    self.alipayView.sd_layout.topEqualToView(self.payTypeView).leftEqualToView(self.payTypeView).rightEqualToView(self.payTypeView).heightIs(65);
    self.lineView.sd_layout.centerYEqualToView(self.payTypeView).leftEqualToView(self.payTypeView).rightEqualToView(self.payTypeView).heightIs(0.7);
    self.line2View.sd_layout.topEqualToView(self.payTypeView).leftEqualToView(self.payTypeView).rightEqualToView(self.payTypeView).heightIs(0.7);
    self.line3View.sd_layout.bottomEqualToView(self.payTypeView).leftEqualToView(self.payTypeView).rightEqualToView(self.payTypeView).heightIs(0.7);
    self.weChatImg.sd_layout.topSpaceToView(self.lineView,24).leftSpaceToView(self.payTypeView,15).heightIs(17).widthIs(17);
    self.weChatIcon.sd_layout.topSpaceToView(self.lineView,17.5).leftSpaceToView(self.alipayImg,30).heightIs(30).widthIs(30);
    self.weChatLab.sd_layout.topSpaceToView(self.lineView,15.5).leftSpaceToView(self.weChatIcon,15).rightSpaceToView(self.payTypeView,15).heightIs(18);
    self.weChatxLab.sd_layout.topSpaceToView(self.weChatLab,2).leftSpaceToView(self.weChatIcon,15).rightSpaceToView(self.payTypeView,15).heightIs(14);
    self.weChatView.sd_layout.topSpaceToView(self.lineView,0).leftEqualToView(self.payTypeView).rightEqualToView(self.payTypeView).heightIs(65);
    self.surePayBtn.sd_layout.topSpaceToView(self.payTypeView,25).leftSpaceToView(self.view,15).rightSpaceToView(self.view,15).heightIs(45);
}

#pragma mark - 懒加载
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
        _lineView.backgroundColor = RGB(220, 220, 220);
    }
    return _lineView;
}
- (UIView *)line2View {
    if (!_line2View) {
        _line2View = [UIView new];
        _line2View.backgroundColor = RGB(220, 220, 220);
    }
    return _line2View;
}
- (UIView *)line3View {
    if (!_line3View) {
        _line3View = [UIView new];
        _line3View.backgroundColor = RGB(220, 220, 220);
    }
    return _line3View;
}
- (UIView *)line4View {
    if (!_line4View) {
        _line4View = [UIView new];
        _line4View.backgroundColor = RGB(220, 220, 220);
    }
    return _line4View;
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
- (UIView *)yueView {
    if (!_yueView) {
        _yueView = [UIView new];
        _yueView.userInteractionEnabled = YES;
    }
    return _yueView;
}
- (UILabel *)payTypeLab {
    if (!_payTypeLab) {
        _payTypeLab = [UILabel new];
        _payTypeLab.text = @"订单金额";
        _payTypeLab.textColor = [UIColor lightGrayColor];
        _payTypeLab.font = [UIFont systemFontOfSize:16];
    }
    return _payTypeLab;
}
- (UILabel *)priceLab {
    if (!_priceLab) {
        _priceLab = [UILabel new];
        _priceLab.text = @"¥ 0.00";
        _priceLab.textColor = RGB(232, 78, 64);
        _priceLab.textAlignment = NSTextAlignmentRight;
        _priceLab.font = [UIFont systemFontOfSize:16];
    }
    return _priceLab;
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
- (UILabel *)yueLab {
    if (!_yueLab) {
        _yueLab = [UILabel new];
        _yueLab.text = @"余额支付";
        _yueLab.font = [UIFont systemFontOfSize:16];
    }
    return _yueLab;
}
- (UILabel *)yuexLab {
    if (!_yuexLab) {
        _yuexLab = [UILabel new];
        _yuexLab.text = @"余额支付安全急速的支付方式";
        _yuexLab.textColor = HuiText_Color;
        _yuexLab.font = [UIFont systemFontOfSize:13];
    }
    return _yuexLab;
}
- (UILabel *)totalPriceLab {
    if (!_totalPriceLab) {
        _totalPriceLab = [UILabel new];
        _totalPriceLab.text = @"¥";
        _totalPriceLab.textColor = RGB(232, 78, 64);
        _totalPriceLab.font = [UIFont systemFontOfSize:13];
    }
    return _totalPriceLab;
}
- (UIImageView *)alipayImg {
    if (!_alipayImg) {
        _alipayImg = [UIImageView new];
        _alipayImg.image = [UIImage imageNamed:@"weixuan"];
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
- (UIImageView *)yueImg {
    if (!_yueImg) {
        _yueImg = [UIImageView new];
        _yueImg.image = [UIImage imageNamed:@"duidui"];
    }
    return _yueImg;
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
- (UIImageView *)yueIcon {
    if (!_yueIcon) {
        _yueIcon = [UIImageView new];
        _yueIcon.image = [UIImage imageNamed:@"yuee"];
    }
    return _yueIcon;
}
- (UIButton *)surePayBtn {
    if (!_surePayBtn) {
        _surePayBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_surePayBtn setTitle:@"确认支付" forState:UIControlStateNormal];
        [_surePayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _surePayBtn.backgroundColor = Main_Color;
        _surePayBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _surePayBtn.clipsToBounds = YES;
        _surePayBtn.layer.cornerRadius = 5;
        [_surePayBtn addTarget:self action:@selector(surePayBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _surePayBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
