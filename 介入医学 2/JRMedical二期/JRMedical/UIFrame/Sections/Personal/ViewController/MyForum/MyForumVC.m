//
//  MyForumVC.m
//  XHSegmentControllerSample
//
//  Created by xihe on 16/4/19.
//  Copyright © 2016年 xihe. All rights reserved.
//

#import "MyForumVC.h"
#import "MyCollectionPostVC.h"
#import "MyPostVC.h"
#import "MyHuiFuPostVC.h"

@interface MyForumVC ()

@end

@implementation MyForumVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.editButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
//    [self.editButtonItem setTitle:@"左滑取消收藏"];
//    self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.title = @"我的论坛";
    
    MyCollectionPostVC *vc1 = [[MyCollectionPostVC alloc] init];
    vc1.title = @"收藏帖子";
    
    MyPostVC *vc2 = [[MyPostVC alloc] init];
    vc2.title = @"我的帖子";
    
    MyHuiFuPostVC *vc3 = [[MyHuiFuPostVC alloc] init];
    vc3.title = @"我回复的";
    
    self.scrollView.bounces = NO;
    self.scrollView.scrollEnabled = NO;
    
    self.viewControllers = @[vc1, vc2, vc3];
}

//- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
//    [super setEditing:editing animated:animated];
//    [self.navigationItem setHidesBackButton:editing animated:YES];
//    if (editing) {
//         [self.editButtonItem setTitle:@"完成"];
//    }
//    else {//点击完成按钮
//         [self.editButtonItem setTitle:@"左滑取消关注"];
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
