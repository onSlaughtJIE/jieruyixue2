//
//  JRLoginViewController.m
//  JRMedical
//
//  Created by apple on 16/5/7.
//  Copyright © 2016年 ZC. All rights reserved.
//

#import "JRLoginViewController.h"

#import "JRRegistViewController.h"
#import "RootTabBarController.h"

#import "IQKeyboardManager.h"
#import "ApplyViewController.h"

#import "JPUSHService.h"

@interface JRLoginViewController ()<UITextFieldDelegate>
{
    MBProgressHUD * _HUD;
}

@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIView *thirdView;
@property (weak, nonatomic) IBOutlet UIView *fourthView;


@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *passWordTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;


- (IBAction)loginBtn:(UIButton *)sender;
- (IBAction)forgetPassBtn:(UIButton *)sender;
- (IBAction)registBtn:(UIButton *)sender;

@end

@implementation JRLoginViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    [self.phoneTF endEditing:YES];
    [self.passWordTF endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Main_Color;

    [self setUpIconAndOther];//设置页面视图 和 其他 UI属性配置
}

#pragma mark - 设置页面视图 和 其他 UI属性配置
- (void)setUpIconAndOther {
    _firstView.layer.borderColor = [[UIColor whiteColor] CGColor];
    _firstView.backgroundColor = Main_Color;
    _firstView.layer.borderWidth = 0.8;
    _firstView.layer.masksToBounds = YES;
    
    _secondView.layer.borderColor = [[UIColor whiteColor] CGColor];
    _secondView.backgroundColor = Main_Color;
    _secondView.layer.borderWidth = 0.8;
    _secondView.layer.masksToBounds = YES;
    
    _thirdView.layer.borderColor = [[UIColor whiteColor] CGColor];
    _thirdView.backgroundColor = Main_Color;
    _thirdView.layer.borderWidth = 1.5;
    _thirdView.layer.masksToBounds = YES;
//    _fourthView.layer.borderColor = [[UIColor whiteColor] CGColor];
//    _fourthView.layer.borderWidth = 2;
    
    self.passWordTF.delegate = self;
    self.phoneTF.delegate = self;
    
    self.passWordTF.secureTextEntry = YES;
    
    self.phoneTF.returnKeyType = UIReturnKeyDone;
    self.phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    
    self.passWordTF.returnKeyType = UIReturnKeyDone;
    self.passWordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passWordTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    [self.phoneTF addTarget:self action:@selector(phoneLengthCheck:) forControlEvents:(UIControlEventEditingChanged)];
    
    _loginBtn.tintColor = Main_Color;
}

#pragma mark - Btn Actions
#pragma mark  登录按钮
- (IBAction)loginBtn:(UIButton *)sender {
    
    [self.phoneTF endEditing:YES];
    [self.passWordTF endEditing:YES];

    if ([Utils isBlankString:self.phoneTF.text] == YES) {
        [self showMessage:@"请输入您的手机号"];
        return;
    }
    if ([Utils isBlankString:self.passWordTF.text] == YES) {
        [self showMessage:@"请输入密码"];
        return;
    }
    
    NSString *registUrl = @"api/Users/UserLogin";
    NSString *datasStr = [NSString stringWithFormat:@"ZICBDYCUserName=%@ZICBDYCPwd=%@", self.phoneTF.text,self.passWordTF.text, nil];
    
    [self showLoadding:@"正在登录" time:20];
    [self loadDataApi:registUrl withParams:datasStr block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"登录 - %@", modelData);
        if (isSuccess) {
            [self showImage:SUCCESS_ICON time:1 message:@"登录成功"];
            
            //方便下次登录免输入账号
            NSUserDf_Set(self.phoneTF.text,@"userPhone");
            
            [UserInfo setAccessToken:modelData[@"JsonData"][@"AccessToken"]];//存入token
            [UserInfo setDevIdentity:modelData[@"DevIdentity"]];//存入单点登录值
            NSUserDf_Set(kYesLogin, JRIsLogin);//存入登录状态
            NSUserDf_Set(modelData[@"JsonData"][@"UserPic"], kUserPic);//用户头像地址
            
            NSString *IsDoctor = modelData[@"JsonData"][@"IsDoctor"];
            NSUserDf_Set(IsDoctor, kDoctor);//是否是医师
            
            NSUserDf_Set(modelData[@"JsonData"][@"HXName"], kHXName);//环信用户名
            NSUserDf_Set(modelData[@"JsonData"][@"HXPwd"], kHXPwd);//环信密码
            
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                
                RootTabBarController *rootTabBarVC = [[RootTabBarController alloc] init];
                UIWindow * window = [UIApplication sharedApplication].keyWindow;
                window.rootViewController = rootTabBarVC;
            });
            
            NSLog(@"环信用户%@^^^^密码%@",NSUserDf_Get(kHXName),NSUserDf_Get(kHXPwd));
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                EMError *error = [[EMClient sharedClient] loginWithUsername:NSUserDf_Get(kHXName) password:NSUserDf_Get(kHXPwd)];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (!error) {
                        [AFManegerHelp getUserMessage];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
                        
                        // 加载数据
                        [self asyncConversationFromDB];
                        
                        NSLog(@"环信登录成功");
                        [[ApplyViewController shareController] loadDataSourceFromLocalDB];
                        
                    } else {
                        NSLog(@"环信登录失败---------%d", error.code);
                    }
                });
            });
            
            // 单独设置推送设置
