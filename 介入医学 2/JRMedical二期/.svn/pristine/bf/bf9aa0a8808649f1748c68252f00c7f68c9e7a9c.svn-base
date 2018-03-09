//
//  MyCollectionRootVC.m
//  JRMedical
//
//  Created by a on 16/12/22.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "MyCollectionRootVC.h"
#import "MyCollectionNewsVC.h"
#import "MyCollectionShangPinVC.h"

@interface MyCollectionRootVC ()

@end

@implementation MyCollectionRootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.editButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    [self.editButtonItem setTitle:@"左滑取消收藏"];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.title = @"我的收藏";
    
    MyCollectionNewsVC *vc1 = [[MyCollectionNewsVC alloc] init];
    vc1.title = @"资讯";
    
    MyCollectionShangPinVC *vc2 = [[MyCollectionShangPinVC alloc] init];
    vc2.title = @"商品";
    
    self.scrollView.bounces = NO;
    self.scrollView.scrollEnabled = NO;
    
    self.viewControllers = @[vc1, vc2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
