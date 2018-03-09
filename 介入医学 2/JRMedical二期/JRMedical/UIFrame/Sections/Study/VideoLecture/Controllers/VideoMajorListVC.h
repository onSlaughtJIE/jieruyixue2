//
//  VideoMajorListVC.h
//  JRMedical
//
//  Created by a on 16/11/16.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "BaseViewController.h"

@interface VideoMajorListVC : BaseViewController

@property (nonatomic, copy) NSString *valueString;
@property (nonatomic, copy) NSString *groupCode;
@property (nonatomic, copy) NSString *LableValueLst;

@property (nonatomic, assign) NSInteger vcTag;//每个控制器的唯一标示值

@end
