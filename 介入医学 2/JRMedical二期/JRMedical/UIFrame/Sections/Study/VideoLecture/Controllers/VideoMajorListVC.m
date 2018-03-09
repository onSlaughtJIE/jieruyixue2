//
//  VideoMajorListVC.m
//  JRMedical
//
//  Created by a on 16/11/16.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "VideoMajorListVC.h"

#import "VideoMajorCell.h"
#import "VideoMajorHeaderCell.h"
#import "VideoSpecialDetailContentVC.h"

#import "PublicNewsListModel.h"
#import "UICollectionView+EmpayData.h"

@interface VideoMajorListVC ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation VideoMajorListVC {
    
    PublicNewsListModel *_headerModel;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefreshDataAfterSortingss" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    self.collectionView.sd_layout.widthIs(Width_Screen).heightIs(Height_Screen-109);
    
    //选择分类下的分类后刷新数据的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDataAfterSortingssClick:) name:@"RefreshDataAfterSortingss" object:nil];
    
    //请求视频讲座列表
    [self requestListDataArrray];
}

#pragma mark - //选择分类下的分类后刷新数据的通知
- (void)refreshDataAfterSortingssClick:(NSNotification *)sender {
    
    NSInteger tag = self.vcTag - 1000;
    
    NSArray *stringArray = sender.userInfo[@"LableValueLstStringss"];
    
    self.LableValueLst = stringArray[tag];
    
    NSArray *typeArray = sender.userInfo[@"typeListAry"];
    
    NSDictionary *dic = typeArray[tag];
    
    self.groupCode = dic[@"GroupCode"];
    self.valueString = dic[@"Value"];
    
    NSString *url = @"api/News/ItemList";
    NSString *params = [NSString stringWithFormat:@"ZICBDYCGroupCode=%@ZICBDYCTypeCode=%@ZICBDYCLableValueLst=%@",self.groupCode,self.valueString,self.LableValueLst];
    
    self.tableType = 2;//Colloection类
    self.baseColloectionView = self.collectionView;//将本类表 赋值给父类去操作
    [self loadDataApi:url withParams:params refresh:RefreshTypeBoth model:PublicNewsListModel.class];
}

#pragma mark - 请求数据列表
- (void)requestListDataArrray {
    
    NSString *url = @"api/News/ItemList";
    NSString *params = [NSString stringWithFormat:@"ZICBDYCGroupCode=%@ZICBDYCTypeCode=%@ZICBDYCLableValueLst=%@",self.groupCode,self.valueString,self.LableValueLst];

    self.tableType = 2;//Colloection类
    self.baseColloectionView = self.collectionView;//将本类表 赋值给父类去操作
    [self showLoadding:@"正在加载" time:20];
    [self loadDataApi:url withParams:params refresh:RefreshTypeBoth model:PublicNewsListModel.class];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.dataSource == nil) {
        [collectionView collectionViewDisplayWitMsg:@"" ifNecessaryForRowCount:self.dataSource.count widthDuiQi:0];
    }
    else {
        [collectionView collectionViewDisplayWitMsg:@"暂无相关视频信息!" ifNecessaryForRowCount:self.dataSource.count widthDuiQi:0];
    }
    if (self.dataSource.count == 0) {
        return 0;
    }
    else {
        if (self.page == 0) {
            _headerModel = self.dataSource[0];
            [self.dataSource removeObjectAtIndex:0];
            self.pageSize = 14;
        }
        return 1;
    }
}

#pragma mark - UICollectionView DataSource Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PublicNewsListModel *model = self.dataSource[indexPath.row];
    VideoMajorCell *item = (VideoMajorCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([VideoMajorCell class]) forIndexPath:indexPath];
    [item setModel:model];
    return item;
}

//自定义区头
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        //定制头部视图的内容
        VideoMajorHeaderCell *headView = (VideoMajorHeaderCell *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([VideoMajorHeaderCell class]) forIndexPath:indexPath];
        [headView setModel:_headerModel];
        headView.userInteractionEnabled = YES;
        [headView bk_whenTapped:^{
            VideoSpecialDetailContentVC *vSDContentVC = [[VideoSpecialDetailContentVC alloc] init];
            vSDContentVC.model = _headerModel;
            [self.navigationController pushViewController:vSDContentVC animated:YES];
        }];
        reusableView = headView;
    }
    
    return reusableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    //区头
    return CGSizeMake(Width_Screen, ((Width_Screen-20)/16*9)+70);
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
        [_collectionView registerClass:[VideoMajorHeaderCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([VideoMajorHeaderCell class])];
    }
    return  _collectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
