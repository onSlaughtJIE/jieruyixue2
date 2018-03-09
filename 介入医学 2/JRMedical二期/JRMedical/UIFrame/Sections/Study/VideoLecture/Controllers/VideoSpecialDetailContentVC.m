//
//  VideoSpecialDetailContentVC.m
//  JRMedical
//
//  Created by a on 16/11/17.
//  Copyright © 2016年 idcby. All rights reserved.
//
#import <YYKit.h>

#import "VideoSpecialDetailContentVC.h"

#import "AuthorIntroduceView.h"
#import "AuthorInfoView.h"
#import "VideoDetailOtherInfoView.h"
#import "SpPingLunViewController.h"

#import "MyCertificationVC.h"

#import "UIScrollView+UITouch.h"

#import "SpCommentModel.h"
#import "SpPingluCell.h"
#import "UITableView+EmpayData.h"

#import "VideoMajorCell.h"
#import "PublicNewsListModel.h"
#import "UICollectionView+EmpayData.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>

#define ScrollView_Height             Height_Screen-Height_SixteenToNine-104
#define SVVideo_SizeHeight(num)    num/2*(((((Width_Screen-15)/2)-20)/16*9)+86+5)

@interface VideoSpecialDetailContentVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UIWebViewDelegate,UIScrollViewDelegate,UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIWebView *videoPlayWebView;
@property (strong, nonatomic) UILabel *webBGView;
@property (strong, nonatomic) UIView *topWhiteView;
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UIImageView *playIcon;
@property (strong, nonatomic) UILabel *playNumLab;

@property (nonatomic, strong) UIImage *shareImage;

@property (nonatomic, strong) UIView *endView; // 底部工具视图

@property (strong, nonatomic) UIScrollView *scrollVideoView;//相关视频的滑动视图
@property (strong, nonatomic) UITableView *pTableView;//评论列表
@property (strong, nonatomic) UICollectionView *vCollectionView;//相关视频列表

@property (strong, nonatomic) NSMutableArray *pDataSource;//相关评论数据源
@property (strong, nonatomic) NSMutableArray *vDataSource;//相关视频数据源

@end

@implementation VideoSpecialDetailContentVC {
    
    BOOL _isTransform;//是否展开简介
    
    VideoDetailOtherInfoView *_footerView;
    
    BOOL _isVideoOrPinglun; //是否 展开 视频 或评论
    
    NSInteger _goToPingLun;
    
    AuthorIntroduceView *_IntroduceView;
    AuthorInfoView *_headerView;
}

static NSString *_videoUrl;

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidBecomeVisibleNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidBecomeHiddenNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PingLunSuccess" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_goToPingLun != 201) {
        [self.videoPlayWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_videoUrl]]];
    }
    
    //设置标题大小
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    NSInteger isDoctor =  [NSUserDf_Get(kDoctor) integerValue];//是否是医师
    
    if (isDoctor == 0) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"只有认证医生才可以查看视频内容,是否去认证?" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (_goToPingLun != 201) {
        [self.videoPlayWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    }
    
    //设置标题大小
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pDataSource = [NSMutableArray arrayWithCapacity:0];
    self.vDataSource = [NSMutableArray arrayWithCapacity:0];
    
    self.view.backgroundColor = RGB(230, 230, 230);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(begainFullScreen) name:UIWindowDidBecomeVisibleNotification object:nil];//进入全屏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endFullScreen) name:UIWindowDidBecomeHiddenNotification object:nil];//退出全屏
    
    
    //评论成功的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pingLunSuccessClick) name:@"PingLunSuccess" object:nil];
    
    //初始化视频详情页
    [self initVideoDetailContentView];
    
    //初始化底部视图信息
    [self initBotInfoView];
    
    //增加浏览计数
    [self addBrowseVideoJiShu];
    
    //加载播放视频及其他数据
    [self loadVideoPlay:self.model];
    
    [self addFooterView];
}

#pragma mark - 通知刷新评价
- (void)pingLunSuccessClick {
    //请求相关评论列表
    [self requestPingListDataArrray:self.model];
}

