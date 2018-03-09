//
//  UCloudLiveViewController.m
//  JRMedical
//
//  Created by ww on 2016/12/3.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "UCloudLiveViewController.h"
#import <Foundation/Foundation.h>
#import "AppDelegate.h"

#import "EaseChatView.h"
#import "UIViewController+DismissKeyboard.h"
#import "EaseChatViewController.h"
#import "AppDelegate.h"
#import "EaseBarrageFlyView.h"
#import "UIImage+Color.h"
#import "EaseLiveCastView.h"
#import "EaseConversationViewController.h"
#import "EasePublishModel.h"

#define kDefaultTop 31.f
#define kDefaultLeft 18.f

@interface UCloudLiveViewController ()<EaseChatViewDelegate, EMChatroomManagerDelegate, UIAlertViewDelegate>
{
    BOOL _isExpand;
}

@property (nonatomic, copy) NSString *playRtmpUrl;
@property (nonatomic) BOOL barHidden;

@property (nonatomic, strong) UIView *liveView;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) EaseChatView *chatview;
@property (nonatomic, strong) EaseLiveCastView *castView;
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIButton *expandBtn;

@end

@implementation UCloudLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.liveView = [[UIView alloc] init];
    [self.view addSubview:self.liveView];
    [self.liveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view).offset(0);
    }];
    
    // ucloud直播
    [self playLive];
    
    // 环信Chat
    [self.liveView addSubview:self.castView];
    [self.liveView addSubview:self.chatview];
    
    self.closeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.closeBtn setImage:[UIImage imageNamed:@"live_close_gray"] forState:(UIControlStateNormal)];
    [self.closeBtn addTarget:self action:@selector(closeLive:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.liveView addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.top.equalTo(_liveView).offset(30);
        make.right.equalTo(_liveView).offset(-15);
    }];
    
    self.expandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.expandBtn setImage:[UIImage imageNamed:@"yincang"] forState:(UIControlStateNormal)];
    [self.expandBtn addTarget:self action:@selector(expandAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.liveView addSubview:self.expandBtn];
    [self.expandBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.top.equalTo(_liveView).offset(30);
        make.right.equalTo(_closeBtn.mas_left).offset(-10);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    __weak UCloudLiveViewController *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL ret = [weakSelf.chatview joinChatroom];
        if (ret) {
            NSLog(@"weakSelf.chatview joinChatroom - 进入聊天室");
            //            [weakSelf.headerListView loadHeaderListWithChatroomId:kDefaultChatroomId];
            [[EMClient sharedClient].roomManager getChatroomSpecificationFromServerByID:_model.ChatRoomsID includeMembersList:YES completion:^(EMChatroom *aChatroom, EMError *aError) {
                
                self.castView.onlineNumLab.text = [NSString stringWithFormat:@"在线人数 : %ld人", (long)aChatroom.membersCount];
                
            }];
        }
    });
    
    [[EMClient sharedClient].roomManager addDelegate:self delegateQueue:nil];
    
    [self setupForDismissKeyboard];
    
    // 调接口
    /*
     
     打开直播时新增播放次数：api/LiveVideo/AddPlay  LiveVideoID直播ID
     进入直播时 新增在线人数： api/LiveVideo/AddOnlineNumber  LiveVideoID直播ID Number人数 打开时+1 退出直播时-1
     */
    
    [self AddPlayCount];
//    [self AddOnlineNumberWithNumStr:@"1"]; // 从环信聊天室获取在线人数, 不调接口了
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[EMClient sharedClient].roomManager removeDelegate:self];
    _chatview.delegate = nil;
}

#pragma mark - getter

- (UIWindow*)window
{
    if (_window == nil) {
        _window = [[UIWindow alloc] initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth, 290.f)];
    }
    return _window;
}

- (EaseLiveCastView*)castView
{
    if (_castView == nil) {
        _castView = [[EaseLiveCastView alloc] initWithFrame:CGRectMake(kDefaultLeft, kDefaultTop, 120.f, 60.f) model:_model];
        
    }
    return _castView;
}

- (EaseChatView*)chatview
{
    if (_chatview == nil) {
        NSString *chatroomId = @"";
        if (_model.ChatRoomsID.length > 0) {
            chatroomId = [_model.ChatRoomsID copy];
        }
        NSLog(@"chatroomId - %@", chatroomId);
        _chatview = [[EaseChatView alloc] initWithFrame:CGRectMake(0, 220, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame) - 220) chatroomId:chatroomId];
        _chatview.delegate = self;
    }
    return _chatview;
}


#pragma mark - EaseChatViewDelegate

- (void)easeChatViewDidChangeFrameToHeight:(CGFloat)toHeight
{
    if ([self.window isKeyWindow]) {
        return;
    }
    if (!self.chatview.hidden) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect = self.chatview.frame;
            rect.origin.y = self.view.frame.size.height - toHeight;
            self.chatview.frame = rect;
        }];
    }
}

