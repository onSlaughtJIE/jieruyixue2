//
//  AllCategoryCollectionVC.m
//  JRMedical
//
//  Created by a on 16/11/14.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "AllCategoryCollectionVC.h"

#import "AllCategoryCollectionCell.h"
#import "AllCategoryHeaderView.h"

@interface AllCategoryCollectionVC ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UICollectionView *collectionTopView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *sureBtn;

@property (nonatomic, strong) NSMutableArray *lableValueListArray;
@property (nonatomic, strong) NSMutableDictionary *lableValueLstStrings;

@end

@implementation AllCategoryCollectionVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:BG_Color];//改变导航栏颜色
    [self setStatusBarBackgroundColor:BG_Color];//改变状态栏背景色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];//改变状态栏颜色
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self setStatusBarBackgroundColor:Main_Color];//改变状态栏背景色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];//改变状态栏颜色
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BG_Color;
    
    self.lableValueListArray = [NSMutableArray arrayWithCapacity:0];
    self.lableValueLstStrings = [NSMutableDictionary dictionaryWithCapacity:0];
    
    //设置导航栏右边按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"closez"] style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarButtonItemClick)];
    [self.navigationController.navigationBar setTintColor:RGB(85, 85, 85)];

    [self initView];// 初始化视图
}

#pragma mark - 确认选择
- (void)sureBtnClick {
    
    NSMutableDictionary *allInfoDic = [[NSMutableDictionary alloc] init];
    
    if (self.lableValueLstStrings.count == 0) {//如果标签数组为
        [allInfoDic setObject:@"" forKey:@"LableValueLstStrings"];
    }
    else {

        NSMutableArray *valueArray = [NSMutableArray array];
        for (NSString *valueString in [self.lableValueLstStrings allValues]) {
            [valueArray addObject:valueString];
        }
        
        NSMutableString *string1;
        NSString *string = @"";
        for (int i = 0; i < valueArray.count; i ++) {
            if (i == 0) {
                string1 = [NSMutableString stringWithFormat:@"%@",valueArray[i]];
            }
            else {
                string = [NSMutableString stringWithFormat:@",%@",valueArray[i]];
            }
            [string1 appendString:string];
        }
        
        [allInfoDic setObject:string1 forKey:@"LableValueLstStrings"];
    }
    [allInfoDic setObject:@(self.curSelectdItem) forKey:@"CurSelectdItem"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshDataAfterSorting" object:nil userInfo:allInfoDic];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 关闭
- (void)rightBarButtonItemClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 初始化视图
- (void)initView {
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.collectionTopView];
    [self.scrollView addSubview:self.collectionView];
    [self.view addSubview:self.sureBtn];

    //底部滑动视图
    self.scrollView.sd_layout.topSpaceToView(self.view,0).widthIs(Width_Screen).heightIs(Height_Screen-154);
    
    //确认按钮
    self.sureBtn.sd_layout.topSpaceToView(self.scrollView,15).centerXEqualToView(self.view).heightIs(40).widthIs((Width_Screen-66)/3);
    
    //初始化分类视图
    [self initTypeListView];
    
    //默认显示第一个分类下的分类
    [self requestData:self.curSelectdItem];
}

#pragma mark - 初始化分类视图
- (void)initTypeListView {
    
    //顶部分类一共多少排
    NSInteger topNum = [[NSString stringWithFormat:@"%lu",self.typeListArray.count/3] integerValue];
    if (self.typeListArray.count % 3) {
        topNum = topNum +1;
    }
    
    //下面分类一共多少排
    NSInteger botNum = [[NSString stringWithFormat:@"%lu",self.lableValueListArray.count/3] integerValue];
    if (self.lableValueListArray.count % 3) {
        botNum = botNum +1;
    }
    
    CGFloat collectionTopHeight = topNum*40+(topNum-1)*8+80;
    CGFloat collectionHeight = botNum*40+(botNum-1)*8+65;
    CGFloat scrollViewHeight = collectionTopHeight+collectionHeight;
    
    self.scrollView.contentSize = CGSizeMake(Width_Screen, scrollViewHeight);
    
    self.collectionTopView.sd_layout.topSpaceToView(self.scrollView,0).widthIs(Width_Screen).heightIs(collectionTopHeight);
    self.collectionView.sd_layout.topSpaceToView(self.collectionTopView,0).widthIs(Width_Screen).heightIs(collectionHeight);
    
    [self.collectionView reloadData];
}

#pragma mark - 请求分类下的分类数据
- (void)requestData:(NSInteger)row {
    
    if (self.typeListArray.count == 0) {
        return;
    }
    
    NSDictionary *typeDic = self.typeListArray[row];
    
    NSString *params = [NSString stringWithFormat:@"ZICBDYCTypeID=%@",typeDic[@"ID"]];
    NSString *url = @"api/News/LableValueListByTypeID";
    
    NSLog(@"%@",params);
    
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"获取分类(%ld)下的分类 - %@",row,modelData);
        if (isSuccess) {
            
            self.lableValueListArray = modelData[@"JsonData"];
            
            [self initTypeListView];
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

#pragma mark - 设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

#pragma mark - UICollectionView DataSource Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.collectionTopView) {
        return self.typeListArray.count;
    }
    return self.lableValueListArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AllCategoryCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([AllCategoryCollectionCell class]) forIndexPath:indexPath];
    
    if (collectionView == self.collectionTopView) {
        NSDictionary *dataDic = self.typeListArray[indexPath.row];
        [cell setDataDic:dataDic];
        if (indexPath.row == self.curSelectdItem) {
            [cell setBackgroundColor:Main_Color];
            cell.titleLab.textColor = [UIColor whiteColor];
        }
    }
    else {
        NSDictionary *dataDic = self.lableValueListArray[indexPath.row];
        [cell setDataDic:dataDic];
    }
    
    return cell;
}

