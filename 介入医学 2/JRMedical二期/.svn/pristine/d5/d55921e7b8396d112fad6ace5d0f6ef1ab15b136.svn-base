//
//  FriendViewController.m
//  JRMedical
//
//  Created by ww on 2016/12/13.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "FriendViewController.h"

#import "ChatViewController.h"
#import "AddFriendViewController.h"
#import "ApplyViewController.h"
#import "EMSearchBar.h"
#import "EMSearchDisplayController.h"
#import "RealtimeSearchUtil.h"
#import "BlackListViewController.h"
#import "BlackListModel.h"
#import "JRLoginViewController.h"

@interface FriendViewController ()<UISearchBarDelegate,UISearchDisplayDelegate,BaseTableCellDelegate,UIActionSheetDelegate,EaseUserCellDelegate>

{
    NSIndexPath *_currentLongPressIndex;
}

@property (strong, nonatomic) NSMutableArray *sectionTitles;
@property (strong, nonatomic) NSMutableArray *contactsSource;

@property (nonatomic) NSInteger unapplyCount;
@property (strong, nonatomic) EMSearchBar *searchBar;

@property (strong, nonatomic) EMSearchDisplayController *searchController;

@property (nonatomic, strong) NSString *username;

@property (nonatomic, strong) NSMutableArray *hxidArray;
@property (nonatomic, strong) NSMutableArray *imageArray;

@property (nonatomic, strong) NSMutableArray *jiaArray;


@end

@implementation FriendViewController

- (NSMutableArray *)jiaArray {
    if (_jiaArray == nil) {
        self.jiaArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _jiaArray;
}

- (NSMutableArray *)hxidArray {
    if (_hxidArray == nil) {
        self.hxidArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _hxidArray;
}


- (NSMutableArray *)imageArray {
    if (_imageArray == nil) {
        self.imageArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _imageArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showRefreshHeader = YES;
    
    _contactsSource = [NSMutableArray array];
    _sectionTitles = [NSMutableArray array];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 113, 0);
    self.tableView.sectionIndexBackgroundColor = RGBA(255, 255, 255, 0.1);
    
    [self searchController];

    UIView *headView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, Width_Screen, 44))];
    self.tableView.tableHeaderView = headView;
    [headView addSubview:self.searchBar];
    
//    aboutBlackListRefreshAction
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataSource) name:@"aboutBlackListRefreshAction" object:nil];

}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"好友列表界面");
    
    [super viewWillAppear:animated];
    
    [self reloadApplyView];
    
}

// 添加好友
- (void)addFriendsAction:(UIBarButtonItem *)sender {
    NSLog(@"添加好友");
    AddFriendViewController *addVC = [[AddFriendViewController alloc]init];
    [self.navigationController pushViewController:addVC animated:YES];
}

#pragma mark - getter

- (NSArray *)rightItems
{
    if (_rightItems == nil) {
        UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [addButton setImage:[UIImage imageNamed:@"addContact.png"] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(addContactAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
        _rightItems = @[addItem];
    }
    
    return _rightItems;
}

- (UISearchBar *)searchBar
{
    if (_searchBar == nil) {
        _searchBar = [[EMSearchBar alloc] initWithFrame:CGRectMake(0, 0, Width_Screen, 44)];
        _searchBar.delegate = self;
        _searchBar.placeholder = NSLocalizedString(@"search", @"Search");
        _searchBar.backgroundColor = [UIColor colorWithRed:0.747 green:0.756 blue:0.751 alpha:1.000];
    }
    
    return _searchBar;
}

- (EMSearchDisplayController *)searchController
{
    if (_searchController == nil) {
        _searchController = [[EMSearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        _searchController.delegate = self;
        _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        __weak FriendViewController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            static NSString *CellIdentifier = @"ContactListCell";
            BaseTableViewCell *cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            // Configure the cell...
            if (cell == nil) {
                cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            NSString *buddy = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            NSString *imageurl = [weakSelf.imageArray objectAtIndex:indexPath.row];
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageurl] placeholderImage:[UIImage imageNamed:@"chatListCellHead"]];
            
            
            cell.textLabel.text = buddy;
            cell.username = buddy;
            
            return cell;
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return 50;
        }];
        
        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            NSString *buddy = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            NSString *hxid = [weakSelf.hxidArray objectAtIndex:indexPath.row];
            
            NSString *loginUsername = [[EMClient sharedClient] currentUsername];
            
            if (loginUsername && loginUsername.length > 0) {
                if ([loginUsername isEqualToString:buddy]) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"friend.notChatSelf", @"can't talk to yourself") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
                    [alertView show];
                    
                    return;
                }
            }
            
            [weakSelf.searchController.searchBar endEditing:YES];
            

           ChatViewController *chatVC = [[ChatViewController alloc] initWithConversationChatter:hxid conversationType:EMConversationTypeChat];
           
           chatVC.title = buddy;
           chatVC.userid = hxid;
//           chatVC.moneyStr = @"官方提醒：当前处于免费聊天模式！";
           [weakSelf.navigationController pushViewController:chatVC animated:YES];
           }];
        }
         
    return _searchController;
}

