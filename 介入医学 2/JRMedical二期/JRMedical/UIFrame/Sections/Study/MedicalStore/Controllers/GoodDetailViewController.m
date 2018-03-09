//
//  GoodDetailViewController.m
//  JRMedical
//
//  Created by ww on 2016/11/16.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "GoodDetailViewController.h"

@interface GoodDetailViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation GoodDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self getMedicalDetailData];
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

#pragma mark - 获取商品详情数据数据
- (void)getMedicalDetailData {
    
    NSString *params = [NSString stringWithFormat:@"ZICBDYCExchangeID=%@ZICBDYCCommodityID=%@",self.exchangeID,self.commodityID];
    NSString *url = @"api/CommodityInfo/CommodityInfoByID";
    
    [self showLoadding:@"正在加载" time:20];
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"获取商品详情数据数据 - %@", modelData);
        if (isSuccess) {
            NSDictionary *detailDataDic = modelData[@"JsonData"];
            
            if (self.isShowTool == 100) {
                _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, Width_Screen, Height_Screen-64)];
            }
            else {
                _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, Width_Screen, Height_Screen-108)];
            }
            
            _webView.delegate = self;
            [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:detailDataDic[@"DescribeHtml"]]]];
            [self.view addSubview:_webView];
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
