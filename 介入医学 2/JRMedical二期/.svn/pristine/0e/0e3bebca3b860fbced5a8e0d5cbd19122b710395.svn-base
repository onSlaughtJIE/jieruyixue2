//
//  BaseTableViewController.m
//  liuzhiyuan
//
//  Created by a on 16/11/3.
//  Copyright © 2016年 刘志远. All rights reserved.
//

#import "BaseTableViewController.h"
#import <YYKit.h>

#import "JRLoginViewController.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController {
    RefreshType refType;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - 接口请求
-(void)setParam:(NSString *)key model:(NSObject *)value{
    if(self.params == nil){
        self.params = [[NSMutableDictionary alloc] init];
    }
    [self.params setObject:value forKey:key];
}

- (void)loadDataApi:(NSString*)api withParams:(NSString *)params refresh:(RefreshType)type model:(Class)modelClass {
    self.api = api;
    self.paramsStr = params;
    self.modelClass = modelClass;
    self.page = 0;
    
    refType = type;
    
    if( self.pageSize == 0){
        self.pageSize = COMMON_PAGE_SIZE;
    }
    switch (type) {
        case RefreshTypeNone:
        {
            self.tableView.mj_header = nil;
            self.tableView.mj_footer = nil;
            [self requestTableViewNetWork];
        }
            break;
        case RefreshTypeHeader:
        {
            self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
            self.tableView.mj_footer = nil;
            
            if (self.isStartRefresh) {
                [self.tableView.mj_header beginRefreshing];
            }
            else {
                [self requestTableViewNetWork];
            }
        }
            break;
        case RefreshTypeFooter:
        {
            self.tableView.mj_header = nil;
            self.tableView.mj_footer = nil;
            [self requestTableViewNetWork];
        }
            break;
        case RefreshTypeBoth:
        {
            self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
            self.tableView.mj_footer = nil;
            
            if (self.isStartRefresh) {
                [self.tableView.mj_header beginRefreshing];
            }
            else {
                [self requestTableViewNetWork];
            }
        }
            break;
        default:
            break;
    }
}

-(void)headerRefresh{
    self.page = 0;
    [self requestTableViewNetWork];
}
-(void)footerRefresh{
    self.page ++ ;
    [self requestTableViewNetWork];
}

- (void)requestTableViewNetWork {
    
    NSString *totaParamsStr = [NSString stringWithFormat:@"%@ZICBDYCCurPage=%dZICBDYCPageSize=%d",self.paramsStr,self.page,self.pageSize];
    
    NSString *paraStr = kTotalEncryptionInfo(totaParamsStr);
    NSString *Datas = [TWDes encryptWithContent:paraStr type:kDesType key:kDesKey];
    
    NSString *token = [UserInfo getAccessToken];
    if (token != nil ) {
        [self setParam:@"Token" model:token];
    }
    
    [self setParam:kDatas model:Datas];
    
    if (self.openDebug) {
        [HYBNetworking enableInterfaceDebug:YES];
    }
    
    [HYBNetworking updateBaseUrl:Server_Int_Url];
    
    [HYBNetworking configRequestType:kHYBRequestTypePlainText];
    [HYBNetworking postWithUrl:self.api
                        params:self.params
                       success:^(id response) {
                           [self.hud hide:YES];
                           
                           int code = [[response objectForKey:@"Code"] intValue];
                           BOOL isSuccess = [[response objectForKey:@"Success"] boolValue];
                           NSArray *dataAry = [response objectForKey:@"JsonData"];
                           
                           NSLog(@"%@",response);
                           
                           if(self.dataSource == nil){
                               self.dataSource = [[NSMutableArray alloc] init];
                           }
                        
                           
                           if (isSuccess) {
                               
                               if (self.page == 0) {
                                   [self.dataSource removeAllObjects];
                               }
                               
                               NSArray *data =nil;
                               if (self.modelClass == nil) {
                                   data = dataAry;
                               }
                               else {
                                   data = [NSArray modelArrayWithClass:self.modelClass json:dataAry];
                               }
                               
                               [self.dataSource addObjectsFromArray:data];

                           }
                           else {
                               NSString *msg  = [response objectForKey:@"Msg"];
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
                               else {
                                   [self showMessage:[NSString stringWithFormat:@"请求失败 #%d",code]];
                               }
                           }
                           
                           [self.tableView reloadData];
                           
                           if (refType != RefreshTypeNone && refType != RefreshTypeHeader) {
                               if (self.dataSource.count >= self.pageSize) {
                                   self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
                               }
                           }
                           
                           if (self.tableView.mj_footer != nil) {
                               if (self.pageSize > dataAry.count) {
                                   [self.tableView.mj_footer endRefreshingWithNoMoreData];
                               }
                               else {
                                   [self.tableView.mj_footer endRefreshing];
                               }
                           }
                           
                           if (self.tableView.mj_header != nil) {
                               [self.tableView.mj_header endRefreshing];
                           }
                           
                           if (self.page == 0) {
                               if (self.baseFinishBlock != nil) {
                                   self.baseFinishBlock(dataAry);
                               }
                           }
                       }
                          fail:^(NSError *error) {

                              [self showMessage:@"服务器开小差了~请稍后再试"];
                              
                              if (self.tableView.mj_header != nil) {
                                  [self.tableView.mj_header endRefreshing];
                              }
                              if (self.tableView.mj_footer != nil) {
                                  [self.tableView.mj_footer endRefreshing];
                              }
                              
                              if (self.page == 0) {
                                  if (self.baseFinishBlock != nil) {
                                      self.baseFinishBlock(nil);
                                  }
                              }
                          }];
}