/**
 *  获取用户昵称
 */

- (void)getUSerMessageWith:(NSString *)str {
    //  /IM/GetCustomerInfoByID
    NSString *urlS = [NSString stringWithFormat:@"%@api/IM/GetCustomerInfoByID", Server_Int_Url];
    NSString *dataS = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@ZICBDYCID=%@", kPrefixPara, kDevIdentity, kDevSysInfo, kDevTypeInfo, kIMEI, str, nil];
    NSString *dataEncrpyt = [TWDes encryptWithContent:dataS type:kDesType key:kDesKey];
    NSString *token = [UserInfo getAccessToken];
    NSDictionary *paraDic = @{kToken:token, kDatas:dataEncrpyt};
    
    [AFManegerHelp POST:urlS parameters:paraDic success:^(id responseObjeck) {
        
        NSLog(@"FriendViewController - 获取用户昵称 - %@", responseObjeck);
        
        if ([responseObjeck[@"Success"] integerValue] == 1) {
            
            NSArray *array = responseObjeck[@"JsonData"];
            for (NSDictionary *d in array) {

               ChatViewController *chatController = [[ChatViewController alloc]
                                                     initWithConversationChatter:str conversationType:EMConversationTypeChat];

               chatController.title = d[@"CustomerName"];
               chatController.userid = str;
//               chatController.moneyStr = @"官方提醒：我不是付费用户！";
               [self.navigationController pushViewController:chatController animated:YES];
            }
            
        } else {
            
            [self showHint:responseObjeck[@"Msg"]];
            if ([responseObjeck[@"Code"] integerValue] == 3) {
                
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
        NSLog(@"%@", error.description);
    }];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.dataArray count] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 2;
    } else {
        NSArray *arr = [self.dataArray objectAtIndex:(section - 1)];
        return arr.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NSString *CellIdentifier = @"addFriend";
            EaseUserCell *cell = (EaseUserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[EaseUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.avatarView.image = [UIImage imageNamed:@"newFriends"];
            cell.titleLabel.text = NSLocalizedString(@"title.apply", @"Application and notification");
            cell.avatarView.badge = self.unapplyCount;
            return cell;
        }
        
        NSString *CellIdentifier = @"commonCell";
        EaseUserCell *cell = (EaseUserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[EaseUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        if (indexPath.row == 1) { // 黑名单
            cell.avatarView.image = [UIImage imageNamed:@"heimingdan"];
            cell.titleLabel.text = NSLocalizedString(@"title.buddyBlock", @"black list");
        }
        else if (indexPath.row == 2) {
            cell.avatarView.image = [UIImage imageNamed:@"EaseUIResource.bundle/group"];
            cell.titleLabel.text = NSLocalizedString(@"title.chatroomlist",@"chatroom list");
        }
        else if (indexPath.row == 3) {
            cell.avatarView.image = [UIImage imageNamed:@"EaseUIResource.bundle/group"];
            cell.titleLabel.text = NSLocalizedString(@"title.robotlist",@"robot list");
        }
        return cell;
    }
    else{
        NSString *CellIdentifier = [EaseUserCell cellIdentifierWithModel:nil];
        
        EaseUserCell *cell = (EaseUserCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        // Configure the cell...
        if (cell == nil) {
            cell = [[EaseUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        NSArray *userSection = [self.dataArray objectAtIndex:(indexPath.section - 1)];
        EaseUserModel *model = [userSection objectAtIndex:indexPath.row];
        cell.indexPath = indexPath;
        cell.delegate = self;
        cell.model = model;
        
        
        return cell;
    }
}

#pragma mark - Table view delegate

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sectionTitles;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    else{
        return 22;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return nil;
    }
    
    NSLog(@"self.sectionTitles - %@", self.sectionTitles);
    
    if (self.sectionTitles.count > 0) {
        UIView *contentView = [[UIView alloc] init];
        [contentView setBackgroundColor:[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0]];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 22)];
        label.backgroundColor = [UIColor clearColor];
        [label setText:[self.sectionTitles objectAtIndex:(section - 1)]];
        [contentView addSubview:label];
        return contentView;
    } else {
        return nil;
    }
    
    
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        if (row == 0) {
            [self.navigationController pushViewController:[ApplyViewController shareController] animated:YES];
        }
        else if (row == 1)
        {
            // 群组
//            GroupListViewController *groupController = [[GroupListViewController alloc] initWithStyle:UITableViewStylePlain];
//            [self.navigationController pushViewController:groupController animated:YES];
            // 我的黑名单
            BlackListViewController *blacklistVC = [[BlackListViewController alloc] init];
            [self.navigationController pushViewController:blacklistVC animated:YES];
        }
    }
    else{
        EaseUserModel *model = [[self.dataArray objectAtIndex:(section - 1)] objectAtIndex:row];
        NSString *loginUsername = [[EMClient sharedClient] currentUsername];
        if (loginUsername && loginUsername.length > 0) {
            if ([loginUsername isEqualToString:model.buddy]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"friend.notChatSelf", @"can't talk to yourself") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
                [alertView show];
                
                return;
            }
        }
        [self getUSerMessageWith:model.buddy];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if (indexPath.section == 0) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *loginUsername = [[EMClient sharedClient] currentUsername];
        EaseUserModel *model = [[self.dataArray objectAtIndex:(indexPath.section - 1)] objectAtIndex:indexPath.row];
        
        if ([model.buddy isEqualToString:loginUsername]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"friend.notDeleteSelf", @"can't delete self") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
            [alertView show];
            
            return;
        }
        
        EMError *error = [[EMClient sharedClient].contactManager deleteContact:model.buddy isDeleteConversation:YES];
        if (!error) {
            [[EMClient sharedClient].chatManager deleteConversation:model.buddy isDeleteMessages:YES completion:nil];
            [tableView beginUpdates];
            [[self.dataArray objectAtIndex:(indexPath.section - 1)] removeObjectAtIndex:indexPath.row];
            [self.contactsSource removeObject:model.buddy];
            [tableView  deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView endUpdates];
        }
        else{
            [self showHint:[NSString stringWithFormat:NSLocalizedString(@"deleteFailed", @"Delete failed:%@"), error.errorDescription]];
            [tableView reloadData];
        }
    }
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    
    [self.searchController.resultsSource removeAllObjects];
    [self.hxidArray removeAllObjects];
    [self.imageArray removeAllObjects];
    [self.searchController.searchResultsTableView reloadData];
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
}

// 搜索列表联系人
- (void)getFrendsByString:(NSString *)string {
    __weak typeof(self) weakSelf = self;
    
    
    NSString *urlS = [NSString stringWithFormat:@"%@api/IM/GetFriendsList", Server_Int_Url];
    NSString *dataS = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@ZICBDYCkey=%@", kPrefixPara, kDevIdentity, kDevSysInfo, kDevTypeInfo, kIMEI, string, nil];
    NSString *dataEncrpyt = [TWDes encryptWithContent:dataS type:kDesType key:kDesKey];
    NSString *token = [UserInfo getAccessToken];
    NSDictionary *paraDic = @{kToken:token, kDatas:dataEncrpyt};
    
    [AFManegerHelp POST:urlS parameters:paraDic success:^(id responseObjeck) {
        NSLog(@"GetFriendsList - %@", responseObjeck);
        
        if ([responseObjeck[@"Success"] integerValue] == 1) {
            
            NSArray *array = responseObjeck[@"JsonData"];
            for (NSDictionary *d in array) {
                NSString *name = d[@"NickName"];
                if (name.length > 0) {
                    [weakSelf.searchController.resultsSource addObject:d[@"NickName"]];
                } else {
                    [weakSelf.searchController.resultsSource addObject:d[@"CustomerName"]];
                }
                [weakSelf.hxidArray addObject:d[@"ID"]];
                [weakSelf.imageArray addObject:d[@"UserPic"]];
                dispatch_async(dispatch_get_main_queue(), ^{

                    [weakSelf.searchController.searchResultsTableView reloadData];
                    
                });
            }
            
        } else {
            [AFManegerHelp Hud:responseObjeck[@"Msg"] Delay:1];
        }
    
    } failure:^(NSError *error) {
         NSLog(@"%@", error.description);
    }];
}




- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self getFrendsByString:searchBar.text];
    
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    
    NSLog(@"点击了取消搜索");
    [[RealtimeSearchUtil currentUtil] realtimeSearchStop];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark - BaseTableCellDelegate

