//
//  OrganizeDetailController.m
//  JRMedical
//
//  Created by ww on 2016/12/27.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "OrganizeDetailController.h"
#import "OrganizeCollectionCell.h"
#import "OrgDetailModel.h"
#import "MdetailController.h"
#import "YDetailController.h"

@interface OrganizeDetailController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, retain) NSMutableArray *dataSource; // 数据源
@property (nonatomic, retain) UICollectionView *collectionView;

@end

@implementation OrganizeDetailController

- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        self.dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureCollectionView];
    
    for (NSDictionary *dic in self.dataArray) {
        
        OrgDetailModel *model = [[OrgDetailModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [self.dataSource addObject:model];
        
    }
    

}


- (void)configureCollectionView {

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((Width_Screen-20)/4, 100);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10);
    
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:flowLayout];

    collectionView.backgroundColor = BG_Color;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self.view addSubview:collectionView];

    [collectionView registerClass:[OrganizeCollectionCell class] forCellWithReuseIdentifier:@"cell"];

    self.collectionView = collectionView;
}

#pragma mark - 数据源方法
// 每个分区中的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}
// 返回item的方法
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    OrganizeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    OrgDetailModel *model = self.dataSource[indexPath.row];
    
    [cell setOrganizeCollectionCellWithModel:model];
    
    return cell;
}
// 点击item会触发的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%ld - %ld", indexPath.section, indexPath.row);
    
    OrgDetailModel *model = self.dataSource[indexPath.row];
    
    if ([AFManegerHelp isYourFriendsWith:model.CustomerID]) {
        
        // 是好友
        YDetailController *yVC = [[YDetailController alloc] init];
        yVC.userid = model.CustomerID;
        [self.navigationController pushViewController:yVC animated:YES];
        
    } else {
        
        // 不是好友
        MdetailController *mdVC = [[MdetailController alloc]init];
        mdVC.userid = model.CustomerID;
        [self.navigationController pushViewController:mdVC animated:YES];
    }
    
    
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
