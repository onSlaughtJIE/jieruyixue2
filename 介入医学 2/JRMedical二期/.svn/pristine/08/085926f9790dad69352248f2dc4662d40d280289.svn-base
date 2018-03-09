//
//  ChooseAddressViewController.h
//  HongJHome
//
//  Created by 曹柏涵 on 15/8/25.
//  Copyright (c) 2015年 yizhisheng. All rights reserved.
//

//#import "HJBaseViewController.h"
#import "HJAddressInfoModel.h"

@protocol ChooseAddressViewControllerDelegate <NSObject>

@optional

- (void)passAddress:(HJAddressInfoModel *)addressModel;

@end



@interface ChooseAddressViewController : UIViewController

@property (nonatomic, assign)id<ChooseAddressViewControllerDelegate>delegate;

@property (nonatomic, assign) NSInteger pushNumber; // 如果是从我的界面push进来的,做设置

@end