#pragma mark - 加载播放视频
- (void)loadVideoPlay:(PublicNewsListModel *)model {
    
    self.model = model;
    
    self.title = model.BiaoTi;
    
    _videoUrl = model.VideoUri;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_videoUrl]];
    [self.videoPlayWebView loadRequest:request];
    
    //标题
    self.titleLab.text = self.model.BiaoTi;
    
    //播放数
    if (model.LiuLanJiLu < 1000) {
        self.playNumLab.text = [NSString stringWithFormat:@"%.0f次",model.LiuLanJiLu];
    }
    else if (model.LiuLanJiLu >= 10000) {
        self.playNumLab.text = [NSString stringWithFormat:@"%.1f万次",model.LiuLanJiLu/10000];
    }
    else {
        self.playNumLab.text = [NSString stringWithFormat:@"%.1f千次",model.LiuLanJiLu/1000];
    }
    CGSize playNumLabWidth = [Utils sizeForTitle:self.playNumLab.text withFont:[UIFont systemFontOfSize:12.5]];//播放数量lab宽度
    self.playNumLab.sd_resetLayout.rightSpaceToView(self.topWhiteView,10).centerYEqualToView(self.topWhiteView).widthIs(playNumLabWidth.width).heightIs(13);
    
    //人物简介视图
    [_IntroduceView setContentString:model.VideoDocDesc];
    
    //人物信息视图
    [_headerView setModel:model];
    
    //请求相关视频列表
    [self requestVideoListDataArrray:model];
    
    //请求相关评论列表
    [self requestPingListDataArrray:model];
}

#pragma mark - UIWebViewDelegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@":%@----:%ld",request.URL,(long)navigationType);
    
    //防止调回视频对应的客户端
    NSString *urlStr = request.URL.absoluteString;
    if ([urlStr rangeOfString:@"sohuvideo:"].location != NSNotFound //拦截搜狐
        || [urlStr rangeOfString:@"action.cmd"].location != NSNotFound) {
        return NO;
    }
    else{
        return YES;
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self showLoadding:@"" time:10 view:self.videoPlayWebView];
    
    self.webBGView.text = @"视频正在加载,请稍后...";
    self.webBGView.hidden = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    self.webBGView.hidden = YES;
    
    NSInteger height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] intValue];
    
    NSLog(@"%ld",(long)height);
    
    [self.hud hide:YES];
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

#pragma mark - 初始化视频详情视图
- (void)initVideoDetailContentView {
    
    //人物简介视图
    _IntroduceView = [AuthorIntroduceView new];
    [self.view addSubview:_IntroduceView];
    _IntroduceView.sd_layout.topSpaceToView(self.view,Height_SixteenToNine+120).widthIs(Width_Screen).heightIs(80);
    
    //人物信息视图
    _headerView = [AuthorInfoView new];
    [self.view addSubview:_headerView];
    _headerView.sd_layout.topSpaceToView(self.view,Height_SixteenToNine+40).widthIs(Width_Screen).heightIs(80);
    
    //视频信息视图
    [self.view addSubview:self.videoPlayWebView];//视频播放web
    [self.videoPlayWebView addSubview:self.webBGView];//占位view
    [self.view addSubview:self.topWhiteView];//视频信息
    [self.topWhiteView addSubview:self.playNumLab];
    [self.topWhiteView addSubview:self.playIcon];
    [self.topWhiteView addSubview:self.titleLab];
    
    self.topWhiteView.sd_layout.topSpaceToView(self.videoPlayWebView,0).leftSpaceToView(self.view,0).rightSpaceToView(self.view,0).heightIs(40);
    
    CGSize playNumLabWidth = [Utils sizeForTitle:self.playNumLab.text withFont:[UIFont systemFontOfSize:12.5]];//播放数量lab宽度
    self.playNumLab.sd_layout.rightSpaceToView(self.topWhiteView,10).centerYEqualToView(self.topWhiteView).widthIs(playNumLabWidth.width).heightIs(13);
    self.playIcon.sd_layout.rightSpaceToView(self.playNumLab,3).centerYEqualToView(self.topWhiteView).widthIs(15).heightIs(15);
    self.titleLab.sd_layout.leftSpaceToView(self.topWhiteView,10).rightSpaceToView(self.playIcon,10).centerYEqualToView(self.topWhiteView).heightIs(15);
    
    [_IntroduceView bk_whenTapped:^{//  展开  收起  更多简介
        
        if (_isTransform) {//展开
            
            _isTransform = NO;
            _IntroduceView.xiaLaImg.transform = CGAffineTransformMakeRotation(M_PI_2*2);
            
            NSString *content = self.model.VideoDocDesc;
            CGRect contentHeight = [Utils getTextRectWithString:content withWidth:Width_Screen-20 withFontSize:14.5];
            
            if (contentHeight.size.height > 34.6) {
                _IntroduceView.sd_resetLayout.topSpaceToView(self.view,Height_SixteenToNine+120).widthIs(Width_Screen).heightIs(contentHeight.size.height+80);
            }
            else {
                _IntroduceView.sd_resetLayout.topSpaceToView(self.view,Height_SixteenToNine+120).widthIs(Width_Screen).heightIs(80);
            }
            
            [self.view addSubview:self.scrollVideoView];
            [self.view bringSubviewToFront:_footerView];
            [self.view bringSubviewToFront:_IntroduceView];
            [self.view bringSubviewToFront:_headerView];
            [self.view bringSubviewToFront:self.topWhiteView];
            [self.view bringSubviewToFront:self.videoPlayWebView];
            [self.view bringSubviewToFront:self.endView];
        }
        else {//收起
            
            _isTransform = YES;
            _IntroduceView.xiaLaImg.transform = CGAffineTransformIdentity;
            _IntroduceView.sd_resetLayout.topSpaceToView(self.view,Height_SixteenToNine+120).widthIs(Width_Screen).heightIs(80);
            
            [self.view bringSubviewToFront:_IntroduceView];
            [self.view bringSubviewToFront:_headerView];
            [self.view addSubview:self.scrollVideoView];
            [self.view bringSubviewToFront:_footerView];
            [self.view bringSubviewToFront:self.topWhiteView];
            [self.view bringSubviewToFront:self.videoPlayWebView];
            [self.view bringSubviewToFront:self.endView];
        }
        
    }];
    
    [_headerView.followBtn bk_whenTapped:^{//加关注
        
    }];
}

