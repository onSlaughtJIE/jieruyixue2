//
//  KeshiSelectController.m
//  JRMedical
//
//  Created by apple on 16/7/14.
//  Copyright © 2016年 ZC. All rights reserved.
//

#import "KeshiSelectController.h"
#import "KeshiSelectCell.h"
#import "LeanCollectionModel.h"
#import "KeshiSelectModel.h"
#import "keshiRightCell.h"

#import "UICollectionView+EmpayData.h"
#import <YYKit.h>

@interface KeshiSelectController ()<UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UITableView *tabelView;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *GoodCategoryArr; // 左侧数据源
@property (nonatomic, strong) NSMutableArray *GoodListArr;  // 右侧数据源

@end

@implementation KeshiSelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.GoodCategoryArr = [NSMutableArray arrayWithCapacity:0];
    self.GoodListArr = [NSMutableArray arrayWithCapacity:0];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configureView];
    
    [self getKeShiArray];
}

- (void)configureView {
    
    
    self.tabelView = [[UITableView alloc]initWithFrame:(CGRectMake(0, 0, 100, Height_Screen))];
    [self.view addSubview:self.tabelView];
    self.tabelView.backgroundColor = RGB(223, 223, 223);
    self.tabelView.dataSource = self;
    self.tabelView.delegate = self;
    self.tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tabelView registerNib:[UINib nibWithNibName:@"KeshiSelectCell" bundle:nil] forCellReuseIdentifier:@"leftCell"];
    
    UIView *tablefoot = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, 100, 60))];
    tablefoot.backgroundColor = RGB(223, 223, 223);
    self.tabelView.tableFooterView = tablefoot;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.collectionView = [[UICollectionView alloc]initWithFrame:(CGRectMake(100, 0, Width_Screen - 100, Height_Screen)) collectionViewLayout:flowLayout];
    [self.view addSubview:self.collectionView];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"rightItem"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"keshiRightCell" bundle:nil] forCellWithReuseIdentifier:@"rightItem"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    flowLayout.itemSize = CGSizeMake(Width_Screen - 100, 50);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.footerReferenceSize = CGSizeMake(0, 60);
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footerItem"];
    
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.GoodCategoryArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    KeshiSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = RGB(223, 223, 223);
    LeanCollectionModel *model = self.GoodCategoryArr[indexPath.row];
    [cell setValueWithLeanModel:model];
    
    if (indexPath.row == 0) {
        [cell.typeImageView setImageURL:[NSURL URLWithString:model.CheckedImage]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"点击左边");
    
    for (int i = 0; i < self.GoodCategoryArr.count; i++) {
        NSIndexPath *temp = [NSIndexPath indexPathForRow:i inSection:0];
        KeshiSelectCell *cell = [tableView cellForRowAtIndexPath:temp];
        LeanCollectionModel *model = self.GoodCategoryArr[i];

        if (cell.isSelected == YES) {
            [cell.typeImageView setImageURL:[NSURL URLWithString:model.CheckedImage]];
        } else {
            [cell.typeImageView setImageURL:[NSURL URLWithString:model.ImageUri]];
        }
    }

    LeanCollectionModel *model = self.GoodCategoryArr[indexPath.row];
    [self chooseKeshiFenLeiList:model.Value];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (Height_Screen-64)/5;
}

#pragma mark - UICollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.GoodListArr == nil) {
        [collectionView collectionViewDisplayWitMsg:@"" ifNecessaryForRowCount:self.GoodListArr.count widthDuiQi:0];
    }
    else {
        [collectionView collectionViewDisplayWitMsg:@"暂无相关科室信息!" ifNecessaryForRowCount:self.GoodListArr.count widthDuiQi:0];
    }
    return self.GoodListArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    keshiRightCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"rightItem" forIndexPath:indexPath];
    KeshiSelectModel *model = self.GoodListArr[indexPath.row];
    
    item.rightLabel.text = model.Name;
    
    return item;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    KeshiSelectModel *model = self.GoodListArr[indexPath.row];

    self.passKeshi(model);
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 获取科室分组
- (void)getKeShiArray {
    
    NSString *params = [NSString stringWithFormat:@"ZICBDYCGroupCode=%@",@"DepartmentType"];
    NSString *url = @"api/Customer/GetDictList";
    
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"获取科室分组 - %@", modelData);
        if (isSuccess) {
            
            NSArray *dataAry = modelData[@"JsonData"];

            [self.GoodCategoryArr removeAllObjects];
            
            NSArray *data = [NSArray modelArrayWithClass:LeanCollectionModel.class json:dataAry];
            
            [self.GoodCategoryArr addObjectsFromArray:data];
            
            [self.tabelView reloadData];
            
            LeanCollectionModel *model = self.GoodCategoryArr[0];
            [self chooseKeshiFenLeiList:model.Value];
        }
        else {
            NSString *msg  = [modelData objectForKey:@"Msg"];
            if (msg!=nil && ![msg isEqual:@""]) {
                [self showMessage:msg];
            }
            else {
                [self showMessage:[NSString stringWithFormat:@"请求失败 #%d",code]];
            }
        }
    }];
}

#pragma mark - 获取科室列表
- (void)chooseKeshiFenLeiList:(NSString *)value {
    
    NSString *params = [NSString stringWithFormat:@"ZICBDYCSonGroupID=%@",value];
    NSString *url = @"api/Customer/GetDeskWorkList";
    [self showLoadding:@"" time:20];
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"获取科室分组 - %@", modelData);
        if (isSuccess) {

            NSArray *dataAry = modelData[@"JsonData"];
            
            [self.GoodListArr removeAllObjects];
            
            NSArray *data = [NSArray modelArrayWithClass:KeshiSelectModel.class json:dataAry];
            
            [self.GoodListArr addObjectsFromArray:data];
            
            [self.collectionView reloadData];
        }
        else {
            NSString *msg  = [modelData objectForKey:@"Msg"];
            if (msg!=nil && ![msg isEqual:@""]) {
                [self showMessage:msg];
            }
            else {
                [self showMessage:[NSString stringWithFormat:@"请求失败 #%d",code]];
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
