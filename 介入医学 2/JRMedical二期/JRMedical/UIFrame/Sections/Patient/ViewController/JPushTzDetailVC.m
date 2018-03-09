//
//  JPushTzDetailVC.m
//  JRMedical
//
//  Created by ww on 2017/2/21.
//  Copyright © 2017年 idcby. All rights reserved.
//

#import "JPushTzDetailVC.h"
#import "KMButton.h"
#import "ReplyPostListCell.h"
#import "ReplyPostModel.h"
#import "ReplyPostVC.h"
#import "NewsDetailView.h"
#import "PublishedPostVC.h"
#import "VideoPlayVC.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>

#define TopHeader_GuTai_Height 140.6//详情的固态高度
#define Img_Height(imgNum) (10+(((Width_Screen-20)/4*3)/3*2))*imgNum// 根据图片数量算图片的高度

//回帖
#define Cell_GuTai_Height 95 //cell的固态高度
#define Cell_Text_ZD_Height 65 //cell的内容的最大高度
#define Cell_Img_Height(imgNum) ((Width_Screen-94)/3+5)*imgNum//cell数张图片的高度
#define Cell_OneImg_Weight (Width_Screen-84)/4*3//cell一个图片的宽度
#define Cell_OneImg_Height ((Width_Screen-84)/4*3)/3*2//cell一个图片的高度

@interface JPushTzDetailVC ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,YHWorkGroupPhotoContainerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger IsDZ;
@property (nonatomic, assign) NSInteger IsShouCang;
@property (nonatomic, strong) UIImage *shareImage;
@property (nonatomic, strong) UIView *endView;

@property (nonatomic, strong) NSMutableArray *tUrlArray;
@property (nonatomic, strong) NSMutableArray *hUrlArray;
@property (nonatomic, strong) NSMutableArray *videoUrlArray;

//回帖
@property (nonatomic, strong) NSMutableArray *thumImgs;//缩略图集合
@property (nonatomic, strong) NSMutableArray *hdImgs;//高清图集合
@property (nonatomic, strong) NSMutableArray *rTypes;//图片类型集合

@end

@implementation JPushTzDetailVC

{
    NSString *_shareType;
    
    NSInteger _isChangState;
}

- (void)dealloc {
    
    if (_isChangState == 200) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"cleanCollectionPost" object:nil userInfo:nil];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidBecomeVisibleNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidBecomeHiddenNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"detailViewRefresh" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //设置标题大小
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //设置标题大小
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"帖子详情";
    self.view.backgroundColor = BG_Color;
    
    _isChangState = 100;
    
    //发布后的 刷新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detailViewRefreshClick) name:@"detailViewRefresh" object:nil];
    
    // 初始化
    self.picUrlArray = [NSMutableArray array];
    self.picOriArray = [NSMutableArray array];
    self.rTypeArray = [NSMutableArray array];
    //回帖
    self.thumImgs = [NSMutableArray arrayWithCapacity:0];//缩略图集合
    self.hdImgs = [NSMutableArray arrayWithCapacity:0];//高清图集合
    self.rTypes = [NSMutableArray arrayWithCapacity:0];//图片类型集合
    
    
    [self setNavBarButtonItem];//设置顶栏右侧按钮
    
    [self.view addSubview:self.tableView];
    
//    [self seTableViewHeader];//设置顶部帖子详情视图
    
    [self addFooterView];//展示资讯状态的工具栏
    
    [self getCurrentPostDetail];//获取当前帖子详情
    
    [self getReplyList];//获取回帖列表
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(begainFullScreen) name:UIWindowDidBecomeVisibleNotification object:nil];//进入全屏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endFullScreen) name:UIWindowDidBecomeHiddenNotification object:nil];//退出全屏
}

#pragma mark - 刷新回帖
- (void)detailViewRefreshClick {
    [self getReplyList];
    
    _isChangState = 200;
}

#pragma - mark  进入全屏
-(void)begainFullScreen {
    AppDelegate *appDelegate = APPDELEGETE;
    appDelegate.allowRotation = YES;//为1时开启横屏 为0时关闭横屏
}

