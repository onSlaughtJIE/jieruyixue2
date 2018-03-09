//
//  NewsPingLunListVC.m
//  JRMedical
//
//  Created by a on 16/12/6.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "NewsPingLunListVC.h"
#import "SpPingluCell.h"
#import "SpCommentModel.h"
#import "SpPingLunViewController.h"
#import "UITableView+EmpayData.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>

#import "JRLoginViewController.h"

@interface NewsPingLunListVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *endView;

@end

@implementation NewsPingLunListVC

- (UIView *)endView {
    if (!_endView) {
        self.endView = [[UIView alloc] initWithFrame:(CGRectMake(0, Height_Screen-40-64, Width_Screen, 40))];
        _endView.backgroundColor = BG_Color;
        _endView.layer.shadowColor = RGB(100, 100, 100).CGColor;//阴影颜色
        _endView.layer.shadowOffset = CGSizeMake(0 , 1);//偏移距离
        _endView.layer.shadowOpacity = 0.5;//不透明度
        _endView.layer.shadowRadius = 3.0;//半径
    }
    return _endView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width_Screen, Height_Screen-104) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = BG_Color;
        _tableView.separatorColor = BG_Color;
        [_tableView registerNib:[UINib nibWithNibName:@"SpPingluCell" bundle:nil] forCellReuseIdentifier:@"plCell"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        
        // 评论cell自适应高度
        _tableView.estimatedRowHeight = 100;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

// 在页面销毁时记得 remove 监听对象，否则会闪退
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"全部评论";
    
    [self.view addSubview:self.tableView];
    
    //评论成功的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PingLunSuccessClick) name:@"PingLunSuccess" object:nil];
    
    [self requestListDataArrray];//请求数据列表
    
     [self addFooterViewWithIsDz:self.IsDZ IsShouCang:self.IsShouCang];
}

#pragma mark - 评论成功的通知 再次请求刷新评论列表
-(void)PingLunSuccessClick {
    [self requestListDataArrray];
}

#pragma mark - 请求数据列表
- (void)requestListDataArrray {
    
    NSString *params = @"";
    if (_isFromCaseCatalogue) {
        params = [NSString stringWithFormat:@"ZICBDYCResourcesType=%@ZICBDYCResourcesID=%@",@"4",self.model.ID];
    } else {
        params = [NSString stringWithFormat:@"ZICBDYCResourcesType=%@ZICBDYCResourcesID=%@",@"1",self.model.ID];
    }
//    NSString *params = [NSString stringWithFormat:@"ZICBDYCResourcesType=%@ZICBDYCResourcesID=%@",@"1",self.model.ID];
    NSString *url = @"api/News/EvaluateList";
    
    self.tableType = 1;//表类
    self.baseTableView = self.tableView;//将本类表 赋值给父类去操作
    [self loadDataApi:url withParams:params refresh:RefreshTypeBoth model:SpCommentModel.class];
}

#pragma mark - Table view datasource and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataSource == nil) {
        [tableView tableViewDisplayWitMsg:@"" ifNecessaryForRowCount:self.dataSource.count];
    }
    else {
        [tableView tableViewDisplayWitMsg:@"还没有人评论过,快来评论吧!" ifNecessaryForRowCount:self.dataSource.count];
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SpCommentModel *model = self.dataSource[indexPath.row];
    SpPingluCell *pinglunCell = [tableView dequeueReusableCellWithIdentifier:@"plCell" forIndexPath:indexPath];
    [pinglunCell setModel:model];
    return pinglunCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.dataSource == nil || self.dataSource.count == 0) {
        return 0.0001;
    }
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 添加工具栏
- (void)addFooterViewWithIsDz:(NSInteger)isDz IsShouCang:(NSInteger)isShouCang {
    
    NSArray *tagArr = @[@201, @202, @203, @204];
    NSArray *titleArr = @[@"评论", @"点赞", @"收藏", @"分享"];
    NSArray *imageArr = @[@"bianji", @"hengtianjinfuicon03", @"shoucang_gray", @"fenxiang-1"];
    NSArray *imageDoneArr = @[@"bianji", @"hengtianjinfuicon03z", @"shoucangz", @"fenxiang-1"];
    
    for (int i = 0; i < titleArr.count; i++) {
        
        UIView *itemView = [[UIView alloc] initWithFrame:(CGRectMake(Width_Screen/4 * i, 0, Width_Screen/4, 40))];
        UIButton *item = [self makeACustomView:tagArr[i] title:titleArr[i] image:imageArr[i] imageDone:imageDoneArr[i] IsDz:isDz IsShouCAng:isShouCang];
        [itemView addSubview:item];
        
        UILabel *lineLab = [[UILabel alloc] initWithFrame:(CGRectMake(Width_Screen/4-1, 15, 1, 10))];
        lineLab.backgroundColor = [UIColor lightGrayColor];
        lineLab.alpha = 0.6;
        if (i < 3) {
            [itemView addSubview:lineLab];
        }
        
        [self.endView addSubview:itemView];
    }
    
    [self.view addSubview:self.endView];
}

