//
//  BaseNavigationController.m
//  liuzhiyuan
//
//  Created by a on 16/11/3.
//  Copyright © 2016年 刘志远. All rights reserved.
//

#import "BaseNavigationController.h"
#import "UINavigationBar+Lzy7575.h"

@interface BaseNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNavigationBar];
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item{
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    item.backBarButtonItem = back;
    return YES;
}

#pragma mark - 设置导航栏主题
- (void)setupNavigationBar {
    
    UIImage *backButtonImage = [[UIImage imageNamed:@"nav_back"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 25, 0, 0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    
    self.navigationBar.hairline_7575.hidden = YES;//清除navbar的底线
    
    [self.navigationBar setBarTintColor:Main_Color];
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationBar.translucent = NO;
    [self.view setBackgroundColor:BG_Color];
    [self.navigationBar setBarStyle:UIBarStyleBlack];
    
    //设置标题大小
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

//#pragma mark - UINavigationController 方法重载
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
