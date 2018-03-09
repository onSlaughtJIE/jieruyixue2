//
//  HosCityChooseController.m
//  JRMedical
//
//  Created by apple on 16/7/19.
//  Copyright © 2016年 ZC. All rights reserved.
//

#import "HosCityChooseController.h"
#import "HosProModel.h"
#import "HosXianChooseController.h"
#import "HosSearchResultsController.h"

@interface HosCityChooseController ()<UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation HosCityChooseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"按城市选择医院";
    
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
    
    [self loadCity];
    
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
    HosXianChooseController *vc = [HosXianChooseController new];
    HosProModel *model = self.dataSource[indexPath.row];
    vc.CityID = model.ID;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadCity {
    
    NSString *url = @"api/System/SysCity";
    NSString *params = [NSString stringWithFormat:@"ZICBDYCProvinceID=%ld", (long)_ProvinceID];
    self.pageSize = 100;
    [self showLoadding:@"正在加载" time:20];
    [self loadDataApi:url withParams:params refresh:RefreshTypeNone model:HosProModel.class];
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
