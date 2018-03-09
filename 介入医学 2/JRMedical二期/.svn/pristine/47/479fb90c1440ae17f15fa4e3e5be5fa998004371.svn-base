//
//  ChooseAddressViewController.m
//  HongJHome
//
//  Created by 曹柏涵 on 15/8/25.
//  Copyright (c) 2015年 yizhisheng. All rights reserved.
//

#import "ChooseAddressViewController.h"
#import "ChooseAddressTableViewCell.h"
#import "NewAddressViewController.h"
#import "HJAddressInfoModel.h"

@interface ChooseAddressViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView * _tableView ;
    NSMutableArray *  _datasourceArr ;
    NSString * _indexPath;
    HJAddressInfoModel * _addressModel;
    
    NSInteger _deleteAddressID; // 地址主键ID,删除时使用
    MBProgressHUD *HUD;
}

@end

@implementation ChooseAddressViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    // 读取收货地址
    [self getRequest];

}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"管理收货地址";

//    [self showBack];
    [self initView];
}

-(void)initView {

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,8, Width_Screen, Height_Screen-64-8) style:UITableViewStylePlain];
    _tableView.dataSource =self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width_Screen, 90)];
    UILabel * addressLabel  = [[UILabel alloc] initWithFrame:CGRectMake(Width_Screen/2 - 50, 0, 100, 30)];
    addressLabel.text = @"新增地址";
    addressLabel.textAlignment = NSTextAlignmentCenter;
    addressLabel.textColor = RGB(154, 155, 155);
    addressLabel.font = [UIFont systemFontOfSize:16.0f];
    [backView addSubview:addressLabel];
    
    UIButton * addAddressBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    addAddressBtn.frame = CGRectMake((Width_Screen-50)/2, 30, 50, 50);
    [addAddressBtn addTarget:self action:@selector(addAddress) forControlEvents:UIControlEventTouchUpInside];
    [addAddressBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [backView addSubview:addAddressBtn];
    
    _tableView.tableFooterView = backView;
}
-(void)addAddress
{
    //新建新地址
    NewAddressViewController * newVC =[[NewAddressViewController alloc] init];
    [self.navigationController pushViewController:newVC animated:YES];
}

