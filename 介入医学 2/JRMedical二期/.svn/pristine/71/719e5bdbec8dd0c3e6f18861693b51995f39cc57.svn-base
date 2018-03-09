//
//  MyExtensionVC.m
//  JRMedical
//
//  Created by a on 16/12/21.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "MyExtensionVC.h"

#import "MyExtensionHeaderView.h"
#import "KMImageBrowser.h"
#import "MyPromotionPeopleVC.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>

@interface MyExtensionVC ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) NSMutableDictionary *shareDataDic;

@end

@implementation MyExtensionVC

// 在页面销毁时记得 remove 监听对象，否则会闪退
- (void)dealloc {
    [_webView.scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的推广";
    
    self.shareDataDic = [NSMutableDictionary dictionaryWithCapacity:0];
    
    self.automaticallyAdjustsScrollViewInsets = NO;//是否自动适应滚动视图的内嵌入；默认为YES，这里设置为NO，避免网页控件中_UIWebViewScrollView的UIWebBrowserView位置偏移
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fenxiangs"] style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarButtonItemClick)];
    
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout
    .heightIs(Height_Screen-64)
    .widthIs(Width_Screen);
    
    [self getShareDataSource];
}

#pragma mark - 获取分享参数
- (void)getShareDataSource {
    NSString *url = @"api/Customer/MyGeneralize";
    NSString *params = @"";
    
    [self showLoadding:@"正在加载" time:20];
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"动态获取UB活动数据源 - %@", modelData);
        if (isSuccess) {
            self.shareDataDic = modelData[@"JsonData"];
            [self.tableView reloadData];
            [self setupWebView];
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

#pragma mark - 分享按钮
- (void)rightBarButtonItemClick {
    
    if (self.shareDataDic.count == 0) {
        return [self showMessage:@"网络君有点慢,请稍等"];
    }
    
    //1、创建分享参数
    NSArray* imageArray = @[self.shareDataDic[@"Image"]];
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

    NSString *imageStr = self.shareDataDic[@"Image"];
    
    if (imageArray) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"介入医学app推广"
                                         images:@[imageStr]
                                            url:[NSURL URLWithString:self.shareDataDic[@"ShareUri"]]
                                          title:@"介入医学app推广"
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

#pragma mark - 设置web页加载
- (void)setupWebView {

    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.shareDataDic[@"Uri"]]]];
    
    /**
     webView缩放
     */
    self.webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.webView.scalesPageToFit = YES;
    self.webView.multipleTouchEnabled = YES;
    self.webView.userInteractionEnabled = YES;
    
    //使用kvo为webView添加监听，监听webView的内容高度  // 这句要放到loadrequest之后
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    
    self.tableView.tableFooterView = self.webView; // 这句很关键
}

#pragma mark - WebView Delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSLog(@"webViewDidFinishLoad");
    [self.hud hide:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self showLoadding:@"正在加载" time:20];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self showImage:FAIL_ICON time:1.5 message:@"加载失败"];
}

#pragma mark - KVO
// 监听webView的contentSize
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]) {
        
        NSLog(@"_webView.scrollView.contentSize.height - %f", _webView.scrollView.contentSize.height);
        CGRect newFrame      = self.webView.frame;
        newFrame.size.height = self.webView.scrollView.contentSize.height;
        self.webView.frame       = newFrame;
        
        [self.tableView setTableFooterView:self.webView];
    }
}

#pragma mark - Table view datasource and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 197;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    MyExtensionHeaderView *headerView = [[MyExtensionHeaderView alloc] initWithFrame:self.tableView.tableHeaderView.frame];
    
    [headerView setDataDic:self.shareDataDic];
    [headerView.codeImg bk_whenTapped:^{
        //查看原图
        [KMImageBrowser showImage:headerView.codeImg];
    }];
    
    [headerView.codeNumLab bk_whenTapped:^{
        //查看原图
        MyPromotionPeopleVC *mppVC = [MyPromotionPeopleVC new];
        [self.navigationController pushViewController:mppVC animated:YES];
    }];
    
    return headerView;
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor  = [UIColor whiteColor];
        _tableView.backgroundColor = BG_Color;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return  _tableView;
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, Width_Screen, 600)];
        _webView.scrollView.scrollEnabled = NO; // 禁止webview滑动,嵌入到tableview的headerView里
        _webView.scrollView.bounces = NO;
        _webView.delegate = self;
    }
    return _webView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
