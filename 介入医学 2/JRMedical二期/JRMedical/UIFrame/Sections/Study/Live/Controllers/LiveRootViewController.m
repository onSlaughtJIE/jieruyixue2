//
//  LiveRootViewController.m
//  JRMedical
//
//  Created by ww on 2016/11/23.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "LiveRootViewController.h"
#import "LivingViewController.h"
#import "LiveRecordViewController.h"
#import "LiveForecastViewController.h"

//
#import "HuiFangViewController.h"
#import "ZhiBoViewController.h"
#import "YuGaoViewController.h"
#import "ApplyLiveViewController.h"

@interface LiveRootViewController ()<UIScrollViewDelegate>

@property (nonatomic, retain) UIScrollView *bigScrollView;
@property (nonatomic, strong) UIScrollView *topScrollView;

@end

@implementation LiveRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.bigScrollView];
    // 添加子控制器
    [self addSubController];
    //添加模块导航栏
    [self addTopBarLabel];
    
    CGFloat contentX = self.childViewControllers.count * Width_Screen;
    self.bigScrollView.contentSize = CGSizeMake(contentX, 0);
    self.bigScrollView.pagingEnabled = YES;
    
    //添加默认控制器
    UIViewController *vc = self.childViewControllers[1] ;
//    vc.view.frame = self.bigScrollView.bounds;
    vc.view.frame = CGRectMake(Width_Screen, 0, Width_Screen, Height_Screen);
    [self.bigScrollView setContentOffsetX:Width_Screen];
    [self.bigScrollView addSubview:vc.view];
    self.navigationItem.titleView = _topScrollView;
    
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"searchr"] style:(UIBarButtonItemStylePlain) target:self action:@selector(liveSearh)];
    
    
    UIView *cusView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, 50, 30))];
    UIButton *cusBtn = [[UIButton alloc] initWithFrame:(CGRectMake(0, 0, 50, 30))];
    [cusBtn setTitle:@"申请" forState:(UIControlStateNormal)];
    [cusBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [cusBtn setImage:[UIImage imageNamed:@"shenqing"] forState:(UIControlStateNormal)];
    [cusBtn addTarget:self action:@selector(liveApply) forControlEvents:(UIControlEventTouchUpInside)];
    [cusView addSubview:cusBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cusView];
    
}

//- (void)liveSearh {
//    
//    [self showMessage:@"努力建设中"];
//}

- (void)liveApply {
    
//    [self showMessage:@"功能正在建设中、敬请期待..."];
    ApplyLiveViewController *applyVC = [[ApplyLiveViewController alloc] init];
    applyVC.title = @"直播申请";
    [self.navigationController pushViewController:applyVC animated:YES];
    
}

- (UIScrollView *)topScrollView {
    if (!_topScrollView) {
        self.topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 156, 32)];
        self.topScrollView.backgroundColor = Main_Color;
        self.topScrollView.showsHorizontalScrollIndicator = NO;
        self.topScrollView.showsVerticalScrollIndicator = NO;
        _topScrollView.scrollEnabled = NO;
        _topScrollView.layer.cornerRadius = 16;
        _topScrollView.layer.borderColor = [[UIColor whiteColor] CGColor];
        _topScrollView.layer.borderWidth = 1;
        _topScrollView.layer.masksToBounds = YES;
        
        
    }
    return _topScrollView;
}

- (UIScrollView *)bigScrollView {
    if (!_bigScrollView) {
        self.bigScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        self.bigScrollView.delegate = self;
        self.bigScrollView.bounces = NO;
        self.bigScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _bigScrollView;
}

- (void)addTopBarLabel {
    
    for (int i = 0; i < 3; i++) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:(CGRectMake(50 * i + 3, 3, 50, 26))];
        UIViewController *vc = self.childViewControllers[i];
        label.text = vc.title;
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 100+i;
        label.font = [UIFont systemFontOfSize:14];
        label.layer.cornerRadius = 13;
        label.textColor = [UIColor whiteColor];
        label.layer.masksToBounds = YES;
        label.userInteractionEnabled = YES;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)]];
        if (i == 1) {
            label.backgroundColor = [UIColor whiteColor];
            label.textColor = Main_Color;
        }
        
        [self.topScrollView addSubview:label];
        
    }
    self.topScrollView.contentSize = CGSizeMake(156, 0);
}

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    
    NSUInteger currentTag = sender.view.tag;
    for (UILabel *label in self.topScrollView.subviews) {
        if (label.tag != currentTag) {
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = [UIColor clearColor];
            
        } else {
            label.textColor = Main_Color;
            label.backgroundColor = [UIColor whiteColor];
            
        }
    }
    
    CGFloat offsetX = (currentTag - 100) * self.bigScrollView.frame.size.width;
    CGFloat offsetY = self.bigScrollView.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    [self.bigScrollView setContentOffset:offset animated:YES];
    
    
    
}

- (void)addSubController {
    for (int i = 0; i < 3; i++) {
        if (0 == i) {
//            LiveRecordViewController *vc = [[LiveRecordViewController alloc] init];
            HuiFangViewController *vc = [[HuiFangViewController alloc] init];
            vc.title = @"回放";
            [self addChildViewController:vc];
            
        } else if (1 == i) {
//            LivingViewController *vc = [[LivingViewController alloc] init];
            ZhiBoViewController *vc = [[ZhiBoViewController alloc] init];
            vc.title = @"直播";
            [self addChildViewController:vc];
            
        } else {
//            LiveForecastViewController *vc = [[LiveForecastViewController alloc] init];
            YuGaoViewController *vc = [[YuGaoViewController alloc] init];
            vc.title = @"预告";
            [self addChildViewController:vc];
        }
    }
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    NSUInteger index = scrollView.contentOffset.x / self.bigScrollView.frame.size.width;
    UILabel *label = self.topScrollView.subviews[index];
    NSUInteger currentTag = label.tag;
    
    for (UILabel *label in self.topScrollView.subviews) {
        if (label.tag != currentTag) {
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = [UIColor clearColor];
            
        } else {
            label.textColor = Main_Color;
            label.backgroundColor = [UIColor whiteColor];
            
        }
    }
    
    CGFloat offsetX = label.center.x - self.topScrollView.frame.size.width * 0.5;
    CGFloat offsetMax = self.topScrollView.contentSize.width - self.topScrollView.frame.size.width;
    if (offsetX < 0) {
        offsetX = 0;
    } else if (offsetX > offsetMax) {
        offsetX = offsetMax;
    }
    CGPoint offset = CGPointMake(offsetX, self.topScrollView.contentOffset.y);
    [self.topScrollView setContentOffset:offset animated:YES];
    UIViewController *vc = self.childViewControllers[index];
    
    if (vc.view.superview) {
        return;
    }
    vc.view.frame = scrollView.bounds;
    [self.bigScrollView addSubview:vc.view];
    
    
}

//滚动结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
