//
//  GoodListViewController.m
//  JRMedical
//
//  Created by ww on 2016/11/16.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "GoodListViewController.h"
#import "KMButton.h"
#import "GoodListTableViewCell.h"
#import "GoodListUBCell.h"
#import "GoodRootViewController.h"
#import "UITableView+EmpayData.h"
#import "MerchandiseListModel.h"
#import "SearchVC.h"
#import "MedicalAllTypeVC.h"
#import "MerchandiseTypeModel.h"

@interface GoodListViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    BOOL _isNumUp;
    BOOL _isPriceUp;
    BOOL _isCommentUp;
}
@property (nonatomic, strong) UIView *optionView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation GoodListViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MedicalTypeRefreshDataAfterSorting" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BG_Color;
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchq"]];
    self.navigationItem.titleView.userInteractionEnabled = YES;
    [self.navigationItem.titleView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goodSearch:)]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fenlei"] style:(UIBarButtonItemStylePlain) target:self action:@selector(fenlei:)];
    
    //选择分类下的分类后刷新数据的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(medicalTypeRefreshDataAfterSorting:) name:@"MedicalTypeRefreshDataAfterSorting" object:nil];
    
    [self requestMerchandiseList:@"" widthSortOrder:@""];//请求商品列表数据
    
    //初始化列表
    [self.view addSubview:self.tableView];
    
    // 顶部筛选
    [self setTopOptionBar];
}

#pragma mark - 选择分类下的分类后刷新数据的通知
- (void)medicalTypeRefreshDataAfterSorting:(NSNotification *)sender {
    
    //当前选择的 分类
    self.curSelectdItem = [sender.userInfo[@"CurSelectdItem"] integerValue];
    
    MerchandiseTypeModel *model = self.typeListArray[self.curSelectdItem];
    
    self.categoryType = model.Value;//根据分类刷新数据
    
    [self requestMerchandiseList:@"" widthSortOrder:@""];//请求商品列表数据
    
    //重置升降序
    {
        KMButton *btn1 = [self.optionView viewWithTag:101];
        KMButton *btn2 = [self.optionView viewWithTag:102];
        [btn1 setImage:[UIImage imageNamed:@"shangxiajiantou"] forState:(UIControlStateNormal)];
        [btn2 setImage:[UIImage imageNamed:@"shangxiajiantou"] forState:(UIControlStateNormal)];
    }
    {
        KMButton *btn1 = [self.optionView viewWithTag:100];
        KMButton *btn2 = [self.optionView viewWithTag:102];
        [btn1 setImage:[UIImage imageNamed:@"shangxiajiantou"] forState:(UIControlStateNormal)];
        [btn2 setImage:[UIImage imageNamed:@"shangxiajiantou"] forState:(UIControlStateNormal)];
    }
    {
        KMButton *btn1 = [self.optionView viewWithTag:100];
        KMButton *btn2 = [self.optionView viewWithTag:101];
        [btn1 setImage:[UIImage imageNamed:@"shangxiajiantou"] forState:(UIControlStateNormal)];
        [btn2 setImage:[UIImage imageNamed:@"shangxiajiantou"] forState:(UIControlStateNormal)];
    }
}

#pragma mark - 请求商品列表数据
- (void)requestMerchandiseList:(NSString *)sortField widthSortOrder:(NSString *)sortOrder {
    
    NSString *params = [NSString stringWithFormat:@"ZICBDYCCategoryType=%@ZICBDYCsortField=%@ZICBDYCsortOrder=%@",self.categoryType,sortField,sortOrder];
    
    NSLog(@"%@",params);
    
    NSString *url = @"api/CommodityInfo/CommodityInfoList";
    
    self.pageSize = 10;//一次加载10条数据
    self.tableType = 1;//TableView表类
    self.baseTableView = self.tableView;//将本类表 赋值给父类去操作
    [self showLoadding:@"" time:20];
    [self loadDataApi:url withParams:params refresh:RefreshTypeBoth model:MerchandiseListModel.class];
    
    //数据请求的回调
//    WeakSelf
//    self.baseFinishBlock = ^(NSArray *dataArray) {
//        [wself.tableView reloadData];
//    };
}

#pragma mark - 根据分类查看商品
- (void)fenlei:(UIBarButtonItem *)sender {
    MedicalAllTypeVC *ptVC = [MedicalAllTypeVC new];
    ptVC.typeListArray = self.typeListArray;
    ptVC.curSelectdItem = self.curSelectdItem;
    BaseNavigationController *ptNC = [[BaseNavigationController alloc] initWithRootViewController:ptVC];
    [self presentViewController:ptNC animated:YES completion:nil];
}

#pragma mark - 搜索商品
- (void)goodSearch:(UITapGestureRecognizer *)sender {
    SearchVC *searchVC = [SearchVC new];
    searchVC.groupCode = @"Product";
    searchVC.searchType = @"2";
    searchVC.dictType = self.categoryType;
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark - 商品升降序查看
- (void)setTopOptionBar {
    
    CGFloat width = Width_Screen/3;
    NSArray *arr = @[@"销量", @"价格", @"评价"];
    
    self.optionView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, Width_Screen, 40))];
    for (int i = 0; i < 3; i++) {
        KMButton *button = [[KMButton alloc] initWithFrame:(CGRectMake(i * width, 0, width, 40))];
        button.kMButtonType = KMButtonCenterRight;
        button.tag = 100+i;
        [button setTitle:arr[i] forState:(UIControlStateNormal)];
        [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [button setImage:[UIImage imageNamed:@"shangxiajiantou"] forState:(UIControlStateNormal)];
        [button addTarget:self action:@selector(btnChoose:) forControlEvents:(UIControlEventTouchUpInside)];
        [_optionView addSubview:button];
    }
    [self.view addSubview:_optionView];
    
    _optionView.layer.shadowColor = RGB(70, 70, 70).CGColor;//阴影颜色
    _optionView.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
    _optionView.layer.shadowOpacity = 0.5;//不透明度
    _optionView.layer.shadowRadius = 5.0;//半径
    _optionView.backgroundColor = [UIColor whiteColor];
}

