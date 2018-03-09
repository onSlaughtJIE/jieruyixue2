//
//  BingliRootViewController.m
//  JRMedical
//
//  Created by ww on 2017/1/16.
//  Copyright © 2017年 idcby. All rights reserved.
//

#import "BingliRootViewController.h"
#import "XinxueViewController.h"
#import "SearchVC.h"
#import "BingliTypeView.h"
#import "BingliModel.h"

@interface BingliRootViewController ()<UIScrollViewDelegate>

@property (nonatomic, retain) UIScrollView *bigScrollView;
@property (nonatomic, strong) UIScrollView *topScrollView;

@end

@implementation BingliRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"病例分类";
    
    self.view.backgroundColor = BG_Color;
    
    
    // 设置导航栏右边按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"searchr"] style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarButtonItemClick)];
    
    
    [self.view addSubview:self.bigScrollView];
    [self.view addSubview:self.topScrollView];
    
    // 添加子控制器
    [self addSubController];
    // 添加模块导航栏
    [self addTopBarLabel];
    
    CGFloat contentX = self.childViewControllers.count * Width_Screen;
    self.bigScrollView.contentSize = CGSizeMake(contentX, 0);
    self.bigScrollView.pagingEnabled = YES;
    
    // 添加默认控制器
    UIViewController *vc = [self.childViewControllers firstObject];
    vc.view.frame = self.bigScrollView.bounds;
    [self.bigScrollView addSubview:vc.view];
    UILabel *label = [self.topScrollView.subviews firstObject];
    label.backgroundColor = BG_Color;
    self.bigScrollView.showsHorizontalScrollIndicator = NO;
    
    
}


#pragma mark - 搜索
- (void)rightBarButtonItemClick {
    SearchVC *searchVC = [SearchVC new];
    searchVC.groupCode = @"CaseCatalogue";
    searchVC.searchType = @"2";
    [self.navigationController pushViewController:searchVC animated:YES];
}



- (UIScrollView *)topScrollView {
    if (!_topScrollView) {
        _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Width_Screen, 60)];
        _topScrollView.backgroundColor = [UIColor whiteColor];
        _topScrollView.showsHorizontalScrollIndicator = NO;
        _topScrollView.showsVerticalScrollIndicator = NO;

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

//    NSArray *arr = @[@"xin", @"ru", @"jie", @"shen"];
    
    CGFloat typeWidth = 0.0;
    switch (_picArr.count) {
        case 1:
            typeWidth = Width_Screen;
            break;
        case 2:
            typeWidth = Width_Screen/2;
            break;
        case 3:
            typeWidth = Width_Screen/3;
            break;
        default:
            typeWidth = Width_Screen/3.2;
            break;
    }
    
    for (int i = 0; i < self.picArr.count; i++) {
        BingliModel *model = self.picArr[i];
        BingliTypeView *typeView = [[BingliTypeView alloc] initWithFrame:(CGRectMake(i*typeWidth, 0, typeWidth, 60))];
        typeView.tag = i+100;
        UIViewController *vc = self.childViewControllers[i];
        typeView.titleLab.text = vc.title;
        [typeView.imageView sd_setImageWithURL:[NSURL URLWithString:model.ImageUri] placeholderImage:[UIImage imageNamed:@"jiazai"]];
        [typeView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)]];
        [self.topScrollView addSubview:typeView];
    }
    self.topScrollView.contentSize = CGSizeMake(_picArr.count*typeWidth, 0);
}

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    
    BingliTypeView *typeView = (BingliTypeView *)sender.view;
    NSUInteger currentTag = sender.view.tag;
    for (BingliTypeView *sView in self.topScrollView.subviews) {
        if (sView.tag != currentTag) {
            sView.backgroundColor = [UIColor whiteColor];
        }
    }
    typeView.backgroundColor = BG_Color;
    CGFloat offsetX = (typeView.tag - 100) * self.bigScrollView.frame.size.width;
    CGFloat offsetY = self.bigScrollView.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    [self.bigScrollView setContentOffset:offset animated:YES];
}

- (void)addSubController {
    for (int i = 0; i < _picArr.count; i++) {
        
        BingliModel *model = _picArr[i];
        XinxueViewController*vc = [[XinxueViewController alloc] init];
        vc.title = model.Name;
        vc.TypeID = model.ID;
        [self addChildViewController:vc];
        
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSUInteger index = scrollView.contentOffset.x / self.bigScrollView.frame.size.width;
    BingliTypeView *typeView = (BingliTypeView *)self.topScrollView.subviews[index];
    
    NSUInteger currentTag = typeView.tag;
    for (BingliTypeView *sView in self.topScrollView.subviews) {
        if (sView.tag != currentTag) {
            sView.backgroundColor = [UIColor whiteColor];
        }
    }
    
    typeView.backgroundColor = BG_Color;
    CGFloat offsetX = typeView.center.x - self.topScrollView.frame.size.width * 0.5;
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
