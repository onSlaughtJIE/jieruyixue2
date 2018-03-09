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

#import "SearchVC.h"

#import "MedicalStoreController.h"
#import <SDCycleScrollView.h>

#import "MerchandiseListModel.h"
#import "MerchandiseTypeModel.h"

#import "GoodListViewController.h"
#import "GoodRootViewController.h"
#import "MerchandiseTypeCell.h"
#import "HeaderCollectionReusableView.h"
#import "BottomCollectionViewCell.h"
#import "HomeExchangeCCell.h"
#import "WLZ_ShoppingCarController.h"//购物车
#import "CommonWebVC.h"
#import <YYKit.h>

@interface MedicalStoreController ()<HomeExchangeCCellDelegate,SDCycleScrollViewDelegate,MerchandiseTypeCellDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate,MedicalExchangeCellDelegate>

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) UICollectionView *storeCollectionView;

@property (nonatomic, strong) NSMutableArray *dataSourceOne; // 集合视图数据源1
@property (nonatomic, strong) NSMutableArray *scrollDataArr; //限时兑换scrollview数据源

@property (nonatomic, strong) NSMutableArray *imagesArray; // 轮播图片
@property (nonatomic, strong) NSMutableArray *titlesArray; // 轮播标题
@property (nonatomic, strong) NSMutableArray *HrefArr;     // 轮播图跳转网址

//轮播图上的UI
@property (nonatomic, strong) UIView *lunboView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *back;
@property (nonatomic, strong) UIImageView *search;
@property (nonatomic, strong) UIImageView *xiaoxi;
@property (nonatomic, strong) UILabel *shoppingNumlab;

@end

@implementation MedicalStoreController {
    
    NSInteger _shoppingNum;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    // 设置导航控制器的代理为self
    self.navigationController.delegate = self;
    
    [self getShoppingData];//请求购物车数量
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //添加一个view替换状态栏 颜色
    UIView *statusBar = [UIView new];
    statusBar.backgroundColor = Main_Color;
    statusBar.sd_layout.topEqualToView(self.view).widthIs(Width_Screen).heightIs(20);
    [self.view addSubview:statusBar];
    
    self.dataSourceOne = [NSMutableArray array];
    self.scrollDataArr = [NSMutableArray array];
    
    self.imagesArray = [NSMutableArray array];
    self.titlesArray = [NSMutableArray array];
    self.HrefArr = [NSMutableArray array];
    
    _shoppingNum = 0;//购物车数量

    //初始化视图
    [self configCollectionView];
    
    // 分区1数据源
    [self addDataForCollectSectionOne];
    
    //请求商品列表
    [self requestMerchandiseListData];
}

- (void)configCollectionView {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 20, Width_Screen, Height_Screen-20) collectionViewLayout:flowLayout];
    
    collectionView.backgroundColor = BG_Color;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerNib:[UINib nibWithNibName:@"BottomCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kCellBottom];
    [collectionView registerClass:[HomeExchangeCCell class] forCellWithReuseIdentifier:kCellMiddle];
    [collectionView registerClass:[MerchandiseTypeCell class] forCellWithReuseIdentifier:kCellTop];

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
            if (!_lunboView) {
                _lunboView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width_Screen, Height_SixteenToNine)];
                [headerView addSubview:_lunboView];
                SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:(CGRectMake(0, 0, Width_Screen, Height_SixteenToNine)) delegate:self placeholderImage:[UIImage imageNamed:@"jiazai"]];
                cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
                cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
                cycleScrollView.currentPageDotColor = Main_Color;
                cycleScrollView.pageDotColor = [UIColor whiteColor];
