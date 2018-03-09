//
//  GiveMindVC.m
//  JRMedical
//
//  Created by a on 16/12/26.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "GiveMindVC.h"

#import "IQTextView.h"
#import "IQKeyboardManager.h"

@interface GiveMindVC ()<UITextViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *topBGView;
@property (nonatomic, strong) UIImageView *myUserImg;
@property (nonatomic, strong) UIImageView *toUserImg;
@property (nonatomic, strong) UIImageView *toImg1;
@property (nonatomic, strong) UIImageView *toImg2;
@property (nonatomic, strong) UIImageView *ubImg;
@property (nonatomic, strong) UILabel *messageLab;
//@property (nonatomic, strong) UIScrollView *ubScrollerView;
@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) UILabel *centerLab;
@property (nonatomic, strong) IQTextView *zfTextView;
@property (nonatomic, strong) UIButton *pushBtn;

@end

@implementation GiveMindVC {
    NSInteger _ubNum;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    [self.zfTextView endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"送心意";
    
    self.view.backgroundColor = BG_Color;
    
    [self setViewAutoLayout];
}

#pragma mark - 送心意
- (void)pushBtnClick {
    
    [self.zfTextView endEditing:YES];
    
    if ([self.zfTextView.text isEqualToString:@""] || self.zfTextView.text == nil) {
        return [self showMessage:@"您还没输入祝福语哦!"];
    }
    
    NSString *params = [NSString stringWithFormat:@"ZICBDYCUMoney=%ldZICBDYCHearInfo=%@ZICBDYCCustomerID=%@",_ubNum,self.zfTextView.text,self.ID];
    NSString *url = @"api/Customer/AddCustomerUMoney";
    
    [self showLoadding:@"" time:20];
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"获取心意列表 - %@", modelData);
        if (isSuccess) {
            NSString *message = nil;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"心意已送出!"
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushXinYiRequestData" object:nil userInfo:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)ubNumBtnClick:(UIButton *)btn {
    
    UIButton *button1 = [self.topView viewWithTag:100];
    UIButton *button2 = [self.topView viewWithTag:101];
    UIButton *button3 = [self.topView viewWithTag:102];
    UIButton *button4 = [self.topView viewWithTag:103];
    UIButton *button5 = [self.topView viewWithTag:104];
    UIButton *button6 = [self.topView viewWithTag:105];
    
    switch (btn.tag) {
        case 100:
        {
            self.messageLab.text = @"2个U币 小小心意";
            
            _ubNum = 2;
            
            button1.selected = YES;
            button2.selected = NO;
            button3.selected = NO;
            button4.selected = NO;
            button5.selected = NO;
            button6.selected = NO;
        }
            break;
        case 101:
        {
            self.messageLab.text = @"5个U币 心意多多";
            
            _ubNum = 5;
            
            button1.selected = NO;
            button2.selected = YES;
            button3.selected = NO;
            button4.selected = NO;
            button5.selected = NO;
            button6.selected = NO;
        }
            break;
        case 102:
        {
            self.messageLab.text = @"10个U币 暖暖心意";
            
            _ubNum = 10;
            
            button1.selected = NO;
            button2.selected = NO;
            button3.selected = YES;
            button4.selected = NO;
            button5.selected = NO;
            button6.selected = NO;
        }
            break;
        case 103:
        {
            self.messageLab.text = @"30个U币 诚心诚意";
            
            _ubNum = 30;
            
            button1.selected = NO;
            button2.selected = NO;
            button3.selected = NO;
            button4.selected = YES;
            button5.selected = NO;
            button6.selected = NO;
        }
            break;
        case 104:
        {
            self.messageLab.text = @"50个U币 心意满满";
            
            _ubNum = 50;
            
            button1.selected = NO;
            button2.selected = NO;
            button3.selected = NO;
            button4.selected = NO;
            button5.selected = YES;
            button6.selected = NO;
        }
            break;
        case 105:
        {
            self.messageLab.text = @"100个U币 医患同心";
            
            _ubNum = 100;
            
            button1.selected = NO;
            button2.selected = NO;
            button3.selected = NO;
            button4.selected = NO;
            button5.selected = NO;
            button6.selected = YES;
        }
            break;
        default:
            break;
    }
}

- (void)setViewAutoLayout {
    
    [self.view addSubview:self.topView];
    [self.topView addSubview:self.topBGView];
    [self.topView addSubview:self.myUserImg];
    [self.topView addSubview:self.toUserImg];
    [self.topView addSubview:self.toImg1];
    [self.topView addSubview:self.toImg2];
    [self.topView addSubview:self.ubImg];
    [self.topView addSubview:self.messageLab];
//    [self.topView addSubview:self.ubScrollerView];
    [self.view addSubview:self.centerView];
    [self.centerView addSubview:self.centerLab];
    [self.centerView addSubview:self.zfTextView];
    [self.view addSubview:self.pushBtn];
    
    self.topView.sd_layout.topEqualToView(self.view).leftEqualToView(self.view).rightEqualToView(self.view).heightIs(250);
    self.topBGView.sd_layout.topSpaceToView(self.topView,-Width_Screen-Width_Screen+Width_Screen*2/10).centerXEqualToView(self.topView).widthIs(Width_Screen*2).heightIs(Width_Screen*2);
    self.ubImg.sd_layout.topSpaceToView(self.topBGView,25).centerXEqualToView(self.topView).widthIs(28).heightIs(30);
    self.toImg1.sd_layout.rightSpaceToView(self.ubImg,15).centerYEqualToView(self.ubImg).widthIs(25).heightIs(16);
    self.myUserImg.sd_layout.rightSpaceToView(self.toImg1,15).centerYEqualToView(self.ubImg).widthIs(60).heightIs(60);
    self.toImg2.sd_layout.leftSpaceToView(self.ubImg,15).centerYEqualToView(self.ubImg).widthIs(25).heightIs(16);
    self.toUserImg.sd_layout.leftSpaceToView(self.toImg2,15).centerYEqualToView(self.ubImg).widthIs(60).heightIs(60);
    self.messageLab.sd_layout.topSpaceToView(self.myUserImg,25).centerXEqualToView(self.topView).widthIs(Width_Screen).heightIs(14);
    self.topView.sd_layout.topEqualToView(self.view).leftEqualToView(self.view).rightEqualToView(self.view).heightIs(250);
    
    self.centerView.sd_layout.topSpaceToView(self.topView,10).leftEqualToView(self.view).rightEqualToView(self.view).heightIs(160);
    
    CGFloat height = (Height_Screen-(250+10+160+40+64))/2;
    
    self.pushBtn.sd_layout.topSpaceToView(self.centerView,height).leftSpaceToView(self.view,10).rightSpaceToView(self.view,10).heightIs(40);
    
    CGFloat leftRightWidth;;
    
    if (Width_Screen > 320) {
        leftRightWidth = (Width_Screen-315)/2;
    }
    else {
        leftRightWidth = (Width_Screen-290)/2;
    }
    
    for (int i = 0; i < 6; i ++) {
        UIButton *ubNumBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [ubNumBtn setBackgroundImage:[UIImage imageNamed:@"hyuan"] forState:UIControlStateNormal];
        [ubNumBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [ubNumBtn setBackgroundImage:[UIImage imageNamed:@"yyuan"] forState:UIControlStateSelected];
        [ubNumBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [ubNumBtn setTintColor:[UIColor clearColor]];
        ubNumBtn.tag = i+100;
        [ubNumBtn addTarget:self action:@selector(ubNumBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:ubNumBtn];
        
        switch (i) {
            case 0:
                [ubNumBtn setTitle:@"2" forState:UIControlStateNormal];
                break;
            case 1:
                [ubNumBtn setTitle:@"5" forState:UIControlStateNormal];
                break;
            case 2:
                _ubNum = 10;
                ubNumBtn.selected = YES;
                self.messageLab.text = @"10个U币 暖暖心意";
                [ubNumBtn setTitle:@"10" forState:UIControlStateNormal];
                break;
            case 3:
                [ubNumBtn setTitle:@"30" forState:UIControlStateNormal];
                break;
            case 4:
                [ubNumBtn setTitle:@"50" forState:UIControlStateNormal];
                break;
            case 5:
                [ubNumBtn setTitle:@"100" forState:UIControlStateNormal];
                break;
            default:
                break;
        }
        
        if (Width_Screen > 320) {
            ubNumBtn.sd_layout.topSpaceToView(self.messageLab,15).leftSpaceToView(self.topView,leftRightWidth+i*40+i*15).widthIs(40).heightIs(40);
        }
        else {
            ubNumBtn.sd_layout.topSpaceToView(self.messageLab,15).leftSpaceToView(self.topView,leftRightWidth+i*40+i*10).widthIs(40).heightIs(40);
        }
        
    }
    
    
    self.centerLab.sd_layout.topSpaceToView(self.centerView,15).leftSpaceToView(self.centerView,15).rightSpaceToView(self.centerView,15).heightIs(14);
    self.zfTextView.sd_layout.topSpaceToView(self.centerLab,15).leftSpaceToView(self.centerView,15).rightSpaceToView(self.centerView,15).bottomSpaceToView(self.centerView,15);
}

#pragma mark - 懒加载
- (UIView *)topView {
    if (!_topView) {
        _topView = [UIView new];
        _topView.backgroundColor = [UIColor whiteColor];
        _topView.clipsToBounds = YES;
    }
    return  _topView;
}
- (UIView *)topBGView {
    if (!_topBGView) {
        _topBGView = [UIView new];
        _topBGView.backgroundColor = Main_Color;
        _topBGView.clipsToBounds = YES;
        _topBGView.layer.cornerRadius = Width_Screen;
    }
    return  _topBGView;
}
- (UIImageView *)ubImg {
    if (!_ubImg) {
        _ubImg = [UIImageView new];
        _ubImg.image = [UIImage imageNamed:@"songbi"];
    }
    return  _ubImg;
}
- (UIImageView *)toImg1 {
    if (!_toImg1) {
        _toImg1 = [UIImageView new];
        _toImg1.image = [UIImage imageNamed:@"jiantou"];
    }
    return  _toImg1;
}
- (UIImageView *)toImg2 {
    if (!_toImg2) {
        _toImg2 = [UIImageView new];
        _toImg2.image = [UIImage imageNamed:@"jiantou"];
    }
    return  _toImg2;
}
- (UIImageView *)myUserImg {
    if (!_myUserImg) {
        _myUserImg = [UIImageView new];
        _myUserImg.image = [UIImage imageNamed:@"yonghutx"];
    }
    return  _myUserImg;
}
- (UIImageView *)toUserImg {
    if (!_toUserImg) {
        _toUserImg = [UIImageView new];
        _toUserImg.image = [UIImage imageNamed:@"yishengtx"];
    }
    return  _toUserImg;
}
- (UILabel *)messageLab {
    if (!_messageLab) {
        _messageLab = [UILabel new];
        _messageLab.font = [UIFont systemFontOfSize:14];
        _messageLab.textAlignment = NSTextAlignmentCenter;
    }
    return _messageLab;
}
- (UIView *)centerView {
    if (!_centerView) {
        _centerView = [UIView new];
        _centerView.backgroundColor = [UIColor whiteColor];
    }
    return  _centerView;
}
- (UILabel *)centerLab {
    if (!_centerLab) {
        _centerLab = [UILabel new];
        _centerLab.font = [UIFont systemFontOfSize:14];
        _centerLab.text  = @"祝福语 : ";
    }
    return _centerLab;
}
- (IQTextView *)zfTextView {
    if (!_zfTextView) {
        _zfTextView = [IQTextView new];
        _zfTextView.delegate = self;
        _zfTextView.font = [UIFont systemFontOfSize:14];
        _zfTextView.placeholder = @"一句问候,一声祝福,一切如愿,一生幸福,一生平安,一帆风顺!";
        _zfTextView.layer.borderColor = RGB(200, 200, 200).CGColor;
        _zfTextView.layer.cornerRadius = 5;
        _zfTextView.clipsToBounds = YES;
        _zfTextView.layer.borderWidth = 0.6;
    }
    return _zfTextView;
}
- (UIButton *)pushBtn {
    if (!_pushBtn) {
        _pushBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _pushBtn.backgroundColor = RGB(253, 166, 57);
        _pushBtn.clipsToBounds = YES;
        _pushBtn.layer.cornerRadius = 5;
        [_pushBtn setTitle:@"送出" forState:UIControlStateNormal];
        [_pushBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_pushBtn addTarget:self action:@selector(pushBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return  _pushBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
