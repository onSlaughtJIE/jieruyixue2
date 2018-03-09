//
//  LearnWebController.m
//  JRMedical
//
//  Created by apple on 16/7/8.
//  Copyright © 2016年 ZC. All rights reserved.
//

#import "LearnWebController.h"

#import "SpPingLunViewController.h"
#import "SpPingluCell.h"
#import "SpCommentModel.h"
#import "LearnRelevantNewsCell.h"

#import "VideoSpecialDetailContentVC.h"
#import "PdfWebViewController.h"
#import "PublicNewsListModel.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>

@interface LearnWebController ()<UIWebViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *webTableView;

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSMutableArray *timeArr;
@property (nonatomic, strong) NSMutableArray *nameArr;

@property (nonatomic, strong) NSMutableArray *relevantZiXunAry;

@property (nonatomic, assign) NSInteger DzCount;

@property (nonatomic, strong) UIImage *shareImage;

@property (nonatomic, strong) UIView *endView;

@end

@implementation LearnWebController

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


// 在页面销毁时记得 remove 监听对象，否则会闪退
- (void)dealloc {
    [_webView.scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark 重新刷新页面
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //设置标题大小
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

-(void)viewWillDisappear:(BOOL)antimated{
    [super viewWillDisappear:antimated];
    
    //设置标题大小
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = BG_Color;
    
    
    self.relevantZiXunAry = [NSMutableArray arrayWithCapacity:0];
    
    self.automaticallyAdjustsScrollViewInsets = NO;//是否自动适应滚动视图的内嵌入；默认为YES，这里设置为NO，避免网页控件中_UIWebViewScrollView的UIWebBrowserView位置偏移
    
    self.title = self.model.BiaoTi;
    
    WeakSelf;
    self.passZiXunStatus = ^(NSInteger dzNum, NSInteger isDz, NSInteger IsShouCang) {
        [wself addFooterViewWithDzNum:dzNum IsDz:isDz IsShouCang:IsShouCang];
    };
    
    //设置评论表
    [self setTableView];
    
    //设置详情web页
    [self setupWebView];
    
    // 获取资讯状态
    [self getCurrentTieziStatus];
    
    //评论成功的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PingLunSuccessClick) name:@"PingLunSuccess" object:nil];
    
    NSLog(@"资讯详情网址 - %@", self.model.Url);
}

#pragma mark - 评论成功的通知 再次请求刷新评论列表
-(void)PingLunSuccessClick {
    [self getCommentsList];
}

- (void)setTableView {
    
    self.webTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width_Screen, Height_Screen-104) style:(UITableViewStylePlain)];
    [self.view addSubview:_webTableView];
    _webTableView.delegate = self;
    _webTableView.dataSource = self;
    _webTableView.backgroundColor = BG_Color;
    _webTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_webTableView registerNib:[UINib nibWithNibName:@"SpPingluCell" bundle:nil] forCellReuseIdentifier:@"plCell"];
    [_webTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [_webTableView registerClass:[LearnRelevantNewsCell class] forCellReuseIdentifier:NSStringFromClass([LearnRelevantNewsCell class])];

    
    // 评论cell自适应高度
    _webTableView.estimatedRowHeight = 100;
    _webTableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)setupWebView {

    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, Width_Screen, 600)];
    _webView.scrollView.scrollEnabled = NO; // 禁止webview滑动,嵌入到tableview的headerView里
    _webView.scrollView.bounces = NO;
    _webView.delegate = self;
    [_webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.model.Url]]];
    
    /**
     webView缩放
     */
    self.webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.webView.scalesPageToFit = YES;
    self.webView.multipleTouchEnabled = YES;
    self.webView.userInteractionEnabled = YES;
    
    //使用kvo为webView添加监听，监听webView的内容高度  // 这句要放到loadrequest之后
    [_webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    
    self.webTableView.tableHeaderView = _webView; // 这句很关键
}

