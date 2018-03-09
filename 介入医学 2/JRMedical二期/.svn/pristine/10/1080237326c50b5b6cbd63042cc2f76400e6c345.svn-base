//
//  VideoSpecialTypeVC.m
//  JRMedical
//
//  Created by a on 16/11/16.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "VideoSpecialTypeVC.h"

#import "VideoSpecialListVC.h"
#import "SCNavTabBarController.h"
#import "SCNavTabBar.h"

#import "AllCategoryCollectionVC.h"

@interface VideoSpecialTypeVC ()

@property (nonatomic, strong) NSMutableArray *tableviewArray;

@end

@implementation VideoSpecialTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"专题";
    self.view.backgroundColor = BG_Color;
    
    self.tableviewArray = [NSMutableArray arrayWithCapacity:0];
    NSArray *titleArray = @[@"综合", @"外周", @"神经", @"心脏", @"超声", @"其他"];
    for (int i = 0; i < titleArray.count; i++) {
        VideoSpecialListVC *tabVC = [[VideoSpecialListVC  alloc] init];
        tabVC.title = titleArray[i];
        tabVC.view.backgroundColor = BG_Color;
        [self.tableviewArray addObject:tabVC];
    }
    SCNavTabBarController *scVC = [[SCNavTabBarController alloc] initWithSubViewControllers:self.tableviewArray];
    scVC.showArrowButton = YES;
    scVC.scrollAnimation = YES;
    scVC.mainViewBounces = YES;
    scVC.navTabBarColor = [UIColor whiteColor];
    [scVC addParentController:self];
    
    SCNavTabBar *navBar = scVC.navTabBar;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(functionButtonPressed)];
    [navBar.arrowButton addGestureRecognizer:tapGestureRecognizer];
}

- (void)functionButtonPressed {
    AllCategoryCollectionVC *mColleVC = [AllCategoryCollectionVC new];
    BaseNavigationController *mColleNC = [[BaseNavigationController alloc] initWithRootViewController:mColleVC];
    [self presentViewController:mColleNC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
