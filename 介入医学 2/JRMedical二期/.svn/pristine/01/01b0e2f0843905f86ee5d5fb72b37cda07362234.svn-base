//
//  PostTypeVC.m
//  JRMedical
//
//  Created by a on 16/12/8.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "PostTypeVC.h"

#import "PostTypeCollectionCell.h"
#import "PostTypeVCHeaderView.h"
#import "UIScrollView+UITouch.h"

@interface PostTypeVC ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionTopView;

@end

@implementation PostTypeVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:BG_Color];//改变导航栏颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];//改变状态栏颜色
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];//改变状态栏颜色
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BG_Color;
    
    //设置导航栏右边按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"closez"] style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarButtonItemClick)];
    [self.navigationController.navigationBar setTintColor:RGB(85, 85, 85)];
    
    [self initView];// 初始化视图
}

#pragma mark - 关闭
- (void)rightBarButtonItemClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 初始化视图
- (void)initView {

    [self.view addSubview:self.collectionTopView];
    
    self.collectionTopView.sd_layout.topSpaceToView(self.view,0).widthIs(Width_Screen).heightIs(Height_Screen-64);
}

#pragma mark - UICollectionView DataSource Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.typeListArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PostTypeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PostTypeCollectionCell class]) forIndexPath:indexPath];
    
    NSDictionary *dataDic = self.typeListArray[indexPath.row];
    [cell setDataDic:dataDic];
    if (indexPath.row == self.curSelectdItem) {
        [cell setBackgroundColor:Main_Color];
        cell.titleLab.textColor = [UIColor whiteColor];
    }
    
    return cell;
}

//自定义区头
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        //定制头部视图的内容
        PostTypeVCHeaderView *headView = (PostTypeVCHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([PostTypeVCHeaderView class]) forIndexPath:indexPath];
        headView.titleLab.text = @"帖子类型";
        reusableView = headView;
    }
    return reusableView;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PostTypeCollectionCell *cell = (PostTypeCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setBackgroundColor:Main_Color];
    cell.titleLab.textColor = [UIColor whiteColor];
    
    NSMutableDictionary *allInfoDic = [[NSMutableDictionary alloc] init];

    self.curSelectdItem = indexPath.row;//选中的当前的分类
    
    NSLog(@"%ld",self.curSelectdItem);
    
    [allInfoDic setObject:@(self.curSelectdItem) forKey:@"CurSelectdItemPost"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PublishrdPostTypeRefreshDataAfterSorting" object:nil userInfo:allInfoDic];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//取消选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PostTypeCollectionCell *cell = (PostTypeCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor whiteColor]];
    cell.titleLab.textColor = [UIColor blackColor];
}

//定义每个Section 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    //分别为上、左、下、右
    return UIEdgeInsetsMake(10, 25, 30, 25);
}

#pragma mark - 布局
- (UICollectionViewFlowLayout *)getFlowLayout {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置单元格大小
    layout.itemSize = CGSizeMake((Width_Screen-66)/3, 40);
    //每一行的分割线(——)
    layout.minimumLineSpacing = 8;
    //每一列的分割线（|）
    layout.minimumInteritemSpacing = 8;
    //区头
    [layout setHeaderReferenceSize:CGSizeMake(Width_Screen, 40)];
    return layout;
}

#pragma mark - 懒加载scrollView
- (UICollectionView *)collectionTopView {
    if (!_collectionTopView) {
        _collectionTopView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:[self getFlowLayout]];
        _collectionTopView.delegate = self;
        _collectionTopView.dataSource = self;
        _collectionTopView.scrollEnabled = NO;
        _collectionTopView.backgroundColor = BG_Color;
        [_collectionTopView selectItemAtIndexPath:[NSIndexPath indexPathForItem:self.curSelectdItem inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        [_collectionTopView registerClass:[PostTypeCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([PostTypeCollectionCell class])];
        [_collectionTopView registerClass:[PostTypeVCHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([PostTypeVCHeaderView class])];
    }
    return  _collectionTopView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
