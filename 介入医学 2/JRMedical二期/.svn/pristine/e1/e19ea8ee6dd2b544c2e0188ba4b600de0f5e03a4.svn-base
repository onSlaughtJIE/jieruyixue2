//
//  WLZ_JieSuanViewController.m
//  JRMedical
//
//  Created by apple on 16/6/22.
//  Copyright © 2016年 ZC. All rights reserved.
//

#import "WLZ_JieSuanViewController.h"
#import "DingdanAddressCell.h"
#import "WLZ_ShoppingCarCell.h"
#import "DingdanInfoCell.h"
#import "WLZ_ShoppIngCarModel.h"
#import "HJAddressInfoModel.h"
#import "DingdanGoodCell.h"
#import "ChooseAddressViewController.h"
#import "WLZ_SubmitOrderController.h"
#import "SCGoodsModel.h"

@interface WLZ_JieSuanViewController ()<UITableViewDelegate, UITableViewDataSource, ChooseAddressViewControllerDelegate, UITextFieldDelegate>

{
    HJAddressInfoModel *_addressInfoModel;
    UIButton *_personalBtn;
    UIButton *_companyBtn;
    CGFloat _totalPrice;
    MBProgressHUD *HUD;
}

@property (nonatomic, strong) UITableView *jsTabelView;
@property (nonatomic, strong) NSMutableArray *goodsDataSource;
@property (nonatomic, strong) UIView *endView;

@property (nonatomic, strong) NSString *addid;

@property (nonatomic, strong) NSString *newtitle;
@property (nonatomic, assign) NSInteger perorgs;
@property (nonatomic, strong) NSString *modestr;
@property (nonatomic, assign) NSInteger isf;
@property (nonatomic, strong) NSString *gsadd;


@end

@implementation WLZ_JieSuanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initTableView];
    
    // 确认订单 底部视图
    [self.view addSubview:self.endView];
    
    // 获取默认收货地址信息
    [self getDefaultShouHuoAddress];
    
//    self.goodsDataSource = self.selectGoodsArr;
    
    if (self.goodModelTypeNum == 288) {
        
        self.goodsDataSource = self.singleGoodArr;
        
    }else {
         self.goodsDataSource = self.selectGoodsArr;
    }
    
    _isf = 0;
    
    NSLog(@"self.selectGoodsArr - %@", self.selectGoodsArr);
}

#pragma mark - 确认订单 底部视图
- (UIView *)endView
{
    if (!_endView) {
        _endView = [[UIView alloc]initWithFrame:CGRectMake(0, Height_Screen-64-44, Width_Screen, 45)];
        _endView.backgroundColor = RGB(244, 244, 244);
        
        if (self.goodModelTypeNum == 288) {
            
            SCGoodsModel *model = self.singleGoodArr.firstObject;
            _totalPrice = model.PromotionPrice;
            _modestr = [NSString stringWithFormat:@"%ld,%d", (long)model.CommodityID, 1];

            
        } else {
            NSString *string;
            NSMutableArray *marray = [NSMutableArray arrayWithCapacity:0];
            for (WLZ_ShoppIngCarModel *model in self.selectGoodsArr) {
                CGFloat temp = model.PromotionPrice * model.Number;
                _totalPrice += temp;
                string = [NSString stringWithFormat:@"%ld,%ld", (long)model.CommodityID, (long)model.Number];
                [marray addObject:string];
            }
            //        NSLog(@"marray - %@", marray);
            NSString *newstring = [marray componentsJoinedByString:@";"];
            _modestr = newstring;
        }
        
        
        
//        NSLog(@"  xuixindexddd%@", newstring);
//        NSLog(@"_totalPrice - %f", _totalPrice);
        UILabel *totalPriceLabel = [[UILabel alloc] initWithFrame:(CGRectMake(15, 5, 200, 35))];
        totalPriceLabel.text = [NSString stringWithFormat:@"实付款: ¥%.2f", _totalPrice];
        [_endView addSubview:totalPriceLabel];
        
        
        UIImageView *rightView = [[UIImageView alloc] initWithFrame:(CGRectMake(Width_Screen/3*2, 0, Width_Screen/3, 45))];
        rightView.image = [UIImage imageNamed:@"tijiao"];
        rightView.userInteractionEnabled = YES;
        [rightView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadOrder:)]];
        [_endView addSubview:rightView];
        
    }
    return _endView;
}