//                cycleScrollView.currentPageDotImage = [UIImage imageWithColor:Main_Color size:CGSizeMake(32, 6)];
//                cycleScrollView.pageDotImage = [UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(32, 6)];
                [_lunboView addSubview:cycleScrollView];
                self.cycleScrollView = cycleScrollView;
            }

            // 加载延迟
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            self.cycleScrollView.imageURLStringsGroup = self.imagesArray;
//            });
            
            // 返回按钮
            if (!_backView) {
                _backView = [[UIView alloc] initWithFrame:(CGRectMake(5, 10, 40, 40))];
                [_lunboView addSubview:_backView];
            }
            if (!_back) {
                _back = [UIImageView new];
                _back.image = [UIImage imageNamed:@"backlv"];
                _back.userInteractionEnabled = YES;
                [_backView addSubview:_back];
                
                [_backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(storeBack)]];
                _back.sd_layout.centerXEqualToView(_backView).topSpaceToView(_backView,5).widthIs(10).heightIs(19);
            }
            
            // 搜索框
            if (!_search) {
                _search = [[UIImageView alloc] initWithFrame:(CGRectMake(Width_Screen/2-100, 10, 200, 30))];
                _search.image = [UIImage imageNamed:@"storeSearch"];
                _search.userInteractionEnabled = YES;
                [_search addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(main_search)]];
                [_lunboView addSubview:_search];
            }
            
            // 购物车
            if (!_xiaoxi) {
                _xiaoxi = [[UIImageView alloc] initWithFrame:(CGRectMake(Width_Screen - 45, 10, 40, 40))];
//                _xiaoxi.backgroundColor = [UIColor whiteColor];
//                _xiaoxi.clipsToBounds = YES;
//                _xiaoxi.layer.cornerRadius = 15;
                _xiaoxi.image = [UIImage imageNamed:@"gouw"];
                _xiaoxi.userInteractionEnabled = YES;
                [_xiaoxi addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shoppingCart)]];
                [_lunboView addSubview:_xiaoxi];
            }
            
            if (!_shoppingNumlab) {
                _shoppingNumlab = [[UILabel alloc] initWithFrame:(CGRectMake(22, -2, 15, 15))];
                _shoppingNumlab.font = [UIFont systemFontOfSize:9];
                _shoppingNumlab.backgroundColor = [UIColor redColor];
                _shoppingNumlab.textColor = [UIColor whiteColor];
                _shoppingNumlab.textAlignment = NSTextAlignmentCenter;
                _shoppingNumlab.layer.masksToBounds = YES;
                _shoppingNumlab.layer.cornerRadius = 7.5;
                [_xiaoxi addSubview:_shoppingNumlab];
            }
            
            if (_shoppingNum == 0) {
                self.shoppingNumlab.hidden = YES;
            }
            else {
                self.shoppingNumlab.hidden = NO;
                self.shoppingNumlab.text = [NSString stringWithFormat:@"%ld",_shoppingNum];
            }
            
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
            return 1;
            break;
        case 1:
            return self.scrollDataArr.count;
            break;
        default:
            return self.dataSource.count;
            break;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
        
    switch (indexPath.section) {
        case 0:
        {
            MerchandiseTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellTop forIndexPath:indexPath];
            [cell setModelAry:self.dataSourceOne];
            cell.delegate = self;
            return cell;
        }
            break;
        case 1:
        {// 限时兑换
            HomeExchangeCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellMiddle forIndexPath:indexPath];
            cell.delegate = self;
            [cell setModelAry:self.scrollDataArr];
            return cell;
        }
            break;
        default:
        {
            MerchandiseListModel *model = self.dataSource[indexPath.row];
            BottomCollectionViewCell *bottomCell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellBottom forIndexPath:indexPath];
            [bottomCell setIndexPath:indexPath];
            bottomCell.delegate = self;
            [bottomCell setModel:model];
            return bottomCell;
        }
            break;
    }

    return nil;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2) {
        //下面商品列表
        MerchandiseListModel *model = self.dataSource[indexPath.row];
        GoodRootViewController *rootVC = [[GoodRootViewController alloc] init];
        rootVC.commodityID = model.CommodityID;//商品id
        rootVC.exchangeID = model.ExchangeID;//兑换id
        rootVC.from = 1000;
        rootVC.isShowTool = 300;//商品
        [self.navigationController pushViewController:rootVC animated:YES];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
 // 动态返回item大小的方法
 - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
     
     switch (indexPath.section) {
         case 0:
             return CGSizeMake(Width_Screen, 80);
             break;
         case 1:
             return CGSizeMake(Width_Screen, 140);
             break;
         default:
             return CGSizeMake((Width_Screen-15)/2, 230);
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
             return CGSizeMake(0, Height_SixteenToNine);
             break;
         case 1:
             if (self.scrollDataArr.count == 0) {
                 return CGSizeMake(0, 0);
             } else {
                 return CGSizeMake(0, 45);
             }
             break;
         default:
             return CGSizeMake(0, 0);
             break;
     }
 }

#pragma mark - MedicalExchangeCellDelegate
- (void)selectRowDelectClick:(NSIndexPath *)indexPath {
    MerchandiseListModel *model = self.dataSource[indexPath.row];
    NSString *params = [NSString stringWithFormat:@"ZICBDYCCommodityID=%@ZICBDYCNumber=%@",model.CommodityID,@"1"];
    NSString *url = @"api/MallsInfo/AddShoppingCart";
    [self showLoadding:@"" time:20];
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"加入购物车 - %@", modelData);
        if (isSuccess) {
            [self showMessage:@"添加购物车成功" time:0.7];
            
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7/*延迟执行时间*/ * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                //增加购物车数据  
                [self getShoppingData];
            });

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

#pragma mark - MerchandiseTypeCellDelegate
- (void)selectTypeView:(NSInteger)typeTag {
    
    MerchandiseTypeModel *model = self.dataSourceOne[typeTag];
    
    NSLog(@"%@",model.Value);
    
    GoodListViewController *listVC = [[GoodListViewController alloc] init];
    listVC.categoryType = model.Value;
    listVC.typeListArray = self.dataSourceOne;
    listVC.curSelectdItem = typeTag;
    [self.navigationController pushViewController:listVC animated:YES];
}

