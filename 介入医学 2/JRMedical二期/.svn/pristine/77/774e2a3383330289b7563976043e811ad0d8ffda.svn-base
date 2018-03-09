//
//  PdfWebViewController.m
//  JRMedical
//
//  Created by ww on 2016/11/29.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "PdfWebViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>

@interface PdfWebViewController ()<UIWebViewDelegate>
{
    int j;
}

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, assign) NSInteger DzCount;

@property (nonatomic, strong) UIImage *shareImage;

@property (nonatomic, strong) UIView *endView;

@property (nonatomic, copy) NSString *endUrl;

@end

@implementation PdfWebViewController

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
    
    j = 0;
    
    self.view.backgroundColor = BG_Color;
    
    self.automaticallyAdjustsScrollViewInsets = NO;//是否自动适应滚动视图的内嵌入；默认为YES，这里设置为NO，避免网页控件中_UIWebViewScrollView的UIWebBrowserView位置偏移
    
    self.title = self.model.BiaoTi;
    
    WeakSelf;
    self.passZiXunStatus = ^(NSInteger dzNum, NSInteger isDz, NSInteger IsShouCang) {
        [wself addFooterViewWithDzNum:dzNum IsDz:isDz IsShouCang:IsShouCang];
    };
    
    //设置详情web页
    [self setupWebView];
    
    // 获取资讯状态
    [self getCurrentTieziStatus];
    
    NSLog(@"self.model.Url - %@", self.model.Url);

}

- (void)setupWebView {
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, Width_Screen, Height_Screen-40)];
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

    [self.view addSubview:_webView];
}

#pragma mark - 添加工具栏
- (void)addFooterViewWithDzNum:(NSInteger)dzNum IsDz:(NSInteger)isDz IsShouCang:(NSInteger)isShouCang{
    
    NSArray *tagArr = @[@201, @202, @203];
    NSArray *titleArr = @[@"点赞", @"收藏", @"分享"];
    NSArray *imageArr = @[@"hengtianjinfuicon03", @"shoucang_gray", @"fenxiang"];
    NSArray *imageDoneArr = @[@"hengtianjinfuicon03z", @"shoucangz", @"fenxiangz"];
    
    for (int i = 0; i < titleArr.count; i++) {
        
        UIView *itemView = [[UIView alloc] initWithFrame:(CGRectMake(Width_Screen/3 * i, 0, Width_Screen/3, 40))];
        UIButton *item = [self makeACustomView:tagArr[i] title:titleArr[i] image:imageArr[i] imageDone:imageDoneArr[i] DzNum:dzNum IsDz:isDz IsShouCAng:isShouCang];
        [itemView addSubview:item];
        
        UILabel *lineLab = [[UILabel alloc] initWithFrame:(CGRectMake(Width_Screen/3-1, 15, 1, 10))];
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
    
    UIButton *button = [[UIButton alloc] initWithFrame:(CGRectMake(0, 0, Width_Screen/3-1, 40))];
    [button setTitle:name forState:(UIControlStateNormal)];
    [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
    button.tag = tag.integerValue;
    [button addTarget:self action:@selector(handleToolbar:) forControlEvents:(UIControlEventTouchUpInside)];
    
    if (tag.integerValue == 201) { // 点赞
        
        if (isDz == 1) {
            [button setTitleColor:RGB(230, 79, 70) forState:(UIControlStateNormal)];
            [button setImage:[UIImage imageNamed:picDone] forState:(UIControlStateNormal)];
        }else {
            [button setTitleColor:RGB(160, 160, 160) forState:(UIControlStateNormal)];
            [button setImage:[UIImage imageNamed:picName] forState:(UIControlStateNormal)];
        }
    }
    
    if (tag.integerValue == 202) { // 收藏
        if (isShouCang == 1) {
            [button setTitleColor:RGB(230, 79, 70) forState:(UIControlStateNormal)];
            [button setImage:[UIImage imageNamed:picDone] forState:(UIControlStateNormal)];
        }else {
            [button setTitleColor:RGB(160, 160, 160) forState:(UIControlStateNormal)];
            [button setImage:[UIImage imageNamed:picName] forState:(UIControlStateNormal)];
        }
    }
    
    if (tag.integerValue == 203) {
        [button setTitleColor:RGB(160, 160, 160) forState:(UIControlStateNormal)];
        [button setImage:[UIImage imageNamed:picName] forState:(UIControlStateNormal)];
    }
    
    return button;
}

#pragma mark - 工具栏Action 响应事件
- (void)handleToolbar:(UIButton *)sender {
    switch (sender.tag) {
        case 201:// 点赞
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
        case 202: // 收藏
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
        case 203: // 分享
        {
            //1、创建分享参数
            NSArray* imageArray = @[[UIImage imageNamed:@"shoucangz"]];
            // （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
            
            // 压缩图片 太大的话 微信分享不出去
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                self.shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.model.TuPian]]];
//                NSData *fData = UIImageJPEGRepresentation(_shareImage, 0.1);
//                if (fData != nil) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        _shareImage = [UIImage imageWithData:fData];
//                    });
//                }
//            });
            
            if (imageArray) {
                NSLog(@"endUrl - %@", self.endUrl);
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKSetupShareParamsByText:self.model.ZhaiYao
                                                 images:@[self.model.TuPian]
                                                    url:[NSURL URLWithString:self.endUrl]
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
    
    [self.hud hide:YES];
    
    // webview 缩放
    NSString *jsMeta = [NSString stringWithFormat:@"var meta = document.createElement('meta');meta.content='width=device-width,initial-scale=1.0,minimum-scale=.5,maximum-scale=3';meta.name='viewport';document.getElementsByTagName('head')[0].appendChild(meta);"];
    
    [_webView stringByEvaluatingJavaScriptFromString:jsMeta];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self showLoadding:@"正在加载" time:10];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
//    [self showMessage:@"加载失败"];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    
    if (j == 0) {
        
        if ([self.model.Url containsString:@"pdf"]) {
            
            NSString *urlString = [[request URL] absoluteString];
            urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"urlString=%@",urlString);
            
            NSArray *arr = [urlString componentsSeparatedByString:@"/"];
            NSLog(@"%@", arr);
            
            NSString *idStr = (NSString *)arr.lastObject;
            NSLog(@"%@", idStr);
            
            NSString *wantUrl = [NSString stringWithFormat:@"http://www.jieruyixue.com/UploadFiles/Temp/%@#pdfjs.action=download", idStr];
            NSLog(@"%@",wantUrl);
            self.endUrl = wantUrl;
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:wantUrl]]];
            
        } else {
            
            NSLog(@"医学文献的url不用处理了");
        }
        
    }
    
    j++;
    
    NSLog(@"%d", j);
    
    return YES;
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