- (void)btnChoose:(KMButton *)sender {
    
    switch (sender.tag) {
        case 100: // 销量
        {
            KMButton *btn1 = [self.optionView viewWithTag:101];
            KMButton *btn2 = [self.optionView viewWithTag:102];
            [btn1 setImage:[UIImage imageNamed:@"shangxiajiantou"] forState:(UIControlStateNormal)];
            [btn2 setImage:[UIImage imageNamed:@"shangxiajiantou"] forState:(UIControlStateNormal)];
            _isPriceUp = NO;
            _isCommentUp = NO;
            
            if (_isNumUp) {
                [sender setImage:[UIImage imageNamed:@"shagnxiafan"] forState:(UIControlStateNormal)];
                [self requestMerchandiseList:@"SaleCount" widthSortOrder:@"desc"];//销量降序
            } else {
                [sender setImage:[UIImage imageNamed:@"shagnxialv"] forState:(UIControlStateNormal)];
                [self requestMerchandiseList:@"SaleCount" widthSortOrder:@"asc"];//销量降序
            }
            _isNumUp = !_isNumUp;
        }
            break;
        case 101: // 价格
        {
            KMButton *btn1 = [self.optionView viewWithTag:100];
            KMButton *btn2 = [self.optionView viewWithTag:102];
            [btn1 setImage:[UIImage imageNamed:@"shangxiajiantou"] forState:(UIControlStateNormal)];
            [btn2 setImage:[UIImage imageNamed:@"shangxiajiantou"] forState:(UIControlStateNormal)];
            _isNumUp = NO;
            _isCommentUp = NO;
            
            if (_isPriceUp) {
                [sender setImage:[UIImage imageNamed:@"shagnxiafan"] forState:(UIControlStateNormal)];
                [self requestMerchandiseList:@"PromotionPrice" widthSortOrder:@"desc"];//价格降序
            } else {
                [sender setImage:[UIImage imageNamed:@"shagnxialv"] forState:(UIControlStateNormal)];
                [self requestMerchandiseList:@"PromotionPrice" widthSortOrder:@"asc"];//价格降序
            }
            _isPriceUp = !_isPriceUp;
        }
            break;
        default: // 评价
        {
            KMButton *btn1 = [self.optionView viewWithTag:100];
            KMButton *btn2 = [self.optionView viewWithTag:101];
            [btn1 setImage:[UIImage imageNamed:@"shangxiajiantou"] forState:(UIControlStateNormal)];
            [btn2 setImage:[UIImage imageNamed:@"shangxiajiantou"] forState:(UIControlStateNormal)];
            _isPriceUp = NO;
            _isNumUp = NO;
            
            if (_isCommentUp) {
                [sender setImage:[UIImage imageNamed:@"shagnxiafan"] forState:(UIControlStateNormal)];
                [self requestMerchandiseList:@"EvaluateCount" widthSortOrder:@"desc"];//评价降序
            } else {
                [sender setImage:[UIImage imageNamed:@"shagnxialv"] forState:(UIControlStateNormal)];
                [self requestMerchandiseList:@"EvaluateCount" widthSortOrder:@"asc"];//评价降序
            }
            _isCommentUp = !_isCommentUp;
        }
            break;
    }
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:(CGRectMake(0, 40, Width_Screen, Height_Screen-104)) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = BG_Color;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 105, 0, 0);
        [_tableView registerNib:[UINib nibWithNibName:@"GoodListTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        [_tableView registerNib:[UINib nibWithNibName:@"GoodListUBCell" bundle:nil] forCellReuseIdentifier:@"UBCell"];
    }
    return _tableView;
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataSource == nil) {
        [tableView tableViewDisplayWitMsg:@"" ifNecessaryForRowCount:self.dataSource.count];
    }
    else {
        [tableView tableViewDisplayWitMsg:@"暂无相关商品信息!" ifNecessaryForRowCount:self.dataSource.count];
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MerchandiseListModel *model = self.dataSource[indexPath.row];
    
    if ([self.categoryType isEqualToString:@"5"]) {
        GoodListUBCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UBCell" forIndexPath:indexPath];
        [cell setModel:model];
        return cell;
    }
    else {
        GoodListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        [cell setModel:model];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    MerchandiseListModel *model = self.dataSource[indexPath.row];
    GoodRootViewController *rootVC = [[GoodRootViewController alloc] init];
    rootVC.commodityID = model.CommodityID;//商品id
    rootVC.exchangeID = model.ExchangeID;//兑换id
    
    if ([self.categoryType isEqualToString:@"5"]) {
        rootVC.from = 2000;//兑换商品
        rootVC.isShowTool = 200;//商品
    }
    else {
        rootVC.from = 1000;//商品
        rootVC.isShowTool = 300;//商品
    }

    [self.navigationController pushViewController:rootVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