#pragma - mark 退出全屏
-(void)endFullScreen {
    
    AppDelegate *appDelegate = APPDELEGETE;
    appDelegate.allowRotation = NO;//为1时开启横屏 为0时关闭横屏
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    //强制归正：
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

#pragma mark - 设置顶部帖子详情视图

- (void)seTableViewHeader {
    
    CGRect contantWidth = [Utils getTextRectWithString:self.model.Content withWidth:Width_Screen-20 withFontSize:16];
    
    CGFloat height = TopHeader_GuTai_Height + contantWidth.size.height + Img_Height(self.model.List.count);
    
    NewsDetailView *headerView = [[NewsDetailView alloc] initWithFrame:CGRectMake(0, 0, Width_Screen, height)];
    [headerView setTUrlArray:self.tUrlArray];
    [headerView setHUrlArray:self.hUrlArray];
    [headerView setVideoUrlArray:self.videoUrlArray];
    [headerView setModel:self.model];
    self.tableView.tableHeaderView = headerView; // 这句很关键
}


#pragma mark - datasource  delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.dataSource.count > 0) {
        
        [self.thumImgs removeAllObjects];
        [self.hdImgs removeAllObjects];
        [self.rTypes removeAllObjects];
        
        //遍历数据源,取出并单独存储每条数据的  缩略图 高清图 和  视频地址  //视频地址 和 图片高清图 是 公用一个Url
        for (ReplyPostModel *model  in self.dataSource) {
            
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
    return self.dataSource.count > 0 ? self.dataSource.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource.count > 0) {
        
        ReplyPostModel *model = self.dataSource[indexPath.row];
        
        NSArray *thumImgArray = self.thumImgs[indexPath.row];
        NSArray *hdImgArray = self.hdImgs[indexPath.row];
        NSArray *rTypeArray = self.rTypes[indexPath.row];
        
        ReplyPostListCell *pinglunCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ReplyPostListCell class]) forIndexPath:indexPath];
        pinglunCell.picContainerView.delegate = self;
        [pinglunCell setIndexPath:indexPath];
        [pinglunCell setPicUrlArray:thumImgArray];
        [pinglunCell setPicOriArray:hdImgArray];
        [pinglunCell setRTypeArray:rTypeArray];
        [pinglunCell setModel:model];
        return pinglunCell;
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.textLabel.text = @"还没有人回过帖,快来回帖吧!";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = RGB(0, 164, 156);
        cell.textLabel.sd_layout.centerXEqualToView(cell.contentView).centerYEqualToView(cell.contentView).widthIs(Width_Screen).heightIs(40);
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataSource.count > 0) {
        ReplyPostModel *model = self.dataSource[indexPath.row];
        
        NSArray *thumImgArray = self.thumImgs[indexPath.row];
        
        NSInteger num;
        if (thumImgArray.count >= 9) {
            num = 9;
        }
        else {
            num = thumImgArray.count;
        }
        
        CGRect contantWidth = [Utils getTextRectWithString:model.Content withWidth:Width_Screen-84 withFontSize:16];
        
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
    return 50;
}

#pragma mark - 区头 / 区尾
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width_Screen, 40)];
    [view setBackgroundColor:RGB(255, 255, 255)];
    
    UIImageView *greenView = [[UIImageView alloc] initWithFrame:(CGRectMake(5, 5, 2, 30))];
    greenView.image = [UIImage imageNamed:@"矩形-6"];
    [view addSubview:greenView];
    
    UILabel *headTitle = [[UILabel alloc] initWithFrame:(CGRectMake(12, 5, 40, 30))];
    headTitle.text = @"回帖";
    [view addSubview:headTitle];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:(CGRectMake(0, 39, Width_Screen, 1))];
    lineLabel.backgroundColor = RGB(239, 240, 241);
    [view addSubview:lineLabel];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - YHWorkGroupPhotoContainerDelegate
- (void)selectedVideoPushPostDetail:(NSString *)url {
    // 1.获得视频播放的URL
    VideoPlayVC *video = [VideoPlayVC new];
    video.url = url;
    BaseNavigationController *videoNC = [[BaseNavigationController alloc] initWithRootViewController:video];
    [self presentViewController:videoNC animated:YES completion:nil];
}

#pragma mark - 评论列表数据接口

- (void)getReplyList {
    
    NSString *params = [NSString stringWithFormat:@"ZICBDYCPostID=%@",self.jPushPostID];
    NSString *url = @"api/Post/GetReplyPostByID";
    
    self.tableType = 1;//表类
    self.pageSize = 10;//表类
    self.baseTableView = self.tableView;//将本类表 赋值给父类去操作
    [self loadDataApi:url withParams:params refresh:RefreshTypeFooter model:ReplyPostModel.class];
}
 

