//
//  SpPingLunViewController.m
//  JRMedical
//
//  Created by apple on 16/5/13.
//  Copyright © 2016年 ZC. All rights reserved.
//

#import "SpPingLunViewController.h"

#import "KMButton.h"
#import "IQTextView.h"
#import "IQKeyboardManager.h"

@interface SpPingLunViewController ()<UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) IQTextView *PLTextView;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) UIView *keyView;

@end

@implementation SpPingLunViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    [self.PLTextView endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BG_Color;
    self.title = @"评论";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftAction:)];
    
    [self setNavBarButtonItem];//设置顶栏右侧按钮
    
    self.PLTextView = [[IQTextView alloc] initWithFrame:(CGRectMake(0, 10, Width_Screen,250))];
    self.PLTextView.delegate = self;
    self.PLTextView.font = [UIFont systemFontOfSize:14];
    self.PLTextView.placeholder = @"请输入您的评论内容...";
    [self.view addSubview:self.PLTextView];
}

#pragma mark - 点击返回键
- (void)leftAction:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 点击发表评论
- (void)navBarButtonItemClick {
    
    [self.PLTextView endEditing:YES];
    
    if ([self.PLTextView.text isEqualToString:@""] || self.PLTextView == nil) {
        [self showMessage:@"评论内容不能为空"];
        return;
    }
 
    NSString *registUrl = @"api/News/AddEvaluate";
    NSString *datasStr = @"";
    if (_isFromCaseCatalogue) {
        datasStr = [NSString stringWithFormat:@"ZICBDYCResourcesType=%@ZICBDYCResourcesID=%@ZICBDYCResourcesContent=%@", @"4",self.ID,self.PLTextView.text, nil];
    } else {
        datasStr = [NSString stringWithFormat:@"ZICBDYCResourcesType=%@ZICBDYCResourcesID=%@ZICBDYCResourcesContent=%@", @"1",self.ID,self.PLTextView.text, nil];
    }
    
    [self.PLTextView endEditing:YES];
    
    [self showLoadding:@"" time:20];
    [self loadDataApi:registUrl withParams:datasStr block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"评论 - %@", modelData);
        if (isSuccess) {
            [self showMessage:@"评论成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PingLunSuccess" object:nil userInfo:nil];
            
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
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

#pragma mark - 设置顶栏右侧按钮
- (void)setNavBarButtonItem {
    
    KMButton *imgBtn = [KMButton buttonWithType:UIButtonTypeSystem];
    imgBtn.spacing = 5;
    imgBtn.kMButtonType = KMButtonLeft;
    imgBtn.size = CGSizeMake(65, 44);
    imgBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [imgBtn setTitle:@"发送" forState:UIControlStateNormal];
    [imgBtn setImage:[UIImage imageNamed:@"fatiez"] forState:UIControlStateNormal];
    [imgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [imgBtn setTintColor:[UIColor whiteColor]];
    [imgBtn addTarget:self action:@selector(navBarButtonItemClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imgBtn];
}

#pragma mark -
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![self.PLTextView isExclusiveTouch]) {
        [_PLTextView resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
