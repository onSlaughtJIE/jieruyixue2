//
//  ServicePingJiaVC.m
//  JRMedical
//
//  Created by a on 16/12/26.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "ServicePingJiaVC.h"

#import "IQTextView.h"
#import "IQKeyboardManager.h"

@interface ServicePingJiaVC ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet IQTextView *plTextView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *BotButton;

@property (weak, nonatomic) IBOutlet UIButton *xing1;
@property (weak, nonatomic) IBOutlet UIButton *xing2;
@property (weak, nonatomic) IBOutlet UIButton *xing3;
@property (weak, nonatomic) IBOutlet UIButton *xing4;
@property (weak, nonatomic) IBOutlet UIButton *xing5;


@end

@implementation ServicePingJiaVC {
    
    NSString *_xingNum;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    [self.plTextView endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"服务评价";
    
    self.view.backgroundColor = BG_Color;
    
    _xingNum = @"5";
    
    self.xing1.userInteractionEnabled = YES;
    self.xing2.userInteractionEnabled = YES;
    self.xing3.userInteractionEnabled = YES;
    self.xing4.userInteractionEnabled = YES;
    self.xing5.userInteractionEnabled = YES;
    
    
    //    xingxing_icon xingji
    [self.xing1 bk_whenTapped:^{
        
        _xingNum = @"1";
        
        [self.xing1 setTintColor:RGB(232, 78, 64)];
        [self.xing2 setTintColor:RGB(185, 182, 178)];
        [self.xing3 setTintColor:RGB(185, 182, 178)];
        [self.xing4 setTintColor:RGB(185, 182, 178)];
        [self.xing5 setTintColor:RGB(185, 182, 178)];
    }];
    
    [self.xing2 bk_whenTapped:^{
        
        _xingNum = @"2";
        
        [self.xing1 setTintColor:RGB(232, 78, 64)];
        [self.xing2 setTintColor:RGB(232, 78, 64)];
        [self.xing3 setTintColor:RGB(185, 182, 178)];
        [self.xing4 setTintColor:RGB(185, 182, 178)];
        [self.xing5 setTintColor:RGB(185, 182, 178)];
    }];
    
    [self.xing3 bk_whenTapped:^{
        
        _xingNum = @"3";
        
        [self.xing1 setTintColor:RGB(232, 78, 64)];
        [self.xing2 setTintColor:RGB(232, 78, 64)];
        [self.xing3 setTintColor:RGB(232, 78, 64)];
        [self.xing4 setTintColor:RGB(185, 182, 178)];
        [self.xing5 setTintColor:RGB(185, 182, 178)];
    }];
    
    [self.xing4 bk_whenTapped:^{
        
        _xingNum = @"4";
        
        [self.xing1 setTintColor:RGB(232, 78, 64)];
        [self.xing2 setTintColor:RGB(232, 78, 64)];
        [self.xing3 setTintColor:RGB(232, 78, 64)];
        [self.xing4 setTintColor:RGB(232, 78, 64)];
        [self.xing5 setTintColor:RGB(185, 182, 178)];
    }];
    
    [self.xing5 bk_whenTapped:^{
        
        _xingNum = @"5";
        
        [self.xing1 setTintColor:RGB(232, 78, 64)];
        [self.xing2 setTintColor:RGB(232, 78, 64)];
        [self.xing3 setTintColor:RGB(232, 78, 64)];
        [self.xing4 setTintColor:RGB(232, 78, 64)];
        [self.xing5 setTintColor:RGB(232, 78, 64)];
    }];
    
    self.plTextView.placeholder = @"亲!真诚的写一下您对医生的服务评价";
//    self.plTextView.font = [UIFont systemFontOfSize:15];
//    self.plTextView.delegate = self;
//    self.plTextView.layer.borderColor = RGB(200, 200, 200).CGColor;
//    self.plTextView.layer.cornerRadius = 5;
//    self.plTextView.clipsToBounds = YES;
//    self.plTextView.layer.borderWidth = 0.6;
    
    self.BotButton.layer.shadowColor = RGB(100, 100, 100).CGColor;//阴影颜色
    self.BotButton.layer.shadowOffset = CGSizeMake(0 , 1);//偏移距离
    self.BotButton.layer.shadowOpacity = 0.5;//不透明度
    self.BotButton.layer.shadowRadius = 3.0;//半径
    
    self.topView.layer.shadowColor = RGB(100, 100, 100).CGColor;//阴影颜色
    self.topView.layer.shadowOffset = CGSizeMake(0 , 1);//偏移距离
    self.topView.layer.shadowOpacity = 0.5;//不透明度
    self.topView.layer.shadowRadius = 3.0;//半径
}

- (IBAction)postPingJiaClick:(id)sender {
    
    [self.plTextView endEditing:YES];
    
    if ([self.plTextView.text isEqualToString:@""] || self.plTextView.text == nil) {
        return [self showMessage:@"请输入您的评价内容"];
    }
    
    if ([_xingNum isEqualToString:@""] || _xingNum == nil) {
        return [self showMessage:@"您还没有对服务打分哦!"];
    }
    
    NSString *params = [NSString stringWithFormat:@"ZICBDYCCustomerServiceID=%@ZICBDYCEvaluationContent=%@ZICBDYCEvaluationStar=%@",self.ID,self.plTextView.text,_xingNum];
    NSString *url = @"Api/Customer/CreateCustomerEvaluate";
    
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"评价- responseObject - %@---%@", modelData, modelData[@"Msg"]);
        if (isSuccess) {
            NSString *message = nil;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"评价成功"
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pingJiaFuWuChengGong" object:nil userInfo:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
