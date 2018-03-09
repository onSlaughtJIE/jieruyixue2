//
//  CommonWebVC.m
//  JRMedical
//
//  Created by ww on 2017/2/18.
//  Copyright © 2017年 idcby. All rights reserved.
//

#import "CommonWebVC.h"

@interface CommonWebVC ()<UIWebViewDelegate>

//{
//    UIAlertView *myAlert;
//}


@property (nonatomic, strong) UIWebView *webView;

@end

@implementation CommonWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    
}

/*
-(void)webViewDidStartLoad:(UIWebView *)webView{
    if(myAlert==nil){
        myAlert =[[UIAlertView alloc]initWithTitle:nil
                                           message:@"正在读取网络资料"delegate:self
                                 cancelButtonTitle:nil
                                 otherButtonTitles:nil];
        
        UIActivityIndicatorView *activityView =[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityView.frame= CGRectMake(120.f, 48.0f, 37.0f, 37.0f);
        [myAlert addSubview:activityView];
        [activityView startAnimating];
        [myAlert show];
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [myAlert dismissWithClickedButtonIndex:0 animated:YES];
}
*/


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
