//
//  HosSearchResultsController.m
//  JRMedical
//
//  Created by apple on 16/7/19.
//  Copyright © 2016年 ZC. All rights reserved.
//

#import "HosSearchResultsController.h"
#import "RenZhengHospitalModel.h"

#import "HosShuruViewController.h"

#import "UITableView+EmpayData.h"

@interface HosSearchResultsController ()

@end

@implementation HosSearchResultsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"搜索结果";
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self loadHos];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataSource == nil) {
        [tableView tableViewDisplayWitMsg:@"" ifNecessaryForRowCount:self.dataSource.count];
    }
    else {
        [tableView tableViewDisplayWitMsg:@"该地区暂无医院信息!" ifNecessaryForRowCount:self.dataSource.count];
    }
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RenZhengHospitalModel *model = self.dataSource[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = model.Name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RenZhengHospitalModel *hosModel = self.dataSource[indexPath.row];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic setObject:hosModel.Name forKey:@"hosName"];
    [dic setObject:hosModel.ID  forKey:@"hosID"];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"passHos" object:nil userInfo:dic];
    
    NSArray * ctrlArray = self.navigationController.viewControllers;
    
    [self.navigationController popToViewController:[ctrlArray objectAtIndex:1] animated:YES];
}

- (void)loadHos {
    
    NSString *url = @"api/Hospital/SearchList";
    NSString *params = [NSString stringWithFormat:@"ZICBDYCArea=%@ZICBDYCKey=%@",@"", self.searchStr];
    self.pageSize = 100;
    [self showLoadding:@"正在加载" time:20];
    [self loadDataApi:url withParams:params refresh:RefreshTypeNone model:RenZhengHospitalModel.class];
}

@end