- (void)initTableView {
    
    _jsTabelView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _jsTabelView.dataSource = self;
    _jsTabelView.delegate = self;
//    _jsTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _jsTabelView.backgroundColor = RGB(233, 233, 233);
    [self.view addSubview:_jsTabelView];
    
    UIView *footView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, Height_Screen, 80))];
    footView.backgroundColor = RGB(233, 233, 233);
    _jsTabelView.tableFooterView = footView;
    
    
    [self.jsTabelView registerNib:[UINib nibWithNibName:@"DingdanAddressCell" bundle:nil] forCellReuseIdentifier:@"AddressCell"];
    [self.jsTabelView registerNib:[UINib nibWithNibName:@"DingdanGoodCell" bundle:nil] forCellReuseIdentifier:@"goodCell"];
    [self.jsTabelView registerNib:[UINib nibWithNibName:@"DingdanInfoCell" bundle:nil] forCellReuseIdentifier:@"infoCell"];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 1) {
        return self.goodsDataSource.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        DingdanAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressCell" forIndexPath:indexPath];
        
//        if ([FXTPublicTools isBlankString:_addressInfoModel.ConsigneeName]) {
//            cell.shouhuoPersonName.text = @"收货人:";
//        }else {
//            cell.shouhuoPersonName.text = [NSString stringWithFormat:@"收货人: %@", _addressInfoModel.ConsigneeName];
//        }
//        
//        if ([FXTPublicTools isBlankString:_addressInfoModel.Consigneephone]) {
//            cell.telLabel.text = @"";
//        }else {
//            cell.telLabel.text = _addressInfoModel.Consigneephone;
//        }
//        
//        if ([FXTPublicTools isBlankString:_addressInfoModel.DetailAddress]) {
//            cell.shouhuoAddress.text = @"收货地址:";         
//        }else {
//             cell.shouhuoAddress.text = [NSString stringWithFormat:@"收货地址: %@", _addressInfoModel.DetailAddress];
//        }
        
      
        return cell;
        
    } else if (indexPath.section == 1){
        
        
        if (self.goodModelTypeNum == 288) {
            
            SCGoodsModel *model = self.goodsDataSource[indexPath.row];
            DingdanGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodCell" forIndexPath:indexPath];
            
            [cell.goodImageView sd_setImageWithURL:[NSURL URLWithString:model.Pic1] placeholderImage:[UIImage imageNamed:@"zhan"]];
            cell.goodTitle.text = model.Name;
            cell.goodPrice.text = [NSString stringWithFormat:@"¥%.2f", model.PromotionPrice];
            cell.goodNumber.text = [NSString stringWithFormat:@"＊%d", 1];
            
            return cell;
            
        } else {
            WLZ_ShoppIngCarModel *model = self.goodsDataSource[indexPath.row];
            
            DingdanGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodCell" forIndexPath:indexPath];
            
            [cell.goodImageView sd_setImageWithURL:[NSURL URLWithString:model.Pic1] placeholderImage:[UIImage imageNamed:@"zhan"]];
            cell.goodTitle.text = model.Name;
            cell.goodPrice.text = [NSString stringWithFormat:@"¥%.2f", model.PromotionPrice];
            cell.goodNumber.text = [NSString stringWithFormat:@"＊%ld", (long)model.Number];
            
            return cell;
        }
       
        
    } else {
        
        DingdanInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoCell" forIndexPath:indexPath];
        
        
        _personalBtn = cell.personalBtn;
        _companyBtn = cell.companyBtn;
//        _gsadd = cell.companyNameTf.text;
        cell.companyNameTf.delegate = self;
        cell.companyNameTf.returnKeyType = UIReturnKeyDone;
        
        [cell.companyNameTf addTarget:self action:@selector(getCEllTfText:) forControlEvents:UIControlEventEditingChanged];
        [_personalBtn addTarget:self action:@selector(personalBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [_companyBtn addTarget:self action:@selector(companyBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        return cell;
    }
    
    return nil;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 90;
    }
    else if (indexPath.section == 2){
        return 130;
    }
 
    return 100;
}

// 区头
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 0.01;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        
        ChooseAddressViewController *addressVC = [ChooseAddressViewController new];
        addressVC.delegate = self;
        [self.navigationController pushViewController:addressVC animated:YES];
        
    } else {
        
        
    }
}

#pragma mark - ChooseAddressViewControllerDelegate
- (void)passAddress:(HJAddressInfoModel *)addressModel {
    
    _addressInfoModel = addressModel; // 更新model信息值
    _addid = [NSString stringWithFormat:@"%ld",(long)addressModel.ID];
    NSIndexSet *indesSet = [NSIndexSet indexSetWithIndex:0];
    // 刷新收货地址信息 - 第一个分区
    [_jsTabelView reloadSections:indesSet withRowAnimation:(UITableViewRowAnimationAutomatic)];
    
}