- (void)didReceiveBarrageWithCMDMessage:(EMMessage *)message
{
    EaseBarrageFlyView *barrageFlyView = [[EaseBarrageFlyView alloc] initWithMessage:message];
    [self.view addSubview:barrageFlyView];
    [barrageFlyView animateInView:self.view];
}

#pragma mark - EMChatroomManagerDelegate

- (void)didReceiveUserJoinedChatroom:(EMChatroom *)aChatroom username:(NSString *)aUsername
{
//    if ([aChatroom.chatroomId isEqualToString:kDefaultChatroomId]) {
//        [_headerListView joinChatroomWithUsername:aUsername];
//    }
    
    if ([aChatroom.chatroomId isEqualToString:self.model.ChatRoomsID]) {
        NSLog(@"有人进入了");
        [[EMClient sharedClient].roomManager getChatroomSpecificationFromServerByID:_model.ChatRoomsID includeMembersList:YES completion:^(EMChatroom *aChatroom, EMError *aError) {
            
            self.castView.onlineNumLab.text = [NSString stringWithFormat:@"在线人数 : %ld人", (long)aChatroom.membersCount];
            
        }];
    }
}

- (void)didReceiveUserLeavedChatroom:(EMChatroom *)aChatroom username:(NSString *)aUsername
{
//    if ([aChatroom.chatroomId isEqualToString:kDefaultChatroomId]) {
//        [_headerListView leaveChatroomWithUsername:aUsername];
//    }
    
    if ([aChatroom.chatroomId isEqualToString:self.model.ChatRoomsID]) {
        NSLog(@"有人离开了");
        [[EMClient sharedClient].roomManager getChatroomSpecificationFromServerByID:_model.ChatRoomsID includeMembersList:YES completion:^(EMChatroom *aChatroom, EMError *aError) {
            
            self.castView.onlineNumLab.text = [NSString stringWithFormat:@"在线人数 : %ld人", (long)aChatroom.membersCount];
            
        }];
    }
}

#pragma mark - Action
- (void)closeAction
{
    [self.window resignKeyWindow];
    [UIView animateWithDuration:0.3 animations:^{
        self.window.top = KScreenHeight;
    } completion:^(BOOL finished) {
        self.window.hidden = YES;
        [self.view.window makeKeyAndVisible];
    }];
}

- (void)sendButtonAction
{
    //    EaseChatViewController *messageView = [[EaseChatViewController alloc] initWithConversationChatter:_model.userId conversationType:EMConversationTypeChat];
    //
    //    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    //    if (delegate.mainVC) {
    //        [delegate.mainVC.navigationController pushViewController:messageView animated:YES];
    //    }
}


- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat y = endFrame.origin.y;
    
    if ([self.window isKeyWindow]) {
        if (y == KScreenHeight) {
            [UIView animateWithDuration:0.3 animations:^{
                self.window.top = KScreenHeight - 290.f;
                self.window.height = 290.f;
            }];
        } else  {
            [UIView animateWithDuration:0.3 animations:^{
                self.window.top = 0;
                self.window.height = KScreenHeight;
            }];
        }
    }
}

- (void)closeLive:(UIButton *)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"确定退出直播吗?"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    [alertView show];
    
    
}

- (void)expandAction:(UIButton *)sender {
    
    if (_isExpand) {
        self.chatview.hidden = NO;
        [sender setImage:[UIImage imageNamed:@"yincang"] forState:(UIControlStateNormal)];
    } else {
        self.chatview.hidden = YES;
        [sender setImage:[UIImage imageNamed:@"xianshi"] forState:(UIControlStateNormal)];
    }
    _isExpand = !_isExpand;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
//        dispatch_async(dispatch_queue_create("close_dispatch",0), ^{
//            
//            [self.playerManager.mediaPlayer.player.view removeFromSuperview];
//            [self.playerManager.mediaPlayer.player shutdown];
//            self.playerManager.mediaPlayer = nil;
//            self.playerManager = nil;
//            self.barHidden = NO;
//            [self setNeedsStatusBarAppearanceUpdate];
//            
//            [self dismissViewControllerAnimated:NO completion:nil];
//        });
        
        __weak typeof(self) weakself = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            // 退出直播 在线人数减一
//            [self AddOnlineNumberWithNumStr:@"-1"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                BOOL ret = [weakself.chatview leaveChatroom];
                if (ret) {
                    // 离开聊天室 jia motify
                    NSLog(@"weakself.chatview leaveChatroom - 离开聊天室");
                }
                
                [weakself.playerManager.mediaPlayer.player.view removeFromSuperview];
                [weakself.playerManager.mediaPlayer.player shutdown];
                weakself.playerManager.mediaPlayer = nil;
                weakself.playerManager = nil;
                weakself.barHidden = NO;
                [weakself setNeedsStatusBarAppearanceUpdate];
                [weakself dismissViewControllerAnimated:NO completion:nil];
                
            });
        });
    }
    
}


