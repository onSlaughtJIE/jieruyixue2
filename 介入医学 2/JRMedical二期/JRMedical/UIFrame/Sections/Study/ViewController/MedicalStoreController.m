//
//  MedicalStoreController.m
//  JRMedical
//
//  Created by ww on 16/11/15.
//  Copyright © 2016年 idcby. All rights reserved.
//

#define kCellTop @"TopCell"
#define kCellMiddle @"MiddleCell"
#define kCellBottom @"BottomCell"

#define kHeader @"collectHeader"
#define kXianshiHeader @"xianshiHeader"

#import "MedicalStoreController.h"
#import <SDCycleScrollView.h>
#import "PYSearch.h"
#import "PYSearchViewController.h"
#import "SearchResultViewController.h"
#import "StudyCollectModel.h"
#import "StudyCollectionCell.h"
#import "HeaderCollectionReusableView.h"
#import "BottomCollectionViewCell.h"
#import "StudyCollectModel.h"
#import "TimeLimitGoodView.h"


@interface MedicalStoreController ()<SDCycleScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate, PYSearchViewControllerDelegate>

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) UICollectionView *storeCollectionView;
@property (nonatomic, strong) UIScrollView *horizonScroll;
@property (nonatomic, strong) NSMutableArray *dataSourceOne; // 集合视图数据源1
@property (nonatomic, strong) NSMutableArray *dataSourceTwo; // 集合视图数据源2
@property (nonatomic, strong) NSMutableArray *scrollDataArr; //限时兑换scrollview数据源
@property (nonatomic, strong) NSMutableArray *imagesArray; // 轮播图片
@property (nonatomic, strong) NSMutableArray *titlesArray; // 轮播标题
@property (nonatomic, strong) NSMutableArray *HrefArr;     // 轮播图跳转网址

@end

@implementation MedicalStoreController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    // 设置导航控制器的代理为self
    self.navigationController.delegate = self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dataSourceOne = [NSMutableArray array];
    self.dataSourceTwo = [NSMutableArray array];
    self.scrollDataArr = [NSMutableArray array];
    
    // 分区1数据源
    [self addDataForCollectSectionOne];
    
    //
    [self configCollectionView];
    
    //
    self.horizonScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Width_Screen, 140)];
    _horizonScroll.showsHorizontalScrollIndicator = NO;
    _horizonScroll.backgroundColor = [UIColor whiteColor];
    _horizonScroll.contentSize = CGSizeMake(8 * 120, 140);
    
    for (int i = 0 ; i < 8; i++) {
        TimeLimitGoodView *goodView = [TimeLimitGoodView shareTimeLimitGoodView];
        goodView.frame = CGRectMake(10*(i+1)+120*i, 0, 120, 140);
        [_horizonScroll addSubview:goodView];
    }
    
   
    
}

- (void)configCollectionView {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    
    collectionView.backgroundColor = BG_Color;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerNib:[UINib nibWithNibName:@"StudyCollectionCell" bundle:nil] forCellWithReuseIdentifier:kCellTop];
    [collectionView registerNib:[UINib nibWithNibName:@"BottomCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kCellBottom];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCellMiddle];
    // 注册页眉
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeader]; // 放轮播图
    [collectionView registerClass:[HeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kXianshiHeader]; // 放限时兑换
    [self.view addSubview:collectionView];
    self.storeCollectionView = collectionView;
}


#pragma mark - UICollectionView Delegate

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        if (indexPath.section == 0) {
            // 重用页眉
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeader forIndexPath:indexPath];
            // 轮播图
            UIView *lunboView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width_Screen, 200)];
            [headerView addSubview:lunboView];
            
            self.imagesArray = [NSMutableArray array];
            self.titlesArray = [NSMutableArray array];
            self.HrefArr = [NSMutableArray array];
            
            SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:(CGRectMake(0, 0, Width_Screen, 200)) delegate:self placeholderImage:[UIImage imageNamed:@"lunboPh"]];
            cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
            // 存放图片/标题的数组
            NSMutableArray *images = self.imagesArray;
            cycleScrollView.titlesGroup = self.titlesArray;
            cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
            
            // 加载延迟
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                cycleScrollView.imageURLStringsGroup = images;
            });
            [lunboView addSubview:cycleScrollView];
            self.cycleScrollView = cycleScrollView;
            
            // 返回按钮
            UIView *backView = [[UIView alloc] initWithFrame:(CGRectMake(5, 10, 40, 40))];
            [lunboView addSubview:backView];
            UIImageView *back = [[UIImageView alloc] initWithFrame:(CGRectMake(10, 7, 10, 15))];
            back.image = [UIImage imageNamed:@"backlv"];
            back.userInteractionEnabled = YES;
            [backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(storeBack)]];
            [backView addSubview:back];
            
            // 搜索框
            UIImageView *search = [[UIImageView alloc] initWithFrame:(CGRectMake(Width_Screen/2-100, 10, 200, 30))];
            search.image = [UIImage imageNamed:@"storeSearch"];
            search.userInteractionEnabled = YES;
            [search addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(main_search)]];
            [lunboView addSubview:search];
            
            // 购物车
            UIImageView *xiaoxi = [[UIImageView alloc] initWithFrame:(CGRectMake(Width_Screen - 40, 12, 30, 30))];
            xiaoxi.image = [UIImage imageNamed:@"gouw"];
            xiaoxi.userInteractionEnabled = YES;
            [lunboView addSubview:xiaoxi];
            
            
            return headerView;
                
            } else if (indexPath.section == 1){
                
                HeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kXianshiHeader forIndexPath:indexPath];
                
                return headerView;
            }
            
        }
    
    
    return nil;
    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    

    switch (section) {
        case 0:
            return self.dataSourceOne.count;
            break;
        case 1:
            return 1;
            break;
        default:
            return 10;
//                return self.dataSourceTwo.count;
            break;
    }
        

    
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
        
    switch (indexPath.section) {
        case 0:
        {
            StudyCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellTop forIndexPath:indexPath];
            
            StudyCollectModel *model = self.dataSourceOne[indexPath.row];
            
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.image.image = [UIImage imageNamed:model.imageName];
            cell.title.text = model.title;
            
            if (Width_Screen == 320) {
                cell.withConst.constant = 25;
                cell.heightConst.constant = 25;
            }
            
            
            return cell;
            
        }
            break;
        case 1:
        {
            UICollectionViewCell *middleCell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellMiddle forIndexPath:indexPath];
            
            [middleCell addSubview:_horizonScroll];
            
            
            return middleCell;
        }
            break;
        default:
        {
            BottomCollectionViewCell *bottomCell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellBottom forIndexPath:indexPath];
            return bottomCell;
        }
            break;
    }
        

        
    
        

    
    return nil;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0: // 商品分类
        {
            
        }
            break;
        case 1: // 限时兑换
        {
            
        }
            break;
            
        default:
        {
            
        }
            break;
    }
        
  
}

