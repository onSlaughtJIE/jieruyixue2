//
//  SCNavTabBarController.m
//  SCNavTabBarController
//
//  Created by ShiCang on 14/11/17.
//  Copyright (c) 2014年 SCNavTabBarController. All rights reserved.
//

#import "SCNavTabBarController.h"
#import "CommonMacro.h"
#import "SCNavTabBar.h"

@interface SCNavTabBarController () <UIScrollViewDelegate, SCNavTabBarDelegate>
{
    NSInteger       _currentIndex;              // current page index
    NSMutableArray  *_titles;                   // array of children view controller's title
    
//    SCNavTabBar     *_navTabBar;                // NavTabBar: press item on it to exchange view
}

@end

@implementation SCNavTabBarController

#pragma mark - Life Cycle
#pragma mark -

- (id)initWithShowArrowButton:(BOOL)show
{
    self = [super init];
    if (self)
    {
        _showArrowButton = show;
    }
    return self;
}

- (id)initWithSubViewControllers:(NSArray *)subViewControllers
{
    self = [super init];
    if (self)
    {
        _subViewControllers = subViewControllers;
    }
    return self;
}

- (id)initWithParentViewController:(UIViewController *)viewController
{
    self = [super init];
    if (self)
    {
        [self addParentController:viewController];
    }
    return self;
}

- (id)initWithSubViewControllers:(NSArray *)subControllers andParentViewController:(UIViewController *)viewController showArrowButton:(BOOL)show;
{
    self = [self initWithSubViewControllers:subControllers];
    
    _showArrowButton = show;
    [self addParentController:viewController];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initConfig];
    [self viewConfig];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods
#pragma mark -
- (void)initConfig
{
    // Iinitialize value
    _currentIndex = 1;
    _navTabBarColor = _navTabBarColor ? _navTabBarColor : NavTabbarColor;
    
    // Load all title of children view controllers
    _titles = [[NSMutableArray alloc] initWithCapacity:_subViewControllers.count];
    for (UIViewController *viewController in _subViewControllers)
    {
        [_titles addObject:viewController.title];
    }
}

- (void)viewInit
{
    // Load NavTabBar and content view to show on window
    if (self.fromBingliFenlei.length > 0) { // motify jia
         _navTabBar = [[SCNavTabBar alloc] initWithFrame:CGRectMake(DOT_COORDINATE, 60, SCREEN_WIDTH, NAV_TAB_BAR_HEIGHT) showArrowButton:_showArrowButton];
        _navTabBar.lineColor = RGB(200, 200, 200);
    } else {
        _navTabBar = [[SCNavTabBar alloc] initWithFrame:CGRectMake(DOT_COORDINATE, DOT_COORDINATE, SCREEN_WIDTH, NAV_TAB_BAR_HEIGHT) showArrowButton:_showArrowButton];
        _navTabBar.lineColor = BG_Color;
    }
//    _navTabBar = [[SCNavTabBar alloc] initWithFrame:CGRectMake(DOT_COORDINATE, DOT_COORDINATE, SCREEN_WIDTH, NAV_TAB_BAR_HEIGHT) showArrowButton:_showArrowButton];
    _navTabBar.delegate = self;
    _navTabBar.backgroundColor = _navTabBarColor;
//    _navTabBar.lineColor = _navTabBarLineColor;
    _navTabBar.itemTitles = _titles;
    _navTabBar.arrowImage = _navTabBarArrowImage;
    
    _navTabBar.layer.shadowColor = RGB(100, 100, 100).CGColor;//阴影颜色
    _navTabBar.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
    _navTabBar.layer.shadowOpacity = 0.5;//不透明度
    _navTabBar.layer.shadowRadius = 5.0;//半径
    
    [_navTabBar updateData];
    
    _mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(DOT_COORDINATE, _navTabBar.frame.origin.y + _navTabBar.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - _navTabBar.frame.origin.y - _navTabBar.frame.size.height - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT)];
    _mainView.delegate = self;
    _mainView.pagingEnabled = YES;
    _mainView.bounces = _mainViewBounces;
    _mainView.showsHorizontalScrollIndicator = NO;
    _mainView.contentSize = CGSizeMake(SCREEN_WIDTH * _subViewControllers.count, DOT_COORDINATE);
    [self.view addSubview:_mainView];
    [self.view addSubview:_navTabBar];
}

