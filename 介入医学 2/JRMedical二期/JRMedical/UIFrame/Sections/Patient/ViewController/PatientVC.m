//
//  PatientVC.m
//  JRMedical
//
//  Created by a on 16/11/4.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "PatientVC.h"

#import "SCNavTabBarController.h"
#import "SCNavTabBar.h"

#import "KMButton.h"
#import "PatientListVC.h"
#import "PublishedPostVC.h"
#import "PostAllTypeVC.h"

#import "JRLoginViewController.h"
#import "MyCertificationVC.h"

@interface PatientVC ()<SCNavTabBarControllerDelegate>

@property (nonatomic, strong) NSMutableArray *tableviewArray;

@property (nonatomic, strong) NSMutableArray *nameArray;
@property (nonatomic, strong) NSMutableArray *valueArray;
@property (nonatomic, strong) NSMutableArray *typeListArray;

@property (nonatomic, strong) SCNavTabBar *navBar;
@property (nonatomic, strong) SCNavTabBarController *scVC;

@property (nonatomic, strong) MBProgressHUD *hud;//透明指示层

@end

@implementation PatientVC {
    
    NSInteger _curSelectdItem;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PostAllTypeVCRefreshDataAfterSorting" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    NSInteger isDoctor =  [NSUserDf_Get(kDoctor) integerValue];//是否是医师
    
    if (isDoctor == 0) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"只有认证医生才能查看论坛,是否去认证?(认证通过需要等待审核)" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"返回首页" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
            
            [self.navigationController.tabBarController setSelectedIndex:0];
            
        }];
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"去认证" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            MyCertificationVC *mycer = [MyCertificationVC new];
            [self.navigationController pushViewController:mycer animated:YES];
        }];
        [alertVC addAction:action1];
        [alertVC addAction:action2];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"学术论坛";
    self.view.backgroundColor = BG_Color;
    
    [self setNavBarButtonItem];
    
    self.typeListArray = [NSMutableArray array];
    
    _curSelectdItem = 0;//默认选择第一个分类
    
    [self checkNetwork:0];//检测网络状态
    
    [self requestCategoryData];//获取分类数据
    
    self.tableviewArray = [NSMutableArray arrayWithCapacity:0];
    
    WeakSelf;
    self.passLearnArr = ^(NSMutableArray *titleArray, NSMutableArray *valueArray){
        for (int i = 0; i < titleArray.count; i++) {
            PatientListVC *tabVC = [[PatientListVC  alloc]init];
            tabVC.title = titleArray[i];
            tabVC.valueString = valueArray[i];
            tabVC.vcTag = i + 1000;
            [wself.tableviewArray addObject:tabVC];
        }
        wself.scVC = [[SCNavTabBarController alloc] initWithSubViewControllers:wself.tableviewArray];
        wself.scVC.showArrowButton = YES;
        wself.scVC.scrollAnimation = YES;
        wself.scVC.mainViewBounces = YES;
        wself.scVC.delegate = wself;
        wself.scVC.navTabBarColor = [UIColor whiteColor];
        [wself.scVC addParentController:wself];
        
        wself.navBar = wself.scVC.navTabBar;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:wself action:@selector(functionButtonPressed)];
        [wself.navBar.arrowButton addGestureRecognizer:tapGestureRecognizer];
    };
    
    //选择分类下的分类后刷新数据的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postAllTypeVCrefreshDataAfterSortingClick:) name:@"PostAllTypeVCRefreshDataAfterSorting" object:nil];
}

#pragma mark - 点击发帖
- (void)navBarButtonItemClick {
    PublishedPostVC *ppVC = [PublishedPostVC new];
    [self.navigationController pushViewController:ppVC animated:YES];
}

#pragma mark - 选择分类下的分类后刷新数据的通知
- (void)postAllTypeVCrefreshDataAfterSortingClick:(NSNotification *)sender {
    
    //通过此通知方法  可以获得 由 AllCategoryCollectionVC 全部分类 页面传出来的 数据  当前选中的第几个 分类  分类下面都选择了那些小标签等等
    
    //当前选择的 分类
    _curSelectdItem = [sender.userInfo[@"CurSelectdItem"] integerValue];
    
    //此处为更新 在全部分类里面 传出来的 当前视图选择
    self.navBar.currentItemIndex = _curSelectdItem;
    [self.scVC.mainView setContentOffset:CGPointMake(_curSelectdItem * Width_Screen, 0.0f) animated:YES];
    
    NSMutableDictionary *allInfoDic = [[NSMutableDictionary alloc] init];
    [allInfoDic setObject:self.typeListArray forKey:@"typeListAry"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"postAllTypeRefreshDataAfterSortingss" object:nil userInfo:allInfoDic];
}