- (void)initBotInfoView {
    
    [self.view addSubview:self.scrollVideoView];
    
    self.scrollVideoView.sd_layout.topSpaceToView(self.view,Height_SixteenToNine+245).widthIs(Width_Screen).heightIs(Height_Screen-(Height_SixteenToNine+245+104));
    self.scrollVideoView.contentSize = CGSizeMake(Width_Screen*2, 0);
    
    //相关视频 评论视图
    _footerView = [VideoDetailOtherInfoView new];
    [self.view addSubview:_footerView];
    _footerView.sd_layout.topSpaceToView(self.view,Height_SixteenToNine+200).widthIs(Width_Screen).heightIs(45);
    
    [self.scrollVideoView addSubview:self.vCollectionView];
    [self.scrollVideoView addSubview:self.pTableView];
    
    [_footerView.relevantVideoLab bk_whenTapped:^{//相关视频
        _footerView.relevantVideoLab.textColor = Main_Color;
        _footerView.commentLab.textColor = [UIColor blackColor];
        
        self.scrollVideoView.contentOffset = CGPointMake(0, 0);
    }];
    [_footerView.commentLab bk_whenTapped:^{//相关评论
        _footerView.relevantVideoLab.textColor = [UIColor blackColor];
        _footerView.commentLab.textColor = Main_Color;
        
        self.scrollVideoView.contentOffset = CGPointMake(Width_Screen, 0);
    }];
    [_footerView.isZhanKai bk_whenTapped:^{//展开相关视频视图
        if (_isVideoOrPinglun) {//展开
            
            _isTransform = YES;
            _IntroduceView.xiaLaImg.transform = CGAffineTransformIdentity;
            _IntroduceView.sd_resetLayout.topSpaceToView(self.view,Height_SixteenToNine+120).widthIs(Width_Screen).heightIs(80);
            
            [self.view bringSubviewToFront:_IntroduceView];
            [self.view bringSubviewToFront:_headerView];
            [self.view addSubview:self.scrollVideoView];
            [self.view bringSubviewToFront:_footerView];
            [self.view bringSubviewToFront:self.topWhiteView];
            [self.view bringSubviewToFront:self.videoPlayWebView];
            [self.view bringSubviewToFront:self.endView];
            
            _isVideoOrPinglun = NO;
            _footerView.isZhanKai.imageView.transform = CGAffineTransformMakeRotation(M_PI_2*2);
            
            self.scrollVideoView.sd_layout.topSpaceToView(self.view,Height_SixteenToNine+85).widthIs(Width_Screen).heightIs(Height_Screen-(Height_SixteenToNine+85+104));
            _footerView.sd_layout.topSpaceToView(self.view,Height_SixteenToNine+40).widthIs(Width_Screen).heightIs(45);
            
            self.vCollectionView.frame = CGRectMake(0, 0, Width_Screen, Height_Screen-(Height_SixteenToNine+85+104));
            self.pTableView.frame = CGRectMake(Width_Screen, 0, Width_Screen, Height_Screen-(Height_SixteenToNine+85+104));
        }
        else {//收起
            
            _isVideoOrPinglun = YES;
            _footerView.isZhanKai.imageView.transform = CGAffineTransformIdentity;
            
            self.scrollVideoView.sd_layout.topSpaceToView(self.view,Height_SixteenToNine+245).widthIs(Width_Screen).heightIs(Height_Screen-(Height_SixteenToNine+245+104));
            _footerView.sd_layout.topSpaceToView(self.view,Height_SixteenToNine+200).widthIs(Width_Screen).heightIs(45);
            
            self.vCollectionView.frame = CGRectMake(0, 0, Width_Screen, Height_Screen-(Height_SixteenToNine+245+104));
            self.pTableView.frame = CGRectMake(Width_Screen, 0, Width_Screen, Height_Screen-(Height_SixteenToNine+245+104));
        }
    }];
}

