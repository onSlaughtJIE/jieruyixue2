//
//  WLZ_SubmitOrderController.m
//  JRMedical
//
//  Created by apple on 16/6/25.
//  Copyright © 2016年 ZC. All rights reserved.
//

#import "WLZ_SubmitOrderController.h"
#import "WLZ_ShoppingCarController.h"
#import "MyPayOrder.h"
//#import "Order.h"
//#import "WXApi.h"
//#import "WXApiObject.h"
//#import <AlipaySDK/AlipaySDK.h>
//#import "DataSigner.h"
#import "SVProgressHUD.h"
//#import "MyOrderDetailController.h"

@interface WLZ_SubmitOrderController ()<UIAlertViewDelegate>

{
    MBProgressHUD *HUD;
}

@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIView *yuePayView;
@property (weak, nonatomic) IBOutlet UIView *wxinPayView;
@property (weak, nonatomic) IBOutlet UIView *aliPayView;

@end



@implementation WLZ_SubmitOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"self.orderID - %@", self.orderID);
    
    self.totalPriceLabel.text = [NSString stringWithFormat:@"¥%.2f", _totalPrice];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"Storegouwuche"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  style:UIBarButtonItemStylePlain target:self action:@selector(GouWuChe:)];
    
    [self.yuePayView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(yuePay:)]];
    [self.wxinPayView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wxinPay:)]];
    [self.aliPayView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aliPay:)]];
    
    /*
    // 接受支付宝支付回调结果的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(aliPayCallBack:) name:kAliPayCallBackInfo object:nil];
    // 接受微信支付回调结果的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weixin_pay_result_success:) name:kWeixin_pay_result_success object:nil];
    */
}

// 支付宝回调  支付成功后 进入订单详情界面
- (void)aliPayCallBack:(NSNotification *)resultDic {

    NSLog(@"resultDic.userInfo - %@", resultDic.userInfo);
    
    NSString *codeStr = resultDic.userInfo[@"resultStatus"];
    
    if ([codeStr isEqualToString:@"9000"]) {
        [SVProgressHUD showSuccessWithStatus:@"支付成功"];
        
//        MyOrderDetailController *orderVc = [MyOrderDetailController new];
//        orderVc.OrderNoString = self.orderID;
//        [self.navigationController pushViewController:orderVc animated:YES];
        
    }
    else if ([codeStr isEqualToString:@"8000"]) {
        [SVProgressHUD showWithStatus:@"正在处理中..."];
    }
    else if ([codeStr isEqualToString:@"4000"]) {
        [SVProgressHUD showErrorWithStatus:@"订单支付失败"];
    }
    else if ([codeStr isEqualToString:@"6002"]) {
        [SVProgressHUD showErrorWithStatus:@"网络连接出错"];
    }
    else if ([codeStr isEqualToString:@"6001"]) {
        [SVProgressHUD showErrorWithStatus:@"取消了订单"];
    }else {
        [SVProgressHUD showErrorWithStatus:@"支付失败"];
    }
    
}

// 微信回调 支付成功后 进入订单详情界面
- (void)weixin_pay_result_success:(NSNotification *)sender {
    
    NSLog(@"医学商城 - 微信支付成功");
    [SVProgressHUD showSuccessWithStatus:@"支付成功"];
    
//    MyOrderDetailController *orderVc = [MyOrderDetailController new];
//    orderVc.OrderNoString = self.orderID;
//    [self.navigationController pushViewController:orderVc animated:YES];
    
}


- (void)GouWuChe:(UIBarButtonItem *)sender {

    WLZ_ShoppingCarController *car = [[WLZ_ShoppingCarController alloc]init];
    [self.navigationController pushViewController:car animated:YES];
}


#pragma mark - 余额支付
- (void)yuePay:(UITapGestureRecognizer *)sender {
    
    NSLog(@"余额支付");
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"是否使用余额支付"
                                                       message:nil
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"确定", nil];
    [alertView show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSLog(@"确认支付");
        [self yuezhifu];
    }
}