#pragma mark - 添加工具栏
- (void)addFooterView {
    
    NSArray *tagArr = @[@201, @202, @203, @204];
    NSArray *titleArr = @[@"回帖", @" 赞 ", @"收藏", @"分享"];
    NSArray *imageArr = @[@"bianji", @"hengtianjinfuicon03", @"shoucang_gray", @"fenxiang-1"];
    
    for (int i = 0; i < titleArr.count; i++) {
        
        UIView *itemView = [[UIView alloc] initWithFrame:(CGRectMake(Width_Screen/4 * i, 0, Width_Screen/4, 40))];
        UIButton *item = [self makeACustomView:tagArr[i] title:titleArr[i] image:imageArr[i]];
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
- (UIButton *)makeACustomView:(NSNumber *)tag title:(NSString *)name image:(NSString *)picName {
    
    UIButton *button = [[UIButton alloc] initWithFrame:(CGRectMake(0, 0, Width_Screen/4-1, 40))];
    [button setTitle:name forState:(UIControlStateNormal)];
    [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
    button.tag = tag.integerValue;
    [button addTarget:self action:@selector(handleToolbar:) forControlEvents:(UIControlEventTouchUpInside)];
    [button setTitleColor:RGB(160, 160, 160) forState:(UIControlStateNormal)];
    [button setImage:[UIImage imageNamed:picName] forState:(UIControlStateNormal)];
    
    return button;
}

#pragma mark - 工具栏Action 响应事件
- (void)handleToolbar:(UIButton *)sender {
    switch (sender.tag) {
        case 201: // 评论
        {
            ReplyPostVC *rpVc = [ReplyPostVC new];
            BaseNavigationController *rpNC = [[BaseNavigationController alloc] initWithRootViewController:rpVc];
            rpVc.ID = self.jPushPostID;
            [self presentViewController:rpNC animated:YES completion:nil];
        }
            break;
        case 202:// 点赞
        {
            NSString *params = [NSString stringWithFormat:@"ZICBDYCPostID=%@",self.jPushPostID];
            NSString *url = @"api/Post/CustomerPostLike";
            
            [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
                NSLog(@"点赞 - %@", modelData);
                if (isSuccess) {
                    
                    NSDictionary *data = modelData[@"JsonData"];
                    
                    if ([data[@"IsLike"] integerValue] == 1) {
                        
                        self.IsDZ = 1;
                        
                        [self showMessage:@"点赞成功"];
                        [sender setTitleColor:Main_Color forState:(UIControlStateNormal)];
                        [sender setImage:[UIImage imageNamed:@"dianzanlu"] forState:(UIControlStateNormal)];
                    }
                    else {
                        
                        self.IsDZ = 0;
                        
                        [self showMessage:@"取消点赞"];
                        [sender setTitleColor:RGB(160, 160, 160) forState:(UIControlStateNormal)];
                        [sender setImage:[UIImage imageNamed:@"hengtianjinfuicon03"] forState:(UIControlStateNormal)];
                    }
                    
                    _isChangState = 200;
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
        case 203: // 收藏
        {
            NSString *params = [NSString stringWithFormat:@"ZICBDYCPostID=%@",self.jPushPostID];
            NSString *url = @"api/Post/CustomerPostCollection";
            
            [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
                NSLog(@"收藏 - %@", modelData);
                if (isSuccess) {
                    
                    NSDictionary *data = modelData[@"JsonData"];
                    
                    if ([data[@"IsCollection"] integerValue] == 1) {
                        
                        self.IsShouCang = 1;
                        
                        [self showMessage:@"收藏成功"];
                        [sender setTitleColor:Main_Color forState:(UIControlStateNormal)];
                        [sender setImage:[UIImage imageNamed:@"shoucangyy"] forState:(UIControlStateNormal)];
                    }
                    else {
                        
                        self.IsShouCang = 0;
                        
                        [self showMessage:@"取消收藏"];
                        [sender setTitleColor:RGB(160, 160, 160) forState:(UIControlStateNormal)];
                        [sender setImage:[UIImage imageNamed:@"shoucang_gray"] forState:(UIControlStateNormal)];
                    }
                    
                    _isChangState = 200;
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
        case 204: // 分享
        {
            //1、创建分享参数
            if (self.model) {
                
                NSArray* imageArray = @[self.model.CreUserPic];
                
                NSLog(@"ImageNum = %ld", (long)self.model.CreUserPic);
                NSString *imageStr = nil;
                if (self.model.CreUserPic) {
                    imageStr = self.model.CreUserPic;
                }else {
                    imageStr = self.model.CreUserPic;
                }
                
                if (imageArray) {
                    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                    [shareParams SSDKSetupShareParamsByText:self.model.Content
                                                     images:@[imageStr]
                                                        url:[NSURL URLWithString:self.model.Uri]
                                                      title:[NSString stringWithFormat:@"%@", self.model.Title]
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
                                                                                       
                                                                                       _isChangState = 200;
                                                                                       
                                                                                       [self shareSuccess];
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
                
            } else {
                NSLog(@"model还未被赋值");
            }

        
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 点击发帖
- (void)navBarButtonItemClick {
    PublishedPostVC *ppVC = [PublishedPostVC new];
    [self.navigationController pushViewController:ppVC animated:YES];
}

#pragma Mark - 获取帖子详情
- (void)getCurrentPostDetail {
    
    NSString *params = [NSString stringWithFormat:@"ZICBDYCPostID=%@",self.jPushPostID];
    NSString *url = @"api/Post/PostDetails";
    
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"获取帖子详情 - %@", modelData);
        if (isSuccess) {
            
            // 给self.model 赋值
            self.model = [[NewestPostModel alloc] init];
            NSDictionary *infoDic = modelData[@"JsonData"];
            [self.model setValuesForKeysWithDictionary:infoDic];
            self.title = self.model.Title;
            
            // 几个数组处理
            NSArray *listArr = infoDic[@"List"];
            for (NSDictionary *dic in listArr) {
                [self.picUrlArray addObject:dic[@"ThumImg"]]; //缩略图URL
                [self.picOriArray addObject:dic[@"Uri"]]; //原图url
                [self.rTypeArray addObject:dic[@"RType"]];//图片类型
                
            }
            // 设置表头
            [self lllll];
            
            //
            self.IsDZ = [modelData[@"JsonData"][@"IsLike"] integerValue];//是否点赞
            self.IsShouCang = [modelData[@"JsonData"][@"IsCollection"] integerValue];//是否收藏
            
            UIButton *dzBtn = (UIButton *)[self.view viewWithTag:202];
            UIButton *scBtn = (UIButton *)[self.view viewWithTag:203];
            
            if (self.IsDZ == 0) {
                [dzBtn setTitleColor:RGB(160, 160, 160) forState:(UIControlStateNormal)];
                [dzBtn setImage:[UIImage imageNamed:@"hengtianjinfuicon03"] forState:(UIControlStateNormal)];
            }
            else {
                [dzBtn setTitleColor:Main_Color forState:(UIControlStateNormal)];
                [dzBtn setImage:[UIImage imageNamed:@"dianzanlu"] forState:(UIControlStateNormal)];
            }
            
            if (self.IsShouCang == 0) {
                [scBtn setTitleColor:RGB(160, 160, 160) forState:(UIControlStateNormal)];
                [scBtn setImage:[UIImage imageNamed:@"shoucang_gray"] forState:(UIControlStateNormal)];
            }
            else {
                [scBtn setTitleColor:Main_Color forState:(UIControlStateNormal)];
                [scBtn setImage:[UIImage imageNamed:@"shoucangyy"] forState:(UIControlStateNormal)];
            }
            
            [self.tableView reloadData];
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

#pragma mark - 分享成功计数
- (void)shareSuccess {
    
    NSString *params = [NSString stringWithFormat:@"ZICBDYCResourcesType=%@ZICBDYCResourcesID=%@ZICBDYCShareGoal=%@",@"2",self.jPushPostID, _shareType];
    NSString *url = @"api/News/AddShare";
    
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"分享成功计数 - %@", modelData);
        if (isSuccess) {
            
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

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width_Screen, Height_Screen-104) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = BG_Color;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 74, 0, 0);
        [_tableView registerClass:[ReplyPostListCell class] forCellReuseIdentifier:NSStringFromClass([ReplyPostListCell class])];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

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


- (void)lllll {
    
    //将视频 和 图片 url  分离出来
    self.tUrlArray = [NSMutableArray arrayWithCapacity:0];
    self.hUrlArray = [NSMutableArray arrayWithCapacity:0];
    self.videoUrlArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < self.rTypeArray.count; i ++) {
        NSString *tUrl = self.picUrlArray[i];
        NSString *hUrl = self.picOriArray[i];
        //将视频 和 图片 url  分离出来
        if ([self.rTypeArray[i] integerValue] == 1) {
            [self.videoUrlArray addObject:hUrl];
        }
        else {
            [self.tUrlArray addObject:tUrl];
            [self.hUrlArray addObject:hUrl];
        }
    }
    
    // 设置表头 - 顶部帖子详情视图
    [self seTableViewHeader];
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
