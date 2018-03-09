//
//  SearchVC.m
//  JRMedical
//
//  Created by a on 16/11/24.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "SearchVC.h"
#import "SearchCollectionCell.h"
#import "SearchTableViewCell.h"
#import "UITableView+EmpayData.h"
#import "SearchResultVC.h"
#import "UICollectionView+EmpayData.h"

#import "PostSearchResultVC.h"
#import "SearchGoodListViewController.h"

@interface SearchVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) UILabel *topLeftLab;
@property (nonatomic, strong) UIButton *topRightBtn;
@property (nonatomic, strong) UILabel *botLeftLab;
@property (nonatomic, strong) UIButton *botRightBtn;

@property (nonatomic, assign) NSInteger curPage;

@property (nonatomic, strong) NSMutableArray *liShiArray;//数据源
@property (nonatomic, strong) NSMutableArray *reSouArray;//数据源

@end

@implementation SearchVC {
    
    NSString *_hotEmtyStr;
}

-(void)viewWillAppear:(BOOL)animated {
     [super viewWillAppear:animated];
    
    //Nav搜索框
    self.searchBar = [[UISearchBar alloc] initWithFrame:(CGRectMake(15, 0, Width_Screen - 80, 44))];
    self.searchBar.delegate = self;
    self.searchBar.barStyle = UIBarStyleDefault;
    self.searchBar.placeholder = @"请输入关键词搜索";
    self.searchBar.tintColor = Main_Color;
    [self.searchBar setImage:[UIImage imageNamed:@"search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [self.navigationController.navigationBar addSubview:self.searchBar];
    
    [self requestLiShiListDataArrray];//刷新历史记录
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //移除Nav搜索框
    [self.searchBar removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BG_Color;
    
    _liShiArray = [[NSMutableArray alloc] initWithCapacity:0];//历史记录数据源
    _reSouArray = [[NSMutableArray alloc] initWithCapacity:0];//热搜数据源
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarButtonItemClick)];
    
    //初始化视图
    [self initView];
    
    self.curPage = 0;//默认当前热搜列表为第一页
    //请求热搜数据列表
    [self showLoadding:@"" time:20];
    [self requestListDataArrray];
}

#pragma mark - 请求搜索信息
- (void)requestSearchInfo:(NSString *)searchKeyWord {
    
    if ([self.groupCode isEqualToString:@"Post"]) {//帖子
        PostSearchResultVC *srVC = [PostSearchResultVC new];
        srVC.dictType = self.dictType;
        srVC.searchKeyWord = searchKeyWord;
        [self.navigationController pushViewController:srVC animated:YES];
    }
    else if ([self.groupCode isEqualToString:@"Product"]) {//商城
        SearchGoodListViewController *srVC = [SearchGoodListViewController new];
        
        if ([self.dictType isEqualToString:@""] || self.dictType == nil) {
            self.dictType = @"";
        }
        
        srVC.dictType = self.dictType;
        srVC.searchKeyWord = searchKeyWord;
        [self.navigationController pushViewController:srVC animated:YES];
    }
    else {
        SearchResultVC *srVC = [SearchResultVC new];
        srVC.groupCode = self.groupCode;
        srVC.searchKeyWord = searchKeyWord;
        srVC.searchType = self.searchType;
        [self.navigationController pushViewController:srVC animated:YES];
    }
}

#pragma mark - 换一换
- (void)topRightBtnClick {
    self.curPage ++;
    [self requestListDataArrray];//请求换一批数据
}

#pragma mark - 清除历史记录
- (void)botRightBtnClick {
    
    NSString *url = @"api/News/DeleteSearch";
    NSString *params = [NSString stringWithFormat:@"ZICBDYCGroupCode=%@",@""];
    
    [self showLoadding:@"" time:20];
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"清除历史记录 - %@", modelData);
        if (isSuccess) {
            [self.liShiArray removeAllObjects];
            [self.tableView reloadData];
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

#pragma mark - 请求热搜数据列表
- (void)requestListDataArrray {
    
    NSString *url = @"api/News/GetHotList";
    
    NSString *params;
    if ([self.groupCode isEqualToString:@"CompanyType"]) {
        params = [NSString stringWithFormat:@"ZICBDYCGroupCode=%@ZICBDYCType=%@ZICBDYCCurPage=%ld",@"Company",self.searchType,self.curPage];
    }
    else {
        params = [NSString stringWithFormat:@"ZICBDYCGroupCode=%@ZICBDYCType=%@ZICBDYCCurPage=%ld",self.groupCode,self.searchType,self.curPage];
    }
    
    
//    NSLog(@"%ld---%@---%@",self.curPage,self.groupCode,self.searchType);
    
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"获取热搜列表 - %@", modelData);
        if (isSuccess) {
            
            NSArray *dataAry = modelData[@"JsonData"];
            
            if (dataAry.count < 6) {
                self.curPage = -1;
            }

            [self.reSouArray removeAllObjects];

            self.reSouArray = [NSMutableArray arrayWithArray:dataAry];
            
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

#pragma mark - 请求历史记录
- (void)requestLiShiListDataArrray {
    
    NSString *url = @"api/News/GetHistoryList";
    NSString *params = @"";
    
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"请求历史记录 - %@", modelData);
        if (isSuccess) {
            
            [self.liShiArray removeAllObjects];
            
            self.liShiArray = [NSMutableArray arrayWithArray:modelData[@"JsonData"]];
            
            [self.tableView reloadData];
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

#pragma mark - 初始化视图
- (void)initView {
    
    [self.view addSubview:self.topLeftLab];
    [self.view addSubview:self.topRightBtn];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.centerView];
    [self.view addSubview:self.botLeftLab];
    [self.view addSubview:self.botRightBtn];
    [self.view addSubview:self.tableView];
    
    self.topLeftLab.sd_layout.topSpaceToView(self.view,0).leftSpaceToView(self.view,15).widthIs(60).heightIs(44);
    self.topRightBtn.sd_layout.topSpaceToView(self.view,0).rightSpaceToView(self.view,15).widthIs(50).heightIs(44);
    self.collectionView.sd_layout.topSpaceToView(self.topLeftLab,10).rightSpaceToView(self.view,15).leftSpaceToView(self.view,15).heightIs(110);
    self.centerView.sd_layout.topSpaceToView(self.collectionView,20).rightSpaceToView(self.view,0).leftSpaceToView(self.view,0).heightIs(10);
    self.botLeftLab.sd_layout.topSpaceToView(self.centerView,15).leftSpaceToView(self.view,15).widthIs(60).heightIs(14);
    self.botRightBtn.sd_layout.topSpaceToView(self.centerView,15).rightSpaceToView(self.view,15).widthIs(30).heightIs(14);
    self.tableView.sd_layout.topSpaceToView(self.botLeftLab,15).widthIs(Width_Screen).bottomSpaceToView(self.view,0);
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self requestSearchInfo:searchBar.text];
    [searchBar resignFirstResponder];
}

#pragma mark - Table view Datasource Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    [tableView tableViewDisplayWitMsg:@"您还没有进行任何搜索记录哦!" ifNecessaryForRowCount:self.liShiArray.count widthDuiQi:1000];
    return self.liShiArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dataDic = self.liShiArray[indexPath.row];
    
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SearchTableViewCell class]) forIndexPath:indexPath];
    [cell setDataDic:dataDic];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width_Screen, 0.5)];
    headerView.backgroundColor = RGB(220, 220, 220);
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dataDic = self.liShiArray[indexPath.row];
    [self requestSearchInfo:dataDic[@"KeyWord"]];
}