//自定义区头
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        //定制头部视图的内容
        AllCategoryHeaderView *headView = (AllCategoryHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([AllCategoryHeaderView class]) forIndexPath:indexPath];
        
        if (collectionView == self.collectionTopView) {
            headView.titleLab.text = @"栏目分类";
        }
        else {
            headView.titleLab.text = @"分类标签";
        }
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
    
    AllCategoryCollectionCell *cell = (AllCategoryCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setBackgroundColor:Main_Color];
    cell.titleLab.textColor = [UIColor whiteColor];
    if (collectionView == self.collectionTopView) {
        //选中上面分类区
        [self requestData:indexPath.row];
        
        self.curSelectdItem = indexPath.row;//选中的当前的顶部分类
    }
    else {
        //选中下面分类区
        NSDictionary *dataDic = self.lableValueListArray[indexPath.row];
        [self.lableValueLstStrings setObject:dataDic[@"ID"] forKey:@(indexPath.row)];
    }
}

//取消选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AllCategoryCollectionCell *cell = (AllCategoryCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor whiteColor]];
    cell.titleLab.textColor = [UIColor blackColor];
    if (collectionView == self.collectionTopView) {
        //取消选中点击上面分类区
        [self.lableValueLstStrings removeAllObjects];
    }
    else {
        //取消选中下面分类区
        [self.lableValueLstStrings removeObjectForKey:@(indexPath.row)];
    }
}

//定义每个Section 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    //分别为上、左、下、右
    if (collectionView == self.collectionTopView) {
        return UIEdgeInsetsMake(10, 25, 30, 25);
    }
    else {
        return UIEdgeInsetsMake(10, 25, 10, 25);
    }
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
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.backgroundColor = BG_Color;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return  _scrollView;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:[self getFlowLayout]];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = BG_Color;
        _collectionView.scrollEnabled = NO;
        _collectionView.allowsMultipleSelection = YES;
        [_collectionView registerClass:[AllCategoryCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([AllCategoryCollectionCell class])];
        [_collectionView registerClass:[AllCategoryHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([AllCategoryHeaderView class])];
    }
    return  _collectionView;
}
- (UICollectionView *)collectionTopView {
    if (!_collectionTopView) {
        _collectionTopView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:[self getFlowLayout]];
        _collectionTopView.delegate = self;
        _collectionTopView.dataSource = self;
        _collectionTopView.scrollEnabled = NO;
        _collectionTopView.backgroundColor = BG_Color;
        [_collectionTopView selectItemAtIndexPath:[NSIndexPath indexPathForItem:self.curSelectdItem inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        [_collectionTopView registerClass:[AllCategoryCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([AllCategoryCollectionCell class])];
        [_collectionTopView registerClass:[AllCategoryHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([AllCategoryHeaderView class])];
    }
    return  _collectionTopView;
}
- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _sureBtn.backgroundColor = Main_Color;
        _sureBtn.clipsToBounds = YES;
        _sureBtn.layer.cornerRadius = 3;
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_sureBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return  _sureBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