- (void)cellImageViewLongPressAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row >= 1) {
        // 群组，聊天室
        return;
    }
    NSString *loginUsername = [[EMClient sharedClient] currentUsername];
    EaseUserModel *model = [[self.dataArray objectAtIndex:(indexPath.section - 1)] objectAtIndex:indexPath.row];
    if ([model.buddy isEqualToString:loginUsername])
    {
        return;
    }
    
    _currentLongPressIndex = indexPath;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel") destructiveButtonTitle:NSLocalizedString(@"friend.block", @"join the blacklist") otherButtonTitles:nil, nil];
    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
}

#pragma mark - action

- (void)addContactAction
{
    AddFriendViewController *addController = [[AddFriendViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:addController animated:YES];
}

#pragma mark - private data

- (void)_sortDataArray:(NSArray *)buddyList
{
    [self.dataArray removeAllObjects];
    [self.sectionTitles removeAllObjects];
    NSMutableArray *contactsSource = [NSMutableArray array];
    
    //从获取的数据中剔除黑名单中的好友
    NSArray *blockList = [[EMClient sharedClient].contactManager getBlackList];
    for (NSString *buddy in buddyList) {
        if (![blockList containsObject:buddy]) {
            [contactsSource addObject:buddy];
        }
    }
    
    NSString *collectStr = [contactsSource componentsJoinedByString:@","];
    NSString *urlS = [NSString stringWithFormat:@"%@/api/IM/GetCustomerInfoByID", Server_Int_Url];
    NSString *dataS = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@ZICBDYCID=%@", kPrefixPara, kDevIdentity, kDevSysInfo, kDevTypeInfo, kIMEI, collectStr, nil];
    NSString *dataEncrpyt = [TWDes encryptWithContent:dataS type:kDesType key:kDesKey];
    NSString *token = [UserInfo getAccessToken];
    NSDictionary *paraDic = @{kToken:token, kDatas:dataEncrpyt};
    [AFManegerHelp POST:urlS parameters:paraDic success:^(id responseObjeck) {
        [self.jiaArray removeAllObjects];
        NSLog(@"blackList - GetCustomerInfoByID - %@", responseObjeck);
        if ([responseObjeck[@"Success"] integerValue] == 1) {
            
            [self hideHud];
            
            NSArray *array = responseObjeck[@"JsonData"];
            for (NSDictionary *dic in array) {
                BlackListModel *model = [[BlackListModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.jiaArray addObject:model];
            }
            
            //建立索引的核心, 返回27，是a－z和＃
            UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
            [self.sectionTitles addObjectsFromArray:[indexCollation sectionTitles]];
            
            NSInteger highSection = [self.sectionTitles count];
            NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
            for (int i = 0; i < highSection; i++) {
                NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
                [sortedArray addObject:sectionArray];
            }
            
            //按首字母分组
            for (BlackListModel *listmodel in self.jiaArray) {
                EaseUserModel *model = [[EaseUserModel alloc] initWithBlackListModel:listmodel];
                if (model) {
                    NSString *firstLetter = [EaseChineseToPinyin pinyinFromChineseString:model.nickname];
                    NSInteger section;
                    if (firstLetter.length > 0) {
                        section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
                    } else {
                        section = [sortedArray count] - 1;
                    }
                    NSMutableArray *array = [sortedArray objectAtIndex:section];
                    [array addObject:model];
                }
            }
            
            //每个section内的数组排序
            for (int i = 0; i < [sortedArray count]; i++) {
                NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(EaseUserModel *obj1, EaseUserModel *obj2) {
                    NSString *firstLetter1 = [EaseChineseToPinyin pinyinFromChineseString:obj1.nickname];
                    NSLog(@"obj1.nickname - %@", obj1.nickname);
                    firstLetter1 = [[firstLetter1 substringToIndex:1] uppercaseString];
                    
                    NSString *firstLetter2 = [EaseChineseToPinyin pinyinFromChineseString:obj2.nickname];
                    firstLetter2 = [[firstLetter2 substringToIndex:1] uppercaseString];
                    
                    return [firstLetter1 caseInsensitiveCompare:firstLetter2];
                }];
                
                
                [sortedArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
            }
            
            //去掉空的section
            for (NSInteger i = [sortedArray count] - 1; i >= 0; i--) {
                NSArray *array = [sortedArray objectAtIndex:i];
                if ([array count] == 0) {
                    [sortedArray removeObjectAtIndex:i];
                    [self.sectionTitles removeObjectAtIndex:i];
                }
            }
            
            [self.dataArray addObjectsFromArray:sortedArray];
            [self.tableView reloadData];
            
        } else {
            [self hideHud];
            [self showHint:responseObjeck[@"Msg"]];
        }
    } failure:^(NSError *error) {
        [self hideHud];
        [self showHint:@"服务器出错"];
        NSLog(@"cuowu%@", error);
    }];
    
    [self.tableView reloadData];
    

}

#pragma mark - EaseUserCellDelegate

- (void)cellLongPressAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row >= 1) {
        // 群组，聊天室
        return;
    }
    NSString *loginUsername = [[EMClient sharedClient] currentUsername];
    EaseUserModel *model = [[self.dataArray objectAtIndex:(indexPath.section - 1)] objectAtIndex:indexPath.row];
    if ([model.buddy isEqualToString:loginUsername])
    {
        return;
    }
    
    _currentLongPressIndex = indexPath;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel") destructiveButtonTitle:NSLocalizedString(@"friend.block", @"join the blacklist") otherButtonTitles:nil, nil];
    [actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex && _currentLongPressIndex) {
        EaseUserModel *model = [[self.dataArray objectAtIndex:(_currentLongPressIndex.section - 1)] objectAtIndex:_currentLongPressIndex.row];
        [self showHudInView:self.view hint:NSLocalizedString(@"wait", @"Pleae wait...")];
        
        EMError *error = [[EMClient sharedClient].contactManager addUserToBlackList:model.buddy relationshipBoth:YES];
        if (!error) {
            //由于加入黑名单成功后会刷新黑名单，所以此处不需要再更改好友列表
            [self reloadDataSource];
        }
        else {
            [self showHint:error.errorDescription];
        }
        [self hideHud];
    }
    _currentLongPressIndex = nil;
}