- (void)yuezhifu {
    
    /*
    NSString *url = [NSString stringWithFormat:@"%@/api/MallsInfo/BalanceOrderPay", UrlStr];
    NSString *datasStr = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@ZICBDYCOrderNO=%@", kPrefixPara, UserDefaultsGet(kDevIdentityInfo), kDevSysInfo, kDevTypeInfo, kIMEI, _orderID, nil];
    NSString *DataEncrypt = [TWDes encryptWithContent:datasStr type:kDesType key:kDesKey];
    // 调接口需要的两个参数
    NSDictionary *paraDic = @{kAccessTokenInfo:UserDefaultsGet(kAccessTokenInfo), kDatas:DataEncrypt};
    
    [Tool postWithPath:url params:paraDic success:^(id JSON) {
        
//        NSLog(@"余额支付 - JSON - %@~~~~~~~%@", JSON,JSON[@"Msg"]);
        
        if ([JSON[@"Success"] integerValue] == 1) {
            
            [SVProgressHUD showSuccessWithStatus:@"支付成功"];
            
            MyOrderDetailController *orderVc = [MyOrderDetailController new];
            orderVc.OrderNoString = self.orderID;
            [self.navigationController pushViewController:orderVc animated:YES];
            
        }else {
            

            [SVProgressHUD showErrorWithStatus:JSON[@"Msg"]];
        }
        
    } failure:^(NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"服务器开小差,支付失败"];
    }];
     
     */

}


#pragma mark - 微信支付
- (void)wxinPay:(UITapGestureRecognizer *)sender {
    
    NSLog(@"微信支付");
    
    [self wPay:_orderID];

}



#pragma mark - 支付宝支付
- (void)aliPay:(UITapGestureRecognizer *)sender {
    
    NSLog(@"支付宝支付");
    
    MyPayOrder * payOrder = [[MyPayOrder alloc] init];
    payOrder.tradeNO =  _orderID;
    payOrder.seller = @"3378128098@qq.com";
    payOrder.partner = @"2088421318655339";
    payOrder.totalMoney = [NSString stringWithFormat:@"%.2f", _totalPrice];
    payOrder.privateKey = @"MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAKaSYIA6++s8RKWV6z1QF78RwcDquw7slnjXK16ZAFPSbUW6STwaZIbZiHVJ9UowI06TDLI1nMpkRn69bLZfLyzlTOjwHITx0qUa2sm7AbHkJJGFxrVvsd7djK765kUT1bF6Y7X5ryhkcmG3S/rBB4EBxyR/97KfJ8Y3O1ya0vA9AgMBAAECgYAxO04+WDChBD0d28OdaZC7Llpf1IDZFmAa8y2kVgBcxfL6CuceVoajvKOyVtuiw7uLu7ai7WmcACs9xmrdNCDS39bTSGou6IFJXyZXWwkylYbJHZzbKPmJkKEz8zhyF2p8tXDXKGf0+oaKGKtWIL1tYqwtLBmgmByNNcVzmyfo2QJBANxzboVt1640I7oY3YXGF6Oit9kF7Rpmfksm2MNEE+tYySgamJBwJiqLdvwUWH9IxwdFfm7ooTjBAupPFfNCSS8CQQDBbrp5GF0IMi+ke1CAZmAkvCAxGgJGlrP9tEE2BBTFdrG2axluBATqenSkCxxZHgp27jxpaZ3yG/DrPuLdBKpTAkBsZ2rqvAf6RvNmmMGd/bo0IljrpGliuRHTnMesxbZR3bgVO3bYV/28oBYjgVG/TadpYPf6S/Sztt3bIIa3t1nLAkAC9ptMt57VPU+ViX4WOXtHlMo5dliKlEx1molVNoLK86KNVN6y3MTmgrG+wZzRkLBAWi36v294Ag2SzQfUsvmZAkB0LN/P6BQOGi24VTTVeK1Z1vW2r3zO3hb4yEzSExbdJJ92KW+Bs97n0VQfMh49O+7+gYmjneOYbIgJAMw3Jyr/";
    [self aliPayFor:payOrder];
    
}