- (void)viewConfig
{
    [self viewInit];
    
    // Load children view controllers and add to content view
    [_subViewControllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        
        UIViewController *viewController = (UIViewController *)_subViewControllers[idx];
        viewController.view.frame = CGRectMake(idx * SCREEN_WIDTH, DOT_COORDINATE, SCREEN_WIDTH, _mainView.frame.size.height);
        [_mainView addSubview:viewController.view];
        [self addChildViewController:viewController];
    }];
}

#pragma mark - Public Methods
#pragma mark -
- (void)setNavTabbarColor:(UIColor *)navTabbarColor
{
    // prevent set [UIColor clear], because this set can take error display
    CGFloat red, green, blue, alpha;
    if ([navTabbarColor getRed:&red green:&green blue:&blue alpha:&alpha] && !red && !green && !blue && !alpha)
    {
        navTabbarColor = NavTabbarColor;
    }
    _navTabBarColor = navTabbarColor;
}

- (void)addParentController:(UIViewController *)viewController
{
    // Close UIScrollView characteristic on IOS7 and later
    if ([viewController respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        viewController.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [viewController addChildViewController:self];
    [viewController.view addSubview:self.view];
}

#pragma mark - Scroll View Delegate Methods
#pragma mark -
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _currentIndex = scrollView.contentOffset.x / SCREEN_WIDTH;
    
    if (_delegate && [_delegate respondsToSelector:@selector(selectedItemWithIndex:)]) { //只有当代理存在，且timeTickOut方法被实现的时候才执行下面的语句
        _currentIndex = [_delegate selectedItemWithIndex:_currentIndex];
    }
    
    _navTabBar.currentItemIndex = _currentIndex;
    
    
    
    
    // add
//    NSInteger count = scrollView.contentSize.width / SCREEN_WIDTH;
//    NSArray *yuanArr = _navTabBar.subviews.lastObject.subviews;
//    NSMutableArray *buttonArr = [NSMutableArray array];
//    for (int i = 0 ; i < count; i++) {
//        [buttonArr addObject:yuanArr[i]];
//    }
//    
//    // add 点击修改栏目颜色为主体蓝色
//    for (UIButton *item in buttonArr) {
//        if (item.tag == _currentIndex) {
//            [item setTitleColor:UIColorWithRGBA(0, 164.0f, 156.0f, 0.7f) forState:(UIControlStateNormal)];
//        } else {
//            [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        }
//    }
    
}


#pragma mark - SCNavTabBarDelegate Methods
#pragma mark -
- (void)itemDidSelectedWithIndex:(NSInteger)index
{
    
    if (_delegate && [_delegate respondsToSelector:@selector(selectedItemWithIndex:)]) { //只有当代理存在，且timeTickOut方法被实现的时候才执行下面的语句
         index = [_delegate selectedItemWithIndex:index];
    }
    
    [_mainView setContentOffset:CGPointMake(index * SCREEN_WIDTH, DOT_COORDINATE) animated:_scrollAnimation];
    
    
    // add
//    NSInteger count = _mainView.contentSize.width / SCREEN_WIDTH;
//    NSArray *yuanArr = _navTabBar.subviews.lastObject.subviews;
//    NSMutableArray *buttonArr = [NSMutableArray array];
//    for (int i = 0 ; i < count; i++) {
//        [buttonArr addObject:yuanArr[i]];
//    }
//    
//    // add 点击修改栏目颜色为主体蓝色
//    for (UIButton *item in buttonArr) {
//        if (item.tag == index) {
//            [item setTitleColor:UIColorWithRGBA(0, 164.0f, 156.0f, 0.7f) forState:(UIControlStateNormal)];
//        } else {
//            [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        }
//    }
    
}

- (void)shouldPopNavgationItemMenu:(BOOL)pop height:(CGFloat)height
{
    if (pop)
    {
        [UIView animateWithDuration:0.5f animations:^{
            _navTabBar.frame = CGRectMake(_navTabBar.frame.origin.x, _navTabBar.frame.origin.y, _navTabBar.frame.size.width, height + NAV_TAB_BAR_HEIGHT);
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5f animations:^{
            _navTabBar.frame = CGRectMake(_navTabBar.frame.origin.x, _navTabBar.frame.origin.y, _navTabBar.frame.size.width, NAV_TAB_BAR_HEIGHT);
        }];
    }
    [_navTabBar refresh];
}

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