#pragma mark - HomeExchangeCCellDelegate
- (void)selectExchangeView:(NSInteger)typeTag {
    
    MerchandiseListModel *model = self.scrollDataArr[typeTag];
    GoodRootViewController *rootVC = [[GoodRootViewController alloc] init];
    rootVC.commodityID = model.CommodityID;//商品id
    rootVC.exchangeID = model.ExchangeID;//兑换id
    rootVC.from = 2000;//兑换商品
    rootVC.isShowTool = 200;//兑换商品
    [self.navigationController pushViewController:rootVC animated:YES];
}

#pragma mark - SDCycleScrollView Delegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    NSString *url = self.HrefArr[index];
    NSString *title = self.titlesArray[index];
    if ([Utils isBlankString:url]) {
        NSLog(@"链接为空");
//        [self showMessage:@"暂无网址链接~"];
    } else {
        
        CommonWebVC *webVC = [[CommonWebVC alloc] init];
        if (![Utils isBlankString:title]) {
            webVC.title = title;
        }
        webVC.url = url;
        [self.navigationController pushViewController:webVC animated:YES];
        
    }
    
}

#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

#pragma mark - 搜索
- (void)main_search {
    SearchVC *searchVC = [SearchVC new];
    searchVC.groupCode = @"Product";
    searchVC.searchType = @"2";
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark - 购物车
- (void)shoppingCart {
    WLZ_ShoppingCarController *scVC = [WLZ_ShoppingCarController new];
    [self.navigationController pushViewController:scVC animated:YES];
}

#pragma mark - 获取商品分类列表
- (void)addDataForCollectSectionOne {
    
    NSString *params = @"";
    NSString *url = @"api/MallsInfo/GetCommodityCategoryList";
    
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"获取商品分类列表数据 - %@", modelData);
        if (isSuccess) {
            
            [self.dataSourceOne removeAllObjects];
            
            NSArray *dataAry = modelData[@"JsonData"];
            NSArray *data = [NSArray modelArrayWithClass:MerchandiseTypeModel.class json:dataAry];
            [self.dataSourceOne addObjectsFromArray:data];
            
            [self.storeCollectionView reloadData];
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

#pragma mark - 获取首页轮播图片
- (void)requestHomeLunBoData {
    
    NSString *params = [NSString stringWithFormat:@"ZICBDYCType=%@",@"1"];
    NSString *url = @"api/News/RepeatPic";
    
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"获取首页轮播图片 - %@", modelData);
        if (isSuccess) {
            
            [self.imagesArray removeAllObjects];
            [self.titlesArray removeAllObjects];
            
            NSArray *dataAry = modelData[@"JsonData"];
            
            for (NSDictionary *dic in dataAry) {
                [self.imagesArray addObject:dic[@"Uri"]];
                [self.titlesArray addObject:dic[@"Title"]];
                [self.HrefArr addObject:dic[@"Href"]];
            }

            [self.storeCollectionView reloadData];
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

#pragma mark - 获取限时兑换数据
- (void)requestLimitedExchangeData {
    
    NSString *params = [NSString stringWithFormat:@"ZICBDYCCurPage=%@ZICBDYCPageSize=%@",@"0",@"10"];
    NSString *url = @"api/CommodityInfo/CommodityExchangeList";
    
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"获取限时兑换数据 - %@", modelData);
        if (isSuccess) {
            
            [self.scrollDataArr removeAllObjects];
            
            NSArray *dataAry = modelData[@"JsonData"];
            NSArray *data = [NSArray modelArrayWithClass:MerchandiseListModel.class json:dataAry];
            [self.scrollDataArr addObjectsFromArray:data];
            
            [self.storeCollectionView reloadData];
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

#pragma mark - 获取购物车数据
- (void)getShoppingData {
    
    NSString *url = @"api/MallsInfo/GetShoppingCartNum";
    NSString *params = @"";
    
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"获取购物车数据 - %@", modelData);
        if (isSuccess) {
            
            NSString *num = modelData[@"JsonData"][@"ShoppingCartNumber"];
            
            _shoppingNum = [num integerValue];
            
            [self.storeCollectionView reloadData];
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

#pragma mark - 获取全部商品列表数据
- (void)requestMerchandiseListData {
    
    NSString *url = @"api/CommodityInfo/CommodityInfoList";
    
    self.tableType = 2;//TableView表类
    self.baseColloectionView = self.storeCollectionView;//将本类表 赋值给父类去操作
    [self showLoadding:@"" time:20];
    [self loadDataApi:url withParams:@"" refresh:RefreshTypeBoth model:MerchandiseListModel.class];
    
    //数据请求的回调
    WeakSelf
    self.baseFinishBlock = ^(NSArray *dataArray) {
        [wself requestHomeLunBoData];//获取首页轮播图片
        [wself requestLimitedExchangeData];//兑换商品加载
    };
}

#pragma mark - 返回按钮
- (void)storeBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
