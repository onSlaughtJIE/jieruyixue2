//
//  LookWuLiuVC.m
//  JRMedical
//
//  Created by a on 16/12/23.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "LookWuLiuVC.h"

@interface LookWuLiuVC ()<UIWebViewDelegate>

@property (nonatomic , strong)UIWebView *webView;

@end

@implementation LookWuLiuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置导航栏右边按钮
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, Width_Screen, Height_Screen-64)];
    self.webView.userInteractionEnabled = YES;
    self.webView.scrollView.bounces = NO;
    
    // 设置代理
    self.webView.delegate = self;
    
    NSURL *url = [NSURL URLWithString:self.model.ExpressUrl];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:self.webView];
    
    //在webView加载之前执行下面代码
    
//    NSString *userAgent = [self.webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
//    
//    userAgent = [userAgent stringByAppendingString:@" Version/7.0 Safari/9537.53"];
//    
//    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent": userAgent}];
    
    
    //读取cookie方法：
    
//    NSHTTPCookieStorage *sharedHTTPCookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    
//    NSArray *cookies = [sharedHTTPCookieStorage cookiesForURL:url];
//    
//    NSEnumerator *enumerator = [cookies objectEnumerator];
//    
//    NSHTTPCookie *cookie;
//    
//    while (cookie = [enumerator nextObject]) {
//        
//        NSLog(@"COOKIE{name: %@, value: %@}", [cookie name], [cookie value]);
//        
//    }
    
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
