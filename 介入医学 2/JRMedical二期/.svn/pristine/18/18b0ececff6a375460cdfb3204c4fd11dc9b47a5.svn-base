//
//  FeedbackVC.m
//  JRMedical
//
//  Created by a on 16/12/20.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "FeedbackVC.h"

#import "KMButton.h"
#import "IQTextView.h"
#import "IQKeyboardManager.h"
#import "IQTextView.h"

@interface FeedbackVC ()<UITextViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UIScrollView *viewSV;
@property (nonatomic, strong) IQTextView *textView;

@end

@implementation FeedbackVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"意见反馈";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavBarButtonItem];//设置顶栏右侧按钮
    
    [self initView];
}

#pragma mark - 添加
- (void)navBarButtonItemClick {
    
    if ([self.textView.text isEqualToString:@""] || self.textView.text == nil) {
        return [self showMessage:@"请输入您的意见"];
    }
    
    NSString *url = @"api/Customer/CreateOpinionProposal";
    NSString *params = [NSString stringWithFormat:@"ZICBDYCSubmitContent=%@",self.textView.text];
    
    [self showLoadding:@"正在提交" time:20];
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"提交您的建议 - %@", modelData);
        if (isSuccess) {
            NSString *message = nil;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提交成功,感谢您的反馈!"
                                                                message:message
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
            [alertView show];
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

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
        [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 初始化视图
- (void)initView {
    
    [self.view addSubview:self.viewSV];
    [self.viewSV addSubview:self.textView];
    
    self.viewSV.sd_layout.widthIs(Width_Screen).heightIs(Height_Screen);
    self.viewSV.contentSize = CGSizeMake(Width_Screen, Height_Screen);

    self.textView.sd_layout.topSpaceToView(self.viewSV,10).leftSpaceToView(self.viewSV,10).rightSpaceToView(self.viewSV,10).heightIs(300);
}

#pragma mark - 懒加载
- (UIScrollView *)viewSV {
    if (!_viewSV) {
        _viewSV = [UIScrollView new];
        _viewSV.backgroundColor = [UIColor whiteColor];
    }
    return _viewSV;
}
- (IQTextView *)textView {
    if (!_textView) {
        _textView = [IQTextView new];
        _textView.placeholder = @"我们懂得聆听,知错就改,您的意见是:";
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.delegate = self;
        _textView.layer.borderColor = RGB(200, 200, 200).CGColor;
        _textView.layer.cornerRadius = 5;
        _textView.clipsToBounds = YES;
        _textView.layer.borderWidth = 0.6;
    }
    return _textView;
}

#pragma mark - 设置顶栏右侧按钮
- (void)setNavBarButtonItem {
    
    KMButton *imgBtn = [KMButton buttonWithType:UIButtonTypeSystem];
    imgBtn.spacing = 5;
    imgBtn.kMButtonType = KMButtonLeft;
    imgBtn.size = CGSizeMake(65, 44);
    imgBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [imgBtn setTitle:@"提交" forState:UIControlStateNormal];
    [imgBtn setImage:[UIImage imageNamed:@"fatiez"] forState:UIControlStateNormal];
    [imgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [imgBtn setTintColor:[UIColor whiteColor]];
    [imgBtn addTarget:self action:@selector(navBarButtonItemClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imgBtn];
}

#pragma mark -
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![self.textView isExclusiveTouch]) {
        [_textView resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