#pragma mark - UICollectionView DataSource Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    [collectionView collectionViewDisplayWitMsg:@"暂无热搜记录了哦!  试试手动搜索?" ifNecessaryForRowCount:self.reSouArray.count widthDuiQi:1000];
    return self.reSouArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dataDic = self.reSouArray[indexPath.row];
    SearchCollectionCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SearchCollectionCell class]) forIndexPath:indexPath];
    [item setDataDic:dataDic];
    return item;
}

//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dataDic = self.reSouArray[indexPath.row];
    [self requestSearchInfo:dataDic[@"KeyWord"]];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dataDic = self.reSouArray[indexPath.row];
    CGSize itemWidth = [Utils sizeForTitle:dataDic[@"KeyWord"] withFont:[UIFont systemFontOfSize:12]];
    
    CGFloat width = (Width_Screen - 80)/2;
    
    if (itemWidth.width >= width) {
        itemWidth.width = width;
    }
    
    CGSize size = CGSizeMake(itemWidth.width+20, 30);
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - collectionView布局
- (UICollectionViewFlowLayout *)getFlowLayout {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //每一行的分割线(——)
    layout.minimumLineSpacing = 10;
    //每一列的分割线（|）
    layout.minimumInteritemSpacing = 10;
    return layout;
}

#pragma mark - 懒加载
- (UILabel *)topLeftLab {
    if (!_topLeftLab) {
        _topLeftLab = [UILabel new];
        _topLeftLab.text = @"热门搜索";
        _topLeftLab.textColor = RGB(140, 140, 140);
        _topLeftLab.font = [UIFont boldSystemFontOfSize:14];
    }
    return  _topLeftLab;
}
- (UIButton *)topRightBtn {
    if (!_topRightBtn) {
        _topRightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_topRightBtn setTitle:@"换一换" forState:UIControlStateNormal];
        _topRightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        [_topRightBtn setTitleColor:RGB(140, 140, 140) forState:UIControlStateNormal];
        _topRightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [_topRightBtn addTarget:self action:@selector(topRightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return  _topRightBtn;
}
- (UILabel *)botLeftLab {
    if (!_botLeftLab) {
        _botLeftLab = [UILabel new];
        _botLeftLab.text = @"历史记录";
        _botLeftLab.textColor = RGB(140, 140, 140);
        _botLeftLab.font = [UIFont boldSystemFontOfSize:14];
    }
    return  _botLeftLab;
}
- (UIButton *)botRightBtn {
    if (!_botRightBtn) {
        _botRightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_botRightBtn setTitle:@"清除" forState:UIControlStateNormal];
        _botRightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        [_botRightBtn setTitleColor:RGB(140, 140, 140) forState:UIControlStateNormal];
        _botRightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [_botRightBtn addTarget:self action:@selector(botRightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return  _botRightBtn;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:[self getFlowLayout]];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = BG_Color;
        [_collectionView registerClass:[SearchCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([SearchCollectionCell class])];
    }
    return  _collectionView;
}
- (UIView *)centerView {
    if (!_centerView) {
        _centerView = [UIView new];
        _centerView.backgroundColor = RGB(220, 220, 220);
    }
    return  _centerView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
        _tableView.backgroundColor = BG_Color;
        _tableView.separatorColor  = RGB(220, 220, 220);
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [_tableView registerClass:[SearchTableViewCell class] forCellReuseIdentifier:NSStringFromClass([SearchTableViewCell class])];
    }
    return  _tableView;
}

#pragma mark - 取消回去上级页面
- (void)rightBarButtonItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
