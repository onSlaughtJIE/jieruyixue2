//
//  RootTabBarController.m
//  JRMedical
//
//  Created by a on 16/11/4.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "RootTabBarController.h"

#import "PersonalVC.h"
#import "PatientVC.h"
#import "LearnFVC.h"
#import "LearnCVC.h"
#import "StudyVC.h"


//#import "MessageViewController.h" // 消息
//#import "FriendViewController.h"  // 好友
//#import "GroupViewController.h"   // 群组
//#import "ApplyViewController.h"
//#import "ChatViewController.h"
//#import "GroupListViewController.h"
//#import "AddFriendViewController.h"
//#import "GroupModel.h"
//#import "CreateGroupViewController.h"
//#import "IMFindViewController.h"

////两次提示的默认间隔
//static const CGFloat kDefaultPlaySoundInterval = 3.0;
//static NSString *kMessageType = @"MessageType";
//static NSString *kConversationChatter = @"ConversationChatter";
//static NSString *kGroupName = @"GroupName";

@interface RootTabBarController ()//<EMChatManagerDelegate, EMContactManagerDelegate, EMGroupManagerDelegate>
//{
//    MessageViewController *_chatListVC;
//    FriendViewController *_contactsVC;
//    ChatViewController *_chatVC;
//}

@property (nonatomic, strong) StudyVC    *studyVC;
@property (nonatomic, strong) LearnCVC  *learnCVC;
@property (nonatomic, strong) LearnFVC   *learnFVC;
@property (nonatomic, strong) PatientVC   *patientVC;
@property (nonatomic, strong) PersonalVC *personalVC;

//@property (strong, nonatomic) NSDate *lastPlaySoundDate;
//@property (nonatomic, strong) NSString *delete;
//@property (nonatomic, strong) UIAlertView *alertView;

@end

@implementation RootTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBar.translucent = NO;
    
    [self.tabBar setTintColor:Main_Color];
    
    //改变tabbar 线条颜色
    CGRect rect = CGRectMake(0, 0, Width_Screen, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   RGB(255, 255, 255).CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.tabBar setShadowImage:img];
    [self.tabBar setBackgroundImage:[[UIImage alloc]init]];
    
    //阴影
    self.tabBar.layer.shadowColor = RGB(100, 100, 100).CGColor;//阴影颜色
    self.tabBar.layer.shadowOffset = CGSizeMake(0 , 1);//偏移距离
    self.tabBar.layer.shadowOpacity = 0.5;//不透明度
    self.tabBar.layer.shadowRadius = 5.0;//半径
    
    [self initControl];
    
//    [self aboutHuanXin];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fvcload) name:@"FVCLoaded" object:nil];
}

//- (void)fvcload {
//    
//    BaseNavigationController *nav = (BaseNavigationController *)self.viewControllers[2];
//    LearnFVC *fvc = nav.viewControllers.firstObject;
//    if (fvc.childViewControllers.count > 0) {
//        _chatListVC = fvc.childViewControllers[0];
//        _contactsVC = fvc.childViewControllers[1];
//    }
//    
//    
//}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)initControl {
    
    BaseNavigationController *nav1 = [[BaseNavigationController alloc] initWithRootViewController:self.studyVC];
    
    BaseNavigationController *nav2 = [[BaseNavigationController alloc] initWithRootViewController:self.learnCVC];
    
    BaseNavigationController *nav3 = [[BaseNavigationController alloc] initWithRootViewController:self.learnFVC];
    
    BaseNavigationController *nav4 = [[BaseNavigationController alloc] initWithRootViewController:self.patientVC];
    
    BaseNavigationController *nav5 = [[BaseNavigationController alloc] initWithRootViewController:self.personalVC];
    
    NSArray *array = @[nav1,nav2,nav3,nav4,nav5];
    self.viewControllers = array;
    self.selectedIndex = 0;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSLog(@"tabBar - item.title - %@", item.title);
    if ([item.title isEqualToString:@"学术交流"]) {
        NSLog(@"badgeValue - %@", item.badgeValue);
        if (item.badgeValue.integerValue > 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LLTabBarDidClickNotification" object:nil userInfo:nil];
        }
        
    }
}

#pragma mark - Getter and Setter
/**
 *  学习园地
 */
- (StudyVC *)studyVC
{
    if (_studyVC == nil) {
        _studyVC = [[StudyVC alloc] init];
        [_studyVC.tabBarItem setTitle:@"学习园地"];
        [_studyVC.tabBarItem setImage:[UIImage imageNamed:@"xuexiyuandi_icon"]];
        [_studyVC.tabBarItem setSelectedImage:[UIImage imageNamed:@"xuexiyuandi_icon_s"]];
    }
    return _studyVC;
}

/**
 *  医患之家
 */
-(LearnCVC *)learnCVC
{
    if (_learnCVC == nil) {
        _learnCVC = [[LearnCVC alloc] init];
        [_learnCVC.tabBarItem setTitle:@"医患之家"];
        [_learnCVC.tabBarItem setImage:[UIImage imageNamed:@"yiyuan_icon"]];
        [_learnCVC.tabBarItem setSelectedImage:[UIImage imageNamed:@"yiyuan_icon_s"]];
    }
    return _learnCVC;
}

/**
 *  学术交流
 */
