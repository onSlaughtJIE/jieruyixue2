//
//  MyUBVC.m
//  JRMedical
//
//  Created by a on 16/11/8.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "MyUBVC.h"

#import "XBConst.h"
#import "XBSettingCell.h"
#import "XBSettingItemModel.h"
#import "XBSettingSectionModel.h"

#import "MyUBDetailedListVC.h"

#import "UITableView+EmpayData.h"

@interface MyUBVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *sectionArray;

@property (nonatomic,strong) NSMutableArray *oneTitleArray;
@property (nonatomic,strong) NSMutableArray *oneImgArray;
@property (nonatomic,strong) NSMutableArray *oneNumArray;
@property (nonatomic,strong) NSMutableArray *twoTitleArray;
@property (nonatomic,strong) NSMutableArray *twoImgArray;
@property (nonatomic,strong) NSMutableArray *twoNumArray;

@end

@implementation MyUBVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的U币";
    
    self.sectionArray = [NSMutableArray arrayWithCapacity:0];
    self.oneTitleArray = [NSMutableArray arrayWithCapacity:0];
    self.oneImgArray = [NSMutableArray arrayWithCapacity:0];
    self.oneNumArray = [NSMutableArray arrayWithCapacity:0];
    self.twoTitleArray = [NSMutableArray arrayWithCapacity:0];
    self.twoImgArray = [NSMutableArray arrayWithCapacity:0];
    self.twoNumArray = [NSMutableArray arrayWithCapacity:0];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"明细" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarButtonItemClick)];
    
    [self.view addSubview:self.tableView];
    
    [self getUBDataSource];
}

#pragma mark - 动态获取UB活动数据源
- (void)getUBDataSource {
    
    NSString *url = @"api/Customer/UMoneyPrice";
    NSString *params = @"";
    
    [self showLoadding:@"" time:20];
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"动态获取UB活动数据源 - %@", modelData);
        if (isSuccess) {
            [self setDataSourceArray:modelData[@"JsonData"]];
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

#pragma mark - 查看明细
- (void)rightBarButtonItemClick {
    MyUBDetailedListVC *mubdlVC = [MyUBDetailedListVC new];
    [self.navigationController pushViewController:mubdlVC animated:YES];
}

#pragma mark - 设置数据源
- (void)setDataSourceArray:(NSArray *)dataSource {
    
    for (int i = 0 ; i < dataSource.count; i ++) {//拆分数据源
        NSDictionary *dic = dataSource[i];
        
        if (i == 0 || i == 1) {
            [self.oneTitleArray addObject:dic[@"Name"]];
            [self.oneImgArray addObject:dic[@"ImageUri"]];
            [self.oneNumArray addObject:dic[@"Value"]];
        }
        else {
            [self.twoTitleArray addObject:dic[@"Name"]];
            [self.twoImgArray addObject:dic[@"ImageUri"]];
            [self.twoNumArray addObject:dic[@"Value"]];
        }
    }
    
    NSMutableArray *xinShouArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < self.oneTitleArray.count ; i ++) {
        XBSettingItemModel *section1Item = [[XBSettingItemModel alloc]init];
        section1Item.funcName = self.oneTitleArray[i];
        section1Item.urlImg = self.oneImgArray[i];
        section1Item.detailText = [NSString stringWithFormat:@"+%@",self.oneNumArray[i]];
        section1Item.detailImage = [UIImage imageNamed:@"jifenqianbi"];
        section1Item.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
        [xinShouArray addObject:section1Item];
    }
    XBSettingSectionModel *section1 = [[XBSettingSectionModel alloc]init];
    section1.itemArray = xinShouArray;

    NSMutableArray *meiRiArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < self.twoTitleArray.count ; i ++) {
        XBSettingItemModel *section1Item = [[XBSettingItemModel alloc]init];
        section1Item.funcName = self.twoTitleArray[i];
        section1Item.urlImg = self.twoImgArray[i];
        section1Item.detailText = [NSString stringWithFormat:@"+%@",self.twoNumArray[i]];
        section1Item.detailImage = [UIImage imageNamed:@"jifenqianbi"];
        section1Item.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
        [meiRiArray addObject:section1Item];
    }
    
    XBSettingSectionModel *section2 = [[XBSettingSectionModel alloc]init];
    section2.itemArray = meiRiArray;
    
    [self.sectionArray addObject:section1];
    [self.sectionArray addObject:section2];
    
    [self.tableView reloadData];
}