#pragma mark - 布局及设置相关视频页面  和 评论页面
- (UIScrollView *)scrollVideoView {
    if (!_scrollVideoView) {
        _scrollVideoView = [UIScrollView new];
        _scrollVideoView.backgroundColor = KMRC;
        _scrollVideoView.delegate = self;
        _scrollVideoView.bounces = NO;
        _scrollVideoView.scrollEnabled = NO;
    }
    return _scrollVideoView;
}

- (UITableView *)pTableView {
    if (!_pTableView) {
        _pTableView = [[UITableView alloc] initWithFrame:CGRectMake(Width_Screen, 0, Width_Screen, Height_Screen-(Height_SixteenToNine+245+104)) style:UITableViewStyleGrouped];
        _pTableView.delegate = self;
        _pTableView.dataSource = self;
        _pTableView.backgroundColor = BG_Color;
        _pTableView.separatorColor = BG_Color;
        [_pTableView registerNib:[UINib nibWithNibName:@"SpPingluCell" bundle:nil] forCellReuseIdentifier:@"plCell"];

        // 评论cell自适应高度
        _pTableView.estimatedRowHeight = 100;
        _pTableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _pTableView;
}

- (UICollectionView *)vCollectionView {
    if (!_vCollectionView) {
        _vCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Width_Screen, Height_Screen-(Height_SixteenToNine+245+104)) collectionViewLayout:[self getFlowLayout]];
        _vCollectionView.delegate = self;
        _vCollectionView.dataSource = self;
        _vCollectionView.backgroundColor = BG_Color;
        [_vCollectionView registerClass:[VideoMajorCell class] forCellWithReuseIdentifier:NSStringFromClass([VideoMajorCell class])];
    }
    return  _vCollectionView;
}

#pragma mark - UITableView Datasource Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.pDataSource == nil) {
        [tableView tableViewDisplayWitMsg:@"" ifNecessaryForRowCount:self.pDataSource.count];
    }
    else {
        [tableView tableViewDisplayWitMsg:@"还没有人评论过,快来评论吧!" ifNecessaryForRowCount:self.pDataSource.count];
    }
    return self.pDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SpCommentModel *model = self.pDataSource[indexPath.row];
    SpPingluCell *pinglunCell = [tableView dequeueReusableCellWithIdentifier:@"plCell" forIndexPath:indexPath];
    [pinglunCell setModel:model];
    return pinglunCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 请求相关评论数据列表
