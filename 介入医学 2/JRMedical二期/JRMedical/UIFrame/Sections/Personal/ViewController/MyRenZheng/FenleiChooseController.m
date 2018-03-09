//
//  FenleiChooseController.m
//  JRMedical
//
//  Created by apple on 16/6/16.
//  Copyright © 2016年 ZC. All rights reserved.
//

#import "FenleiChooseController.h"
#import "RenZhengKeshiModel.h"

#import "UITableView+EmpayData.h"

#define kJieRuFenLei @"InterventionalType"

@interface FenleiChooseController ()

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation FenleiChooseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setEditing:YES animated:YES];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:(UIBarButtonItemStylePlain) target:self action:@selector(tijiao:)];
    
    // 获取介入分类
    [self chooseJieRuFenLei];
    
    self.dataSource = [NSMutableArray array];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"fenleiCell"];
}


- (void)tijiao:(UIBarButtonItem *)sender {
    
    NSLog(@"提交");
    
    NSMutableArray *passArr = [NSMutableArray arrayWithCapacity:0];

    NSMutableArray *indexPathArray = [NSMutableArray arrayWithArray:self.tableView.indexPathsForSelectedRows];
    
//    NSLog(@"indexPathArray - %@", indexPathArray);
    
    for (NSIndexPath *index in indexPathArray) {
        RenZhengKeshiModel *model = self.dataSource[index.row];
        [passArr addObject:model];
    }
    
    self.passFenLei(passArr);

    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  设置系统自带编辑按钮的响应
 */
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
    
    [self.tableView setEditing:editing animated:animated];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}

/**
 *  多选模式设置
 */
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleInsert | UITableViewCellEditingStyleDelete;
}

#pragma mark - 获取介入分类
- (void)chooseJieRuFenLei {

    NSString *url = @"api/Customer/GetDictList";
    NSString *params = [NSString stringWithFormat:@"ZICBDYCGroupCode=%@", @"InterventionalType"];
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
        [tableView tableViewDisplayWitMsg:@"暂无相关分类信息!" ifNecessaryForRowCount:self.dataSource.count];
    }
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fenleiCell" forIndexPath:indexPath];
    
    RenZhengKeshiModel *model = self.dataSource[indexPath.row];
    cell.textLabel.text = model.Name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    RenZhengKeshiModel *model = self.dataSource[indexPath.row];
//    NSMutableArray *array = [NSMutableArray array];
//    [array addObject:model];
//
//    self.passFenLei(array);
//    [self.navigationController popViewControllerAnimated:YES];
}

@end
