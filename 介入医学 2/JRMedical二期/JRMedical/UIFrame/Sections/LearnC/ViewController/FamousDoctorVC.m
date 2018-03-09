//
//  FamousDoctorVC.m
//  JRMedical
//
//  Created by ww on 2016/12/29.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "FamousDoctorVC.h"
#import "FamousHosCell.h"
#import "MyAttentionModel.h"
#import "UITableView+EmpayData.h"
//#import "PayOrderVC.h"
//#import "MyPayOrder.h"
//#import "Order.h"
//#import "WXApi.h"
//#import "WXApiObject.h"
//#import <AlipaySDK/AlipaySDK.h>
//#import "DataSigner.h"

//#import "ChatViewController.h"
#import "ExpertDetailsVC.h"

@interface FamousDoctorVC ()<UITableViewDelegate, UITableViewDataSource>
{
    NSString *_expertID;
    NSString *_chatName;
//    NSInteger _serviceTypeNum; // 1 图文咨询 ; 2 电话咨询
    NSString *_hxid;
//    ChatViewController *_chatVC;
}

@property (nonatomic, strong) UITableView *tableView;
@end

@implementation FamousDoctorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
    self.tableView.backgroundColor = BG_Color;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"FamousHosCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:(CGRectMake(0, 0, Width_Screen, Width_Screen/2))];
    self.tableView.tableHeaderView = imageView;
    imageView.backgroundColor = BG_Color;
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.hosPic] placeholderImage:[UIImage imageNamed:@"jiazai"]];
    //
    [self requestListDataArrray];
    
    //
    /*
    // 接受支付宝支付回调结果的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(aliPayCallBack2:) name:kAliPayCallBackInfo object:nil];
    // 接受微信支付回调结果的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weixin_pay_result_success2:) name:kWeixin_pay_result_success object:nil];
     */
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.dataSource == nil) {
        [tableView tableViewDisplayWitMsg:@"" ifNecessaryForRowCount:self.dataSource.count];
    }
    else {
        [tableView tableViewDisplayWitMsg:@"暂无相关信息!" ifNecessaryForRowCount:self.dataSource.count];
    }
    return self.dataSource.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FamousHosCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    MyAttentionModel *model = self.dataSource[indexPath.row];
    
    [cell setFamousHosCellWithModel:model];
    
//    [cell.chatBtn addTarget:self action:@selector(chatAction:) forControlEvents:(UIControlEventTouchUpInside)];
    cell.chatBtn.userInteractionEnabled = NO;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyAttentionModel *model = self.dataSource[indexPath.row];
    
    ExpertDetailsVC *expertVC = [[ExpertDetailsVC alloc] init];
    
    expertVC.title = model.CustomerName;
    
    expertVC.model = model;
    
    [self.navigationController pushViewController:expertVC animated:YES];
    
}

// 图文咨询
- (void)chatAction:(UIButton *)sender {
    
    NSLog(@"nothing");
    
    /*
    FamousHosCell *cell = (FamousHosCell *)sender.superview.superview.superview;
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    MyAttentionModel *model = self.dataSource[index.row];
    
    // 会员咨询医生之前查询医生的在线状态
    NSLog(@"model.CustomerID - %@", model.CustomerID);
    _expertID = model.CustomerID;
    _chatName = model.CustomerName;
    [self GetIMUserStatuWithHuanXinID:_expertID];
    */
    
}

#pragma mark - 请求数据列表
- (void)requestListDataArrray {
    
    NSString *url = @"api/Customer/HospitalDoctorList";
    NSString *params = [NSString stringWithFormat:@"ZICBDYCHospitalID=%@", self.HospitalID];
    
    self.pageSize = 8;//一次加载8条数据
    self.tableType = 1;//TableView表类
    self.baseTableView = self.tableView;//将本类表 赋值给父类去操作
    [self showLoadding:@"" time:20];
    [self loadDataApi:url withParams:params refresh:RefreshTypeBoth model:MyAttentionModel.class];
}


