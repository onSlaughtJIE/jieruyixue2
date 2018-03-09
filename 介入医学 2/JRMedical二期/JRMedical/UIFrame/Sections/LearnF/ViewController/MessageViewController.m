//
//  MessageViewController.m
//  JRMedical
//
//  Created by ww on 2016/12/13.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "MessageViewController.h"

#import "ChatViewController.h"
#import "EMSearchBar.h"
#import "EMSearchDisplayController.h"
#import "RealtimeSearchUtil.h"
#import "AddFriendViewController.h"

@implementation EMConversation (search)

//根据用户昵称,环信机器人名称,群名称进行搜索
- (NSString*)showName
{
    if (self.type == EMConversationTypeChat) {
        //        if ([[RobotManager sharedInstance] isRobotWithUsername:self.conversationId]) {
        //            return [[RobotManager sharedInstance] getRobotNickWithUsername:self.conversationId];
        //        }
        //        return [[UserProfileManager sharedInstance] getNickNameWithUsername:self.conversationId];
        return self.conversationId;
    } else if (self.type == EMConversationTypeGroupChat) {
        if ([self.ext objectForKey:@"subject"] || [self.ext objectForKey:@"isPublic"]) {
            return [self.ext objectForKey:@"subject"];
        }
    }
    return self.conversationId;
}

@end



@interface MessageViewController ()<EaseConversationListViewControllerDelegate, EaseConversationListViewControllerDataSource,UISearchDisplayDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UIView *networkStateView;
@property (nonatomic, strong) EMSearchBar *searchBar;
@property (strong, nonatomic) EMSearchDisplayController *searchController;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) ChatViewController *chatVC;

@end



@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 113, 0);
    
    UIView *headView = [[UIView alloc]initWithFrame:(CGRectMake(0, 0, Width_Screen, 44))];
    self.tableView.tableHeaderView = headView;
    [headView addSubview:self.searchBar];
    
    
    [self networkStateView];
    
    [self searchController];
    
    [self tableViewDidTriggerHeaderRefresh];
    
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSLog(@"conversations111--------%@", conversations);
    
    [self removeEmptyConversationsFromDB];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refresh];
}

// 添加好友
- (void)addFriendsAction:(UIBarButtonItem *)sender {
    NSLog(@"添加好友");
    AddFriendViewController *addVC = [[AddFriendViewController alloc]init];
    [self.navigationController pushViewController:addVC animated:YES];
}

- (void)removeEmptyConversationsFromDB
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSMutableArray *needRemoveConversations;
    for (EMConversation *conversation in conversations) {
        if (!conversation.latestMessage || (conversation.type == EMConversationTypeChatRoom)) {
            if (!needRemoveConversations) {
                needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
            }
            
            [needRemoveConversations addObject:conversation];
        }
    }
    
    if (needRemoveConversations && needRemoveConversations.count > 0) {
        [[EMClient sharedClient].chatManager deleteConversations:needRemoveConversations isDeleteMessages:YES completion:nil];
    }
}

