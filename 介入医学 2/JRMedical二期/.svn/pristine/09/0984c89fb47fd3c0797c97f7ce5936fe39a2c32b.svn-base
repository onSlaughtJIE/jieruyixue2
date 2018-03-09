//
//  VideoLectureVC.m
//  JRMedical
//
//  Created by a on 16/11/16.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "VideoLectureVC.h"
#import "SearchVC.h"

#import "VideoMajorTypeVC.h"
#import "VideoSpecialListVC.h"

@interface VideoLectureVC ()<UIScrollViewDelegate>

@property (nonatomic, retain) UIScrollView *bigScrollView;
@property (nonatomic, strong) UIScrollView *topScrollView;

@end

@implementation VideoLectureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BG_Color;
    
    //设置导航栏右边按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"searchr"] style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarButtonItemClick)];
    
    [self.view addSubview:self.bigScrollView];
    
    [self addSubController];
    //添加模块导航栏
    [self addTopBarLabel];
    
    CGFloat contentX = self.childViewControllers.count * Width_Screen;
    self.bigScrollView.contentSize = CGSizeMake(contentX, 0);
    self.bigScrollView.pagingEnabled = YES;
    
    //添加默认控制器
    UIViewController *vc = [self.childViewControllers firstObject];
    vc.view.frame = self.bigScrollView.bounds;
    [self.bigScrollView addSubview:vc.view];
    UILabel *label = [self.topScrollView.subviews firstObject];
    label.textColor = Main_Color;
    self.bigScrollView.showsHorizontalScrollIndicator = NO;
    
    self.navigationItem.titleView = self.topScrollView;
}

#pragma mark - 搜索
- (void)rightBarButtonItemClick {
    SearchVC *searchVC = [SearchVC new];
    searchVC.groupCode = @"VideoLecturesMajor";
    searchVC.searchType = @"2";
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (UIScrollView *)topScrollView {
    if (!_topScrollView) {
        _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 144, 32)];
        _topScrollView.backgroundColor = Main_Color;
        _topScrollView.showsHorizontalScrollIndicator = NO;
        _topScrollView.showsVerticalScrollIndicator = NO;
//        _topScrollView.directionalLockEnabled = YES;
        _topScrollView.scrollEnabled = NO;
        _topScrollView.layer.cornerRadius = 15;
        _topScrollView.layer.borderColor = [[UIColor whiteColor] CGColor];
        _topScrollView.layer.borderWidth = 1;
        _topScrollView.layer.masksToBounds = YES;
    }
    return _topScrollView;
}

- (UIScrollView *)bigScrollView {
    if (!_bigScrollView) {
        _bigScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _bigScrollView.delegate = self;
        _bigScrollView.scrollEnabled = NO;
    }
    return _bigScrollView;
}

- (void)addTopBarLabel {
    
    for (int i = 0; i < 2; i++) {
        UILabel *label = [[UILabel alloc] init];
        if (i == 0) {
            label.backgroundColor = [UIColor whiteColor];
            label.textColor = Main_Color;
        }
        UIViewController *vc = self.childViewControllers[i];
        label.text = vc.title;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize:14];
        label.frame = CGRectMake(70 * i + 3, 3, 68, 26);
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.cornerRadius = 13;
        label.layer.masksToBounds = YES;
        label.tag = 100 + i;
        label.userInteractionEnabled = YES;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)]];
        [self.topScrollView addSubview:label];
    }
    self.topScrollView.contentSize = CGSizeMake(72 * 2, 0);
}

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    
    UILabel *label = (UILabel *)sender.view;
    NSUInteger currentTag = sender.view.tag;
    for (UILabel *slabel in self.topScrollView.subviews) {
        if (slabel.tag != currentTag) {
            slabel.backgroundColor = [UIColor clearColor];
            slabel.textColor = [UIColor whiteColor];
        }
    }
    
    label.backgroundColor = [UIColor whiteColor];
    label.textColor = Main_Color;
    
    CGFloat offsetX = (label.tag - 100) * self.bigScrollView.frame.size.width;
    CGFloat offsetY = self.bigScrollView.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    [self.bigScrollView setContentOffset:offset animated:YES];
}

- (void)addSubController {
    for (int i = 0; i < 2; i++) {
        if (0 == i) {
            VideoMajorTypeVC *vc = [[VideoMajorTypeVC alloc] init];
            vc.title = @"专业";
            [self addChildViewController:vc];
        }
        else if (1 == i) {
            VideoSpecialListVC *vc = [[VideoSpecialListVC alloc] init];
            vc.title = @"专题";
            [self addChildViewController:vc];
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSUInteger index = scrollView.contentOffset.x / self.bigScrollView.frame.size.width;
    UILabel *label = (UILabel *)self.topScrollView.subviews[index];
    
    NSUInteger currentTag = label.tag;
    for (UILabel *slabel in self.topScrollView.subviews) {
        if (slabel.tag != currentTag) {
            slabel.backgroundColor = [UIColor clearColor];
            slabel.textColor = [UIColor whiteColor];
        }
    }
    label.backgroundColor = [UIColor whiteColor];
    label.textColor = Main_Color;
    
    
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

@end
