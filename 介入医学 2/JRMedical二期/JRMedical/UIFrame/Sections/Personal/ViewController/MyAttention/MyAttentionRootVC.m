//
//  MyAttentionRootVC.m
//  JRMedical
//
//  Created by a on 16/12/26.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "MyAttentionRootVC.h"

#import "ServiceHistoryVC.h"
#import "MyAttentionVC.h"

@interface MyAttentionRootVC ()

@end

@implementation MyAttentionRootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的关注";
    
    [self.editButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    [self.editButtonItem setTitle:@"左滑取消关注"];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    MyAttentionVC *vc1 = [[MyAttentionVC alloc] init];
    vc1.title = @"我的医生";
    
    ServiceHistoryVC *vc2 = [[ServiceHistoryVC alloc] init];
    vc2.title = @"服务历史";
    
    self.scrollView.bounces = NO;
    self.scrollView.scrollEnabled = NO;
    
    self.viewControllers = @[vc1, vc2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
