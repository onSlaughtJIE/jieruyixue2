//
//  RelevantVideoListVC.m
//  JRMedical
//
//  Created by a on 16/11/17.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "RelevantVideoListVC.h"

#import "VideoMajorCell.h"
#import "VideoLectureListModel.h"
#import "UICollectionView+EmpayData.h"

@interface RelevantVideoListVC ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation RelevantVideoListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    self.collectionView.sd_layout.widthIs(Width_Screen).heightIs(Height_Screen-64);
    self.collectionView.scrollEnabled = NO;
    
    [self requestListDataArrray];//请求数据列表
}

#pragma mark - 请求数据列表
- (void)requestListDataArrray {
    
    NSString *url = @"api/News/RelevantViedoList";
    NSString *params = [NSString stringWithFormat:@"ZICBDYCVideoID=%@",self.videoId];
    
    self.pageSize = 6;
    self.tableType = 2;//Colloection类
    self.baseColloectionView = self.collectionView;//将本类表 赋值给父类去操作
    [self loadDataApi:url withParams:params refresh:RefreshTypeNone model:VideoLectureListModel.class];
    
    //数据请求的回调
    self.baseFinishBlock = ^(NSArray *dataArray) {
        
        NSMutableDictionary *allInfoDic = [[NSMutableDictionary alloc] init];
        [allInfoDic setObject:@(dataArray.count) forKey:@"VideoNum"];        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeVideoDetailsHeight" object:nil userInfo:allInfoDic];
    };
}

#pragma mark - UICollectionView DataSource Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.dataSource == nil) {
        [collectionView collectionViewDisplayWitMsg:@"" ifNecessaryForRowCount:self.dataSource.count widthDuiQi:0];
    }
    else {
        [collectionView collectionViewDisplayWitMsg:@"" ifNecessaryForRowCount:self.dataSource.count widthDuiQi:0];
    }
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VideoLectureListModel *model = self.dataSource[indexPath.row];
    VideoMajorCell *item = (VideoMajorCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([VideoMajorCell class]) forIndexPath:indexPath];
    [item setModel:model];
    return item;
}


//定义每个Section 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
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
