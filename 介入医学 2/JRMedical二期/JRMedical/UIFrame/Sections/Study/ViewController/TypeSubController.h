//
//  TypeSubController.h
//  JRMedical
//
//  Created by ww on 16/11/12.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "BaseTableViewController.h"

@interface TypeSubController : BaseTableViewController

@property (nonatomic, copy) NSString *valueString;
@property (nonatomic, copy) NSString *groupCode;
@property (nonatomic, copy) NSString *LableValueLst;

@property (nonatomic, assign) NSInteger vcTag;//每个控制器的唯一标示值

@end
