//
//  DoctorInfoViewController.h
//  JRMedical
//
//  Created by ww on 2016/12/28.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "BaseViewController.h"
#import "MyAttentionModel.h"

@interface DoctorInfoViewController : BaseViewController

@property (nonatomic, strong) MyAttentionModel *model;

@property (nonatomic, strong) NSDictionary *dataInfo;

@end
