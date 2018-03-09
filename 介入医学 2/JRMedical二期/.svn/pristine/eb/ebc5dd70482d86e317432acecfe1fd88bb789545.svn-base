//
//  MyAddressVC.m
//  JRMedical
//
//  Created by a on 16/12/16.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "MyAddressVC.h"
#import "ChooseAddressTableViewCell.h"
#import "UITableView+EmpayData.h"
#import "MyAddressModel.h"
#import "AddNewAddressVC.h"

#import <YYKit.h>

#import "JRLoginViewController.h"

@interface MyAddressVC ()<UIAlertViewDelegate,ChooseAddressTableViewCellDelegate>

@property(nonatomic,strong)NSIndexPath *selectedIndexPath;//当前选中的NSIndexPath

@end

@implementation MyAddressVC {
    
    NSInteger _section;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"addReceiptAddress" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的地址";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"新增" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarButtonItemClick)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addReceiptAddressClick) name:@"addReceiptAddress" object:nil];
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
    self.tableView.backgroundColor = BG_Color;
    [self.tableView registerClass:[ChooseAddressTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ChooseAddressTableViewCell class])];
    
    [self getMyAddressData];
}

#pragma mark - ChooseAddressTableViewCellDelegate
- (void)selectRowDelectClick:(NSIndexPath *)indexPath {
    
    //取消上一次选定状态
    ChooseAddressTableViewCell *oldCell =  [self.tableView cellForRowAtIndexPath:_selectedIndexPath];
    oldCell.moRenAddBtn.selected = NO;
    //勾选当前选定状态
    ChooseAddressTableViewCell *newCell =  [self.tableView cellForRowAtIndexPath:indexPath];
    newCell.moRenAddBtn.selected = YES;
    //保存
    self.selectedIndexPath = indexPath;
    
    MyAddressModel *model = self.dataSource[indexPath.section];
    
    NSString *url = @"api/MallsInfo/SetDefaultAddress";
    NSString *params = [NSString stringWithFormat:@"ZICBDYCID=%@",model.ID];
    [self showLoadding:@"" time:20];
    [BaseNetwork postLoadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"默认地址 - %@",modelData);
        if (isSuccess) {
            [self showMessage:@"设置成功"];
        }
        else {
            if (code == 999) {
                [self showMessage:@"服务器开小差了~请稍后再试"];
                return ;
            }
            NSString *msg  = [modelData objectForKey:@"Msg"];
            if (msg!=nil && ![msg isEqual:@""]) {
                [self showMessage:msg];
                if (code == 3) {
                    
                    [UserInfo removeAccessToken];//移除token
                    [UserInfo removeDevIdentity];//移除单点登录
                    NSUserDf_Set(kNoLogin,JRIsLogin);//修改登录状态
                    NSUserDf_Remove(kDoctor);//移除是否是医师信息
                    [UserInfo removeUserInfo];//移除用户信息
                    EMError *error = [[EMClient sharedClient] logout:YES];
                    if (!error) {
                        NSLog(@"环信退出成功");
                    }
                    NSUserDf_Set(nil, kHXName);
                    NSUserDf_Set(nil, kHXPwd);
                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5/*延迟执行时间*/ * NSEC_PER_SEC));
                    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                        JRLoginViewController *loginVC = [[JRLoginViewController alloc] init];
                        loginVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                        [self presentViewController:loginVC animated:YES completion:nil];
                    });
                    
                    return ;
                }
            }
            else{
                [self showMessage:[NSString stringWithFormat:@"请求失败 #%d",code]];
            }
        }
    }];
}

#pragma mark - 添加修改新地址刷新
- (void)addReceiptAddressClick {
    [self getMyAddressData];
}

#pragma mark - 新增地址
- (void)rightBarButtonItemClick {
    AddNewAddressVC *addNewAddVC = [AddNewAddressVC new];
    [self.navigationController pushViewController:addNewAddVC animated:YES];
}

