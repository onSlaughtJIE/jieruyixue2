//
//  CaseLibraryVC.m
//  JRMedical
//
//  Created by a on 16/11/14.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "CaseLibraryVC.h"

#import "AddCaseVC.h"
#import "CaseLibraryCell.h"
#import "CaseLibraryModel.h"
#import "CaseLibraryDetailVC.h"

#import "UITableView+EmpayData.h"

#import "JRLoginViewController.h"

@interface CaseLibraryVC ()<UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray *thumImgs;//缩略图集合
@property (nonatomic, strong) NSMutableArray *hdImgs;//高清图集合
@property (nonatomic, strong) NSMutableArray *rTypes;//图片类型集合

@end

@implementation CaseLibraryVC {
    
    NSInteger _curRow;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"addCaseLibraryNotification" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"病例库";
    
    self.thumImgs = [NSMutableArray arrayWithCapacity:0];//缩略图集合
    self.hdImgs = [NSMutableArray arrayWithCapacity:0];//高清图集合
    self.rTypes = [NSMutableArray arrayWithCapacity:0];//图片类型集合
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加病例" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarButtonItemClick)];
    
    //发布后的 刷新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCaseLibraryNotificationClick) name:@"addCaseLibraryNotification" object:nil];
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
    self.tableView.backgroundColor = BG_Color;
    [self.tableView registerClass:[CaseLibraryCell class] forCellReuseIdentifier:NSStringFromClass([CaseLibraryCell class])];
    
    [self showLoadding:@"正在加载" time:20];
    [self requestListDataArrray];
}

#pragma mark - 添加病例后刷新
- (void)addCaseLibraryNotificationClick {
    self.isStartRefresh = YES;
    [self requestListDataArrray];
}

#pragma mark - 请求数据列表
- (void)requestListDataArrray {
    NSString *url = @"api/Customer/CustomerCaseLst";
    NSString *params = @"";
    [self loadDataApi:url withParams:params refresh:RefreshTypeBoth model:CaseLibraryModel.class];
}

#pragma mark - 添加病例
- (void)rightBarButtonItemClick {
    AddCaseVC *aCaseVC = [AddCaseVC new];
    [self.navigationController pushViewController:aCaseVC animated:YES];
}

#pragma mark - Table view datasource and delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataSource == nil) {
        [tableView tableViewDisplayWitMsg:@"" ifNecessaryForRowCount:self.dataSource.count];
    }
    else {
        [tableView tableViewDisplayWitMsg:@"暂无相关病例信息!" ifNecessaryForRowCount:self.dataSource.count];
        
        if (self.dataSource.count > 0) {
            
            [self.thumImgs removeAllObjects];
            [self.hdImgs removeAllObjects];
            [self.rTypes removeAllObjects];
            
            //遍历数据源,取出并单独存储每条数据的  缩略图 高清图 和  视频地址  //视频地址 和 图片高清图 是 公用一个Url
            for (CaseLibraryModel *model  in self.dataSource) {
                
                NSMutableArray *tImgAry = [NSMutableArray arrayWithCapacity:0];
                NSMutableArray *hImgAry = [NSMutableArray arrayWithCapacity:0];
                NSMutableArray *rTypeAry = [NSMutableArray arrayWithCapacity:0];
                
                //如果没有发表图片视频信息 则 不存储
                if (model.List.count > 0) {
                    for (NSDictionary *data in model.List) {
                        
                        [rTypeAry addObject:data[@"RType"]];
                        
                        if ([data[@"RType"] integerValue] == 1) {
                            [tImgAry addObject:data[@"VideoPic"]];//如果是 视频类型 则 缩略图数组 储存 视频的图片
                            [hImgAry addObject:data[@"Uri"]];//将公用的Url储存到视频连接数组去
                        }
                        else {
                            [tImgAry addObject:data[@"ThumImg"]];//如果是 图片类型 则 缩略图数组 储存 图片缩略图片
                            [hImgAry addObject:data[@"Uri"]];//将公用的Url储存到图片高清图数组去
                        }
                    }
                }
                [self.thumImgs addObject:tImgAry];//存储遍历过来的缩略图片
                [self.hdImgs addObject:hImgAry];//存储遍历过来的高清图片
                [self.rTypes addObject:rTypeAry];//存储每个 视频 还是 图片 的类型
            }
        }
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CaseLibraryModel *model = self.dataSource[indexPath.row];
    CaseLibraryCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CaseLibraryCell class]) forIndexPath:indexPath];
    [cell setModel:model];
    
    [cell.seleBtn bk_whenTapped:^{
        
        _curRow = indexPath.row;
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"删除病例"
                                                            message:@"您确认要删除这条病例么?"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确认",nil];
        [alertView show];
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001;
}

#pragma mark  点击cell的响应的代理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CaseLibraryModel *model = self.dataSource[indexPath.row];
    NSArray *thumImgArray = self.thumImgs[indexPath.row];
    NSArray *hdImgArray = self.hdImgs[indexPath.row];
    NSArray *rTypeArray = self.rTypes[indexPath.row];
    
    CaseLibraryDetailVC *cldVC = [CaseLibraryDetailVC new];
    cldVC.model = model;
    cldVC.picUrlArray = thumImgArray;
    cldVC.picOriArray = hdImgArray;
    cldVC.rTypeArray = rTypeArray;
    [self.navigationController pushViewController:cldVC animated:YES];
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        CaseLibraryModel *model = [self.dataSource objectAtIndex:_curRow];
        
        NSString *params = [NSString stringWithFormat:@"ZICBDYCCaseID=%@",model.CaseID];
        NSString *url = @"api/Customer/DelCustomerCase";
        
        [self showLoadding:@"" time:20];
        
        [BaseNetwork postLoadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
            [self.hud hide:YES];
            NSLog(@"删除 - %@", modelData);
            if (isSuccess) {
                // //左滑删除
                [self.dataSource removeObjectAtIndex:_curRow];
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
