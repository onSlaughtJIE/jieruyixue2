//
//  ZhiChengChooseController.m
//  JRMedical
//
//  Created by apple on 16/6/16.
//  Copyright © 2016年 ZC. All rights reserved.
//

#import "ZhiChengChooseController.h"
#import "RenZhengKeshiModel.h"

#import "UITableView+EmpayData.h"

#define kZhiChengFenLei @"ClassificationType"

@interface ZhiChengChooseController ()

@end

@implementation ZhiChengChooseController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    // 获取职称分类
    [self chooseZhiChengFenLei];
    
    self.dataSource = [NSMutableArray array];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"zhichengCell"];
}


#pragma mark - 获取职称分类
- (void)chooseZhiChengFenLei {

    NSString *url = @"api/Customer/GetDictList";
    NSString *params = [NSString stringWithFormat:@"ZICBDYCGroupCode=%@", @"ClassificationType"];
    self.pageSize = 150;
    [self showLoadding:@"正在加载" time:20];
    [self loadDataApi:url withParams:params refresh:RefreshTypeNone model:RenZhengKeshiModel.class];
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
        [tableView tableViewDisplayWitMsg:@"暂无相关职称信息!" ifNecessaryForRowCount:self.dataSource.count];
    }
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"zhichengCell" forIndexPath:indexPath];
    
    RenZhengKeshiModel *model = self.dataSource[indexPath.row];
    
    cell.textLabel.text = model.Name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RenZhengKeshiModel *model = self.dataSource[indexPath.row];
    self.passZhiCheng(model);
    [self.navigationController popViewControllerAnimated:YES];
}

@end