- (void)requestPingListDataArrray:(PublicNewsListModel *)model {
    
    NSString *url = @"api/News/EvaluateList";
    NSString *params = [NSString stringWithFormat:@"ZICBDYCResourcesType=%@ZICBDYCResourcesID=%@ZICBDYCCurPage=%@ZICBDYCPageSize=%@",@"1",model.ID,@"0",@"10"];
    
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"相关评论列表 - %@", modelData);
        if (isSuccess) {
            
            [self.pDataSource removeAllObjects];
            
            NSArray *dataAry = modelData[@"JsonData"];
            
            NSArray *data = [NSArray modelArrayWithClass:SpCommentModel.class json:dataAry];
            
            [self.pDataSource addObjectsFromArray:data];
            
            [self.pTableView reloadData];
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

#pragma mark - UICollectionView DataSource Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.vDataSource == nil) {
        [collectionView collectionViewDisplayWitMsg:@"" ifNecessaryForRowCount:self.vDataSource.count widthDuiQi:0];
    }
    else {
        [collectionView collectionViewDisplayWitMsg:@"暂无相关视频信息!" ifNecessaryForRowCount:self.vDataSource.count widthDuiQi:0];
    }
    return self.vDataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PublicNewsListModel *model = self.vDataSource[indexPath.row];
    VideoMajorCell *item = (VideoMajorCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([VideoMajorCell class]) forIndexPath:indexPath];
    [item setModel:model];
    return item;
}


//定义每个Section 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PublicNewsListModel *model = self.vDataSource[indexPath.row];
    [self loadVideoPlay:model];
}

#pragma mark - 布局
- (UICollectionViewFlowLayout *)getFlowLayout {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置单元格大小
    layout.itemSize = CGSizeMake((Width_Screen-15)/2, ((((Width_Screen-15)/2)-20)/16*9)+86);
    //每一行的分割线(——)
    layout.minimumLineSpacing = 5;
    //每一列的分割线（|）
    layout.minimumInteritemSpacing = 5;
    return layout;
}