#pragma mark - data

- (void)tableViewDidTriggerHeaderRefresh
{
    [self showHudInView:self.view hint:NSLocalizedString(@"loadData", @"Load data...")];
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError *error = nil;
        NSArray *buddyList = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
        if (!error) {
            [[EMClient sharedClient].contactManager getBlackListFromServerWithError:&error];
            if (!error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakself.contactsSource removeAllObjects];
                    
                    for (NSInteger i = (buddyList.count - 1); i >= 0; i--) {
                        NSString *username = [buddyList objectAtIndex:i];
                        [weakself.contactsSource addObject:username];
                    }
                    
                    NSString *loginUsername = [[EMClient sharedClient] currentUsername];
                    if (loginUsername && loginUsername.length > 0) {
                        [weakself.contactsSource addObject:loginUsername];
                    }
                    [weakself _sortDataArray:self.contactsSource];
                });
            }
        }
        if (error) {
            [self hideHud];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself showHint:NSLocalizedString(@"帐号已在其它设备登录!", @"Load data failed.")];
                [weakself reloadDataSource];
                
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
                
            });
        }
        [weakself tableViewDidFinishTriggerHeader:YES reload:NO];
    });
}

#pragma mark - public

- (void)reloadDataSource
{
    [self.dataArray removeAllObjects];
    [self.contactsSource removeAllObjects];
    
    NSArray *buddyList = [[EMClient sharedClient].contactManager getContacts];
    for (NSString *buddy in buddyList) {
        [self.contactsSource addObject:buddy];
    }
    
    NSString *loginUsername = [[EMClient sharedClient] currentUsername];
    if (loginUsername && loginUsername.length > 0) {
        [self.contactsSource addObject:loginUsername];
    }
    
    [self _sortDataArray:self.contactsSource];
    
    [self.tableView reloadData];
}

- (void)reloadApplyView
{
    NSInteger count = [[[ApplyViewController shareController] dataSource] count];
    self.unapplyCount = count;
    [self.tableView reloadData];
}

- (void)reloadGroupView
{
    [self reloadApplyView];
    
    if (_groupController) {
        [_groupController reloadDataSource];
    }
}

- (void)addFriendAction
{
    AddFriendViewController *addController = [[AddFriendViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:addController animated:YES];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
