//
//  SearchGoodListViewController.m
//  JRMedical
//
//  Created by a on 16/12/15.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "SearchGoodListViewController.h"
#import "KMButton.h"
#import "GoodListTableViewCell.h"
#import "GoodRootViewController.h"
#import "UITableView+EmpayData.h"
#import "MerchandiseListModel.h"
#import "GoodListUBCell.h"

@interface SearchGoodListViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    BOOL _isNumUp;
    BOOL _isPriceUp;
    BOOL _isCommentUp;
}
@property (nonatomic, strong) UIView *optionView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SearchGoodListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"搜索结果";
    
    self.view.backgroundColor = BG_Color;
    
    [self requestMerchandiseList:@"" widthSortOrder:@""];
    
    //初始化列表
    [self.view addSubview:self.tableView];
    
    // 顶部筛选
    [self setTopOptionBar];
}

#pragma mark - 请求商品列表数据
- (void)requestMerchandiseList:(NSString *)sortField widthSortOrder:(NSString *)sortOrder {
    
    NSString *params;
    if ([self.dictType isEqualToString:@""]) {//商城首页全部搜索
        params = [NSString stringWithFormat:@"ZICBDYCQuery=%@ZICBDYCsortField=%@ZICBDYCsortOrder=%@",self.searchKeyWord,sortField,sortOrder];
    }
    else {//某分类下的搜索
        params = [NSString stringWithFormat:@"ZICBDYCQuery=%@ZICBDYCCategoryType=%@ZICBDYCsortField=%@ZICBDYCsortOrder=%@",self.searchKeyWord,self.dictType,sortField,sortOrder];
    }
    
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
        _tableView = [[UITableView alloc] initWithFrame:(CGRectMake(0, 40, Width_Screen, Height_Screen-104)) style:(UITableViewStyleGrouped)];
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
    
    if (model.PromotionPrice == 0) {
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
    
    if (model.PromotionPrice == 0) {
        rootVC.from = 2000;//兑换商品
        rootVC.isShowTool = 200;//兑换商品
    }
    else {
        rootVC.from = 1000;//兑换商品
        rootVC.isShowTool = 300;
    }
    
    [self.navigationController pushViewController:rootVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