// 自定义方法
- (UIButton *)makeACustomView:(NSNumber *)tag title:(NSString *)name image:(NSString *)picName imageDone:(NSString *)picDone IsDz:(NSInteger)isDz IsShouCAng:(NSInteger)isShouCang {
    
    UIButton *button = [[UIButton alloc] initWithFrame:(CGRectMake(0, 0, Width_Screen/4-1, 40))];
    [button setTitle:name forState:(UIControlStateNormal)];
    [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
    button.tag = tag.integerValue;
    [button addTarget:self action:@selector(handleToolbar:) forControlEvents:(UIControlEventTouchUpInside)];
    
    if (tag.integerValue == 202) { // 点赞
        
        if (isDz == 1) {
            [button setTitleColor:RGB(230, 79, 70) forState:(UIControlStateNormal)];
            [button setImage:[UIImage imageNamed:picDone] forState:(UIControlStateNormal)];
        }else {
            [button setTitleColor:RGB(160, 160, 160) forState:(UIControlStateNormal)];
            [button setImage:[UIImage imageNamed:picName] forState:(UIControlStateNormal)];
        }
    }
    
    if (tag.integerValue == 203) { // 收藏
        if (isShouCang == 1) {
            [button setTitleColor:RGB(230, 79, 70) forState:(UIControlStateNormal)];
            [button setImage:[UIImage imageNamed:picDone] forState:(UIControlStateNormal)];
        }else {
            [button setTitleColor:RGB(160, 160, 160) forState:(UIControlStateNormal)];
            [button setImage:[UIImage imageNamed:picName] forState:(UIControlStateNormal)];
        }
    }
    
    if (tag.integerValue == 201 || tag.integerValue == 204) {
        [button setTitleColor:RGB(160, 160, 160) forState:(UIControlStateNormal)];
        [button setImage:[UIImage imageNamed:picName] forState:(UIControlStateNormal)];
    }
    
    return button;
}

#pragma mark - 工具栏Action 响应事件
- (void)handleToolbar:(UIButton *)sender {
    switch (sender.tag) {
        case 201: // 评论
        {
            SpPingLunViewController *plVc = [SpPingLunViewController new];
            BaseNavigationController *plNC = [[BaseNavigationController alloc] initWithRootViewController:plVc];
            plVc.ID = self.model.ID;
            if (_isFromCaseCatalogue) {
                plVc.isFromCaseCatalogue = YES;
            }
            [self presentViewController:plNC animated:YES completion:nil];
        }
            break;
        case 202:// 点赞
        {
            NSString *params = @"";
            if (_isFromCaseCatalogue) {
                params = [NSString stringWithFormat:@"ZICBDYCResourcesType=%@ZICBDYCResourcesID=%@",@"4",self.model.ID];
            } else {
                params = [NSString stringWithFormat:@"ZICBDYCResourcesType=%@ZICBDYCResourcesID=%@",@"1",self.model.ID];
            }
//            NSString *params = [NSString stringWithFormat:@"ZICBDYCResourcesType=%@ZICBDYCResourcesID=%@",@"1",self.model.ID];
            NSString *url = @"api/News/AddLiked";
            
            [BaseNetwork postLoadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
                NSLog(@"点赞 - %@", modelData);
                if (isSuccess) {
                    if (code == 8) {
                        [self showMessage:@"取消点赞"];
                        [sender setTitleColor:RGB(160, 160, 160) forState:(UIControlStateNormal)];
                        [sender setImage:[UIImage imageNamed:@"hengtianjinfuicon03"] forState:(UIControlStateNormal)];
                    }
                    else if (code == 9) {
                        [self showMessage:@"点赞成功"];
                        [sender setTitleColor:RGB(230, 79, 70) forState:(UIControlStateNormal)];
                        [sender setImage:[UIImage imageNamed:@"hengtianjinfuicon03z"] forState:(UIControlStateNormal)];
                    }
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"dianZhanZhuangTai" object:nil userInfo:nil];
                }
                else {
                    if (code == 999) {
                        [self showMessage:@"服务器开小差了~请稍后再试"];
                        return ;
                    }
                    NSString *msg  = [modelData objectForKey:@"Msg"];
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
                    else{
                        [self showMessage:[NSString stringWithFormat:@"请求失败 #%d",code]];
                    }
                }
            }];
        }
            break;
        case 203: // 收藏
        {
            NSString *params = @"";
            if (_isFromCaseCatalogue) {
                params = [NSString stringWithFormat:@"ZICBDYCResourcesType=%@ZICBDYCResourcesID=%@",@"4",self.model.ID];
            } else {
                params = [NSString stringWithFormat:@"ZICBDYCResourcesType=%@ZICBDYCResourcesID=%@",@"1",self.model.ID];
            }
//            NSString *params = [NSString stringWithFormat:@"ZICBDYCResourcesType=%@ZICBDYCResourcesID=%@",@"1",self.model.ID];
            NSString *url = @"api/News/AddCollection";
            
            [BaseNetwork postLoadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
                NSLog(@"收藏 - %@", modelData);
                if (isSuccess) {
                    if (code == 8) {
                        [self showMessage:@"取消收藏"];
                        [sender setTitleColor:RGB(160, 160, 160) forState:(UIControlStateNormal)];
                        [sender setImage:[UIImage imageNamed:@"shoucang_gray"] forState:(UIControlStateNormal)];
                    }
                    else if (code == 9) {
                        [self showMessage:@"收藏成功"];
                        [sender setTitleColor:RGB(230, 79, 70) forState:(UIControlStateNormal)];
                        [sender setImage:[UIImage imageNamed:@"shoucangz"] forState:(UIControlStateNormal)];
                    }
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"shouChangZhuangTai" object:nil userInfo:nil];
                }
                else {
                    if (code == 999) {
                        [self showMessage:@"服务器开小差了~请稍后再试"];
                        return ;
                    }
                    NSString *msg  = [modelData objectForKey:@"Msg"];
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
                    else{
                        [self showMessage:[NSString stringWithFormat:@"请求失败 #%d",code]];
                    }
                }
            }];
        }
            break;