#pragma mark - UICollectionViewDelegateFlowLayout

 // 动态返回item大小的方法
 - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
     
     switch (indexPath.section) {
         case 0:
             return CGSizeMake(Width_Screen/6, 80);
             break;
         case 1:
             return CGSizeMake(Width_Screen, 140);
             break;
         default:
             return CGSizeMake((Width_Screen-15)/2, 250);
             break;
     }
 
 }
 // 动态设置每个分区的缩进量
 - (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {

     switch (section) {
         case 0:
             return UIEdgeInsetsMake(0, 0, 0, 0);
             break;
         case 1:
             return UIEdgeInsetsMake(0, 0, 0, 0);
             break;
         default:
             return UIEdgeInsetsMake(10, 5, 10, 5);
             break;
     }

 
 
 }
 // 动态设置行间距
 - (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
 
     if (section == 2) {
         return 5;
     }else {
         return 0;
     }
     
 
 }
 // 动态设置列间距
 - (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
 
     if (section == 2) {
         return 5;
     }else {
         return 0;
     }
 
 }
 // 动态设置页眉的大小
 - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
 
     switch (section) {
         case 0:
             return CGSizeMake(0, 200);
             break;
         case 1:
             return CGSizeMake(0, 45);
             break;
         default:
             return CGSizeMake(0, 0);
             break;
     }

 }




#pragma mark - SDCycleScrollView Delegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
 
    NSLog(@"轮播图点击");
 
}

#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}


- (void)main_search {
    
    // 1.创建热门搜索
    NSArray *hotSeaches = @[@"Java", @"Python", @"Objective-C", @"Swift", @"C", @"C++", @"PHP", @"C#", @"Perl", @"Go", @"JavaScript", @"R", @"Ruby", @"MATLAB"];
    // 2. 创建控制器
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"搜索编程语言" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        // 开始搜索执行以下代码
        // 如：跳转到指定控制器
        [searchViewController.navigationController pushViewController:[[SearchResultViewController alloc] init] animated:YES];
    }];
    // 3. 设置风格
    searchViewController.hotSearchStyle = PYHotSearchStyleColorfulTag; // 热门搜索风格根据选择
    searchViewController.searchHistoryStyle = PYHotSearchStyleDefault; // 搜索历史风格为default
    // 4. 设置代理
    searchViewController.delegate = self;
    // 5. 跳转到搜索控制器
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav animated:NO completion:nil];
    
}

#pragma mark - PYSearchViewControllerDelegate
- (void)searchViewController:(PYSearchViewController *)searchViewController searchTextDidChange:(UISearchBar *)seachBar searchText:(NSString *)searchText
{
    if (searchText.length) { // 与搜索条件再搜索
        // 根据条件发送查询（这里模拟搜索）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 搜素完毕
            // 显示建议搜索结果
            NSMutableArray *searchSuggestionsM = [NSMutableArray array];
            for (int i = 0; i < arc4random_uniform(5) + 10; i++) {
                NSString *searchSuggestion = [NSString stringWithFormat:@"搜索建议 %d", i];
                [searchSuggestionsM addObject:searchSuggestion];
            }
            // 返回
            searchViewController.searchSuggestions = searchSuggestionsM;
        });
    }
}

- (void)addDataForCollectSectionOne {
    NSString *path = [[NSBundle mainBundle]pathForResource:@"medicalStore" ofType:@"plist"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
    NSArray *arrays = dic[@"collectionview"];
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in arrays) {
        StudyCollectModel *model = [[StudyCollectModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [array addObject:model];
    }
    
    [self.dataSourceOne addObjectsFromArray:array];
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:0];
    [self.storeCollectionView reloadSections:set];
}

- (void)storeBack {
    
    [self.navigationController popViewControllerAnimated:YES];
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
