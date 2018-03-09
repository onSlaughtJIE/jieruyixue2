//
//  MedicalMeetListVC.m
//  JRMedical
//
//  Created by a on 16/11/15.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "MedicalMeetListVC.h"

#import "MedicalMeetCell.h"
#import "LearnWebController.h"
#import "MedicalMeetWebDetailVC.h"

#import "PublicNewsListModel.h"
#import "UITableView+EmpayData.h"

@interface MedicalMeetListVC ()

@end

@implementation MedicalMeetListVC {
    
    NSMutableDictionary *_sectionDict;
    NSMutableArray *_sectionModelAry;
    NSMutableArray *_sectionAry;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefreshDataAfterSortingss" object:nil];
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _sectionDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    _sectionAry  = [[NSMutableArray alloc] initWithCapacity:0];

    
    self.tableView.separatorColor = BG_Color;
    self.tableView.backgroundColor = BG_Color;
    [self.tableView registerClass:[MedicalMeetCell class] forCellReuseIdentifier:NSStringFromClass([MedicalMeetCell class])];
    
    //选择分类下的分类后刷新数据的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDataAfterSortingssClick:) name:@"RefreshDataAfterSortingss" object:nil];
    
    //请求医学会议列表
    [self requestListDataArrray];
}

#pragma mark - //选择分类下的分类后刷新数据的通知
- (void)refreshDataAfterSortingssClick:(NSNotification *)sender {
    
    NSInteger tag = self.vcTag - 1000;
    
    NSArray *stringArray = sender.userInfo[@"LableValueLstStringss"];
    
    self.LableValueLst = stringArray[tag];
    
    NSArray *typeArray = sender.userInfo[@"typeListAry"];
    
    NSDictionary *dic = typeArray[tag];
    
    self.groupCode = dic[@"GroupCode"];
    self.valueString = dic[@"Value"];
    
    NSString *url = @"api/News/ItemList";
    NSString *params = [NSString stringWithFormat:@"ZICBDYCGroupCode=%@ZICBDYCTypeCode=%@ZICBDYCLableValueLst=%@",self.groupCode,self.valueString,self.LableValueLst];
    
    [self loadDataApi:url withParams:params refresh:RefreshTypeBoth model:PublicNewsListModel.class];
}

#pragma mark - 请求数据列表
- (void)requestListDataArrray {
    
    NSString *url = @"api/News/ItemList";
    NSString *params = [NSString stringWithFormat:@"ZICBDYCGroupCode=%@ZICBDYCTypeCode=%@ZICBDYCLableValueLst=%@",self.groupCode,self.valueString,self.LableValueLst];
    
    [self showLoadding:@"正在加载" time:20];
    [self loadDataApi:url withParams:params refresh:RefreshTypeBoth model:PublicNewsListModel.class];
}

#pragma mark - Table view datasource and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.dataSource == nil) {
        [tableView tableViewDisplayWitMsg:@"" ifNecessaryForRowCount:self.dataSource.count];
    }
    else {
        
        [tableView tableViewDisplayWitMsg:@"暂无相关会议信息!" ifNecessaryForRowCount:self.dataSource.count];
        
        [_sectionDict removeAllObjects];
        [_sectionAry removeAllObjects];
        [_sectionModelAry removeAllObjects];
        
        //处理账单数据
        for (PublicNewsListModel *model in self.dataSource) {
            
            NSString *timeStr  = [Utils formatTimeStamp:@"MM月" withTime:model.TimeStamp];//交易时间
            
            NSString *firstStr = [timeStr substringWithRange:NSMakeRange(0, 1)];
            NSString *timeStr2 = nil;
            if ([firstStr isEqualToString:@"0"]) {
                timeStr2 = [timeStr substringWithRange:NSMakeRange(1, 2)];
            }
            else {
                timeStr2 = timeStr;
            }
            
            if ([[_sectionDict allKeys] containsObject:timeStr2]) {
                
                [_sectionModelAry addObject:model];
            }
            else {
                
                _sectionModelAry = [[NSMutableArray alloc] initWithCapacity:0];
                [_sectionModelAry addObject:model];
                [_sectionDict setObject:_sectionModelAry forKey:timeStr2];
            }
            
            if (![_sectionAry containsObject:timeStr2]) {
                [_sectionAry addObject:timeStr2];
            }
        }
    }
    
    return _sectionAry.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSArray *sectionModelAry = [_sectionDict objectForKey:[_sectionAry objectAtIndex:section]];
    return sectionModelAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *sectionModelAry = [_sectionDict objectForKey:[_sectionAry objectAtIndex:indexPath.section]];
    PublicNewsListModel *model = sectionModelAry[indexPath.row];
    
    MedicalMeetCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MedicalMeetCell class]) forIndexPath:indexPath];
    [cell setModel:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 60;
    }
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:self.tableView.frame];
    
    UIView *yuanyuanView = [UIView new];
    yuanyuanView.clipsToBounds = YES;
    yuanyuanView.layer.cornerRadius = 20;
    yuanyuanView.backgroundColor = Main_Color;
    [headerView addSubview:yuanyuanView];
    
    yuanyuanView.sd_layout.leftSpaceToView(headerView,10).bottomEqualToView(headerView).heightIs(40).widthIs(40);
    
    UILabel *yueFenLab = [UILabel new];
    yueFenLab.text = [_sectionAry objectAtIndex:section];
    yueFenLab.textColor = [UIColor whiteColor];
    yueFenLab.textAlignment = NSTextAlignmentCenter;
    yueFenLab.font = [UIFont boldSystemFontOfSize:14];
    [yuanyuanView addSubview:yueFenLab];
    
    yueFenLab.sd_layout.centerXEqualToView(yuanyuanView).centerYEqualToView(yuanyuanView).heightIs(40).widthIs(40);
    
    return headerView;
}

#pragma mark  点击cell的响应的代理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PublicNewsListModel *model = self.dataSource[indexPath.row];
    MedicalMeetWebDetailVC *webVC = [[MedicalMeetWebDetailVC alloc] init];
    webVC.model = model;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
