//
//  KeshiSelectController.h
//  JRMedical
//
//  Created by apple on 16/7/14.
//  Copyright © 2016年 ZC. All rights reserved.
//

#import "BaseViewController.h"
@class KeshiSelectModel;

typedef void(^PassKeshi)(KeshiSelectModel *);

@interface KeshiSelectController : BaseViewController

@property (nonatomic, copy) PassKeshi passKeshi;

@end
