//
//  RecordSubViewController.h
//  JRMedical
//
//  Created by ww on 2016/11/23.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordSubViewController : UIViewController

@property (nonatomic, copy) NSString *valueString;
@property (nonatomic, copy) NSString *groupCode;
@property (nonatomic, copy) NSString *LableValueLst;

@property (nonatomic, assign) NSInteger vcTag;//每个控制器的唯一标示值

@end