#pragma mark - getter
- (UIView *)networkStateView
{
    if (_networkStateView == nil) {
        _networkStateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
        _networkStateView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:199 / 255.0 blue:199 / 255.0 alpha:0.5];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (_networkStateView.frame.size.height - 20) / 2, 20, 20)];
        imageView.image = [UIImage imageNamed:@"messageSendFail"];
        [_networkStateView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 5, 0, _networkStateView.frame.size.width - (CGRectGetMaxX(imageView.frame) + 15), _networkStateView.frame.size.height)];
        label.font = [UIFont systemFontOfSize:15.0];
        label.textColor = [UIColor grayColor];
        label.backgroundColor = [UIColor clearColor];
        label.text = NSLocalizedString(@"network.disconnection", @"Network disconnection");
        [_networkStateView addSubview:label];
    }
    
    return _networkStateView;
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[EMSearchBar alloc] initWithFrame: CGRectMake(0, 0, Width_Screen, 44)];
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
        _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _searchController.searchResultsTableView.tableFooterView = [[UIView alloc] init];
        
        __weak MessageViewController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            NSString *CellIdentifier = [EaseConversationCell cellIdentifierWithModel:nil];
            EaseConversationCell *cell = (EaseConversationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            // Configure the cell...
            if (cell == nil) {
                cell = [[EaseConversationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            id<IConversationModel> model = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            cell.model = model;
            
            cell.detailLabel.text = (NSString *)[weakSelf conversationListViewController:weakSelf latestMessageTitleForConversationModel:model]; // motify jia
            cell.timeLabel.text = [weakSelf conversationListViewController:weakSelf latestMessageTimeForConversationModel:model];
            
            return cell;
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return [EaseConversationCell cellHeightWithModel:nil];
        }];
        
        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [weakSelf.searchController.searchBar endEditing:YES];
            id<IConversationModel> model = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            EMConversation *conversation = model.conversation;
            

           weakSelf.chatVC = [[ChatViewController alloc] initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
           
           [weakSelf getUSerMessageWith:conversation.conversationId];
           weakSelf.chatVC.userid = conversation.conversationId;
//           weakSelf.chatVC.moneyStr = @"官方提醒：当前处于免费聊天模式！";
           
           [weakSelf.navigationController pushViewController:weakSelf.chatVC animated:YES];
           [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
           [weakSelf.tableView reloadData];
           }];
        }
         
         return _searchController;
}

/**
 *  获取用户昵称
 */
- (void)getUSerMessageWith:(NSString *)str {
    
    _username = nil;
    NSString *urlS = [NSString stringWithFormat:@"%@api/IM/GetCustomerInfoByID", Server_Int_Url];
    NSString *dataS = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@ZICBDYCID=%@", kPrefixPara, kDevIdentity, kDevSysInfo, kDevTypeInfo, kIMEI,str, nil];
    NSString *dataEncrpyt = [TWDes encryptWithContent:dataS type:kDesType key:kDesKey];
    NSString *token = [UserInfo getAccessToken];
    NSDictionary *paraDic = @{kToken:token, kDatas:dataEncrpyt};
    
    [AFManegerHelp POST:urlS parameters:paraDic success:^(id responseObjeck) {
        
        NSLog(@"GetCustomerInfoByID - %@", responseObjeck);
        
        if ([responseObjeck[@"Success"] integerValue] == 1) {
            
            NSArray *array = responseObjeck[@"JsonData"];
            for (NSDictionary *d in array) {
                self.chatVC.title = d[@"CustomerName"];
            }
            
        } else {

            NSLog(@"%@", responseObjeck[@"Msg"]);
        }
    
    } failure:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
    
}

#pragma mark - EaseConversationListViewControllerDelegate

- (void)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
            didSelectConversationModel:(id<IConversationModel>)conversationModel
{
    __weak typeof(self)weakSelf = self;
    if (conversationModel) {
        EMConversation *conversation = conversationModel.conversation;
        if (conversation) {
            if (conversation.type == EMConversationTypeChat) {
                NSLog(@"danliao");
                
//                if (![AFManegerHelp isYourFriendsWith:conversation.conversationId]) {
//                    NSLog(@"是好友");
//                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"你们不是好友,请先添加好友再聊天" message:nil delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
//                    [alert show];
//                } else  {

                       weakSelf.chatVC = [[ChatViewController alloc] initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
                       [self getUSerMessageWith:conversation.conversationId];
                       _chatVC.userid = conversation.conversationId;
//                       _chatVC.moneyStr = @"官方提醒：当前处于免费聊天模式！";
                       // 发push新控制器的时候把底部的tabbar隐藏
                       [_chatVC setHidesBottomBarWhenPushed:YES];
                       [self.navigationController pushViewController:_chatVC animated:YES];
//                }
            } else {

              weakSelf.chatVC = [[ChatViewController alloc] initWithConversationChatter:conversation.conversationId conversationType:conversation.type];
              [self getUSerMessageWith:conversation.conversationId];
              _chatVC.userid = conversation.conversationId;
//              _chatVC.moneyStr = @"官方提醒：当前处于免费聊天模式！";
              // 发push新控制器的时候把底部的tabbar隐藏
              [_chatVC setHidesBottomBarWhenPushed:YES];
              [self.navigationController pushViewController:_chatVC animated:YES];
            }
        }
          [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
          [self.tableView reloadData];
    }
}


#pragma mark - EaseConversationListViewControllerDataSource

- (id<IConversationModel>)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
                                    modelForConversation:(EMConversation *)conversation
{
    EaseConversationModel *model = [[EaseConversationModel alloc] initWithConversation:conversation];
    if (model.conversation.type == EMConversationTypeChat) {
        
        NSLog(@"单聊 - conversationId - %@", conversation.conversationId);
        
    } else if (model.conversation.type == EMConversationTypeGroupChat) {
        NSString *imageName = @"groupPublicHeader";
        if (![conversation.ext objectForKey:@"subject"])
        {
            NSArray *groupArray = [[EMClient sharedClient].groupManager getJoinedGroups];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:conversation.conversationId]) {
                    NSMutableDictionary *ext = [NSMutableDictionary dictionaryWithDictionary:conversation.ext];
                    [ext setObject:group.subject forKey:@"subject"];
                    [ext setObject:[NSNumber numberWithBool:group.isPublic] forKey:@"isPublic"];
                    conversation.ext = ext;
                    break;
                }
            }
        }
        model.title = [conversation.ext objectForKey:@"subject"];
        NSLog(@"model.title --- %@", model.title);
        imageName = [[conversation.ext objectForKey:@"isPublic"] boolValue] ? @"groupPublicHeader" : @"groupPrivateHeader";
        model.avatarImage = [UIImage imageNamed:imageName];
    }
    return model;
}

