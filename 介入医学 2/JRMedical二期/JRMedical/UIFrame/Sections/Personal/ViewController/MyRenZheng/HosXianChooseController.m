//
//  HosXianChooseController.m
//  JRMedical
//
//  Created by apple on 16/7/19.
//  Copyright © 2016年 ZC. All rights reserved.
//

#import "HosXianChooseController.h"
#import "HosProModel.h"
#import "HosEndController.h"
#import "HosSearchResultsController.h"

@interface HosXianChooseController ()<UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation HosXianChooseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"按地区选择医院";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell1"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    UIView *headView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, Width_Screen, 40))];
    self.searchBar = [[UISearchBar alloc] initWithFrame:(CGRectMake(0, 0, Width_Screen , 40))];
    [headView addSubview:self.searchBar];
    self.searchBar.barStyle = UIBarStyleDefault;
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"搜索医院";
    self.tableView.tableHeaderView = headView;
    
    [self loadXian];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    HosProModel *model = self.dataSource[indexPath.row];
    
    cell.textLabel.text = model.Name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HosProModel *model = self.dataSource[indexPath.row];
    
    HosEndController *endVC = [HosEndController new];
    
    endVC.AreaID = [NSString stringWithFormat:@"%ld", (long)model.ID];
    
    [self.navigationController pushViewController:endVC animated:YES];
}

- (void)loadXian {
    
    NSString *url = [[NSString alloc] init];
    NSString *dataStr = [[NSString alloc] init];

    if (self.FromNumber == 5566) {
        
        url = @"api/System/SysAreaByProvince";
        dataStr = [NSString stringWithFormat:@"ZICBDYCProvinceID=%ld", (long)_CityID];
        
    }
    else {
        
        url = @"api/System/SysArea";
        dataStr = [NSString stringWithFormat:@"ZICBDYCCityID=%ld", (long)_CityID];
    }
    
    self.pageSize = 100;
    [self showLoadding:@"正在加载" time:20];
    [self loadDataApi:url withParams:dataStr refresh:RefreshTypeNone model:HosProModel.class];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    HosSearchResultsController *reVC = [[HosSearchResultsController alloc] init];
    
    reVC.searchStr = searchBar.text;
    
    [self.view endEditing:YES];
    
    [self.navigationController pushViewController:reVC animated:YES];
}

@end
