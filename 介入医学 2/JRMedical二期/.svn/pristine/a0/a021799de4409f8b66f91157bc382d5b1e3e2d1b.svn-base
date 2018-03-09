//
//  MyOrderRootVC.m
//  JRMedical
//
//  Created by a on 16/12/22.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "MyOrderRootVC.h"

#import "AllOrderVC.h"
#import "DaiPayOrder.h"
#import "DaiPostOrder.h"
#import "DaiCollectionOrder.h"
#import "DaiPingJiaOrder.h"

#import <YYKit.h>

#import "WLZ_ShoppingCarController.h"
#import "GoodRootViewController.h"

@interface MyOrderRootVC ()

@end

@implementation MyOrderRootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的订单";
    
    if ([self.payOrderTo isEqualToString:@"购物车"] || [self.payOrderTo isEqualToString:@"商品详情"] || [self.payOrderTo isEqualToString:@"商品兑换"]) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftAction)];
    }
    
    AllOrderVC *vc1 = [[AllOrderVC alloc] init];
    vc1.title = @"全部";
    
    DaiPayOrder *vc2 = [[DaiPayOrder alloc] init];
    vc2.title = @"待付款";
    
    DaiPostOrder *vc3 = [[DaiPostOrder alloc] init];
    vc3.title = @"待发货";
    
    DaiCollectionOrder *vc4 = [[DaiCollectionOrder alloc] init];
    vc4.title = @"待收货";
    
    DaiPingJiaOrder *vc5 = [[DaiPingJiaOrder alloc] init];
    vc5.title = @"待评价";
    
    self.viewControllers = @[vc1, vc2, vc3, vc4, vc5];
    
    if ((self.tagVC-1) == 0) {
        self.segmentControl.selectIndex = 1;
    }
    else if ((self.tagVC-1) == 1) {
        self.segmentControl.selectIndex = 2;
    }
    else if ((self.tagVC-1) == 2) {
        self.segmentControl.selectIndex = 4;
    }
    else if ((self.tagVC-1) == 3) {
        self.segmentControl.selectIndex = 0;
    }
}

- (void)leftAction {
    
    if ([self.payOrderTo isEqualToString:@"购物车"]) {
        NSArray * ctrlArray = self.navigationController.viewControllers;
        NSInteger renzhengNum = 0;
        int i = 0;
        for (UIViewController *controller in ctrlArray) {
            if ([controller.className isEqualToString:@"WLZ_ShoppingCarController"]) {
                renzhengNum = i;
            }
            i++;
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"payOrderReturn" object:nil userInfo:nil];
        
        [self.navigationController popToViewController:[ctrlArray objectAtIndex:renzhengNum] animated:YES];
    }
    else {
        NSArray * ctrlArray = self.navigationController.viewControllers;
        NSInteger renzhengNum = 0;
        int i = 0;
        for (UIViewController *controller in ctrlArray) {
            if ([controller.className isEqualToString:@"GoodRootViewController"]) {
                renzhengNum = i;
            }
            i++;
        }
        [self.navigationController popToViewController:[ctrlArray objectAtIndex:renzhengNum] animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