#pragma mark - 检测网络状态
- (void)checkNetwork {
    [self checkNetwork:0];
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
//             [self showMessage:@"无网络连接，请检查您的网络状态"];
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

#pragma mark - 透明指示层
- (void)showImage:(NSString *)name time:(NSTimeInterval)time message:(NSString *)message {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    if (self.hud != nil) {
        [self.hud hide:YES];
    }
    self.hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    
    // Set the custom view mode to show any view.
    self.hud.mode = MBProgressHUDModeCustomView;
    // Set an image view with a checkmark.
    UIImage *image = [[UIImage imageNamed:name] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.hud.customView = [[UIImageView alloc] initWithImage:image];
    // Looks a bit nicer if we make it square.
    self.hud.square = YES;
    // Optional label text.
    self.hud.labelText = message;
    self.hud.margin = 20.f;
    self.hud.opacity = 0.7;
    self.hud.cornerRadius = 4;
    self.hud.removeFromSuperViewOnHide = YES;
    [self.hud hide:YES afterDelay:time];
}

- (void)showMessage:(NSString *)message {
    [self showMessage:message time:1.5];
}
- (void)showMessage:(NSString *)message time:(NSTimeInterval)time {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    if (self.hud != nil) {
        [self.hud hide:YES];
    }
    self.hud = [MBProgressHUD showHUDAddedTo:window
                                    animated:YES];
    self.hud.mode = MBProgressHUDModeText;
    self.hud.labelText = message;
    self.hud.labelFont = [UIFont systemFontOfSize:14];
    //self.hud.yOffset = -(WIDTH_SCREEN / 2 - HEIGHT_NAVBAR - 30);
    self.hud.margin = 15.f;
    self.hud.opacity = 0.7;
    self.hud.cornerRadius = 4;
    self.hud.removeFromSuperViewOnHide = YES;
    [self.hud hide:YES afterDelay:time];
}

- (void)showMessage:(NSString *)message time:(NSTimeInterval)time view:(UIView *)view {
    
    if (self.hud != nil) {
        [self.hud hide:YES];
    }
    self.hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    self.hud.mode = MBProgressHUDModeText;
    self.hud.labelText = message;
    self.hud.labelFont = [UIFont systemFontOfSize:14];
    self.hud.yOffset = -(Width_Screen / 2 - Height_Screen - 80);
    self.hud.margin = 15.f;
    self.hud.opacity = 0.7;
    self.hud.cornerRadius = 4;
    self.hud.removeFromSuperViewOnHide = YES;
    if(time != 0){
        [self.hud hide:YES afterDelay:time];
    }
}

- (void)showLoadding:(NSString *)message {
    [self showLoadding:message time:3];
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

- (void)showLoadding:(NSString *)message time:(NSTimeInterval)time view:(UIView *)view {
    
    if (self.hud != nil) {
        [self.hud hide:YES];
    }
    self.hud = [MBProgressHUD showHUDAddedTo:view
                                    animated:YES];
    self.hud.labelText = message;
    self.hud.labelFont = [UIFont systemFontOfSize:12];
    self.hud.margin = 8.f;
    self.hud.opacity = 0.7;
    self.hud.cornerRadius = 4;
    self.hud.removeFromSuperViewOnHide = YES;
    if(time != 0){
        [self.hud hide:YES afterDelay:time];
    }
}

#pragma mark - alert
- (void)alert:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:message delegate:self cancelButtonTitle:@"" otherButtonTitles:nil];
    [alertView show];
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
