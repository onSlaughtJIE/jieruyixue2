//
//  LearnFVC.m
//  JRMedical
//
//  Created by a on 16/11/4.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "LearnFVC.h"
#import "MessageViewController.h" // 消息
#import "FriendViewController.h"  // 好友
#import "GroupViewController.h"   // 群组
#import "ApplyViewController.h"
#import "ChatViewController.h"
#import "GroupListViewController.h"
#import "AddFriendViewController.h"
#import "GroupModel.h"
#import "CreateGroupViewController.h"
#import "IMFindViewController.h"
#import "DTKDropdownMenuView.h"
#define ColorWithRGB(r,g,b) [UIColor colorWithRed:r/255. green:g/255. blue:b/255. alpha:1]

//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;
static NSString *kMessageType = @"MessageType";
static NSString *kConversationChatter = @"ConversationChatter";
static NSString *kGroupName = @"GroupName";

@interface LearnFVC ()<UIScrollViewDelegate, EMChatManagerDelegate, EMContactManagerDelegate, EMGroupManagerDelegate, UITabBarDelegate>
{
    MessageViewController *_chatListVC;
    FriendViewController *_contactsVC;
    ChatViewController *_chatVC;
}
@property (nonatomic, retain) UIScrollView *bigScrollView;
@property (nonatomic, strong) UIScrollView *topScrollView;
@property (strong, nonatomic) NSDate *lastPlaySoundDate;
@property (nonatomic, strong) NSString *delete;
@property (nonatomic, strong) UIAlertView *alertView;

@end

@implementation LearnFVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BG_Color;
    
    [self.view addSubview:self.bigScrollView];
    // 添加子控制器
    [self addSubController];
    //添加模块导航栏
    [self addTopBarLabel];
    
    CGFloat contentX = self.childViewControllers.count * Width_Screen;
    self.bigScrollView.contentSize = CGSizeMake(contentX, 0);
    self.bigScrollView.pagingEnabled = YES;
    
    //添加默认控制器
    UIViewController *vc = self.childViewControllers.firstObject;
    vc.view.frame = self.bigScrollView.bounds;
    [self.bigScrollView addSubview:vc.view];
    self.navigationItem.titleView = _topScrollView;

    // 添加好友
    [self addRightItem];
    
    // 监听获取好友请求数目的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUntreatedApplyCount) name:@"setupUntreatedApplyCount" object:nil];
    
    // 监听未读消息数变化的通知 （主要是在点击会话列表的代理方法中，发起的这个通知，点击会话列表进入聊天界面，把未读消息都标记为已读，然后将未读消息数清0），可以全局搜索 "setupUnreadMessageCount"，就知道位置了
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUnreadMessageCount) name:@"setupUnreadMessageCount" object:nil];
    
    // 监听tabbar点击
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarDidClick) name:@"LLTabBarDidClickNotification" object:nil];
    
    // 监听极光推送加好友 调整偏移
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jpushWithAdd) name:kJPushWithAdd object:nil];
    
    [self addDelegate];
    
    
}

- (void)tabBarDidClick
{
    NSLog(@"接受到tabbar点击监听");
    
    CGFloat offsetX = 0;
    CGFloat offsetY = self.bigScrollView.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    [self.bigScrollView setContentOffset:offset animated:YES];
    
    for (UILabel *label in self.topScrollView.subviews) {
        if (label.tag != 100) {
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = [UIColor clearColor];
            
        } else {
            label.textColor = Main_Color;
            label.backgroundColor = [UIColor whiteColor];
            
        }
    }
}

- (void)jpushWithAdd {
    
    NSLog(@"接受到极光推送加好友");
    
    CGFloat offsetX = Width_Screen;
    CGFloat offsetY = self.bigScrollView.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    [self.bigScrollView setContentOffset:offset animated:YES];
    
    for (UILabel *label in self.topScrollView.subviews) {
        if (label.tag != 101) {
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = [UIColor clearColor];
            
        } else {
            label.textColor = Main_Color;
            label.backgroundColor = [UIColor whiteColor];
            
        }
    }
}