#pragma mark - Table view datasource and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.dataSource == nil) {
        [tableView tableViewDisplayWitMsg:@"" ifNecessaryForRowCount:self.dataSource.count];
    }
    else {
        [tableView tableViewDisplayWitMsg:@"您还没有添加任何地址信息哦!" ifNecessaryForRowCount:self.dataSource.count];
    }
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyAddressModel *model = self.dataSource[indexPath.section];
    
    ChooseAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ChooseAddressTableViewCell class]) forIndexPath:indexPath];
    
    cell.delegate = self;
    
    [cell setIndexPath:indexPath];
    
    [cell setModel:model];
    
    if (model.IsDefault) {
        _selectedIndexPath = indexPath;
    }
    
    //编辑
    [cell.bianJiBtn bk_whenTapped:^{
        AddNewAddressVC *addNewAddVC = [AddNewAddressVC new];
        addNewAddVC.from = 1000;
        addNewAddVC.model = model;
        [self.navigationController pushViewController:addNewAddVC animated:YES];
    }];
    
    //删除
    [cell.deleBtn bk_whenTapped:^{
        
        _section = indexPath.section;
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确认删除"
                                                            message:@"您确认要删除这条地址么?"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确认",nil];
        [alertView show];
        
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 128.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.from == 1000) {//返回详情页
        MyAddressModel *model = self.dataSource[indexPath.section];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
        [dic setObject:model forKey:@"myAddressModel"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectMyAddress" object:nil userInfo:dic];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (self.from == 2000) {//返回订单填写页
        MyAddressModel *model = self.dataSource[indexPath.section];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
        [dic setObject:model forKey:@"myAddressModel"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectMyAddress" object:nil userInfo:dic];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self shanChuAddress:_section];
    }
}

#pragma mark - 删除地址
- (void)shanChuAddress:(NSInteger)section {
    NSLog(@"-------------%ld",section);
    
    MyAddressModel *mode = self.dataSource[section];
    
    NSString *url = @"api/MallsInfo/DeleteReceiptAddress";
    NSString *params = [NSString stringWithFormat:@"ZICBDYCID=%@",mode.ID];
    [self showLoadding:@"" time:20];
    [BaseNetwork postLoadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        
        NSLog(@"删除地址 - %@",modelData);
        if (isSuccess) {
            [self.dataSource removeObjectAtIndex:section];
            [self.tableView reloadData];
        }
        else {
            if (code == 999) {
                [self showMessage:@"服务器开小差了~请稍后再试"];
                return ;
            }
            NSString *msg  = [modelData objectForKey:@"Msg"];
            if (msg!=nil && ![msg isEqual:@""]) {
                [self showMessage:msg];
                if (code == 3) {
                    
                    [UserInfo removeAccessToken];//移除token
                    [UserInfo removeDevIdentity];//移除单点登录
                    NSUserDf_Set(kNoLogin,JRIsLogin);//修改登录状态
                    NSUserDf_Remove(kDoctor);//移除是否是医师信息
                    [UserInfo removeUserInfo];//移除用户信息
                    EMError *error = [[EMClient sharedClient] logout:YES];
                    if (!error) {
                        NSLog(@"环信退出成功");
                    }
                    NSUserDf_Set(nil, kHXName);
                    NSUserDf_Set(nil, kHXPwd);
                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5/*延迟执行时间*/ * NSEC_PER_SEC));
                    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                        JRLoginViewController *loginVC = [[JRLoginViewController alloc] init];
                        loginVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                        [self presentViewController:loginVC animated:YES completion:nil];
                    });
                    
                    return ;
                }
            }
            else{
                [self showMessage:[NSString stringWithFormat:@"请求失败 #%d",code]];
            }
        }
    }];
}

#pragma mark - 获取我的地址
- (void)getMyAddressData {
    
    NSString *params = [NSString stringWithFormat:@"ZICBDYCOpeType=%@",@"All"];
    NSString *url = @"api/MallsInfo/ReceiptAddressLst";
    [self showLoadding:@"正在加载" time:20];
    [self loadDataApi:url withParams:params refresh:RefreshTypeBoth model:MyAddressModel.class];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