//支付宝支付
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
    
    /*
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = getOrder.partner;
    order.sellerID = getOrder.seller;
    order.outTradeNO = getOrder.tradeNO; //订单ID（由商家自行制定）
    order.subject = @"介入医学商品购买"; //商品标题
    order.body = @"医学商城"; //商品描述
    order.totalFee = getOrder.totalMoney; //商品价格
    order.notifyURL = [NSString stringWithFormat:@"www.jieruyixue.com:7023/AlipayNotify"]; //回调URL
    
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
                [SVProgressHUD showSuccessWithStatus:@"支付成功了"];
                
                MyOrderDetailController *orderVc = [MyOrderDetailController new];
                orderVc.OrderNoString = self.orderID;
                [self.navigationController pushViewController:orderVc animated:YES];

                
            }
            else if ([codeStr isEqualToString:@"8000"]) {
                [SVProgressHUD showWithStatus:@"正在处理中..."];
            }
            else if ([codeStr isEqualToString:@"4000"]) {
                [SVProgressHUD showErrorWithStatus:@"订单支付失败"];
            }
            else if ([codeStr isEqualToString:@"6002"]) {
                [SVProgressHUD showErrorWithStatus:@"网络连接出错"];
            }
            else if ([codeStr isEqualToString:@"6001"]) {
                [SVProgressHUD showErrorWithStatus:@"取消了订单"];
            }else {
                [SVProgressHUD showErrorWithStatus:@"支付失败"];
            }
            
            NSURL *myUrl = [NSURL URLWithString:@"jieruyixue"];
            if([[UIApplication sharedApplication] canOpenURL:myUrl]){
                [[UIApplication sharedApplication] openURL:myUrl];
            }
        }];
    }
     
     */
}



//微信支付
- (void)wPay:(NSString *)orderID
{
    [SVProgressHUD show];

    /*
    NSString *url = [NSString stringWithFormat:@"%@/api/MallsInfo/WxOrderPay", UrlStr];
    NSString *datasStr = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@ZICBDYCOrderNO=%@", kPrefixPara, UserDefaultsGet(kDevIdentityInfo), kDevSysInfo, kDevTypeInfo, kIMEI, _orderID, nil];
    NSString *DataEncrypt = [TWDes encryptWithContent:datasStr type:kDesType key:kDesKey];
    // 调接口需要的两个参数
    NSDictionary *paraDic = @{kAccessTokenInfo:UserDefaultsGet(kAccessTokenInfo), kDatas:DataEncrypt};
    
    [Tool postWithPath:url params:paraDic success:^(id JSON) {
        
        NSLog(@"微信支付 - JSON - %@", JSON);
        
        if ([JSON[@"Success"] integerValue] == 1) {
            
            [SVProgressHUD dismiss];
            
            if ([[JSON objectForKey:@"Success"] integerValue]==1) {
                
                NSDictionary *dic = JSON[@"JsonData"];
                //构造支付请求
                PayReq *request   = [[PayReq alloc]init];
                request.partnerId = [dic objectForKey:@"partnerid"];
                request.prepayId  = [dic objectForKey:@"prepayid"];
                request.package   = [dic objectForKey:@"packages"];
                request.nonceStr  = [dic objectForKey:@"noncestr"];
                request.timeStamp = [[dic objectForKey:@"timestamp"]intValue];
                request.sign = [dic objectForKey:@"sign"];
                [WXApi sendReq:request];
                
//                NSLog(@"timeStamp - %u", (unsigned int)request.timeStamp);
//                NSLog(@"request - %@", request);
                
            }else{
                [self showHUDWithText:[JSON objectForKey:@"msg"]];
            }
            
            
        }else {
            
            [SVProgressHUD dismissWithError:JSON[@"Msg"]];

        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@", error.description);
        [SVProgressHUD dismissWithError:error.description];

    }];
     
     */
    
}


-(void)showHUDWithText:(NSString *)showText
{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = showText;
    HUD.mode = MBProgressHUDModeText;
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [HUD removeFromSuperview];
        HUD = nil;
    }];
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
