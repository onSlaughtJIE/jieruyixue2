//
//  LivingSubViewController.m
//  JRMedical
//
//  Created by ww on 2016/11/23.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "LivingSubViewController.h"
#import "LiveTableViewCell.h"
#import "EasePublishModel.h"
#import <SDCycleScrollView.h>
#import "UITableView+EmpayData.h"
#import <YYKit.h>

#import "JRLoginViewController.h"

@interface LivingSubViewController ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) NSMutableArray *imagesArray; // 轮播图片
@property (nonatomic, strong) NSMutableArray *titlesArray; // 轮播标题
@property (nonatomic, strong) NSMutableArray *HrefArr;     // 轮播图跳转网址

@end

@implementation LivingSubViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefreshDataAfterSortingss" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
//    [self.dataSource addObject:[[EasePublishModel alloc] initWithName:@"jia的直播间" number:@"100人" headImageName:@"2" streamId:@"jia" chatroomId:@"203138578711052716"]];
    [self sethunxinlogin];
    
    //
    self.tableView.backgroundColor = BG_Color;
    self.tableView.separatorColor = BG_Color;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"LiveTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    
    //
    UIView *lunboView = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, Width_Screen, 200))];
    lunboView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = lunboView;
    
    self.imagesArray = [NSMutableArray array];
    self.titlesArray = [NSMutableArray array];
    self.HrefArr = [NSMutableArray array];
    
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:(CGRectMake(0, 0, Width_Screen, 200)) delegate:self placeholderImage:[UIImage imageNamed:@"jiazai"]];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    cycleScrollView.currentPageDotColor = Main_Color;
    cycleScrollView.pageDotColor = [UIColor whiteColor];
//    cycleScrollView.currentPageDotImage = [UIImage imageWithColor:Main_Color size:CGSizeMake(32, 6)];
//    cycleScrollView.pageDotImage = [UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(32, 6)];
    [lunboView addSubview:cycleScrollView];
    self.cycleScrollView = cycleScrollView;
    
    [self requestLiveLunBoData];
    

    //选择分类下的分类后刷新数据的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDataAfterSortingssClick:) name:@"RefreshDataAfterSortingss" object:nil];
    [self GetLiveVideoList];
    
}

#pragma mark - //选择分类下的分类后刷新数据的通知
- (void)refreshDataAfterSortingssClick:(NSNotification *)sender {
    
    NSInteger tag = self.vcTag - 1000;
    
    NSArray *stringArray = sender.userInfo[@"LableValueLstStringss"];
    
    self.LableValueLst = stringArray[tag];
    
    NSArray *typeArray = sender.userInfo[@"typeListAry"];
    
    NSDictionary *dic = typeArray[tag];
    
    self.groupCode = dic[@"GroupCode"];
    self.valueString = dic[@"Value"];
    
    NSString *url = @"api/LiveVideo/GetLiveVideoList";
    NSString *params = [NSString stringWithFormat:@"ZICBDYCType=%dZICBDYCVideoType=%@ZICBDYCLableValueLst=%@",1, self.valueString,self.LableValueLst];
    
    [self loadDataApi:url withParams:params refresh:RefreshTypeBoth model:EasePublishModel.class];
}

- (void)sethunxinlogin {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EMClient sharedClient] registerWithUsername:@"test_see"password:@"123"];
        
    });
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EMClient sharedClient] loginWithUsername:@"test_see" password:@"123"];
    });

    
}

#pragma mark - Table view datasource and delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.dataSource == nil) {
        [tableView tableViewDisplayWitMsg:@"" ifNecessaryForRowCount:self.dataSource.count];
    }
    else {
        [tableView tableViewDisplayWitMsg:@"暂无相关信息!" ifNecessaryForRowCount:self.dataSource.count];
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EasePublishModel *model = self.dataSource[indexPath.row];
    
    LiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.layer.shadowColor = [UIColor blackColor].CGColor;// 阴影颜色
    cell.layer.shadowOffset = CGSizeMake(0, 0);// 偏移距离
    cell.layer.shadowOpacity = 0.5; // 不透明度
    cell.layer.shadowRadius = 5; // 半径
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell setLiveTableViewCellWithModel:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 300;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    EasePublishModel *model = [self.dataSource objectAtIndex:indexPath.row];
//    EaseLiveViewController *view = [[EaseLiveViewController alloc] initWithStreamModel:model];
//    [self.navigationController presentViewController:view animated:YES completion:nil];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

#pragma mark - 获取直播间列表
- (void)GetLiveVideoList {
    // Type	0回放，1直播，2预告
    NSString *url = @"api/LiveVideo/GetLiveVideoList";
    NSString *params = [NSString stringWithFormat:@"ZICBDYCType=%dZICBDYCVideoType=%@ZICBDYCLableValueLst=%@", 1, self.valueString,self.LableValueLst];
    
    [self showLoadding:@"正在加载" time:20];
    [self loadDataApi:url withParams:params refresh:RefreshTypeBoth model:EasePublishModel.class];
    
}

#pragma mark - 获取首页轮播图片
- (void)requestLiveLunBoData {
    
    NSString *params = [NSString stringWithFormat:@"ZICBDYCType=%@",@"0"];
    NSString *url = @"api/News/RepeatPic";
    
    
    [BaseNetwork postLoadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        
        NSLog(@"获取轮播图数据 - %@",modelData);
        if (isSuccess) {
            
            NSArray *dataAry = modelData[@"JsonData"];
            
            for (NSDictionary *dic in dataAry) {
                [self.imagesArray addObject:dic[@"Uri"]];
                [self.titlesArray addObject:dic[@"Title"]];
            }
            
            // self.cycleScrollView.titlesGroup = self.titlesArray;
            // 加载延迟
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.cycleScrollView.imageURLStringsGroup = self.imagesArray;
            });
            
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

#pragma mark - SDCycleScrollView Delegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