#pragma mark - datasource  delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if (self.relevantZiXunAry.count > 0) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.relevantZiXunAry.count > 0) {
        if (section == 0) {
            return self.relevantZiXunAry.count;
        }
        else {
            return self.dataSource.count > 0 ? self.dataSource.count : 1;
        }
    }
    else {
        return self.dataSource.count > 0 ? self.dataSource.count : 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.relevantZiXunAry.count > 0) {
        if (indexPath.section == 0) {
            
            PublicNewsListModel *model = self.relevantZiXunAry[indexPath.row];
            LearnRelevantNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LearnRelevantNewsCell class]) forIndexPath:indexPath];
            [cell setArrayNum:self.relevantZiXunAry.count];
            [cell setIndexPath:indexPath];
            [cell setModel:model];
            
            return cell;
        }
        else {
            if (self.dataSource.count > 0) {
                SpCommentModel *model = self.dataSource[indexPath.row];
                SpPingluCell *pinglunCell = [tableView dequeueReusableCellWithIdentifier:@"plCell" forIndexPath:indexPath];
                [pinglunCell setModel:model];
                return pinglunCell;
            }
            else {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
                cell.textLabel.text = @"还没有人评论过,快来评论吧!";
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                cell.textLabel.textColor = RGB(0, 164, 156);
                return cell;
            }
        }
    }
    else {
        if (self.dataSource.count > 0) {
            SpCommentModel *model = self.dataSource[indexPath.row];
            SpPingluCell *pinglunCell = [tableView dequeueReusableCellWithIdentifier:@"plCell" forIndexPath:indexPath];
            [pinglunCell setModel:model];
            return pinglunCell;
        }
        else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            cell.textLabel.text = @"还没有人评论过,快来评论吧!";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = RGB(0, 164, 156);
            return cell;
        }
    }
}

#pragma mark - 区头 / 区尾
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width_Screen, 40)];
    [view setBackgroundColor:RGB(255, 255, 255)];
    
    UIImageView *greenView = [[UIImageView alloc] initWithFrame:(CGRectMake(5, 5, 2, 30))];
    greenView.image = [UIImage imageNamed:@"矩形-6"];
    [view addSubview:greenView];
    
    UILabel *headTitle = [[UILabel alloc] initWithFrame:(CGRectMake(12, 5, 40, 30))];
    headTitle.text = @"评论";
    [view addSubview:headTitle];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:(CGRectMake(0, 39, Width_Screen, 1))];
    lineLabel.backgroundColor = RGB(239, 240, 241);
    [view addSubview:lineLabel];
    
    if (self.relevantZiXunAry.count > 0) {
        if (section == 0) {
            return nil;
        }
        else {
            return view;
        }
    }
    else {
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.relevantZiXunAry.count > 0) {
        if (section == 0) {
            return 0.00001;
        }
        else {
            return 40;
        }
    }
    else {
        return 40;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (self.relevantZiXunAry.count > 0) {
        
        PublicNewsListModel *model = self.relevantZiXunAry[indexPath.row];
        
        NSString *isVideo = model.GroupCode;
        
        if ([isVideo isEqualToString:@"VideoLecturesMajor"]) {//视频
            VideoSpecialDetailContentVC *vSDContentVC = [[VideoSpecialDetailContentVC alloc] init];
            vSDContentVC.model = model;
            [self.navigationController pushViewController:vSDContentVC animated:YES];
        }
        else {
            if ([model.Url containsString:@"pdf"]) {
                // 进入医学课件
                PdfWebViewController *webVC = [[PdfWebViewController alloc] init];
                webVC.model = model;
                [self.navigationController pushViewController:webVC animated:YES];
                
            }
            else {
                LearnWebController *webVC = [[LearnWebController alloc] init];
                webVC.model = model;
                [self.navigationController pushViewController:webVC animated:YES];
            }
        }
    }
}

