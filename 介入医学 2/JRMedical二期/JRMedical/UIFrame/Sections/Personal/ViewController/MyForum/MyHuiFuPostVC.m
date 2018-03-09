//
//  MyHuiFuPostVC.m
//  JRMedical
//
//  Created by a on 16/12/22.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "MyHuiFuPostVC.h"

#import "PatientDetailVC.h"
#import "VideoPlayVC.h"

#import "NewestPostCell.h"
#import "NewestPostModel.h"
#import "NewesPostFooterView.h"

#import "UITableView+EmpayData.h"

#import <YYKit.h>

#import "ReplyPostVC.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>

#define Cell_GuTai_Height 95 //cell的固态高度
#define Cell_Text_ZD_Height 65 //cell的内容的最大高度
#define Cell_Img_Height(imgNum) ((Width_Screen-30)/3+5)*imgNum//cell数张图片的高度
#define Cell_OneImg_Weight (Width_Screen-20)/4*3//cell一个图片的宽度
#define Cell_OneImg_Height ((Width_Screen-20)/4*3)/3*2//cell一个图片的高度

@interface MyHuiFuPostVC ()<UITableViewDelegate,UITableViewDataSource,YHWorkGroupPhotoContainerDelegate,NewesPostFooterViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *thumImgs;//缩略图集合
@property (nonatomic, strong) NSMutableArray *hdImgs;//高清图集合
@property (nonatomic, strong) NSMutableArray *rTypes;//图片类型集合


@end

@implementation MyHuiFuPostVC {
    NSString *_shareType;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cleanCollectionPost" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.thumImgs = [NSMutableArray arrayWithCapacity:0];//缩略图集合
    self.hdImgs = [NSMutableArray arrayWithCapacity:0];//高清图集合
    self.rTypes = [NSMutableArray arrayWithCapacity:0];//图片类型集合
    
    //进入详情点击收藏按钮后的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanCollectionPostClick) name:@"cleanCollectionPost" object:nil];
    
    [self.view addSubview:self.tableView];
    
    [self showLoadding:@"正在加载" time:20];
    [self requestListDataArrray];
}

#pragma mark - 进入详情点击收藏按钮后的通知
- (void)cleanCollectionPostClick {
//    [self showLoadding:@"" time:20];
    [self requestListDataArrray];
}