// ----------------------------------- ucloud直播 ----------------------------

- (BOOL)shouldAutorotate
{
    return NO;
    
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
    
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
    
}


- (BOOL)prefersStatusBarHidden
{
    return self.barHidden;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.playerManager)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        
    }
    
}


-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
  
}


- (void)playLive {
    
    //    隐藏导航栏
    self.barHidden = YES;
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.playRtmpUrl = [NSString stringWithFormat:@"rtmp://rtmpjryx.idcby.cn/YouChuangYiLiao/%@", _model.HomeNO];
 
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.vc = self;
    self.playerManager = [[PlayerManager alloc] init];
    self.playerManager.view = self.liveView;
    self.playerManager.viewContorller = self;
    
    float height = 0.f;

    [self.playerManager setSupportAutomaticRotation:NO];
    [self.playerManager setSupportAngleChange:YES];
    
    height = self.view.frame.size.height;
    
    [self.playerManager setPortraitViewHeight:height];
    [self.playerManager buildMediaPlayer:self.playRtmpUrl];
    
}


//- (void)noti:(NSNotification *)noti
//{
//    [[UIApplication sharedApplication] setStatusBarHidden:NO];
//    if ([noti.name isEqualToString:UCloudMoviePlayerClickBack])
//    {
//        
//        
//        /**
//         *  一定要置空
//         */
//        self.playerManager = nil;
//        
////        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
////        delegate.vc = nil;
//        
////        self.barHidden = NO;
////        [self setNeedsStatusBarAppearanceUpdate];
//        
//        [self dismissViewControllerAnimated:YES completion:nil];
//        
//        
//    }
//}


/*
// 以下方法必须实现

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if (self.playerManager)
    {
        return self.playerManager.supportInterOrtation;
    }
    else
    {
        // 这个在播放之外的程序支持的设备方向

        return UIInterfaceOrientationMaskPortrait;
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.playerManager rotateEnd];
    
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.playerManager rotateBegain:toInterfaceOrientation];
}

*/

/*ios8之后 - (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration 被弃用(但是还会调用)，可以使用下面的代理
 - (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
 {
 UIInterfaceOrientation or = UIInterfaceOrientationUnknown;
 if (size.width > size.height)
 {
 or = UIInterfaceOrientationLandscapeLeft;
 }
 else
 {
 or = UIInterfaceOrientationPortrait;
 }
 [[NSNotificationCenter defaultCenter] postNotificationName:UCloudViewControllerWillRotate object:@(or)];
 
 [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
 
 } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
 [[NSNotificationCenter defaultCenter] postNotificationName:UCloudViewControllerDidRotate object:nil];
 }];
 }
 */

// 打开直播时新增播放次数
- (void)AddPlayCount {
    
    NSString *urlS = [NSString stringWithFormat:@"%@api/LiveVideo/AddPlay", Server_Int_Url];
    NSString *dataS = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@ZICBDYCLiveVideoID=%ld", kPrefixPara, kDevIdentity, kDevSysInfo, kDevTypeInfo, kIMEI, (long)_model.ID, nil];
    NSString *dataEncrpyt = [TWDes encryptWithContent:dataS type:kDesType key:kDesKey];
    NSString *token = [UserInfo getAccessToken];
    NSDictionary *paraDic = @{kToken:token, kDatas:dataEncrpyt};
    
    [AFManegerHelp POST:urlS parameters:paraDic success:^(id responseObjeck) {
        
        NSLog(@"打开直播时新增播放次数 - %@", responseObjeck);
        
        if ([responseObjeck[@"Success"] integerValue] == 1) {
            
            
        } else {
            
            NSLog(@"%@", responseObjeck[@"Msg"]);
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
    
}

// 进入直播时 新增在线人数  打开时+1 退出直播时-1
- (void)AddOnlineNumberWithNumStr:(NSString *)num {
    
    NSString *urlS = [NSString stringWithFormat:@"%@api/LiveVideo/AddOnlineNumber", Server_Int_Url];
    NSString *dataS = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@ZICBDYCLiveVideoID=%ldZICBDYCNumber=%@", kPrefixPara, kDevIdentity, kDevSysInfo, kDevTypeInfo, kIMEI, (long)_model.ID, num, nil];
    NSString *dataEncrpyt = [TWDes encryptWithContent:dataS type:kDesType key:kDesKey];
    NSString *token = [UserInfo getAccessToken];
    NSDictionary *paraDic = @{kToken:token, kDatas:dataEncrpyt};
    
    [AFManegerHelp POST:urlS parameters:paraDic success:^(id responseObjeck) {
        
        NSLog(@"进入直播时 新增在线人数 打开时+1 退出直播时-1- %@", responseObjeck);
        
        if ([responseObjeck[@"Success"] integerValue] == 1) {
            
            
        } else {
            NSLog(@"%@", responseObjeck[@"Msg"]);
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
    
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