- (NSString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
      latestMessageTitleForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString *latestMessageTitle = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];
    if (lastMessage) {
        EMMessageBody *messageBody = lastMessage.body;
        switch (messageBody.type) {
            case EMMessageBodyTypeImage:{
                latestMessageTitle = NSLocalizedString(@"message.image1", @"[image]");
            } break;
            case EMMessageBodyTypeText:{
                // 表情映射。
                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                latestMessageTitle = didReceiveText;
                if ([lastMessage.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
                    latestMessageTitle = @"[动画表情]";
                }
            } break;
            case EMMessageBodyTypeVoice:{
                latestMessageTitle = NSLocalizedString(@"message.voice1", @"[voice]");
            } break;
            case EMMessageBodyTypeLocation: {
                latestMessageTitle = NSLocalizedString(@"message.location1", @"[location]");
            } break;
            case EMMessageBodyTypeVideo: {
                latestMessageTitle = NSLocalizedString(@"message.video1", @"[video]");
            } break;
            case EMMessageBodyTypeFile: {
                latestMessageTitle = NSLocalizedString(@"message.file1", @"[file]");
            } break;
            default: {
            } break;
        }
    }
    
    return latestMessageTitle;
}

- (NSString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
       latestMessageTimeForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString *latestMessageTime = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];;
    if (lastMessage) {
        latestMessageTime = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }
    
    
    return latestMessageTime;
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    __weak typeof(self) weakSelf = self;
    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:self.dataArray searchText:(NSString *)searchText collationStringSelector:@selector(title) resultBlock:^(NSArray *results) {
        NSLog(@"dataArray - %@", self.dataArray);
        NSLog(@"results - %@", results);
        if (results) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.searchController.resultsSource removeAllObjects];
                [weakSelf.searchController.resultsSource addObjectsFromArray:results];
                [weakSelf.searchController.searchResultsTableView reloadData];
            });
        }
    }];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [[RealtimeSearchUtil currentUtil] realtimeSearchStop];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark - public

-(void)refresh
{
    [self refreshAndSortView];
}

-(void)refreshDataSource
{
    [self tableViewDidTriggerHeaderRefresh];
}

- (void)isConnect:(BOOL)isConnect{
    if (!isConnect) {
        self.tableView.tableHeaderView = _networkStateView;
    }
    else{
        self.tableView.tableHeaderView = nil;
    }
    
}

- (void)networkChanged:(EMConnectionState)connectionState
{
    if (connectionState == EMConnectionDisconnected) {
        self.tableView.tableHeaderView = _networkStateView;
    }
    else{
        self.tableView.tableHeaderView = nil;
    }
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