#pragma mark - 请求数据列表
- (void)requestListDataArrray {
    
    NSString *url = @"api/Customer/ReplyMyPostLst";
    NSString *params = @"";
    
    self.pageSize = 10;//一次加载8条数据
    self.tableType = 1;//TableView表类
    self.baseTableView = self.tableView;//将本类表 赋值给父类去操作
    [self loadDataApi:url withParams:params refresh:RefreshTypeBoth model:NewestPostModel.class];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.dataSource == nil) {
        [tableView tableViewDisplayWitMsg:@"" ifNecessaryForRowCount:self.dataSource.count];
    }
    else {
        [tableView tableViewDisplayWitMsg:@"暂无相关论坛信息!" ifNecessaryForRowCount:self.dataSource.count];
        
        if (self.dataSource.count > 0) {
            
            [self.thumImgs removeAllObjects];
            [self.hdImgs removeAllObjects];
            [self.rTypes removeAllObjects];
            
            //遍历数据源,取出并单独存储每条数据的  缩略图 高清图 和  视频地址  //视频地址 和 图片高清图 是 公用一个Url
            for (NewestPostModel *model  in self.dataSource) {
                
                NSMutableArray *tImgAry = [NSMutableArray arrayWithCapacity:0];
                NSMutableArray *hImgAry = [NSMutableArray arrayWithCapacity:0];
                NSMutableArray *rTypeAry = [NSMutableArray arrayWithCapacity:0];
                
                //如果没有发表图片视频信息 则 不存储
                if (model.List.count > 0) {
                    for (NSDictionary *data in model.List) {
                        
                        [rTypeAry addObject:data[@"RType"]];
                        
                        if ([data[@"RType"] integerValue] == 1) {
                            [tImgAry addObject:data[@"VideoPic"]];//如果是 视频类型 则 缩略图数组 储存 视频的图片
                            [hImgAry addObject:data[@"Uri"]];//将公用的Url储存到视频连接数组去
                        }
                        else {
                            [tImgAry addObject:data[@"ThumImg"]];//如果是 图片类型 则 缩略图数组 储存 图片缩略图片
                            [hImgAry addObject:data[@"Uri"]];//将公用的Url储存到图片高清图数组去
                        }
                    }
                }
                [self.thumImgs addObject:tImgAry];//存储遍历过来的缩略图片
                [self.hdImgs addObject:hImgAry];//存储遍历过来的高清图片
                [self.rTypes addObject:rTypeAry];//存储每个 视频 还是 图片 的类型
            }
        }
    }
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewestPostModel *model = self.dataSource[indexPath.section];
    
    NSArray *thumImgArray = self.thumImgs[indexPath.section];
    NSArray *hdImgArray = self.hdImgs[indexPath.section];
    NSArray *rTypeArray = self.rTypes[indexPath.section];
    
    NewestPostCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NewestPostCell class]) forIndexPath:indexPath];
    cell.picContainerView.delegate = self;
    [cell setIndexPath:indexPath];
    [cell setPicUrlArray:thumImgArray];
    [cell setPicOriArray:hdImgArray];
    [cell setRTypeArray:rTypeArray];
    [cell setModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewestPostModel *model = self.dataSource[indexPath.section];
    
    NSArray *thumImgArray = self.thumImgs[indexPath.section];
    
    NSInteger num;
    if (thumImgArray.count >= 9) {
        num = 9;
    }
    else {
        num = thumImgArray.count;
    }
    
    CGRect contantWidth = [Utils getTextRectWithString:model.Title withWidth:Width_Screen-20 withFontSize:16];
    
    if (contantWidth.size.height >= Cell_Text_ZD_Height) {
        contantWidth.size.height = Cell_Text_ZD_Height;
    }
    
    if (num == 1) {
        return Cell_GuTai_Height + contantWidth.size.height + Cell_OneImg_Height;
    }
    else if (num <= 3 && num >1) {
        return Cell_GuTai_Height + contantWidth.size.height + Cell_Img_Height(1) - 5;
    }
    else if (num >= 3 && num <= 6) {
        return Cell_GuTai_Height + contantWidth.size.height + Cell_Img_Height(2) - 5;
    }
    else if (num > 6) {
        return Cell_GuTai_Height + contantWidth.size.height + Cell_Img_Height(3) - 5;
    }
    else {
        return Cell_GuTai_Height + contantWidth.size.height - 10;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    NewestPostModel *model = self.dataSource[section];
    
    NewesPostFooterView *footer = [NewesPostFooterView new];
    [footer setSection:section];
    footer.delegate = self;
    [footer setModel:model];
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.0001;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 40;
}

#pragma mark - NewesPostFooterViewDelegate
- (void)selectPostStateClick:(NSInteger)tag curSection:(NSInteger)section {
    
    NewestPostModel *model = self.dataSource[section];
    
    //  NSArray *tagArr = @[@201, @202, @203, @204];
    
    switch (tag) {
        case 202: // 评论
        {
            ReplyPostVC *rpVc = [ReplyPostVC new];
            BaseNavigationController *rpNC = [[BaseNavigationController alloc] initWithRootViewController:rpVc];
            rpVc.ID = model.PostID;
            [self presentViewController:rpNC animated:YES completion:nil];
            
            //            [[NSNotificationCenter defaultCenter] postNotificationName:@"cleanCollectionPost" object:nil userInfo:nil];
        }
            break;
        case 203:// 点赞
        {
            NSString *params = [NSString stringWithFormat:@"ZICBDYCPostID=%@",model.PostID];
            NSString *url = @"api/Post/CustomerPostLike";
            
            [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
                NSLog(@"点赞 - %@", modelData);
                if (isSuccess) {
                    
                    NSDictionary *data = modelData[@"JsonData"];
                    
                    NSInteger isLike = [data[@"IsLike"] integerValue];
                    
                    if (isLike == 1) {
                        [self showMessage:@"点赞成功"];
                    }
                    else {
                        [self showMessage:@"取消点赞"];
                    }
                    NSDictionary *dataDic = @{@"isLike":@(isLike)};
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshPostListStateDianZhan" object:nil userInfo:dataDic];
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
            break;
        case 204: // 收藏
        {
            NSString *params = [NSString stringWithFormat:@"ZICBDYCPostID=%@",model.PostID];
            NSString *url = @"api/Post/CustomerPostCollection";
            
            [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
                NSLog(@"收藏 - %@", modelData);
                if (isSuccess) {
                    
                    NSDictionary *data = modelData[@"JsonData"];
                    
                    NSInteger isCollection = [data[@"IsCollection"] integerValue];
                    
                    if (isCollection == 1) {
                        [self showMessage:@"收藏成功"];
                    }
                    else {
                        [self showMessage:@"取消收藏"];
                    }
                    
                    NSDictionary *dataDic = @{@"isCollection":@(isCollection)};
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshPostListStateCollection" object:nil userInfo:dataDic];
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
            break;
#pragma mark 分享
        case 201: // 分享
        {
            //1、创建分享参数
            NSArray* imageArray = @[model.CreUserPic];
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
            NSLog(@"ImageNum = %ld", (long)model.CreUserPic);
            NSString *imageStr = nil;
            if (model.CreUserPic) {
                imageStr = model.CreUserPic;
            }else {
                imageStr = model.CreUserPic;
            }
            
            if (imageArray) {
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKSetupShareParamsByText:model.Content
                                                 images:@[imageStr]
                                                    url:[NSURL URLWithString:model.Uri]
                                                  title:[NSString stringWithFormat:@"%@", model.Title]
                                                   type:SSDKContentTypeAuto];
                //2、分享
                [SSUIShareActionSheetStyle setShareActionSheetStyle:ShareActionSheetStyleSimple]; //设置简单分享菜单样式
                SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:nil
                                                                                 items:nil
                                                                           shareParams:shareParams
                                                                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                                                                       
                                                                       switch (platformType) {
                                                                           case 22:
                                                                               _shareType = @"微信好友";
                                                                               break;
                                                                           case 23:
                                                                               _shareType = @"微信朋友圈";
                                                                               break;
                                                                           case 37:
                                                                               _shareType = @"微信收藏";
                                                                               break;
                                                                           case 24:
                                                                               _shareType = @"QQ好友";
                                                                               break;
                                                                           case 6:
                                                                               _shareType = @"QQ空间";
                                                                               break;
                                                                           default:
                                                                               _shareType = @"";
                                                                               break;
                                                                       }
                                                                       
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
                                                                                   
                                                                               }
                                                                               else {
                                                                                   
                                                                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                                                                       message:nil
                                                                                                                                      delegate:nil
                                                                                                                             cancelButtonTitle:@"确定"
                                                                                                                             otherButtonTitles:nil];
                                                                                   [alertView show];
                                                                                   
                                                                                   [self shareSuccess:model];
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

#pragma mark - 分享成功计数
- (void)shareSuccess:(NewestPostModel *)model {
    
    NSString *params = [NSString stringWithFormat:@"ZICBDYCResourcesType=%@ZICBDYCResourcesID=%@ZICBDYCShareGoal=%@",@"2",model.PostID,_shareType];
    NSString *url = @"api/News/AddShare";
    
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"分享成功计数 - %@", modelData);
        if (isSuccess) {
            //            [[NSNotificationCenter defaultCenter] postNotificationName:@"cleanCollectionPost" object:nil userInfo:nil];
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

#pragma mark  点击cell的响应的代理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NewestPostModel *model = self.dataSource[indexPath.section];
    NSArray *thumImgArray = self.thumImgs[indexPath.section];
    NSArray *hdImgArray = self.hdImgs[indexPath.section];
    NSArray *rTypeArray = self.rTypes[indexPath.section];
    
    PatientDetailVC *pdVC = [PatientDetailVC new];
    pdVC.model = model;
    pdVC.picUrlArray = thumImgArray;
    pdVC.picOriArray = hdImgArray;
    pdVC.rTypeArray = rTypeArray;
    [self.navigationController pushViewController:pdVC animated:YES];
}

#pragma mark - YHWorkGroupPhotoContainerDelegate
- (void)selectedVideoPushPostDetail:(NSString *)url {
    // 1.获得视频播放的URL
    VideoPlayVC *video = [VideoPlayVC new];
    video.url = url;
    BaseNavigationController *videoNC = [[BaseNavigationController alloc] initWithRootViewController:video];
    [self presentViewController:videoNC animated:YES completion:nil];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, Width_Screen, Height_Screen-108) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor  = BG_Color;
        _tableView.backgroundColor = BG_Color;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [_tableView registerClass:[NewestPostCell class] forCellReuseIdentifier:NSStringFromClass([NewestPostCell class])];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