#pragma mark - 收货地址>>读取 >> IsDefault
-(void)getDefaultShouHuoAddress
{    
//    NSString *url = [NSString stringWithFormat:@"%@/API/MallsInfo/ReceiptAddressLst", UrlStr];
//    
//    NSString *datasStr = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@ZICBDYCOpeType=%@", kPrefixPara, UserDefaultsGet(kDevIdentityInfo), kDevSysInfo, kDevTypeInfo, kIMEI, @"IsDefault", nil];
//    //    NSLog(@"加密前的字符串 ----- %@", datasStr);
//    NSString *DataEncrypt = [TWDes encryptWithContent:datasStr type:kDesType key:kDesKey];
//    //    NSLog(@"加密后的字符串 ----- %@", DataEncrypt);
//    
//    // 调接口需要的两个参数
//    NSDictionary *paraDic = @{kAccessTokenInfo:UserDefaultsGet(kAccessTokenInfo), kDatas:DataEncrypt};
//    
//    [Tool postWithPath:url params:paraDic success:^(id JSON) {
//        NSLog(@" // 收货地址 >> 读取 >> 默认 --  %@", JSON);
//        if ([JSON[@"Success"] integerValue] == 1) {
//            
//            _addressInfoModel = [[HJAddressInfoModel alloc] init]; // 别忘记初始化
//            NSArray *jsonArr = JSON[@"JsonData"];
//            [_addressInfoModel setValuesForKeysWithDictionary:jsonArr.firstObject];
//            _addid = [NSString stringWithFormat:@"%ld",(long)_addressInfoModel.ID];
//            
//        }
//    
//        
//        NSIndexSet *indesSet = [NSIndexSet indexSetWithIndex:0];
//        // 刷新收货地址信息 - 第一个分区
//        [_jsTabelView reloadSections:indesSet withRowAnimation:(UITableViewRowAnimationAutomatic)];
//        
//    } failure:^(NSError *error) {
//        NSLog(@"error - %@", error);
//    }];
    
    
}

#pragma mark - Button Action
- (void)personalBtnAction:(UIButton *)sender {
//    NSLog(@"选择了个人");
    _perorgs = 1;
    _isf = 1;
    [sender setImage:[UIImage imageNamed:@"yes"] forState:(UIControlStateNormal)];
    [_companyBtn setImage:[UIImage imageNamed:@"no"] forState:(UIControlStateNormal)];
}

- (void)companyBtnAction:(UIButton *)sender {
//     NSLog(@"选择了公司");
    _perorgs = 0;
    _isf = 1;
    [sender setImage:[UIImage imageNamed:@"yes"] forState:(UIControlStateNormal)];
    [_personalBtn setImage:[UIImage imageNamed:@"no"] forState:(UIControlStateNormal)];
}

- (void)getCEllTfText:(UITextField *)sender {
    
    _gsadd = sender.text;
}

- (void)uploadOrder:(UITapGestureRecognizer *)sender {
    NSLog(@"提交订单");
/*
//    NSLog(@"订单地址 - %@", _addid);
    
    if ([FXTPublicTools isBlankString:_addressInfoModel.Consigneephone] || [FXTPublicTools isBlankString:_addressInfoModel.ConsigneeName]) {
        [self showHUDWithText:@"请完善收货人信息"];
        
    } else {
        [SVProgressHUD show];
        
//        NSLog(@"发票抬头 - _gsadd - %@", _gsadd);
        
        NSString *url = [NSString stringWithFormat:@"%@/api/Order/CreateOrder", UrlStr];
        NSString *datasStr = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@ZICBDYCReceiptAddressID=%@ZICBDYCPayMoneyAmount=%.2fZICBDYCIsInvoice=%ldZICBDYCInvoiceType=%ldZICBDYCInvoiceHeader=%@ZICBDYCCommodityLst=%@", kPrefixPara, UserDefaultsGet(kDevIdentityInfo), kDevSysInfo, kDevTypeInfo, kIMEI, _addid, _totalPrice, (long)_isf, (long)_perorgs, _gsadd, _modestr, nil];
//        NSLog(@"订单提交 - %@", datasStr);
        NSString *DataEncrypt = [TWDes encryptWithContent:datasStr type:kDesType key:kDesKey];
        // 调接口需要的两个参数
        NSDictionary *paraDic = @{kAccessTokenInfo:UserDefaultsGet(kAccessTokenInfo), kDatas:DataEncrypt};
        
        [Tool postWithPath:url params:paraDic success:^(id JSON) {
            
//            NSLog(@" 提交订单 - JSON - %@------%@", JSON,JSON[@"Msg"]);
            
            if ([JSON[@"Success"] integerValue] == 1) {
                
                [SVProgressHUD dismiss];
                
                NSDictionary *orderDic = JSON[@"JsonData"];
                
                WLZ_SubmitOrderController *orderVC = [[WLZ_SubmitOrderController alloc] init];
                orderVC.title = @"我的收银台";
                orderVC.totalPrice =_totalPrice;
                orderVC.orderID = orderDic[@"OrderNO"];
                [self.navigationController pushViewController:orderVC animated:YES];
                
                
            }else {
                
                [SVProgressHUD dismissWithError:JSON[@"MSg"]];
            }
            
        } failure:^(NSError *error) {
            
            [SVProgressHUD dismissWithError:@"服务器开小差了,订单提交失败"];
            
        }];
    }
    
    
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