#pragma mark 分享
        case 204: // 分享
        {
            //1、创建分享参数
            NSArray* imageArray = @[[UIImage imageNamed:@"shoucangz"]];
            // （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
            
            // 压缩图片 太大的话 微信分享不出去
            //            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //                NSLog(@"ImageNum = %ld", (long)self.model.ImageNum);
            //                if (self.model.ImageNum) {
            //                    self.shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.model.TuPian1]]];
            //                } else {
            //                    self.shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.model.TuPian]]];
            //                }
            //
            //                NSData *fData = UIImageJPEGRepresentation(_shareImage, 0.1);
            //                if (fData != nil) {
            //                    dispatch_async(dispatch_get_main_queue(), ^{
            //                        _shareImage = [UIImage imageWithData:fData];
            //                    });
            //                }
            //            });
            NSLog(@"ImageNum = %ld", (long)self.model.ImageNum);
            NSString *imageStr = nil;
            if (self.model.ImageNum) {
                imageStr = self.model.TuPian1;
            }else {
                imageStr = self.model.TuPian;
            }
            
            if (imageArray) {
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKSetupShareParamsByText:self.model.ZhaiYao
                                                 images:@[imageStr]
                                                    url:[NSURL URLWithString:self.model.Url]
                                                  title:[NSString stringWithFormat:@"%@", self.model.BiaoTi]
                                                   type:SSDKContentTypeAuto];
                //2、分享
                [SSUIShareActionSheetStyle setShareActionSheetStyle:ShareActionSheetStyleSimple]; //设置简单分享菜单样式
                SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:nil
                                                                                 items:nil
                                                                           shareParams:shareParams
                                                                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                                                                       
                                                                       switch (state) {
                                                                           case SSDKResponseStateSuccess:
                                                                           {
                                                                               if (platformType == SSDKPlatformTypeCopy) {
                                                                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"拷贝成功"
                                                                                                                                       message:nil
                                                                                                                                      delegate:nil
                                                                                                                             cancelButtonTitle:@"确定"
                                                                                                                             otherButtonTitles:nil];
                                                                                   [alertView show];
                                                                                   
                                                                               }else {
                                                                                   
                                                                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                                                                       message:nil
                                                                                                                                      delegate:nil
                                                                                                                             cancelButtonTitle:@"确定"
                                                                                                                             otherButtonTitles:nil];
                                                                                   [alertView show];
                                                                               }
                                                                               
                                                                               break;
                                                                           }
                                                                           case SSDKResponseStateFail:
                                                                           {
                                                                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                                                                              delegate:nil
                                                                                                                     cancelButtonTitle:@"OK"
                                                                                                                     otherButtonTitles:nil, nil];
                                                                               [alert show];
                                                                               break;
                                                                           }
                                                                           default:
                                                                               break;
                                                                       }
                                                                   }];
                
                // SSDKPlatformTypeCopy 点击拷贝不再弹出编辑界面
                [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeCopy)]; //（加了这个方法之后可以不跳分享编辑界面，直接点击分享菜单里的选项，直接分享）
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
