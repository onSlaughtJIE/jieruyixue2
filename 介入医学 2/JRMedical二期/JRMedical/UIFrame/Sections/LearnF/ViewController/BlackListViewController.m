/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "BlackListViewController.h"

#import "BaseTableViewCell.h"
#import "SRRefreshView.h"
#import "BlackListModel.h"
#import "LearnFVC.h"
#import "FriendViewController.h"
#import "JRLoginViewController.h"

//#import "ChatDemoHelper.h"
//#import "EaseChineseToPinyin.h"

@interface BlackListViewController ()<UITableViewDataSource, UITableViewDelegate, SRRefreshDelegate>
{
    NSMutableArray *_dataSource;
}

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) SRRefreshView *slimeView;

@property (strong, nonatomic) NSMutableArray *nickDataSource;

@end

@implementation BlackListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _dataSource = [NSMutableArray array];
        _nickDataSource = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    self.title = NSLocalizedString(@"friend.black", @"Black List");
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    _slimeView = [[SRRefreshView alloc] init];
    _slimeView.delegate = self;
    _slimeView.upInset = 0;
    _slimeView.slimeMissWhenGoingBack = YES;
    _slimeView.slime.bodyColor = [UIColor grayColor];
    _slimeView.slime.skinColor = [UIColor grayColor];
    _slimeView.slime.lineWith = 1;
    _slimeView.slime.shadowBlur = 4;
    _slimeView.slime.shadowColor = [UIColor grayColor];
    [self.tableView addSubview:_slimeView];
    
    [self.slimeView setLoadingWithExpansion];
    
}

/**
 *  设置系统自带编辑按钮的响应
 */
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    _slimeView.delegate = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    BlackListModel *model = self.dataSource[indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.UserPic] placeholderImage:[UIImage imageNamed:@"chatListCellHead.png"]];
    cell.textLabel.text = model.CustomerName;
    cell.username = model.CustomerName;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        BlackListModel *model = self.dataSource[indexPath.row];
        NSString *username = model.ID;
        EMError *error = [[EMClient sharedClient].contactManager removeUserFromBlackList:username];
        if (!error)
        {
//            [[ChatDemoHelper shareHelper].contactViewVC reloadDataSource];
            // TODO: 这里需要对好友列表(FriendViewController)进行刷新
//            NSLog(@"%@", self.navigationController.viewControllers);
//            LearnFVC *mainVC = self.navigationController.viewControllers.firstObject;
//            NSLog(@"%@", mainVC.childViewControllers);
//            FriendViewController *friendVC = mainVC.childViewControllers[1];
//            [friendVC reloadDataSource];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"aboutBlackListRefreshAction" object:nil];
            // 操作当前数据源
            [self.dataSource removeObjectAtIndex:indexPath.row];
            [tableView reloadData];
        } else {
            [self showHint:error.errorDescription];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_slimeView scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_slimeView scrollViewDidEndDraging];
}

#pragma mark - slimeRefresh delegate
//刷新列表
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    [self reloadDataSource];
    [_slimeView endRefresh];
}

- (void)reloadDataSource
{
    
    [self showHudInView:self.view hint:NSLocalizedString(@"loadData", @"Load data...")];
    
    [self.dataSource removeAllObjects];
    [self.nickDataSource removeAllObjects];
    EMError *error = nil;
    NSArray *blocked = [[EMClient sharedClient].contactManager getBlackListFromServerWithError:&error];
    NSLog(@"blocked - %@", blocked);
    NSString *idCollectStr = @"";
    NSString *str = @"";
    for (NSString *idStr in blocked) {
        str = [idStr stringByAppendingString:@","];
        idCollectStr = [idCollectStr stringByAppendingString:str];
    }
    
    NSLog(@"idCollectStr - %@", idCollectStr);
    
    NSString *urlS = [NSString stringWithFormat:@"%@/api/IM/GetCustomerInfoByID", Server_Int_Url];
    NSString *dataS = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@ZICBDYCID=%@", kPrefixPara, kDevIdentity, kDevSysInfo, kDevTypeInfo, kIMEI, idCollectStr, nil];
    NSString *dataEncrpyt = [TWDes encryptWithContent:dataS type:kDesType key:kDesKey];
    NSString *token = [UserInfo getAccessToken];
    NSDictionary *paraDic = @{kToken:token, kDatas:dataEncrpyt};
    
    [AFManegerHelp POST:urlS parameters:paraDic success:^(id responseObjeck) {
        NSLog(@"blackList - GetCustomerInfoByID - %@", responseObjeck);
        if ([responseObjeck[@"Success"] integerValue] == 1) {
            
            [self hideHud];
            NSArray *array = responseObjeck[@"JsonData"];
            for (NSDictionary *dic in array) {
                BlackListModel *model = [[BlackListModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.nickDataSource addObject:model];
                
            }
            
            [self tableViewRefresh];

        } else {
            
            [self hideHud];
            
            if ([Utils isBlankString:idCollectStr]) {
                [self showHint:@"无黑名单信息" yOffset:-100];
            }
            
            if ([responseObjeck[@"Code"] integerValue] == 3) {
                
                [self showHint:responseObjeck[@"Msg"]];
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
        
    } failure:^(NSError *error) {
        [self hideHud];
        NSLog(@"cuowu%@", error);
    }];
        
    
    
    
}

- (void)tableViewRefresh {
    
    [self.dataSource addObjectsFromArray:self.nickDataSource];
    if (self.dataSource.count == 0) {
        UILabel *label = [[UILabel alloc]initWithFrame:(CGRectMake(0, 0, Width_Screen, 40))];
        label.text = @"无黑名单信息";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor lightGrayColor];
        self.tableView.backgroundView = label;
        
    }
    [self hideHud];
    [self.tableView reloadData];
    
}




@end
