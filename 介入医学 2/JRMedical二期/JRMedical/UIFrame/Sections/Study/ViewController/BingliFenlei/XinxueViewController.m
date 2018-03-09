//
//  XinxueViewController.m
//  JRMedical
//
//  Created by ww on 2017/1/16.
//  Copyright © 2017年 idcby. All rights reserved.
//

#import "XinxueViewController.h"
#import "XinxueListViewController.h"
#import "SCNavTabBarController.h"
#import "JRLoginViewController.h"

@interface XinxueViewController ()

@property (nonatomic, strong) NSMutableArray *tableviewArray;
@property (nonatomic, strong) NSMutableArray *nameArray;
@property (nonatomic, strong) NSMutableArray *typeIdArray;
@property (nonatomic, strong) NSMutableArray *picArray;
@property (nonatomic, strong) NSMutableArray *memoArray;

@end

@implementation XinxueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BG_Color;
    
    [self getTypeList];
    
    self.tableviewArray = [NSMutableArray arrayWithCapacity:0];
    WeakSelf;
    self.passTypeArr = ^(NSMutableArray *titleArray, NSMutableArray *typeIdArray,NSMutableArray *lunboArr, NSMutableArray *memoArr){
        
        for (int i = 0; i < titleArray.count; i++) {
            XinxueListViewController *tabVC = [[XinxueListViewController alloc]init];
            tabVC.title = titleArray[i];
            tabVC.LableID = typeIdArray[i];
            tabVC.memo = memoArr[i];
            tabVC.lunboArr = lunboArr;
            [wself.tableviewArray addObject:tabVC];
            
        }
        SCNavTabBarController *scVC = [[SCNavTabBarController alloc]initWithSubViewControllers:wself.tableviewArray];
        scVC.showArrowButton = NO;
        scVC.scrollAnimation = YES;
        scVC.mainViewBounces = YES;
        scVC.navTabBarColor = BG_Color;
        scVC.fromBingliFenlei = @"fromBingliFenlei";
        [scVC addParentController:wself];
        
    };
}

- (void)getTypeList {
    
    self.nameArray = [NSMutableArray array];
    self.typeIdArray = [NSMutableArray array];
    self.picArray = [NSMutableArray array];
    self.memoArray = [NSMutableArray array];
    
    NSString *url = @"api/CaseCatalogue/ItemList";
    NSString *params = [NSString stringWithFormat:@"ZICBDYCTypeID=%@", self.TypeID];
    
    [self showHudInView:self.view hint:@"获取分类数据"];
    [BaseNetwork postLoadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        
        NSLog(@"心血管获取分类数据 - %@",modelData);
        if (isSuccess) {
            
            [self hideHud];
            NSArray *jsonArr = modelData[@"JsonData"];
            for (NSDictionary *dic in jsonArr) {
                [self.nameArray addObject:dic[@"LableName"]];
                [self.typeIdArray addObject:dic[@"ID"]];
                [self.memoArray addObject: dic[@"Memo"]];
                self.picArray = dic[@"PicList"];
                
            }
            self.passTypeArr(self.nameArray, self.typeIdArray, self.picArray, self.memoArray);
        }
        else {
            [self hideHud];
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
