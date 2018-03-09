//
//  VideoSpecialDetailListVC.m
//  JRMedical
//
//  Created by a on 16/11/17.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "VideoSpecialDetailListVC.h"

#import "VideoMajorCell.h"
#import "PublicNewsListModel.h"
#import "VideoSpecialDetailContentVC.h"
#import "UICollectionView+EmpayData.h"

@interface VideoSpecialDetailListVC ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation VideoSpecialDetailListVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //设置标题大小
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //设置标题大小
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.model.Title;
    
    [self.view addSubview:self.collectionView];
    self.collectionView.sd_layout.widthIs(Width_Screen).heightIs(Height_Screen-64);
    
    //请求视频讲座列表
    [self requestListDataArrray];
}

#pragma mark - 请求数据列表
- (void)requestListDataArrray {
    
    NSString *url = @"api/News/VideoListBySpecialID";
    NSString *params = [NSString stringWithFormat:@"ZICBDYCSpecialID=%@",self.model.ID];
    
    self.pageSize = 14;
    self.tableType = 2;//Colloection类
    self.baseColloectionView = self.collectionView;//将本类表 赋值给父类去操作
    [self showLoadding:@"正在加载" time:20];
    [self loadDataApi:url withParams:params refresh:RefreshTypeBoth model:PublicNewsListModel.class];
}

#pragma mark - UICollectionView DataSource Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.dataSource == nil) {
        [collectionView collectionViewDisplayWitMsg:@"" ifNecessaryForRowCount:self.dataSource.count widthDuiQi:0];
    }
    else {
        [collectionView collectionViewDisplayWitMsg:@"暂无相关视频信息!" ifNecessaryForRowCount:self.dataSource.count widthDuiQi:0];
    }
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PublicNewsListModel *model = self.dataSource[indexPath.row];
    VideoMajorCell *item = (VideoMajorCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([VideoMajorCell class]) forIndexPath:indexPath];
    [item setModel:model];
    return item;
}


//定义每个Section 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PublicNewsListModel *model = self.dataSource[indexPath.row];
    VideoSpecialDetailContentVC *vSDContentVC = [[VideoSpecialDetailContentVC alloc] init];
    vSDContentVC.model = model;
    [self.navigationController pushViewController:vSDContentVC animated:YES];
}

#pragma mark - 布局
- (UICollectionViewFlowLayout *)getFlowLayout {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置单元格大小
    layout.itemSize = CGSizeMake((Width_Screen-15)/2, ((((Width_Screen-15)/2)-20)/16*9)+86);
    //每一行的分割线(——)
    layout.minimumLineSpacing = 5;
    //每一列的分割线（|）
    layout.minimumInteritemSpacing = 5;
    return layout;
}

#pragma mark - 懒加载scrollView
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:[self getFlowLayout]];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = BG_Color;
        [_collectionView registerClass:[VideoMajorCell class] forCellWithReuseIdentifier:NSStringFromClass([VideoMajorCell class])];
    }
    return  _collectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