#pragma mark - 添加工具栏
- (void)addFooterViewWithDzNum:(NSInteger)dzNum IsDz:(NSInteger)isDz IsShouCang:(NSInteger)isShouCang {
    
    NSArray *tagArr = @[@201, @202, @203, @204];
    NSArray *titleArr = @[@"评论", @"点赞", @"收藏", @"分享"];
    NSArray *imageArr = @[@"groupcopy5", @"hengtianjinfuicon03", @"shoucang_gray", @"fenxiang"];
    NSArray *imageDoneArr = @[@"groupcopy5z", @"hengtianjinfuicon03z", @"shoucangz", @"fenxiangz"];
    
    for (int i = 0; i < titleArr.count; i++) {

        UIView *itemView = [[UIView alloc] initWithFrame:(CGRectMake(Width_Screen/4 * i, 0, Width_Screen/4, 40))];
        UIButton *item = [self makeACustomView:tagArr[i] title:titleArr[i] image:imageArr[i] imageDone:imageDoneArr[i] DzNum:dzNum IsDz:isDz IsShouCAng:isShouCang];
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
- (UIButton *)makeACustomView:(NSNumber *)tag title:(NSString *)name image:(NSString *)picName imageDone:(NSString *)picDone DzNum:(NSInteger)dzNum IsDz:(NSInteger)isDz IsShouCAng:(NSInteger)isShouCang {
    
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

#pragma mark - WebView Delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSLog(@"webViewDidFinishLoad");
    // 加载完成页面之后不允许让页面放大或者缩小,
    // 通过stringByEvaluatingJavaScriptFromString方法来动态添加js代码：
//    NSString *injectionJSString = @"var script = document.createElement('meta');"
//    "script.name = 'viewport';"
//    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
//    "document.getElementsByTagName('head')[0].appendChild(script);";
//    [webView stringByEvaluatingJavaScriptFromString:injectionJSString];
    
    // 标签里的scale 值就是页面的初始化页面大小< initial-scale >和可伸缩放大最大< maximum-scale >和最小< minimum-scale >的的倍数。如果还有别的需求可自行设置,如果都为1表示初始化的时候显示为原来大小,可缩放的大小都为原来的大小<即不可缩放>。
    
    [self.hud hide:YES];
    
    [self getCommentsList];
    
    [self getRelevantZiXunList];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self showLoadding:@"正在加载" time:10];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self showMessage:@"加载失败"];
}

#pragma mark - KVO
// 监听webView的contentSize
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]) {
        
        NSLog(@"_webView.scrollView.contentSize.height - %f", _webView.scrollView.contentSize.height);
        CGRect newFrame      = _webView.frame;
        newFrame.size.height = _webView.scrollView.contentSize.height;
        _webView.frame       = newFrame;
        
        [self.webTableView setTableHeaderView:_webView];
    }
}

#pragma mark - 评论列表数据接口
- (void)getCommentsList {
    
    NSString *params = [NSString stringWithFormat:@"ZICBDYCResourcesType=%@ZICBDYCResourcesID=%@",@"1",self.model.ID];
    NSString *url = @"api/News/EvaluateList";
    
    self.tableType = 1;//表类
    self.baseTableView = self.webTableView;//将本类表 赋值给父类去操作
    [self loadDataApi:url withParams:params refresh:RefreshTypeFooter model:SpCommentModel.class];
}

#pragma mark - 相关资讯数据接口
- (void)getRelevantZiXunList {
    
    NSString *params = [NSString stringWithFormat:@"ZICBDYCZiXunID=%@",self.model.ID];
    NSString *url = @"api/News/GetNewByLable";
    
    NSLog(@"%@",self.model.ID);
    
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"获取相关资讯 - %@", modelData);
        if (isSuccess) {
            
            [self.relevantZiXunAry removeAllObjects];
            
            NSArray *dataAry = [modelData objectForKey:@"JsonData"];
            
            NSArray *data = nil;
            if (self.modelClass == nil) {
                data = dataAry;
            }
            else {
                data = [NSArray modelArrayWithClass:PublicNewsListModel.class json:dataAry];
            }
            
            [self.relevantZiXunAry addObjectsFromArray:data];
            
            [self.webTableView reloadData];
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

#pragma Mark - 获取资讯状态
- (void)getCurrentTieziStatus {
    
    NSString *params = [NSString stringWithFormat:@"ZICBDYCZiXunID=%@",self.model.ID];
    NSString *url = @"api/News/GetNewDetail";
    
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"获取资讯状态 - %@", modelData);
        if (isSuccess) {
            self.DzCount = [modelData[@"JsonData"][@"DianZhanShuLiang"] integerValue];
            NSInteger IsDZ = [modelData[@"JsonData"][@"IsDianZan"] integerValue];
            NSInteger IsShouCang = [modelData[@"JsonData"][@"IsShouCang"] integerValue];
            self.passZiXunStatus(self.DzCount, IsDZ, IsShouCang);
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
