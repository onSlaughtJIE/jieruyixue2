//
//  EquipmentSuppliesWebVC.m
//  JRMedical
//
//  Created by a on 16/12/24.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "EquipmentSuppliesWebVC.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>

@interface EquipmentSuppliesWebVC ()<UIWebViewDelegate>

@property (nonatomic , strong)UIWebView *webView;

@end

@implementation EquipmentSuppliesWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置导航栏右边按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fenxiangs"] style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarButtonItemClick)];
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, Width_Screen, Height_Screen-64)];
    self.webView.userInteractionEnabled = YES;
    self.webView.scrollView.bounces = NO;
    
    // 设置代理
    self.webView.delegate = self;
    
    NSURL *url = [NSURL URLWithString:self.model.Uri];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:self.webView];
    
}

#pragma mark - 分享按钮
- (void)rightBarButtonItemClick {
    
    //1、创建分享参数
    NSArray* imageArray = @[self.model.Pic];
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
    
    NSString *imageStr = self.model.Pic;
    
    if (imageArray) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:self.model.Describe
                                         images:@[imageStr]
                                            url:[NSURL URLWithString:self.model.Uri]
                                          title:self.model.CompanyName
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


- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self showLoadding:@"正在加载" time:20];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSInteger height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] intValue];
    
    NSLog(@"%ld",(long)height);
    
    [self.hud hide:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self showImage:FAIL_ICON time:1.5 message:@"加载失败"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