// 统计好友请求，群组请求数目
- (void)setupUntreatedApplyCount
{
    NSInteger unreadCount = [[[ApplyViewController shareController] dataSource] count];
    if (_contactsVC) {
        if (unreadCount > 0) {
            _contactsVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
        }else{
            _contactsVC.tabBarItem.badgeValue = nil;
        }
    }
}

// 统计未读消息数
-(void)setupUnreadMessageCount
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    if (_chatListVC) {
        if (unreadCount > 0) {
            self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
            NSLog(@"unreadCount----------%ld", (long)unreadCount);
        }else{
            self.tabBarItem.badgeValue = nil;
        }
    }

    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:unreadCount];
}


- (void)addDelegate
{
    NSLog(@"添加代理");
    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];

}

// 移除代理
- (void)dealloc
{
    [[EMClient sharedClient].groupManager removeDelegate:self];
    [[EMClient sharedClient].contactManager removeDelegate:self];
    [[EMClient sharedClient].chatManager removeDelegate:self];

}

// 会话列表发生变化时的回调
- (void)didUpdateConversationList:(NSArray *)aConversationList
{
    
    if (_chatListVC) {
        // 获取未读消息数
        [self setupUnreadMessageCount];
        // 刷新会话列表数据
        [_chatListVC refreshDataSource];
    }
    
}

// 接收消息的回调函数
- (void)didReceiveMessages:(NSArray *)aMessages{
    
    NSLog(@"获取未读消息数");
 
    
    EMMessage *message = aMessages.firstObject;
    if (message.chatType == EMChatTypeChatRoom) {
        NSLog(@"这是聊天室的消息");
    } else {
        
        BOOL isRefreshCons = YES;
        _chatVC = nil;
        for(EMMessage *message in aMessages){
            
            BOOL needShowNotification = (message.chatType != EMChatTypeChat) ? [self _needShowNotification:message.conversationId] : YES;
            
            UIApplicationState state = [[UIApplication sharedApplication] applicationState];
            
            if (needShowNotification) {
#if !TARGET_IPHONE_SIMULATOR
                switch (state) {
                    case UIApplicationStateActive:
                        [self playSoundAndVibration];
                        break;
                    case UIApplicationStateInactive:
                        [self playSoundAndVibration];
                        break;
                    case UIApplicationStateBackground:
                        [self showNotificationWithMessage:message];
                        break;
                    default:
                        break;
                }
#endif
            }
            
            
            if (_chatVC == nil) {
                _chatVC = [self _getCurrentChatView];
            }
            BOOL isChatting = NO;
            if (_chatVC) {
                NSLog(@"message.conversationId - %@", message.conversationId);
                NSLog(@"_chatVC.conversation.conversationId - %@", _chatVC.conversation.conversationId);
                isChatting = [message.conversationId isEqualToString:_chatVC.conversation.conversationId];
            }
            if (_chatVC == nil || !isChatting || state == UIApplicationStateBackground) {
                
                if (_chatListVC) {
                    // 获取未读消息数
                    [self setupUnreadMessageCount];
                    [self playSoundAndVibration];
                    
                    // 刷新会话列表数据
                    [_chatListVC refresh];
                }
                return;
            }
            
            if (isChatting) {
                NSLog(@"正在聊天");
                isRefreshCons = NO;
            }
            
            
        }
        
        if (isRefreshCons) {
            if (_chatListVC) {
                // 获取未读消息数
                [self setupUnreadMessageCount];
                [self playSoundAndVibration];
                
                // 刷新会话列表数据
                [_chatListVC refresh];
            }
            
        }
        
        
        
        
    }
    
    
    
    
}



