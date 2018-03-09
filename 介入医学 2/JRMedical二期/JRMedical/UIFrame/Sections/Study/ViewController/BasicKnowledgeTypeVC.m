//
//  BasicKnowledgeTypeVC.m
//  JRMedical
//
//  Created by a on 16/11/15.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "BasicKnowledgeTypeVC.h"

#import "BasicKnowledgeListVC.h"
#import "SCNavTabBarController.h"
#import "SCNavTabBar.h"
#import "SearchVC.h"

#import "AllCategoryCollectionVC.h"

#import "JRLoginViewController.h"

@interface BasicKnowledgeTypeVC ()<SCNavTabBarControllerDelegate>

@property (nonatomic, strong) NSMutableArray *tableviewArray;

@property (nonatomic, strong) NSMutableArray *nameArray;
@property (nonatomic, strong) NSMutableArray *groupCodeArray;
@property (nonatomic, strong) NSMutableArray *valueArray;
@property (nonatomic, strong) NSMutableArray *lableValueLst;
@property (nonatomic, strong) NSMutableArray *typeListArray;

@property (nonatomic, strong) SCNavTabBar *navBar;
@property (nonatomic, strong) SCNavTabBarController *scVC;

@end

@implementation BasicKnowledgeTypeVC {
    
    NSInteger _curSelectdItem;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefreshDataAfterSorting" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"基础知识";
    self.view.backgroundColor = BG_Color;
    
    self.typeListArray = [NSMutableArray array];
    
    //设置导航栏右边按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"searchr"] style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarButtonItemClick)];
    
    _curSelectdItem = 0;//默认选择第一个分类
    
    [self checkNetwork:0];//检测网络状态
    
    [self requestCategoryData];//获取分类数据
    
    self.tableviewArray = [NSMutableArray arrayWithCapacity:0];
    
    WeakSelf;
    self.passLearnArr = ^(NSMutableArray *titleArray, NSMutableArray *groupCodeArray, NSMutableArray *valueArray, NSMutableArray *lableValueLst){
        for (int i = 0; i < titleArray.count; i++) {
            BasicKnowledgeListVC *tabVC = [[BasicKnowledgeListVC  alloc]init];
            tabVC.title = titleArray[i];
            tabVC.valueString = valueArray[i];
            tabVC.groupCode = groupCodeArray[i];
            tabVC.LableValueLst = lableValueLst[i];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDataAfterSortingClick:) name:@"RefreshDataAfterSorting" object:nil];
}

#pragma mark - 选择分类下的分类后刷新数据的通知
- (void)refreshDataAfterSortingClick:(NSNotification *)sender {
    
    //通过此通知方法  可以获得 由 AllCategoryCollectionVC 全部分类 页面传出来的 数据  当前选中的第几个 分类  分类下面都选择了那些小标签等等
    
    //当前选择的 分类
    _curSelectdItem = [sender.userInfo[@"CurSelectdItem"] integerValue];
    
    //此处为更新 在全部分类里面 传出来的 当前视图选择
    self.navBar.currentItemIndex = _curSelectdItem;
    [self.scVC.mainView setContentOffset:CGPointMake(_curSelectdItem * Width_Screen, 0.0f) animated:YES];
    
    //当前选择的 分类 下的 标签
    NSString *lableValueLstStrings = sender.userInfo[@"LableValueLstStrings"];
    
    //替换 当前选中分类下 的标签
    [self.lableValueLst replaceObjectAtIndex:_curSelectdItem withObject:lableValueLstStrings];
    
    NSLog(@"%ld",self.lableValueLst.count);
    
    NSMutableDictionary *allInfoDic = [[NSMutableDictionary alloc] init];
    [allInfoDic setObject:self.lableValueLst forKey:@"LableValueLstStringss"];
    [allInfoDic setObject:self.typeListArray forKey:@"typeListAry"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshDataAfterSortingss" object:nil userInfo:allInfoDic];
}

#pragma mark- 分类按钮点击的 回调 代理
- (NSInteger)selectedItemWithIndex:(NSInteger)index {
    
    //通过此代理方法  可以获得 当前选中的是哪个分类(控制器)
    
    _curSelectdItem = index;
    
    return _curSelectdItem;
}

#pragma mark - 搜索
- (void)rightBarButtonItemClick {
    SearchVC *searchVC = [SearchVC new];
    searchVC.groupCode = @"VascularAnatomy";
    searchVC.searchType = @"2";
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)functionButtonPressed {
    AllCategoryCollectionVC *mColleVC = [AllCategoryCollectionVC new];
    mColleVC.typeListArray = self.typeListArray;
    mColleVC.curSelectdItem = _curSelectdItem;//传入当前所在 分类 并显示在 全部分类页面
    BaseNavigationController *mColleNC = [[BaseNavigationController alloc] initWithRootViewController:mColleVC];
    [self presentViewController:mColleNC animated:YES completion:nil];
}

#pragma mark - 获取分类数据
- (void)requestCategoryData {
    
    self.nameArray = [NSMutableArray array];
    self.valueArray = [NSMutableArray array];
    self.groupCodeArray = [NSMutableArray array];
    self.lableValueLst = [NSMutableArray array];
    
    NSString *url = @"api/News/TypeList";
    NSString *params = [NSString stringWithFormat:@"ZICBDYCGroupCode=%@",@"VascularAnatomy"];
    
    [BaseNetwork postLoadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        
        NSLog(@"获取分类数据 - %@",modelData);
        if (isSuccess) {
            
            self.typeListArray = modelData[@"JsonData"];
            
            for (NSDictionary *dic in self.typeListArray) {
                [self.nameArray addObject:dic[@"Name"]];
                [self.groupCodeArray addObject:dic[@"GroupCode"]];
                [self.valueArray addObject:dic[@"Value"]];
                [self.lableValueLst addObject:@""];
            }
            self.passLearnArr(self.nameArray, self.groupCodeArray,self.valueArray,self.lableValueLst);
        }
        else {
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
