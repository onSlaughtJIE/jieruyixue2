//
//  JRRegistViewController.h
//  JRMedical
//
//  Created by apple on 16/5/11.
//  Copyright © 2016年 ZC. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^PassTelNumber)(NSString *telString);

@interface JRRegistViewController : BaseViewController

@property (nonatomic, copy) PassTelNumber passTelNumBer;

@property (nonatomic, assign) NSInteger fromMySetup; // 从设置的忘记密码进入

@end