- (void)getuserNameWith:(NSString *)aUsername withMeaage:(NSString *)message {
    NSString *urlS = [NSString stringWithFormat:@"%@api/IM/GetCustomerInfoByID", Server_Int_Url];
    NSString *dataS = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@ZICBDYCID=%@", kPrefixPara, kDevIdentity, kDevSysInfo, kDevTypeInfo, kIMEI,aUsername, nil];
    NSString *dataEncrpyt = [TWDes encryptWithContent:dataS type:kDesType key:kDesKey];
    NSString *token = [UserInfo getAccessToken];
    NSDictionary *paraDic = @{kToken:token, kDatas:dataEncrpyt};
    
    [AFManegerHelp POST:urlS parameters:paraDic success:^(id responseObjeck) {
        NSLog(@"GetCustomerInfoByID - %@", responseObjeck);
        
        if ([responseObjeck[@"Success"] integerValue] == 1) {
            
            NSArray *array = responseObjeck[@"JsonData"];
            for (NSDictionary *d in array) {
                NSString *msgstr;
                if ([_delete isEqualToString:@"1"]) {
                    msgstr = [NSString stringWithFormat:@"你已经删除了好友：%@", d[@"CustomerName"]];
                } else {
                    msgstr = [NSString stringWithFormat:@"%@%@", d[@"CustomerName"], message];
                }

                _alertView = [[UIAlertView alloc] initWithTitle:nil message:msgstr delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                [NSTimer scheduledTimerWithTimeInterval:0.9 target:self selector:@selector(dismissAlert) userInfo:nil repeats:NO];
                [_alertView show];
            }
            
        } else {
            
            [AFManegerHelp Hud:responseObjeck[@"Msg"] Delay:1];
        }
        
    } failure:^(NSError *error) {
         NSLog(@"%@", error.description);
    }];
    
}


- (void)dismissAlert {
    
    [_alertView dismissWithClickedButtonIndex:0 animated:YES];
}


// 用户B申请加A为好友后，用户A会收到这个回调
- (void)didReceiveFriendInvitationFromUsername:(NSString *)aUsername
                                       message:(NSString *)aMessage
{
    
    NSLog(@"接收到好友请求了------");
    if (!aUsername) {
        //        aUsername = [self getuserNameWith:aUsername];
        return;
    }
    NSLog(@"---%@", aUsername);
    
    
    if (!aMessage) {
        aMessage = [NSString stringWithFormat:NSLocalizedString(@"friend.somebodyAddWithName", @"%@ add you as a friend"), aUsername];
    }
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":aUsername, @"username":aUsername, @"applyMessage":aMessage, @"applyStyle":[NSNumber numberWithInteger:ApplyStyleFriend]}];
    
    
    [[ApplyViewController shareController] addNewApply:dic];
    
    
    // 获取好友请求的数目，给tabBarItem.badgeValue 赋值
    [self setupUntreatedApplyCount];
    //#if !TARGET_IPHONE_SIMULATOR
    [self playSoundAndVibration];
    
    //    BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
    //    if (!isAppActivity) {
    //        //发送本地推送
    //        UILocalNotification *notification = [[UILocalNotification alloc] init];
    //        notification.fireDate = [NSDate date]; //触发通知的时间
    //        notification.alertBody = [NSString stringWithFormat:NSLocalizedString(@"friend.somebodyAddWithName", @"%@ add you as a friend"), aUsername];
    //        notification.alertAction = NSLocalizedString(@"open", @"Open");
    //        notification.timeZone = [NSTimeZone defaultTimeZone];
    //    }
    //#endif
    
    [_contactsVC reloadApplyView];
}

// 用户B删除与用户A的好友关系后，用户A会收到这个回调
- (void)didReceiveDeletedFromUsername:(NSString *)aUsername
{
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    ChatViewController *chatViewContrller = nil;
    for (id viewController in viewControllers)
    {
        if ([viewController isKindOfClass:[ChatViewController class]] && [aUsername isEqualToString:[(ChatViewController *)viewController conversation].conversationId])
        {
            chatViewContrller = viewController;
            break;
        }
    }
    if (chatViewContrller)
    {
        [viewControllers removeObject:chatViewContrller];
        if ([viewControllers count] > 0) {
            [self.navigationController setViewControllers:@[viewControllers[0]] animated:YES];
        } else {
            [self.navigationController setViewControllers:viewControllers animated:YES];
        }
    }
    //    [self showHint:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"delete", @"delete"), aUsername]];
    _delete = @"1";
    [self getuserNameWith:aUsername withMeaage:@""];
    [_contactsVC reloadDataSource];
}

// 用户B同意用户A的好友申请后，用户A和用户B都会收到这个回调
//- (void)didReceiveAddedFromUsername:(NSString *)aUsername
//{
//    [_contactsVC reloadDataSource];
//}

- (void)didReceiveAgreedFromUsername:(NSString *)aUsername
{
    _delete = @"0";
    //    NSString *msgstr = [NSString stringWithFormat:@"%@同意了加好友申请", aUsername];
    //    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:msgstr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //    [alertView show];
    [self getuserNameWith:aUsername withMeaage:@"同意了加好友申请"];
    [_contactsVC reloadDataSource];
}

- (void)didReceiveDeclinedFromUsername:(NSString *)aUsername
{
    [self getuserNameWith:aUsername withMeaage:@"拒绝了加好友申请"];
}

//  群组加入通知
- (void)didReceiveAcceptedJoinGroup:(EMGroup *)aGroup
{
    NSLog(@"同意入群");
    
    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"group.agreedAndJoined", @"agreed to join the group of \'%@\'"), aGroup.subject];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)didReceiveJoinGroupApplication:(EMGroup *)aGroup
                             applicant:(NSString *)aApplicant
                                reason:(NSString *)aReason
{
    if (!aGroup || !aApplicant) {
        return;
    }
    
    
    NSString *urlS = [NSString stringWithFormat:@"%@api/IM/GetCustomerInfoByID", Server_Int_Url];
    NSString *dataS = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@ZICBDYCID=%@", kPrefixPara, kDevIdentity, kDevSysInfo, kDevTypeInfo, kIMEI, aApplicant, nil];
    NSString *dataEncrpyt = [TWDes encryptWithContent:dataS type:kDesType key:kDesKey];
    NSString *token = [UserInfo getAccessToken];
    NSDictionary *paraDic = @{kToken:token, kDatas:dataEncrpyt};
    
    [AFManegerHelp POST:urlS parameters:paraDic success:^(id responseObjeck) {
        NSLog(@"GetCustomerInfoByID - %@", responseObjeck);
        
        if ([responseObjeck[@"Success"] integerValue] == 1) {
            
            NSArray *array = responseObjeck[@"JsonData"];
            for (NSDictionary *d in array) {
                NSString *str = [NSString stringWithFormat:@"申请人:%@ 加入群组:%@ 申请理由:%@",d[@"CustomerName"], aGroup.subject ,aReason];

                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":aGroup.subject, @"groupId":aGroup.groupId, @"username":aApplicant, @"groupname":aGroup.subject, @"applyMessage":str, @"applyStyle":[NSNumber numberWithInteger:ApplyStyleJoinGroup]}];
                NSLog(@"申请信息%@", dic[@"applyMessage"]);
                [[ApplyViewController shareController] addNewApply:dic];
                [self playSoundAndVibration];
                if (_contactsVC) {
                    [_contactsVC reloadApplyView];
                }
            }
            
        } else {
            [AFManegerHelp Hud:responseObjeck[@"Msg"] Delay:1];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
}






- (void)didReceiveGroupInvitation:(NSString *)aGroupId
                          inviter:(NSString *)aInviter
                          message:(NSString *)aMessage {
    EMError *error = nil;
    EMGroup *group = [[EMClient sharedClient].groupManager fetchGroupInfo:aGroupId includeMembersList:YES error:&error];
    
    
    NSString *urlS = [NSString stringWithFormat:@"%@api/IM/GetCustomerInfoByID", Server_Int_Url];
    NSString *dataS = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@ZICBDYCID=%@", kPrefixPara, kDevIdentity, kDevSysInfo, kDevTypeInfo, kIMEI,aInviter, nil];
    NSString *dataEncrpyt = [TWDes encryptWithContent:dataS type:kDesType key:kDesKey];
    NSString *token = [UserInfo getAccessToken];
    NSDictionary *paraDic = @{kToken:token, kDatas:dataEncrpyt};
    
    
    [AFManegerHelp POST:urlS parameters:paraDic success:^(id responseObjeck) {
        
        NSLog(@"GetCustomerInfoByID - %@", responseObjeck);
        
        if ([responseObjeck[@"Success"] integerValue] == 1) {
            
            NSArray *array = responseObjeck[@"JsonData"];
            for (NSDictionary *d in array) {
                NSString *str = [NSString stringWithFormat:@"%@邀请你加入%@", d[@"CustomerName"], group.subject];
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"groupId":aGroupId,@"username" :[EMClient sharedClient].currentUsername,@"applyMessage":str, @"applyStyle":[NSNumber numberWithInteger:ApplyStyleGroupInvitation]}];

                [[ApplyViewController shareController] addNewApply:dic];
                [self playSoundAndVibration];
                if (_contactsVC) {
                    [_contactsVC reloadApplyView];
                }
            }
            
        } else {
            [AFManegerHelp Hud:responseObjeck[@"Msg"] Delay:1];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
    
    
    
    //    NSLog(@"收到群邀请");
    //    NSString *str = [NSString stringWithFormat:@"%@%@", aInviter, aMessage];
    //    NSLog(@"----%@", str);
    //
    
    
    
}

- (EMError *)acceptJoinApplication:(NSString *)aGroupId
                         groupname:(NSString *)aGroupname
                         applicant:(NSString *)aUsername {
    NSLog(@"接受邀请");
    return nil;
}

- (void)playSoundAndVibration{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
}


- (ChatViewController*)_getCurrentChatView
{
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    ChatViewController *chatViewContrller = nil;
    for (id viewController in viewControllers)
    {
        if ([viewController isKindOfClass:[ChatViewController class]])
        {
            chatViewContrller = viewController;
            break;
        }
    }
    return chatViewContrller;
}

#pragma mark - private
- (BOOL)_needShowNotification:(NSString *)fromChatter
{
    BOOL ret = YES;
//    NSArray *igGroupIds = [[EMClient sharedClient].groupManager getAllIgnoredGroupIds];
    NSArray *igGroupIds = [[EMClient sharedClient].groupManager getGroupsWithoutPushNotification:nil];
    for (NSString *str in igGroupIds) {
        if ([str isEqualToString:fromChatter]) {
            ret = NO;
            break;
        }
    }
    return ret;
}


#pragma mark - public

- (void)jumpToChatList
{
    if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
        //        ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
        //        [chatController hideImagePicker];
    }
    else if(_chatListVC)
    {
//        [self.navigationController popToViewController:self animated:NO];
//        
//        [self tabBarDidClick];
        [self.tabBarController setSelectedIndex:2];
        
    }
}

- (EMConversationType)conversationTypeFromMessageType:(EMChatType)type
{
    EMConversationType conversatinType = EMConversationTypeChat;
    switch (type) {
        case EMChatTypeChat:
            conversatinType = EMConversationTypeChat;
            break;
        case EMChatTypeGroupChat:
            conversatinType = EMConversationTypeGroupChat;
            break;
        case EMChatTypeChatRoom:
            conversatinType = EMConversationTypeChatRoom;
            break;
        default:
            break;
    }
    return conversatinType;
}


- (void)networkChanged:(EMConnectionState)connectionState
{
    _connectionState = connectionState;
    [_chatListVC networkChanged:connectionState];
}


- (void)didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    if (userInfo)
    {
        if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
            //            ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
            //            [chatController hideImagePicker];
        }
        
        NSArray *viewControllers = self.navigationController.viewControllers;
        [viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            if (obj != self)
            {
                if (![obj isKindOfClass:[ChatViewController class]])
                {
                    [self.navigationController popViewControllerAnimated:NO];
                }
                else
                {
                    NSString *conversationChatter = userInfo[kConversationChatter];
                    ChatViewController *chatViewController = (ChatViewController *)obj;
                    if (![chatViewController.conversation.conversationId isEqualToString:conversationChatter])
                    {
                        [self.navigationController popViewControllerAnimated:NO];
                        EMChatType messageType = [userInfo[kMessageType] intValue];

                        chatViewController = [[ChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
                        [self.navigationController pushViewController:chatViewController animated:NO];
                    }
                    *stop= YES;
                }
            }
            else
            {
                ChatViewController *chatViewController = nil;
                NSString *conversationChatter = userInfo[kConversationChatter];
                EMChatType messageType = [userInfo[kMessageType] intValue];

                chatViewController = [[ChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
                [self.navigationController pushViewController:chatViewController animated:NO];
            }
        }];
    }
    else if (_chatListVC)
    {
//        [self.navigationController popToViewController:self animated:NO];
//        [self setSelectedViewController:_chatListVC];
        [self.tabBarController setSelectedIndex:2];
    }
}

- (void)didReceiveUserNotification:(UNNotification *)notification
{
    NSDictionary *userInfo = notification.request.content.userInfo;
    if (userInfo)
    {
        if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
            //            ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
            //            [chatController hideImagePicker];
        }
        
        NSArray *viewControllers = self.navigationController.viewControllers;
        [viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            if (obj != self)
            {
                if (![obj isKindOfClass:[ChatViewController class]])
                {
                    [self.navigationController popViewControllerAnimated:NO];
                }
                else
                {
                    NSString *conversationChatter = userInfo[kConversationChatter];
                    ChatViewController *chatViewController = (ChatViewController *)obj;
                    if (![chatViewController.conversation.conversationId isEqualToString:conversationChatter])
                    {
                        [self.navigationController popViewControllerAnimated:NO];
                        EMChatType messageType = [userInfo[kMessageType] intValue];

                        chatViewController = [[ChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
                        [self.navigationController pushViewController:chatViewController animated:NO];
                    }
                    *stop= YES;
                }
            }
            else
            {
                ChatViewController *chatViewController = nil;
                NSString *conversationChatter = userInfo[kConversationChatter];
                EMChatType messageType = [userInfo[kMessageType] intValue];

                chatViewController = [[ChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
                [self.navigationController pushViewController:chatViewController animated:NO];
            }
        }];
    }
    else if (_chatListVC)
    {
//        [self.navigationController popToViewController:self animated:NO];
//        [self setSelectedViewController:_chatListVC];
        [self.tabBarController setSelectedIndex:2];
    }
}



- (void)showNotificationWithMessage:(EMMessage *)message
{
    EMPushOptions *options = [[EMClient sharedClient] pushOptions];
    NSString *alertBody = nil;
    if (options.displayStyle == EMPushDisplayStyleMessageSummary) {
        EMMessageBody *messageBody = message.body;
        NSString *messageStr = nil;
        switch (messageBody.type) {
            case EMMessageBodyTypeText:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case EMMessageBodyTypeImage:
            {
                messageStr = NSLocalizedString(@"message.image", @"Image");
            }
                break;
            case EMMessageBodyTypeLocation:
            {
                messageStr = NSLocalizedString(@"message.location", @"Location");
            }
                break;
            case EMMessageBodyTypeVoice:
            {
                messageStr = NSLocalizedString(@"message.voice", @"Voice");
            }
                break;
            case EMMessageBodyTypeVideo:{
                messageStr = NSLocalizedString(@"message.video", @"Video");
            }
                break;
            default:
                break;
        }
        
        do {
//            NSString *title = [[UserProfileManager sharedInstance] getNickNameWithUsername:message.from];
            NSString *title = @"what?";
            if (message.chatType == EMChatTypeGroupChat) {
                NSDictionary *ext = message.ext;
                if (ext && ext[kGroupMessageAtList]) {
                    id target = ext[kGroupMessageAtList];
                    if ([target isKindOfClass:[NSString class]]) {
                        if ([kGroupMessageAtAll compare:target options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                            alertBody = [NSString stringWithFormat:@"%@%@", title, NSLocalizedString(@"group.atPushTitle", @" @ me in the group")];
                            break;
                        }
                    }
                    else if ([target isKindOfClass:[NSArray class]]) {
                        NSArray *atTargets = (NSArray*)target;
                        if ([atTargets containsObject:[EMClient sharedClient].currentUsername]) {
                            alertBody = [NSString stringWithFormat:@"%@%@", title, NSLocalizedString(@"group.atPushTitle", @" @ me in the group")];
                            break;
                        }
                    }
                }
                NSArray *groupArray = [[EMClient sharedClient].groupManager getJoinedGroups];
                for (EMGroup *group in groupArray) {
                    if ([group.groupId isEqualToString:message.conversationId]) {
                        title = [NSString stringWithFormat:@"%@(%@)", message.from, group.subject];
                        break;
                    }
                }
            }
            else if (message.chatType == EMChatTypeChatRoom)
            {
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                NSString *key = [NSString stringWithFormat:@"OnceJoinedChatrooms_%@", [[EMClient sharedClient] currentUsername]];
                NSMutableDictionary *chatrooms = [NSMutableDictionary dictionaryWithDictionary:[ud objectForKey:key]];
                NSString *chatroomName = [chatrooms objectForKey:message.conversationId];
                if (chatroomName)
                {
                    title = [NSString stringWithFormat:@"%@(%@)", message.from, chatroomName];
                }
            }
            
            alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
        } while (0);
    }
    else{
        alertBody = NSLocalizedString(@"receiveMessage", @"you have a new message");
    }
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
    BOOL playSound = NO;
    if (!self.lastPlaySoundDate || timeInterval >= kDefaultPlaySoundInterval) {
        self.lastPlaySoundDate = [NSDate date];
        playSound = YES;
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:message.chatType] forKey:kMessageType];
    [userInfo setObject:message.conversationId forKey:kConversationChatter];
    
    //发送本地推送
    if (NSClassFromString(@"UNUserNotificationCenter")) {
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.01 repeats:NO];
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        if (playSound) {
            content.sound = [UNNotificationSound defaultSound];
        }
        content.body =alertBody;
        content.userInfo = userInfo;
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:message.messageId content:content trigger:trigger];
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
    }
    else {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate date]; //触发通知的时间
        notification.alertBody = alertBody;
        notification.alertAction = NSLocalizedString(@"open", @"Open");
        notification.timeZone = [NSTimeZone defaultTimeZone];
        if (playSound) {
            notification.soundName = UILocalNotificationDefaultSoundName;
        }
        notification.userInfo = userInfo;
        
        //发送通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}





// -----------------------------------------------
- (void)addRightItem
{
    __weak typeof(self) weakSelf = self;
    DTKDropdownItem *item0 = [DTKDropdownItem itemWithTitle:@"加好友" iconName:@"reng" callBack:^(NSUInteger index, id info) {
        NSLog(@"rightItem%lu",(unsigned long)index);
        [weakSelf addFriendOrGroupByIndex:0];
    }];
    DTKDropdownItem *item1 = [DTKDropdownItem itemWithTitle:@"创建群" iconName:@"quntit" callBack:^(NSUInteger index, id info) {
        NSLog(@"rightItem%lu",(unsigned long)index);
        [weakSelf addFriendOrGroupByIndex:1];
    }];
    DTKDropdownMenuView *menuView = [DTKDropdownMenuView dropdownMenuViewWithType:dropDownTypeRightItem frame:CGRectMake(0, 0, 44.f, 44.f) dropdownItems:@[item0,item1] icon:@"jia"];
    
    menuView.cellColor = [UIColor darkGrayColor];
    menuView.dropWidth = 120.f;
    menuView.titleFont = [UIFont systemFontOfSize:18.f];
    menuView.textColor = [UIColor whiteColor];
    menuView.textFont = [UIFont systemFontOfSize:13.f];
    menuView.cellSeparatorColor = [UIColor whiteColor];
    menuView.textFont = [UIFont boldSystemFontOfSize:14.f];
    menuView.animationDuration = 0.2f;
    menuView.backgroundAlpha = 0.1f;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:menuView];
}

#pragma mark - 加好友/创建群
- (void)addFriendOrGroupByIndex:(NSInteger)index
{
//    [self showMessage:@"功能正在建设中、敬请期待..."];
    if (index == 0) {
        NSLog(@"添加好友");
//        AddFriendViewController *addVC = [[AddFriendViewController alloc]init];
//        [self.navigationController pushViewController:addVC animated:YES];
        
        IMFindViewController *addVC = [[IMFindViewController alloc] init];
        [self.navigationController pushViewController:addVC animated:YES];

    } else {
        NSLog(@"创建群");
        CreateGroupViewController *createChatroom = [[CreateGroupViewController alloc] init];
        [self.navigationController pushViewController:createChatroom animated:YES];
    }
    
}



- (UIScrollView *)topScrollView {
    if (!_topScrollView) {
        self.topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 156, 32)];
        self.topScrollView.backgroundColor = Main_Color;
        self.topScrollView.showsHorizontalScrollIndicator = NO;
        self.topScrollView.showsVerticalScrollIndicator = NO;
        _topScrollView.scrollEnabled = NO;
        _topScrollView.layer.cornerRadius = 16;
        _topScrollView.layer.borderColor = [[UIColor whiteColor] CGColor];
        _topScrollView.layer.borderWidth = 1;
        _topScrollView.layer.masksToBounds = YES;
        
        
    }
    return _topScrollView;
}

- (UIScrollView *)bigScrollView {
    if (!_bigScrollView) {
        self.bigScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        self.bigScrollView.delegate = self;
        self.bigScrollView.bounces = NO;
        self.bigScrollView.showsHorizontalScrollIndicator = NO;
        self.bigScrollView.scrollEnabled = NO; // 不让bigScrollView滚动
    }
    return _bigScrollView;
}

- (void)addTopBarLabel {
    
    for (int i = 0; i < 3; i++) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:(CGRectMake(50 * i + 3, 3, 50, 26))];
        UIViewController *vc = self.childViewControllers[i];
        label.text = vc.title;
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 100+i;
        label.font = [UIFont systemFontOfSize:14];
        label.layer.cornerRadius = 13;
        label.textColor = [UIColor whiteColor];
        label.layer.masksToBounds = YES;
        label.userInteractionEnabled = YES;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)]];
        if (i == 0) {
            label.backgroundColor = [UIColor whiteColor];
            label.textColor = Main_Color;
        }
        
        [self.topScrollView addSubview:label];
        
    }
    self.topScrollView.contentSize = CGSizeMake(156, 0);
}

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    
    NSUInteger currentTag = sender.view.tag;
    for (UILabel *label in self.topScrollView.subviews) {
        if (label.tag != currentTag) {
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = [UIColor clearColor];
            
        } else {
            label.textColor = Main_Color;
            label.backgroundColor = [UIColor whiteColor];
            
        }
    }
    
    CGFloat offsetX = (currentTag - 100) * self.bigScrollView.frame.size.width;
    CGFloat offsetY = self.bigScrollView.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    [self.bigScrollView setContentOffset:offset animated:YES];
    
    
    
}

