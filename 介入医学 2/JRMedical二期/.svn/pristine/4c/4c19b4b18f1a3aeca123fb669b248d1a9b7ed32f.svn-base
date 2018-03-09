//
//  YuGaoWebDetailController.m
//  JRMedical
//
//  Created by ww on 2016/11/29.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "YuGaoWebDetailController.h"

@interface YuGaoWebDetailController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation YuGaoWebDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BG_Color;
    
    NSLog(@"MemoUri - %@", self.model.MemoUri);
    
    self.title = self.model.Title;
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    
    self.webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.model.MemoUri]]];
    
    [self.view addSubview:self.webView];
    
    
    
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