#pragma mark - 请求相关视频数据列表
- (void)requestVideoListDataArrray:(PublicNewsListModel *)model {

    NSString *url = @"api/News/RelevantViedoList";
    NSString *params = [NSString stringWithFormat:@"ZICBDYCVideoID=%@ZICBDYCCurPage=%@ZICBDYCPageSize=%@",model.ID,@"0",@"8"];
    
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"相关视频列表 - %@", modelData);
        if (isSuccess) {
            
            [self.vDataSource removeAllObjects];
            
            NSArray *dataAry = modelData[@"JsonData"];
            
            NSArray *data = [NSArray modelArrayWithClass:PublicNewsListModel.class json:dataAry];
            
            [self.vDataSource addObjectsFromArray:data];
            
            [self.vCollectionView reloadData];
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

#pragma mark - 添加工具栏
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

- (void)addFooterView {
    
    NSArray *tagArr = @[@201, @202, @203, @204];
    NSArray *titleArr = @[@"评论", @"点赞", @"收藏", @"分享"];
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
            
            _goToPingLun = 201;
            
            SpPingLunViewController *plVc = [SpPingLunViewController new];
            BaseNavigationController *plNC = [[BaseNavigationController alloc] initWithRootViewController:plVc];
            plVc.ID = self.model.ID;
            [self presentViewController:plNC animated:YES completion:nil];
        }
            break;
        case 202:// 点赞
        {
            NSString *params = [NSString stringWithFormat:@"ZICBDYCResourcesType=%@ZICBDYCResourcesID=%@",@"1",self.model.ID];
            NSString *url = @"api/News/AddLiked";
            
            [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
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
            NSString *params = [NSString stringWithFormat:@"ZICBDYCResourcesType=%@ZICBDYCResourcesID=%@",@"1",self.model.ID];
            NSString *url = @"api/News/AddCollection";
            
            [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
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
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"cleanCollectionNews" object:nil userInfo:nil];
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
            NSArray* imageArray = @[[UIImage imageNamed:@"shoucangz"]];
            // （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
            
            // 压缩图片 太大的话 微信分享不出去
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                self.shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.model.TuPian]]];
                NSData *fData = UIImageJPEGRepresentation(_shareImage, 0.1);
                if (fData != nil) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _shareImage = [UIImage imageWithData:fData];
                    });
                }
            });
            
            if (imageArray) {
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKSetupShareParamsByText:self.model.ZhaiYao
                                                 images:imageArray
                                                    url:[NSURL URLWithString:self.model.VideoUri]
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

#pragma Mark - 获取视频状态
- (void)getCurrentVideoStatus {
    
    NSString *params = [NSString stringWithFormat:@"ZICBDYCZiXunID=%@",self.model.ID];
    NSString *url = @"api/News/GetNewDetail";
    
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"获取视频状态 - %@", modelData);
        if (isSuccess) {
            NSInteger IsDZ = [modelData[@"JsonData"][@"IsDianZan"] integerValue];
            NSInteger IsShouCang = [modelData[@"JsonData"][@"IsShouCang"] integerValue];
            
            UIButton *dzBtn = (UIButton *)[self.view viewWithTag:202];
            UIButton *scBtn = (UIButton *)[self.view viewWithTag:203];
            
            if (IsDZ == 0) {
                [dzBtn setTitleColor:RGB(160, 160, 160) forState:(UIControlStateNormal)];
                [dzBtn setImage:[UIImage imageNamed:@"hengtianjinfuicon03"] forState:(UIControlStateNormal)];
            }
            else {
                [dzBtn setTitleColor:RGB(230, 79, 70) forState:(UIControlStateNormal)];
                [dzBtn setImage:[UIImage imageNamed:@"hengtianjinfuicon03z"] forState:(UIControlStateNormal)];
            }
            
            if (IsShouCang == 0) {
                [scBtn setTitleColor:RGB(160, 160, 160) forState:(UIControlStateNormal)];
                [scBtn setImage:[UIImage imageNamed:@"shoucang_gray"] forState:(UIControlStateNormal)];
            }
            else {
                [scBtn setTitleColor:RGB(230, 79, 70) forState:(UIControlStateNormal)];
                [scBtn setImage:[UIImage imageNamed:@"shoucangz"] forState:(UIControlStateNormal)];
            }
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

#pragma Mark - 增加浏览计数
- (void)addBrowseVideoJiShu {
    
    NSString *params = [NSString stringWithFormat:@"ZICBDYCResourcesType=%@ZICBDYCResourcesID=%@",@"1",self.model.ID];
    NSString *url = @"api/News/AddBrowse";
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"增加浏览计数 - %@", modelData);
        if (isSuccess) {
            // 获取资讯状态
            [self getCurrentVideoStatus];
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
- (UIWebView *)videoPlayWebView {
    if (!_videoPlayWebView) {
        _videoPlayWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, Width_Screen, Height_SixteenToNine)];
        _videoPlayWebView.backgroundColor = [UIColor blackColor];
        _videoPlayWebView.delegate = self;
        _videoPlayWebView.scrollView.scrollEnabled = YES;
    }
    return _videoPlayWebView;
}
- (UILabel *)webBGView {
    if (!_webBGView) {
        _webBGView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Width_Screen, Height_SixteenToNine)];
        _webBGView.textColor = [UIColor whiteColor];
        //        _webBGView.hidden = YES;
        _webBGView.font = [UIFont systemFontOfSize:14];
        _webBGView.textAlignment = NSTextAlignmentCenter;
        _webBGView.backgroundColor = RGB(100, 100, 100);
    }
    return _webBGView;
}
- (UIView *)topWhiteView {
    if (!_topWhiteView) {
        _topWhiteView = [UIView new];
        _topWhiteView.backgroundColor = [UIColor whiteColor];
        _topWhiteView.layer.shadowColor = RGB(100, 100, 100).CGColor;//阴影颜色
        _topWhiteView.layer.shadowOffset = CGSizeMake(0 , 1);//偏移距离
        _topWhiteView.layer.shadowOpacity = 0.5;//不透明度
        _topWhiteView.layer.shadowRadius = 3.0;//半径
    }
    return _topWhiteView;
}
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont systemFontOfSize:14];
    }
    return _titleLab;
}
- (UILabel *)playNumLab {
    if (!_playNumLab) {
        _playNumLab = [UILabel new];
        _playNumLab.font = [UIFont systemFontOfSize:12];
        _playNumLab.textAlignment = NSTextAlignmentRight;
        _playNumLab.textColor = Main_Color;
    }
    return _playNumLab;
}
- (UIImageView *)playIcon {
    if (!_playIcon) {
        _playIcon = [UIImageView new];
        _playIcon.image = [UIImage imageNamed:@"bofangs"];
    }
    return _playIcon;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
