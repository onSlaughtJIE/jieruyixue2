//
//  HTMLViewController.m
//  JRMedical
//
//  Created by apple on 16/5/15.
//  Copyright © 2016年 ZC. All rights reserved.
//

#import "HTMLViewController.h"

@interface HTMLViewController ()<UIWebViewDelegate>
@property (nonatomic , strong)UIWebView *webView;
@end

@implementation HTMLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, Width_Screen, Height_Screen-64)];
    self.webView.userInteractionEnabled = YES;
    self.webView.scrollView.bounces = NO;
    
    // 设置代理
    self.webView.delegate = self;
    
    //    NSString *str = self.webUrl;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", Server_Web_Url,_urlStr]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:self.webView];

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
