//
//  FenleiChooseController.h
//  JRMedical
//
//  Created by apple on 16/6/16.
//  Copyright © 2016年 ZC. All rights reserved.
//

#import "BaseTableViewController.h"

typedef void(^PassFenLei)(NSMutableArray *);

@interface FenleiChooseController : BaseTableViewController

@property (nonatomic, copy) PassFenLei passFenLei;

@end