//            [[EMClient sharedClient] setApnsNickname:@""];
            
            // 设置别名
            [JPUSHService setAlias:modelData[@"JsonData"][@"HXName"] callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];

            
        }
        else {
            NSString *msg  = [modelData objectForKey:@"Msg"];
            if (msg!=nil && ![msg isEqual:@""]) {
                [self showMessage:msg];
            }
            else {
                [self showMessage:[NSString stringWithFormat:@"请求失败 #%d",code]];
            }
        }
    }];
}

- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    
    NSString *callbackString = [NSString stringWithFormat:@"%d, \ntags: %@, \nalias: %@\n", iResCode, tags, alias];
    
    NSLog(@"TagsAlias回调:%@", callbackString);
}

- (void)asyncConversationFromDB
{
    __weak typeof(self) weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *array = [[EMClient sharedClient].chatManager getAllConversations];
        [array enumerateObjectsUsingBlock:^(EMConversation *conversation, NSUInteger idx, BOOL *stop){
            if(conversation.latestMessage == nil){
                [[EMClient sharedClient].chatManager deleteConversation:conversation.conversationId isDeleteMessages:NO completion:nil];
            }
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakself.conversationListVC) {
                NSLog(@"12344");
                //                [weakself.conversationListVC refreshDataSource];
            }
            
            if (weakself.mainController) {
                //                [weakself.mainController setupUnreadMessageCount];
                NSLog(@"1eeee2344");
            }
        });
        
    });
}

#pragma mark 忘记密码
- (IBAction)forgetPassBtn:(UIButton *)sender {
    JRRegistViewController *forgetVC = [[JRRegistViewController alloc] init];
    BaseNavigationController *forgetNC = [[BaseNavigationController alloc] initWithRootViewController:forgetVC];
    forgetVC.navigationItem.title = @"忘记密码";
    [self presentViewController:forgetNC animated:YES completion:^{
        
        forgetVC.passTelNumBer = ^(NSString *telText) {
            self.phoneTF.text = telText;
        };
    }];
}
#pragma mark 注册按钮
- (IBAction)registBtn:(UIButton *)sender {
    JRRegistViewController *registVC = [[JRRegistViewController alloc] init];
    BaseNavigationController *registNC = [[BaseNavigationController alloc] initWithRootViewController:registVC];
    registVC.title = @"用户注册";
    [self presentViewController:registNC animated:YES completion:^{
        registVC.passTelNumBer = ^(NSString *telText) {
            self.phoneTF.text = telText;
        };
    }];
}

#pragma mark--
#pragma mark           UITextFildDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 手机号检查输入长度
- (void)phoneLengthCheck:(UITextField *)sender {
//    NSLog(@"sender.text.length - %lu", sender.text.length);
    if ([sender.text length] > 11) {
        sender.text = [sender.text substringToIndex:11];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