- (void)addSubController {
    for (int i = 0; i < 3; i++) {
        if (0 == i) {
            
            _chatListVC = [[MessageViewController alloc] init];
            _chatListVC.title = @"消息";
            [self addChildViewController:_chatListVC];
            
        } else if (1 == i) {
            
            _contactsVC = [[FriendViewController alloc] init];
            _contactsVC.title = @"好友";
            [self addChildViewController:_contactsVC];
            
        } else {
            
            GroupViewController *vc = [[GroupViewController alloc] init];
            vc.title = @"群组";
            [self addChildViewController:vc];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FVCLoaded" object:nil];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    NSUInteger index = scrollView.contentOffset.x / self.bigScrollView.frame.size.width;
    UILabel *label = self.topScrollView.subviews[index];
    NSUInteger currentTag = label.tag;
    
    for (UILabel *label in self.topScrollView.subviews) {
        if (label.tag != currentTag) {
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = [UIColor clearColor];
            
        } else {
            label.textColor = Main_Color;
            label.backgroundColor = [UIColor whiteColor];
            
        }
    }
    
    CGFloat offsetX = label.center.x - self.topScrollView.frame.size.width * 0.5;
    CGFloat offsetMax = self.topScrollView.contentSize.width - self.topScrollView.frame.size.width;
    if (offsetX < 0) {
        offsetX = 0;
    } else if (offsetX > offsetMax) {
        offsetX = offsetMax;
    }
    CGPoint offset = CGPointMake(offsetX, self.topScrollView.contentOffset.y);
    [self.topScrollView setContentOffset:offset animated:YES];
    UIViewController *vc = self.childViewControllers[index];
    
    if (vc.view.superview) {
        return;
    }
    vc.view.frame = scrollView.bounds;
    [self.bigScrollView addSubview:vc.view];
    
    
}

//滚动结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
