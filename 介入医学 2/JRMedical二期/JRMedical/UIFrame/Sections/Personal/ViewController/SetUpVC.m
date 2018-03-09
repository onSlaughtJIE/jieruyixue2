//
//  SetUpVC.m
//  JRMedical
//
//  Created by a on 16/11/8.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "SetUpVC.h"

#import "XBConst.h"
#import "XBSettingCell.h"
#import "XBSettingItemModel.h"
#import "XBSettingSectionModel.h"
#import "JRLoginViewController.h"
#import "JRRegistViewController.h"
#import "HTMLViewController.h"
#import "FeedbackVC.h"

#import "ZFActionSheet.h"//底部弹出视图

@interface SetUpVC ()<UITableViewDelegate,UITableViewDataSource,ZFActionSheetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *sectionArray;

@end

@implementation SetUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    
    [self setDataSourceArray];//设置数据源
    
    [self.view addSubview:self.tableView];
}

#pragma mark - 设置数据源
- (void)setDataSourceArray {
    
    NSArray *leftName = @[@"修改登录密码",@"介入医学简介",@"声明",@"版本号",@"意见反馈",@"客服中心"];
    NSArray *leftImg = @[@"mimaxg",@"jianjj",@"shengm",@"banben",@"yjfankui",@"kefzx"];
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < leftName.count ; i ++) {
        XBSettingItemModel *section1Item = [[XBSettingItemModel alloc] init];
        section1Item.funcName = leftName[i];
        section1Item.img = [UIImage imageNamed:leftImg[i]];
        
        if (i == 5) {
            section1Item.detailText = @"400-693-7369";
        }
        else if (i == 3) {
            section1Item.detailText = [NSString stringWithFormat:@"v%@",[self getCurrentAppVersion]];
        }
        
        section1Item.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
        [array addObject:section1Item];
    }
    XBSettingSectionModel *section = [[XBSettingSectionModel alloc] init];
    section.sectionHeaderHeight = 15;
    section.itemArray = array;
    
    NSArray *leftName2 = @[@"退出登录"];
    NSArray *leftImg2 = @[@"tuichu"];
    NSMutableArray *array2 = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < leftName2.count ; i ++) {
        XBSettingItemModel *section2Item = [[XBSettingItemModel alloc] init];
        section2Item.funcName = leftName2[i];
        section2Item.img = [UIImage imageNamed:leftImg2[i]];
        section2Item.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
        [array2 addObject:section2Item];
    }
    XBSettingSectionModel *section2 = [[XBSettingSectionModel alloc] init];
    section2.sectionHeaderHeight = 15;
    section2.itemArray = array2;
    
    self.sectionArray = @[section,section2];
}

#pragma mark - Table view datasource and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    XBSettingSectionModel *sectionModel = self.sectionArray[section];
    return sectionModel.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    XBSettingSectionModel *sectionModel = self.sectionArray[indexPath.section];
    XBSettingItemModel *itemModel = sectionModel.itemArray[indexPath.row];
    
    XBSettingCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XBSettingCell class]) forIndexPath:indexPath];
    cell.item = itemModel;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    XBSettingSectionModel *sectionModel = self.sectionArray[section];
    return sectionModel.sectionHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //点击跳转对应界面
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {//修改登录密码
            
            JRRegistViewController *forgetVC = [[JRRegistViewController alloc] init];
            BaseNavigationController *forgetNC = [[BaseNavigationController alloc] initWithRootViewController:forgetVC];
            forgetVC.navigationItem.title = @"修改密码";
            [self presentViewController:forgetNC animated:YES completion:nil];
            
        }
        else if (indexPath.row == 1) {//介入医学简介
            
            HTMLViewController * htmlVC = [[HTMLViewController alloc] init];
            htmlVC.urlStr = @"Web/CustomerInfo/GroupInfo";
            htmlVC.title = @"简介";
            [self.navigationController pushViewController:htmlVC animated:YES];
            
        }
        else if (indexPath.row == 2) {//声明
            
            HTMLViewController * htmlVC = [[HTMLViewController alloc] init];
            htmlVC.urlStr = @"Web/CustomerInfo/GroupInfo";
            htmlVC.title = @"声明";
            [self.navigationController pushViewController:htmlVC animated:YES];
            
        }
        else if (indexPath.row == 3) {
            //版本号
        }
        else if (indexPath.row == 4) {//意见反馈
            FeedbackVC * htmlVC = [[FeedbackVC alloc] init];
            [self.navigationController pushViewController:htmlVC animated:YES];
        }
        else if (indexPath.row == 5) {//客服中心
             [Utils makeCallWithPhoneNum:@"4006937369" target:self];
        }
    }
    else {
        switch (indexPath.row) {
        case 0:
            {
                [self logOut];
            }
            break;
        default:
            break;
        }
    }
}

#pragma mark - 退出登录
-(void)logOut {
    ZFActionSheet *actionSheet = [ZFActionSheet actionSheetWithTitle:@"退出后不会删除任何历史数据，下次登录依然可以使用本账号" confirms:@[@"退出登录"] cancel:@"取消" style:ZFActionSheetStyleDestructive];
    actionSheet.delegate = self;
    [actionSheet showInView:self.view.window];
    return;
}

#pragma mark - ZFActionSheetDelegate
- (void)clickAction:(ZFActionSheet *)actionSheet atIndex:(NSUInteger)index {
    
    [UserInfo removeAccessToken];//移除token
    [UserInfo removeDevIdentity];//移除单点登录
    
    NSUserDf_Set(kNoLogin,JRIsLogin);//修改登录状态
    NSUserDf_Remove(kDoctor);//移除是否是医师信息
    
//    NSUserDf_Remove(kUserPic);//移除用户头像地址
    
//    NSUserDf_Remove(kHXName);//移除环信用户名
//    NSUserDf_Remove(kHXPwd);//移除环信密码
    EMError *error = [[EMClient sharedClient] logout:YES];
    if (!error) {
        NSLog(@"环信退出成功");
    }
    NSUserDf_Set(nil, kHXName);
    NSUserDf_Set(nil, kHXPwd);
    
    [UserInfo removeUserInfo];//移除用户信息
    
    [self showLoadding:@"" time:1];

    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self.hud hide:YES];
        JRLoginViewController *loginVC = [[JRLoginViewController alloc] init];
        loginVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:loginVC animated:YES completion:nil];
    });
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = BG_Color;
        [_tableView registerClass:[XBSettingCell class] forCellReuseIdentifier:NSStringFromClass([XBSettingCell class])];
    }
    return  _tableView;
}

//获取当前软件版本
- (NSString *)getCurrentAppVersion {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return app_Version;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