- (LearnFVC *)learnFVC
{
    if (_learnFVC == nil) {
        _learnFVC = [[LearnFVC alloc] init];
        [_learnFVC.tabBarItem setTitle:@"学术交流"];
        [_learnFVC.tabBarItem setImage:[UIImage imageNamed:@"jiaoliu_icon"]];
        [_learnFVC.tabBarItem setSelectedImage:[UIImage imageNamed:@"jiaoliu_icon_s"]];
    }
    return _learnFVC;
}

/**
 *  学术论坛
 */
- (PatientVC *)patientVC
{
    if (_patientVC == nil) {
        _patientVC = [[PatientVC alloc] init];
        [_patientVC.tabBarItem setTitle:@"学术论坛"];
        [_patientVC.tabBarItem setImage:[UIImage imageNamed:@"luntan_icon"]];
        [_patientVC.tabBarItem setSelectedImage:[UIImage imageNamed:@"luntan_icon_s"]];
    }
    return _patientVC;
}

/**
 *  我的中心
 */
- (PersonalVC *)personalVC
{
    if (_personalVC == nil) {
        _personalVC = [[PersonalVC alloc] init];
        [_personalVC.tabBarItem setTitle:@"我的中心"];
        [_personalVC.tabBarItem setImage:[UIImage imageNamed:@"wode_icon"]];
        [_personalVC.tabBarItem setSelectedImage:[UIImage imageNamed:@"wode_icon_s"]];
    }
    return _personalVC;
}

/*
// ============================================ 一只默默无闻的分割线 =====================================
#pragma mark - Ablout Huanxin
- (void)aboutHuanXin {
    
    // 监听获取好友请求数目的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUntreatedApplyCount) name:@"setupUntreatedApplyCount" object:nil];

    // 监听未读消息数变化的通知 （主要是在点击会话列表的代理方法中，发起的这个通知，点击会话列表进入聊天界面，把未读消息都标记为已读，然后将未读消息数清0），可以全局搜索 "setupUnreadMessageCount"，就知道位置了
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUnreadMessageCount) name:@"setupUnreadMessageCount" object:nil];
    
    [self addDelegate];
    

    
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
    BaseNavigationController *nav = (BaseNavigationController *)self.viewControllers[2];
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:nav.viewControllers];
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
            [nav setViewControllers:@[viewControllers[0]] animated:YES];
        } else {
            [nav setViewControllers:viewControllers animated:YES];
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
    BaseNavigationController *nav = (BaseNavigationController *)self.viewControllers[2];
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:nav.viewControllers];
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
//    if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
//        //        ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
//        //        [chatController hideImagePicker];
//    }
    if(_chatListVC)
    {
        //        [self.navigationController popToViewController:self animated:NO];
        //
        //        [self tabBarDidClick];
        [self setSelectedIndex:2];
        
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
//        if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
//            //            ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
//            //            [chatController hideImagePicker];
//        }
        
        BaseNavigationController *nav = (BaseNavigationController *)self.viewControllers[2];
        
        NSArray *viewControllers = nav.viewControllers;
        [viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            if (obj != self)
            {
                if (![obj isKindOfClass:[ChatViewController class]])
                {
                    [nav popViewControllerAnimated:NO];
                }
                else
                {
                    NSString *conversationChatter = userInfo[kConversationChatter];
                    ChatViewController *chatViewController = (ChatViewController *)obj;
                    if (![chatViewController.conversation.conversationId isEqualToString:conversationChatter])
                    {
                        [nav popViewControllerAnimated:NO];
                        EMChatType messageType = [userInfo[kMessageType] intValue];
                        
                        chatViewController = [[ChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
                        [nav pushViewController:chatViewController animated:NO];
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
                [nav pushViewController:chatViewController animated:NO];
            }
        }];
    }
    else if (_chatListVC)
    {
        //        [self.navigationController popToViewController:self animated:NO];
        //        [self setSelectedViewController:_chatListVC];
        [self setSelectedIndex:2];
    }
}

- (void)didReceiveUserNotification:(UNNotification *)notification
{
    NSDictionary *userInfo = notification.request.content.userInfo;
    if (userInfo)
    {
//        if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
//            //            ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
//            //            [chatController hideImagePicker];
//        }
        
        BaseNavigationController *nav = (BaseNavigationController *)self.viewControllers[2];
        
        NSArray *viewControllers = nav.viewControllers;
        [viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            if (obj != self)
            {
                if (![obj isKindOfClass:[ChatViewController class]])
                {
                    [nav popViewControllerAnimated:NO];
                }
                else
                {
                    NSString *conversationChatter = userInfo[kConversationChatter];
                    ChatViewController *chatViewController = (ChatViewController *)obj;
                    if (![chatViewController.conversation.conversationId isEqualToString:conversationChatter])
                    {
                        [nav popViewControllerAnimated:NO];
                        EMChatType messageType = [userInfo[kMessageType] intValue];
                        
                        chatViewController = [[ChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
                        [nav pushViewController:chatViewController animated:NO];
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
                [nav pushViewController:chatViewController animated:NO];
            }
        }];
    }
    else if (_chatListVC)
    {
        //        [self.navigationController popToViewController:self animated:NO];
        //        [self setSelectedViewController:_chatListVC];
        [self setSelectedIndex:2];
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
*/


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
