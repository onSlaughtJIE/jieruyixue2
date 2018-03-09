//
//  NewAddressViewController.h
//  JRMedical
//
//  Created by apple on 16/6/23.
//  Copyright © 2016年 ZC. All rights reserved.
//

//#import "HJBaseViewController.h"
#import "HJAddressInfoModel.h"
@interface NewAddressViewController : UIViewController

@property (nonatomic, strong) HJAddressInfoModel * addressModel;

@property (nonatomic, assign) NSInteger AddressID; // 编辑地址 主键ID

@property (nonatomic, assign) NSInteger fromNumber;

@end