#pragma mark- 分类按钮点击的 回调 代理
- (NSInteger)selectedItemWithIndex:(NSInteger)index {
    
    //通过此代理方法  可以获得 当前选中的是哪个分类(控制器)
    
    _curSelectdItem = index;
    
    return _curSelectdItem;
}

- (void)functionButtonPressed {
    PostAllTypeVC *ptVC = [PostAllTypeVC new];
    ptVC.typeListArray = self.typeListArray;
    ptVC.curSelectdItem = _curSelectdItem;//传入当前所在 分类 并显示在 全部分类页面
    BaseNavigationController *ptNC = [[BaseNavigationController alloc] initWithRootViewController:ptVC];
    [self presentViewController:ptNC animated:YES completion:nil];
}

#pragma mark - 获取分类数据
- (void)requestCategoryData {
    
    self.nameArray = [NSMutableArray array];
    self.valueArray = [NSMutableArray array];
    
    NSString *url = @"api/Post/GetPostDictTypeList";
    NSString *params = @"";
    
    [self showLoadding:@"正在加载" time:20];
    [BaseNetwork postLoadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        [self.hud hide:YES];
        NSLog(@"获取分类数据 - %@",modelData);
        if (isSuccess) {
            
            self.typeListArray = modelData[@"JsonData"];
            
            for (NSDictionary *dic in self.typeListArray) {
                [self.nameArray addObject:dic[@"Name"]];
                [self.valueArray addObject:dic[@"Value"]];
            }
            self.passLearnArr(self.nameArray, self.valueArray);
        }
        else {
            [self.hud hide:YES];
            if (code == 999) {
                [self showHint:@"服务器开小差了~请稍后再试"];
                return ;
            }
            NSString *msg  = [modelData objectForKey:@"Msg"];
            if (msg!=nil && ![msg isEqual:@""]) {
                [self showHint:msg];
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
                [self showHint:[NSString stringWithFormat:@"请求失败 #%d",code]];
            }
        }
    }];
}

- (void)checkNetwork:(NSInteger)level {
    
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager]
     setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
         if (status == AFNetworkReachabilityStatusUnknown &&
             level >= AFNetworkReachabilityStatusUnknown) {
             [self alert:@"无法获取网络状态"];
         } else if (status == AFNetworkReachabilityStatusNotReachable &&
                    level >= AFNetworkReachabilityStatusNotReachable) {
             [self alert:@"无网络连接，请检查您的网络状态"];
         } else if (status == AFNetworkReachabilityStatusReachableViaWWAN &&
                    level >= AFNetworkReachabilityStatusReachableViaWWAN) {
             [self alert:@"您正在使用数据流量"];
         } else if (status == AFNetworkReachabilityStatusReachableViaWiFi &&
                    level >= AFNetworkReachabilityStatusReachableViaWiFi) {
             [self alert:@"您正在使用WIFI网络"];
         }
     }];
}

#pragma mark - alert
- (void)alert:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:message delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - 设置顶栏右侧按钮
- (void)setNavBarButtonItem {
    
    KMButton *imgBtn = [KMButton buttonWithType:UIButtonTypeSystem];
    imgBtn.spacing = 5;
    imgBtn.kMButtonType = KMButtonLeft;
    imgBtn.size = CGSizeMake(65, 44);
    imgBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [imgBtn setTitle:@"发帖" forState:UIControlStateNormal];
    [imgBtn setImage:[UIImage imageNamed:@"fatiez"] forState:UIControlStateNormal];
    [imgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [imgBtn setTintColor:[UIColor whiteColor]];
    [imgBtn addTarget:self action:@selector(navBarButtonItemClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imgBtn];
}

- (void)showLoadding:(NSString *)message time:(NSTimeInterval)time {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    if (self.hud != nil) {
        [self.hud hide:YES];
    }
    self.hud = [MBProgressHUD showHUDAddedTo:window
                                    animated:YES];
    self.hud.labelText = message;
    self.hud.margin = 20.f;
    self.hud.opacity = 0.7;
    self.hud.cornerRadius = 4;
    self.hud.removeFromSuperViewOnHide = YES;
    if(time != 0){
        [self.hud hide:YES afterDelay:time];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