#pragma mark - 收货地址>>读取 >> All
-(void)getRequest
{
    [SVProgressHUD show];
    
    _datasourceArr = [[NSMutableArray alloc] init];

    /*
    NSString *url = [NSString stringWithFormat:@"%@/API/MallsInfo/ReceiptAddressLst", UrlStr];
    
    NSString *datasStr = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@ZICBDYCOpeType=%@", kPrefixPara, UserDefaultsGet(kDevIdentityInfo), kDevSysInfo, kDevTypeInfo, kIMEI, @"All", nil];
    //    NSLog(@"加密前的字符串 ----- %@", datasStr);
    NSString *DataEncrypt = [TWDes encryptWithContent:datasStr type:kDesType key:kDesKey];
    //    NSLog(@"加密后的字符串 ----- %@", DataEncrypt);
    
    // 调接口需要的两个参数
    NSDictionary *paraDic = @{kAccessTokenInfo:UserDefaultsGet(kAccessTokenInfo), kDatas:DataEncrypt};
    
    [Tool postWithPath:url params:paraDic success:^(id JSON) {
        NSLog(@" // 收货地址 >> 读取 --  %@", JSON);
        if ([JSON[@"Success"] integerValue] == 1) {
            
            [SVProgressHUD dismiss];
            
            NSArray *jsonArr = JSON[@"JsonData"];
            for (NSDictionary *dic in jsonArr) {
                HJAddressInfoModel *addressModel = [[HJAddressInfoModel alloc] init];
                [addressModel setValuesForKeysWithDictionary:dic];
                [_datasourceArr addObject:addressModel];
            }
            
        }else {
            
            [SVProgressHUD dismissWithError:JSON[@"Msg"]];
        }
        
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismissWithError:@"服务器出错"];
    }];
    */
   
}
#pragma mark - 行数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell.frame.size.height;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datasourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentify = @"ChooseAddressTableViewCell";
    
    ChooseAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ChooseAddressTableViewCell" owner:nil options:nil] lastObject];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
    }
    if (_datasourceArr.count>0) {
        HJAddressInfoModel * addressModel = [_datasourceArr objectAtIndex:indexPath.row];
     
        cell.addressLabel.text = addressModel.DetailAddress;
        cell.informationLabel.text = addressModel.ConsigneeName;
        cell.phoneLabel.text = addressModel.Consigneephone;
        
        cell.deleteBtn.tag = 2*indexPath.row+1;
        cell.changeAddressBtn.tag = 2*indexPath.row;
        cell.defultAddressBtn.tag = indexPath.row+1;
        [cell.defultAddressBtn addTarget:self action:@selector(defultAddressAction:) forControlEvents:UIControlEventTouchUpInside];
        if (_indexPath==nil) {
            if (addressModel.IsDefault == 1) {
                [cell.defultAddressBtn setTitle:@"  默认地址" forState:UIControlStateNormal];
                [cell.defultAddressBtn setImage:[UIImage imageNamed:@"yes.png"] forState:UIControlStateNormal];
            } else {
                [cell.defultAddressBtn setTitle:@"  设为默认" forState:UIControlStateNormal];
                [cell.defultAddressBtn setImage:[UIImage imageNamed:@"no.png"] forState:UIControlStateNormal];
            }
        }else{
            if ([_indexPath integerValue] == indexPath.row) {
                [cell.defultAddressBtn setTitle:@"  默认地址" forState:UIControlStateNormal];
                [cell.defultAddressBtn setImage:[UIImage imageNamed:@"yes.png"] forState:UIControlStateNormal];
            }else{
                [cell.defultAddressBtn setTitle:@"  设为默认" forState:UIControlStateNormal];
                [cell.defultAddressBtn setImage:[UIImage imageNamed:@"no.png"] forState:UIControlStateNormal];
            }
        }
//        UIFont *fot = [UIFont systemFontOfSize:15.0f];
//        CGSize size = [cell.informationLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fot,NSFontAttributeName, nil]];
        // 名字的W
//        CGFloat nameW = size.width;
//        cell.phoneLabel.frame = [FXTPublicTools changeXForFrame:cell.phoneLabel.frame withX:nameW+cell.informationLabel.frame.origin.x +10];
        [cell.deleteBtn addTarget:self action:@selector(deleteThis:) forControlEvents:UIControlEventTouchUpInside];
        [cell.delBtn addTarget:self action:@selector(deleteThis:) forControlEvents:UIControlEventTouchUpInside];
        [cell.changeAddressBtn addTarget:self action:@selector(changeThis:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中状态
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (_pushNumber == 104) {
        
        NSLog(@"我是从我的界面进来的");
        
    }else{
        
        ChooseAddressTableViewCell *cell = (ChooseAddressTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.redSelectBtn.hidden = NO;
        HJAddressInfoModel * addressModel = [_datasourceArr objectAtIndex:indexPath.row];
        
        [self.delegate passAddress:addressModel];
        
        [self performSelector:@selector(afterPop) withObject:nil afterDelay:0.5];
        
    }
    
    
}
-(void)afterPop
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 删除收货地址
-(void)deleteThis:(id)sender {

    UIButton * btn = (UIButton *)sender;
    _addressModel = [_datasourceArr objectAtIndex:(btn.tag-1)/2];
    _deleteAddressID = _addressModel.ID; // add
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

#pragma mark - 编辑收货地址
-(void)changeThis:(id)sender{
    UIButton * btn = (UIButton *)sender;
    HJAddressInfoModel * addressModel = [_datasourceArr objectAtIndex:btn.tag/2];
    NewAddressViewController * newAddressVC = [[NewAddressViewController alloc] init];
    newAddressVC.addressModel = addressModel;
    newAddressVC.fromNumber = 2333;
    newAddressVC.AddressID = addressModel.ID;
    [self.navigationController pushViewController:newAddressVC animated:YES];
}

#pragma mark - 设置默认按钮点击事件
- (void)defultAddressAction:(UIButton *)sender
{
    HJAddressInfoModel * addressModel = [_datasourceArr objectAtIndex:sender.tag-1];

    /*
    NSString *urlStr = [NSString stringWithFormat:@"%@/api/MallsInfo/SetDefaultAddress",UrlStr];
    
    NSString *datasStr = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@ZICBDYCID=%ld", kPrefixPara, UserDefaultsGet(kDevIdentityInfo), kDevSysInfo, kDevTypeInfo, kIMEI, (long)addressModel.ID, nil];

    NSString *DataEncrypt = [TWDes encryptWithContent:datasStr type:kDesType key:kDesKey];
    
    // 调接口需要的两个参数
    NSDictionary *paraDic = @{kAccessTokenInfo:UserDefaultsGet(kAccessTokenInfo), kDatas:DataEncrypt};
    
    [Tool postWithPath:urlStr params:paraDic success:^(id JSON) {
        
//        NSLog(@"设置默认地址 - JSON - %@", JSON);
        if ([JSON[@"Success"] integerValue] == 1) {
//            [self showHUDWithText:@"设置成功"];
            _indexPath =[NSString stringWithFormat:@"%ld",(long)sender.tag-1] ;
            [self getRequest];
            
        }else{
            [self showHUDWithText:JSON[@"Msg"]];
        }
        
     
    } failure:^(NSError *error) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络异常" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
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

// 删除收货地址
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    /*
    if (buttonIndex == 1) {
//        HJUserModel *userModer = [FXTPublicTools readUserModel];
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        
        NSString * urlStr = [NSString stringWithFormat:@"%@/api/MallsInfo/DeleteReceiptAddress", UrlStr];
        
        NSString *datasStr = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@ZICBDYCID=%ld", kPrefixPara, UserDefaultsGet(kDevIdentityInfo), kDevSysInfo, kDevTypeInfo, kIMEI, (long)_deleteAddressID, nil];
        //    NSLog(@"加密前的字符串 ----- %@", datasStr);
        NSString *DataEncrypt = [TWDes encryptWithContent:datasStr type:kDesType key:kDesKey];
        //    NSLog(@"加密后的字符串 ----- %@", DataEncrypt);
        
        // 调接口需要的两个参数
        NSDictionary *paraDic = @{kAccessTokenInfo:UserDefaultsGet(kAccessTokenInfo), kDatas:DataEncrypt};
        
        [Tool postWithPath:urlStr params:paraDic success:^(id JSON) {
            
//            NSLog(@"删除收货地址 - %@", JSON);
            
            if ([JSON[@"Success"] integerValue] == 1) {
                //            NSArray *jsonArr = JSON[@"JsonData"];
                
                [SVProgressHUD dismiss];
                
                [self getRequest];
                
            }else {
                
                [SVProgressHUD dismissWithError:JSON[@"Msg"]];
            }
            
            
        } failure:^(NSError *error) {
            [SVProgressHUD dismissWithError:@"服务器出错"];
        }];
    }
     
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