/*
#pragma mark - 会员咨询医生之前查询医生的在线状态
- (void) GetIMUserStatuWithHuanXinID:(NSString *)huanxinID {
    
    NSString *url = [NSString stringWithFormat:@"%@//api/Customer/GetIMUserStatu", Server_Int_Url];
    NSString *datasStr = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@ZICBDYCCustomerID=%@", kPrefixPara, kDevIdentity, kDevSysInfo, kDevTypeInfo, kIMEI, huanxinID, nil];
    NSString *DataEncrypt = [TWDes encryptWithContent:datasStr type:kDesType key:kDesKey];
    NSString *token = [UserInfo getAccessToken];
    NSDictionary *paraDic = @{kToken:token, kDatas:DataEncrypt};

    
    [AFManegerHelp POST:url parameters:paraDic success:^(id responseObjeck) {
        NSLog(@"GetIMUserStatu - %@", responseObjeck);
        
        if ([responseObjeck[@"Success"] integerValue] == 1) {

            NSDictionary *dic = responseObjeck[@"JsonData"];

            if ([dic[@"Online"] integerValue] == 1) {
                NSLog(@"--------在线");
                [self alertThing];

            } else {
                NSLog(@"-----------不在线");
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示"
                                                                   message:@"您想咨询的医生不在线"
                                                                  delegate:self
                                                         cancelButtonTitle:@"确定"
                                                         otherButtonTitles:nil, nil];
                [alertView show];
            }

        }else {
            [self showMessage:@"获取医生在线状态失败"];
        }
        
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"cuowu%@", error);
    }];
}

- (void)alertThing {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"支付宝支付" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"支付宝支付");
        [self AliPayWithDocID:_expertID ServiceType:_serviceTypeNum];
    }];
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"微信支付" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"微信支付");
        [self WXinPayWithDocID:_expertID ServiceType:_serviceTypeNum];
    }];
    
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"余额支付" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"余额支付");
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"确定使用余额支付吗?"
                                                           message:nil
                                                          delegate:self
                                                 cancelButtonTitle:@"取消"
                                                 otherButtonTitles:@"确定", nil];
        [alertView show];
    }];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];
    
    
    [alert addAction:action2];
    [alert addAction:action3];
    [alert addAction:action4];
    [alert addAction:action1];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}


#pragma mark - 余额支付

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSLog(@"余额 - 确认支付");
        [self RemainPayWithDocID:_expertID ServiceType:_serviceTypeNum];
    }
}

- (void)RemainPayWithDocID:(NSString *)docID ServiceType:(NSInteger)serviceType {
    NSString *url = [NSString stringWithFormat:@"%@/api/MallsInfo/ServiceBalancePay", Server_Int_Url];
    NSString *datasStr = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@ZICBDYCDocID=%@ZICBDYCServiceType=%ld", kPrefixPara, kDevIdentity, kDevSysInfo, kDevTypeInfo, kIMEI, docID, (long)serviceType, nil];
    NSString *DataEncrypt = [TWDes encryptWithContent:datasStr type:kDesType key:kDesKey];
    NSString *token = [UserInfo getAccessToken];
    NSDictionary *paraDic = @{kToken:token, kDatas:DataEncrypt};
    
    [AFManegerHelp POST:url parameters:paraDic success:^(id responseObjeck) {
        
        if ([responseObjeck[@"Success"] integerValue] == 1) {
            
            [SVProgressHUD showSuccessWithStatus:@"支付成功"];
            _hxid = _expertID;
            _chatVC = [[ChatViewController alloc] initWithConversationChatter:_hxid
                                                                 conversationType:EMConversationTypeChat];
            _chatVC.title = _chatName;
            _chatVC.userid =  _hxid;
//            _chatVC.moneyStr = @"官方提醒：当前聊天由付费模式发起！";

            switch (serviceType) {
                case 1:
//                    _chatVC.isTextl = YES;
                    [self.navigationController pushViewController:_chatVC animated:YES];
                    break;
                case 2:
                    // (调起本地通话)
//                    [self alertPhoneCall];
                    break;
                default:
                    break;
            }
            
        }else { // 余额不足
            
            [self showMessage:responseObjeck[@"Msg"]];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error - %@", error);
    }];
}


#pragma mark - 微信支付
- (void)WXinPayWithDocID:(NSString *)docID ServiceType:(NSInteger)serviceType {
    
    [SVProgressHUD show];
    
    NSString *url = [NSString stringWithFormat:@"%@/api/MallsInfo/ServiceWxPay", Server_Int_Url];
    NSString *datasStr = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@ZICBDYCDocID=%@ZICBDYCServiceType=%ld", kPrefixPara, kDevIdentity, kDevSysInfo, kDevTypeInfo, kIMEI, docID, (long)serviceType, nil];
    
    NSString *DataEncrypt = [TWDes encryptWithContent:datasStr type:kDesType key:kDesKey];
    NSString *token = [UserInfo getAccessToken];
    NSDictionary *paraDic = @{kToken:token, kDatas:DataEncrypt};
    
    [AFManegerHelp POST:url parameters:paraDic success:^(id responseObjeck) {
        NSLog(@"微信支付 - %@", responseObjeck);
        if ([responseObjeck[@"Success"] integerValue] == 1) {
            
                [SVProgressHUD dismiss];

                NSDictionary *dic = responseObjeck[@"JsonData"];
                //构造支付请求
                PayReq *request   = [[PayReq alloc]init];
                request.partnerId = [dic objectForKey:@"partnerid"];
                request.prepayId  = [dic objectForKey:@"prepayid"];
                request.package   = [dic objectForKey:@"packages"];
                request.nonceStr  = [dic objectForKey:@"noncestr"];
                request.timeStamp = [[dic objectForKey:@"timestamp"]intValue];
                request.sign = [dic objectForKey:@"sign"];
                [WXApi sendReq:request];

            }else {
                
                [SVProgressHUD dismiss];
                [self showMessage:responseObjeck[@"Msg"]];
            }
        
        } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"cuowu%@", error);
    }];
}



#pragma mark - 支付宝支付 获取支付宝订单号
- (void)AliPayWithDocID:(NSString *)docID ServiceType:(NSInteger)serviceType{
    
    NSString *url = [NSString stringWithFormat:@"%@/api/MallsInfo/ServiceAliPay", Server_Int_Url];
    NSString *datasStr = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@ZICBDYCDocID=%@ZICBDYCServiceType=%ld", kPrefixPara, kDevIdentity, kDevSysInfo, kDevTypeInfo, kIMEI, docID, (long)serviceType, nil];
    NSLog(@"datasStr - %@", datasStr);
    
    NSString *DataEncrypt = [TWDes encryptWithContent:datasStr type:kDesType key:kDesKey];
    NSString *token = [UserInfo getAccessToken];
    NSDictionary *paraDic = @{kToken:token, kDatas:DataEncrypt};
    
    [AFManegerHelp POST:url parameters:paraDic success:^(id responseObjeck) {
        
        NSLog(@"支付宝支付 - %@", responseObjeck);

        if ([responseObjeck[@"Success"] integerValue] == 1) {

            NSDictionary *dic = responseObjeck[@"JsonData"];
            NSString *serviceNO = dic[@"ServiceNO"];
            CGFloat serviceMoney = [dic[@"ServiceMoney"] floatValue];

            [self aliPayWithServiceNO:serviceNO ServiceMoney:serviceMoney];

        }else {
            
            [self showMessage:responseObjeck[@"Msg"]];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error - %@", error);
    }];
}

#pragma mark - 支付宝支付
- (void)aliPayWithServiceNO:(NSString *)aliPayOrderID ServiceMoney:(CGFloat)serviceMoney{
    
    NSLog(@"支付宝支付");
    
    MyPayOrder * payOrder = [[MyPayOrder alloc] init];
    payOrder.tradeNO = aliPayOrderID;
    payOrder.seller = @"3378128098@qq.com";
    payOrder.partner = @"2088421318655339";
    payOrder.totalMoney = [NSString stringWithFormat:@"%.2f", serviceMoney];
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
    
 
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = getOrder.partner;
    order.sellerID = getOrder.seller;
    order.outTradeNO = getOrder.tradeNO; //订单ID（由商家自行制定）
    order.subject = @"介入医学服务"; //商品标题
    order.body = @"支付金额"; //商品描述
    order.totalFee = getOrder.totalMoney; //商品价格
    order.notifyURL = [NSString stringWithFormat:@"%@/AlipayNotify/ServiceIndex", Server_Int_Url]; //回调URL
    
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
            // 这块一直不走 网页的支付回调会走这里
            if ([codeStr isEqualToString:@"9000"]) {
                [SVProgressHUD showSuccessWithStatus:@"支付成功了"];
                
                _hxid = _expertID;
                _chatVC = [[ChatViewController alloc] initWithConversationChatter:_hxid
                                                                     conversationType:EMConversationTypeChat];
                _chatVC.title = _chatName;
                _chatVC.userid =  _hxid;
                
                NSLog(@"支付宝 - _serviceTypeNum - 1图文咨询 - 2电话咨询 - %ld", (long)_serviceTypeNum);
                switch (_serviceTypeNum) {
                    case 1:
//                        _chatVC.isTextl = YES;
                        [self.navigationController pushViewController:_chatVC animated:YES];
                        break;
                    case 2:
                        // (调起本地通话)
//                        [self alertPhoneCall];
                        break;
                        
                    default:
                        break;
                }
                
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
}


// 支付宝回调  支付成功后 进入订单详情界面
- (void)aliPayCallBack2:(NSNotification *)resultDic {
    
    NSLog(@"resultDic.userInfo - %@", resultDic.userInfo);
    
    NSString *codeStr = resultDic.userInfo[@"resultStatus"];
    
    if ([codeStr isEqualToString:@"9000"]) {
        
        [SVProgressHUD showSuccessWithStatus:@"支付成功"];

        _hxid = _expertID;
        _chatVC = [[ChatViewController alloc] initWithConversationChatter:_hxid
                                                             conversationType:EMConversationTypeChat];
        _chatVC.title = _chatName;
        _chatVC.userid =  _hxid;
        
        NSLog(@"支付宝 - _serviceTypeNum - 1图文咨询 - 2电话咨询 - %ld", (long)_serviceTypeNum);
        switch (_serviceTypeNum) {
            case 1:
//                _chatVC.isTextl = YES;
                [self.navigationController pushViewController:_chatVC animated:YES];
                break;
            case 2:
                // (调起本地通话)
//                [self alertPhoneCall];
                break;
                
            default:
                break;
        }
        
        
        
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
- (void)weixin_pay_result_success2:(NSNotification *)sender {
    
    NSLog(@"医生服务 - 微信支付成功");
    [SVProgressHUD showSuccessWithStatus:@"支付成功"];

    _hxid = _expertID;
    _chatVC = [[ChatViewController alloc] initWithConversationChatter:_expertID
                                                         conversationType:EMConversationTypeChat];
    _chatVC.title = _chatName;
    _chatVC.userid =  _hxid;
    
    NSLog(@"微信 - _serviceTypeNum - 1图文咨询 - 2电话咨询 - %ld", (long)_serviceTypeNum);
    switch (_serviceTypeNum) {
        case 1:
//            _chatVC.isTextl = YES;
            [self.navigationController pushViewController:_chatVC animated:YES];
            break;
        case 2:
            // (调起本地通话)
//            [self alertPhoneCall];
            break;
        default:
            break;
    }
    
    
    
}

*/


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