#pragma mark - Table view datasource and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    [tableView tableViewDisplayWitMsg:@"暂无U币活动信息!" ifNecessaryForRowCount:self.sectionArray.count];
    
    if (self.sectionArray.count > 0) {
        return self.sectionArray.count+2;
    }
    else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 2) {
        return 0;
    }
    else if (section == 1) {
        XBSettingSectionModel *sectionModel = self.sectionArray[0];
        return sectionModel.itemArray.count;
    }
    else {
        XBSettingSectionModel *sectionModel = self.sectionArray[1];
        return sectionModel.itemArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 || indexPath.section == 2) {
        return nil;
    }
    
    XBSettingSectionModel *sectionModel = nil;
    if (indexPath.section == 1) {
        sectionModel = self.sectionArray[0];
    }
    else {
        sectionModel = self.sectionArray[1];
    }
    
    XBSettingItemModel *itemModel = sectionModel.itemArray[indexPath.row];
    
    XBSettingCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XBSettingCell class]) forIndexPath:indexPath];
    cell.item = itemModel;
    cell.indicator.hidden = YES;
    cell.imgView.x = 30 + cell.imgView.width;
    cell.funcNameLabel.x = CGRectGetMaxX(cell.imgView.frame) + XBFuncLabelToFuncImgGap;
    cell.detailLabel.x = Width_Screen - 28;
    cell.detailLabel.textColor = RGB(255, 152, 0);
    
    if (indexPath.section == 1) {
        
        
        
        NSInteger num = self.oneTitleArray.count-1;
        if (indexPath.row != num) {
            cell.line.x = 30 + cell.imgView.width;
        }
        else {
            cell.line.y = 51;
        }
    }
    
    if (indexPath.section == 3) {
        NSInteger num = self.twoTitleArray.count-1;
        if (indexPath.row != num) {
            cell.line.x = 30 + cell.imgView.width;
        }
        else {
            cell.line.y = 51;
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 2) {
        return 15;
    }
    return 51;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:self.tableView.tableHeaderView.frame];
    headerView.backgroundColor = BG_Color;
    
    if (section == 0 || section == 2) {
        return headerView;
    }
    
    UIView *headerView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width_Screen, 50)];
    headerView1.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:headerView1];
    
    UIImageView *leftImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rwrenw"]];
    leftImg.centerY = headerView1.centerY;
    leftImg.x = XBFuncImgToLeftGap;
    [headerView1 addSubview:leftImg];
    
    UILabel *leftLab = [UILabel new];
    leftLab.textColor = XBMakeColorWithRGB(51, 51, 51, 1);
    leftLab.font = [UIFont systemFontOfSize:XBFuncLabelFont];
    if (section == 1) {
        leftLab.text = @"新手任务";
        leftLab.size = [Utils sizeForTitle:@"新手任务" withFont:leftLab.font];
    }
    else if (section == 3) {
        leftLab.text = @"每日任务";
        leftLab.size = [Utils sizeForTitle:@"每日任务" withFont:leftLab.font];
    }
    
    leftLab.centerY = headerView1.centerY;
    leftLab.x = CGRectGetMaxX(leftImg.frame) + XBFuncLabelToFuncImgGap;
    [headerView1 addSubview:leftLab];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width_Screen, Height_Screen-64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _tableView.separatorColor  = [UIColor clearColor];
        _tableView.backgroundColor = BG_Color;
        [_tableView registerClass:[XBSettingCell class] forCellReuseIdentifier:NSStringFromClass([XBSettingCell class])];
    }
    return  _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
