//
//  XinxueListViewController.h
//  JRMedical
//
//  Created by ww on 2017/1/16.
//  Copyright © 2017年 idcby. All rights reserved.
//

#import "BaseTableViewController.h"

@interface XinxueListViewController : BaseTableViewController

@property (nonatomic, copy) NSString *LableID; // 标签ID
@property (nonatomic, copy) NSString *memo; // 简介
@property (nonatomic, strong) NSMutableArray *lunboArr;

@end
