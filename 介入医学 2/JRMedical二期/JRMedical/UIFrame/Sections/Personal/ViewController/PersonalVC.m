//
//  PersonalVC.m
//  JRMedical
//
//  Created by a on 16/11/4.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "PersonalVC.h"

#import "SetUpVC.h"
#import "SetMyInfoVC.h"
#import "MyUBVC.h"
#import "MyBalanceVC.h"
#import "MyCertificationVC.h"
#import "MyAttentionVC.h"
#import "CaseLibraryVC.h"
#import "MyOrderRootVC.h"

#import "UIScrollView+UITouch.h"
#import "KMButton.h"
#import <YYKit.h>

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "EMCDDeviceManager.h"
#import "EMCDDeviceManager+Remind.h"

@interface PersonalVC ()<CAAnimationDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *userPhotoImg;
@property (nonatomic, strong) UIImageView *photoCornerImg;

@property (nonatomic, strong) UILabel *ubLab;
@property (nonatomic, strong) UILabel *moneyLab;
@property (nonatomic, strong) UILabel *userNameLab;
@property (nonatomic, strong) UILabel *userCompanyLab;//此为用户所属单位 例 : 若为医生 -- 河南省第一人民医院
@property (nonatomic, strong) UILabel *userCategoryLab;//此为用户分类 医生还是患者 例 : 若为医生 -- 主任医师

@property (nonatomic, strong) UIView *topBGView;
@property (nonatomic, strong) UIView *lineLView;
@property (nonatomic, strong) UIView *lineRView;
@property (nonatomic, strong) UIView *ubView;
@property (nonatomic, strong) UIView *moneyView;
@property (nonatomic, strong) UIView *userInfoView;

@property (nonatomic, strong) KMButton *daKaBtn;
@property (nonatomic, strong) KMButton *ubIcon;
@property (nonatomic, strong) KMButton *moneyIcon;
@property (nonatomic, strong) UIButton *ubBtn;
@property (nonatomic, strong) UIButton *moneyBtn;

@property (strong, nonatomic) NSMutableArray    *resources;
@property (strong, nonatomic) NSMutableArray    *resourcesBottom;

@property (nonatomic, strong)UILabel * babyLable;
@property (nonatomic, strong)UIView * grayView;
@property (nonatomic, strong)CAEmitterLayer * emitterLayer;

@end

@implementation PersonalVC {
    UIView *_itemBgView;
    
    NSInteger _UmoneyNum;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //请求个人信息
    [self requestUserInfoData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的中心";
    
    //设置导航栏右边按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"shezhi"] style:(UIBarButtonItemStylePlain) target:self action:@selector(rightBarButtonItemClick)];
    
    //取出所有分类
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"PersonalTop" ofType:@"plist"];
    _resources = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    NSString *plistPathB = [[NSBundle mainBundle] pathForResource:@"PersonalBot" ofType:@"plist"];
    _resourcesBottom = [[NSMutableArray alloc] initWithContentsOfFile:plistPathB];

    //初始化顶部视图
    [self initTopView];
    
    //更新用户信息
    [self updateUserInfo];
    
    //初始化其他视图
    [self initOtherView];
    [self initOtherBottomView];
    
    [self initAntimation];//金币视图
}

#pragma mark - 更新用户信息
- (void)updateUserInfo {

    //点击头像
    [self.userPhotoImg bk_whenTapped:^{
        SetMyInfoVC *smiVC = [SetMyInfoVC new];
        [self.navigationController pushViewController:smiVC animated:YES];
    }];
    
    //更新头像
    NSString *userImg =  (NSString *)[UserInfo getUserInfoValue:@"UserPic"];
    [self.userPhotoImg sd_setImageWithURL:[NSURL URLWithString:userImg] placeholderImage:[UIImage imageNamed:@"mtou"]];

    //判断是否是医师,,然后根据情况显示信息
    [self jiancheIsDoctor];
    
    //更新U币
    NSString *ub =  (NSString *)[UserInfo getUserInfoValue:@"UMoney"];
    if (ub == nil) {
        [self.ubIcon setTitle:@"* * *" forState:UIControlStateNormal];
    }
    else {
        [self.ubIcon setTitle:[NSString stringWithFormat:@"%ld",[ub integerValue]] forState:UIControlStateNormal];
    }
    CGSize ubSize = [Utils sizeForTitle:self.ubIcon.titleLabel.text withFont:[UIFont systemFontOfSize:12]];
    self.ubIcon.sd_resetLayout.centerXEqualToView(self.ubView).bottomSpaceToView(self.ubLab,2).heightIs(18).widthIs(ubSize.width+24);
    //更新余额
    NSString *yue =  (NSString *)[UserInfo getUserInfoValue:@"AccountMoney"];
    if (yue == nil) {
        [self.moneyIcon setTitle:@"* * *" forState:UIControlStateNormal];
    }
    else {
        [self.moneyIcon setTitle:[NSString stringWithFormat:@"%.2f",[yue floatValue]] forState:UIControlStateNormal];
    }
    CGSize moneySize = [Utils sizeForTitle:self.moneyIcon.titleLabel.text withFont:[UIFont systemFontOfSize:12]];
    self.moneyIcon.sd_resetLayout.centerXEqualToView(self.moneyView).bottomSpaceToView(self.moneyLab,2).heightIs(18).widthIs(moneySize.width+24);
}

#pragma mark - 是否是医师
- (void)jiancheIsDoctor {
    
    //是否是医师
    NSString *isDoctor =  NSUserDf_Get(kDoctor);//是否是医师
    if ([isDoctor integerValue] == 0) {
        
        //是否显示认证图标
        self.photoCornerImg.hidden = YES;
        
        //更新名字
        NSString *userName=  (NSString *)[UserInfo getUserInfoValue:@"CustomerName"];
        self.userNameLab.text = userName;
        
        self.userInfoView.sd_resetLayout.leftSpaceToView(self.lineLView,1).rightSpaceToView(self.lineRView,1).bottomSpaceToView(self.topBGView,13).heightIs(52);
        self.userNameLab.sd_resetLayout.centerXEqualToView(self.userInfoView).centerYEqualToView(self.userInfoView).rightEqualToView(self.userInfoView).leftEqualToView(self.userInfoView).heightIs(16);
        
        //不是医师没有医院科室信息
        self.userCompanyLab.hidden = YES;
        self.userCategoryLab.hidden = YES;
    }
    else {
        
        //是否显示认证图标
        self.photoCornerImg.hidden = NO;
        
        //更新名字
        NSString *userName=  (NSString *)[UserInfo getUserInfoValue:@"CustomerName"];
        self.userNameLab.text = userName;
        
        self.userCompanyLab.hidden = NO;
        self.userCategoryLab.hidden = NO;
        
        //更新单位
        NSString *hospitalName =  (NSString *)[UserInfo getUserInfoValue:@"HospitalName"];
        if ([hospitalName isEqualToString:@""] || hospitalName == nil) {
            self.userCompanyLab.text = @"未录入医院信息";
            self.userCompanyLab.textColor = RGB(220, 220, 220);
        }
        else {
            self.userCompanyLab.text = hospitalName;
            self.userCompanyLab.textColor = [UIColor whiteColor];
        }
        //更新职位
        NSString *postName =  (NSString *)[UserInfo getUserInfoValue:@"PostName"];
        if ([postName isEqualToString:@""] || postName == nil) {
            self.userCategoryLab.text = @"未录入职称信息";
            self.userCategoryLab.textColor = RGB(220, 220, 220);
        }
        else {
            self.userCategoryLab.text = postName;
            self.userCategoryLab.textColor = Main_Color;
        }
        
        self.userInfoView.sd_resetLayout.leftSpaceToView(self.lineLView,1).rightSpaceToView(self.lineRView,1).bottomSpaceToView(self.topBGView,13).heightIs(52);
        self.userNameLab.sd_resetLayout.centerXEqualToView(self.userInfoView).leftEqualToView(self.userInfoView).rightEqualToView(self.userInfoView).topSpaceToView(self.userInfoView,0).heightIs(16);
        self.userCompanyLab.sd_resetLayout.centerXEqualToView(self.userInfoView).leftEqualToView(self.userInfoView).rightEqualToView(self.userInfoView).topSpaceToView(self.userNameLab,0).heightIs(16);
        
        CGFloat userCategoryWidth = self.userCategoryLab.text.length*10.5+20;
        
        self.userCategoryLab.sd_resetLayout.centerXEqualToView(self.userInfoView).topSpaceToView(self.userCompanyLab,2).heightIs(16).widthIs(userCategoryWidth);
    }
}

#pragma mark - 打卡
- (void)daKaButtonClick {
    
    NSString *url = @"/api/Customer/CreateCustomerSign";
    NSString *params = @"";
    
    [self showLoadding:@"" time:20];
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"打卡 - %@", modelData);
        if (isSuccess) {
            
            NSDictionary *dic = modelData[@"JsonData"];
            _UmoneyNum = [dic[@"UMoney"] integerValue];
            
            self.babyLable.text = [NSString stringWithFormat:@"+%ld金币", (long)_UmoneyNum];
            
            // 金币动画
            [self beginAnimation]; // 开始金币动画
            [self playSoundAndVibration];
            
            //更新U币
            NSString *ub =  (NSString *)[UserInfo getUserInfoValue:@"UMoney"];
            if (ub == nil) {
                [self.ubIcon setTitle:@"* * *" forState:UIControlStateNormal];
            }
            else {
                NSInteger ubNum = [ub integerValue];
                [self.ubIcon setTitle:[NSString stringWithFormat:@"%ld",ubNum+_UmoneyNum] forState:UIControlStateNormal];
            }
            CGSize ubSize = [Utils sizeForTitle:self.ubIcon.titleLabel.text withFont:[UIFont systemFontOfSize:12]];
            self.ubIcon.sd_resetLayout.centerXEqualToView(self.ubView).bottomSpaceToView(self.ubLab,2).heightIs(18).widthIs(ubSize.width+24);
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

- (void)playSoundAndVibration{
    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playMyNewMessageSound];
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
}

#pragma mark - 设置金币动画
- (void)initAntimation {
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    UIView * grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width_Screen, Height_Screen)];
        grayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    [window addSubview:self.grayView = grayView];
    self.grayView.hidden = YES;
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
    label.center = CGPointMake(CGRectGetWidth(self.view.frame)/2.0, CGRectGetHeight(self.view.frame)/2.0);
    
//    label.text = [NSString stringWithFormat:@"+%ld金币", (long)_UmoneyNum];    
//    NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"+%ld金币", (long)_UmoneyNum]];
//    NSRange range1 = [[attstr string]rangeOfString:[NSString stringWithFormat:@"+%ld", (long)_UmoneyNum]];
//    NSRange range2 = [[attstr string] rangeOfString:@"金币"];
//    [attstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:254/255.0 green:211/255.0 blue:10/255.0 alpha:1] range:range1];
//    [attstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:254/255.0 green:211/255.0 blue:10/255.0 alpha:1] range:range2];
//    label.attributedText = attstr;
    
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:254/255.0 green:211/255.0 blue:10/255.0 alpha:1];
    [window addSubview: self.babyLable = label];
    self.babyLable.hidden = YES;
    
    
    //粒子动画
    {
        //发射源
        CAEmitterLayer * emitter = [CAEmitterLayer layer];
        emitter.frame = CGRectMake(0, 0, CGRectGetWidth(self.babyLable.frame), CGRectGetHeight(self.babyLable.frame));
        [self.babyLable.layer addSublayer:self.emitterLayer = emitter];
        //发射源形状
        emitter.emitterShape = kCAEmitterLayerCircle;
        //发射模式
        emitter.emitterMode = kCAEmitterLayerOutline;
        //渲染模式
        //    emitter.renderMode = kCAEmitterLayerAdditive;
        //发射位置
        emitter.emitterPosition = CGPointMake(self.babyLable.frame.size.width/2.0, self.babyLable.frame.size.height/2.0);
        //发射源尺寸大小
        emitter.emitterSize = CGSizeMake(20, 20);
        
        // 从发射源射出的粒子
        {
            CAEmitterCell * cell = [CAEmitterCell emitterCell];
            cell.name = @"zanShape";
            //粒子要展现的图片
            cell.contents = (__bridge id)[UIImage imageNamed:@"coin"].CGImage;
            //    cell.contents = (__bridge id)[UIImage imageNamed:@"EffectImage"].CGImage;
            //            cell.contentsRect = CGRectMake(100, 100, 100, 100);
            //粒子透明度在生命周期内的改变速度
            cell.alphaSpeed = -0.5;
            //生命周期
            cell.lifetime = 3.0;
            //粒子产生系数(粒子的速度乘数因子)
            cell.birthRate = 0;
            //粒子速度
            cell.velocity = 300;
            //速度范围
            cell.velocityRange = 100;
            //周围发射角度
            cell.emissionRange = M_PI / 8;
            //发射的z轴方向的角度
            cell.emissionLatitude = -M_PI;
            //x-y平面的发射方向
            cell.emissionLongitude = -M_PI / 2;
            //粒子y方向的加速度分量
            cell.yAcceleration = 250;
            emitter.emitterCells = @[cell];
        }
    }
}

/**
*  开始动画
*/
-(void)beginAnimation
{
    __weak typeof(self)bself = self;
    self.babyLable.hidden = NO;
    self.grayView.hidden = NO;
    [UIView animateWithDuration:0.5f delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:5 options:UIViewAnimationOptionCurveLinear animations:^{
        CABasicAnimation * effectAnimation = [CABasicAnimation animationWithKeyPath:@"emitterCells.zanShape.birthRate"];
        effectAnimation.fromValue = [NSNumber numberWithFloat:30];
        effectAnimation.toValue = [NSNumber numberWithFloat:0];
        effectAnimation.duration = 0.0f;
        effectAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        [bself.emitterLayer addAnimation:effectAnimation forKey:@"zanCount"];
        //放大动画
        {
            CABasicAnimation * aniScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            aniScale.fromValue = [NSNumber numberWithFloat:0.5];
            aniScale.toValue = [NSNumber numberWithFloat:3.0];
            aniScale.duration = 1.5;
            aniScale.delegate = self;
            aniScale.removedOnCompletion = NO;
            aniScale.repeatCount = 1;
            [bself.babyLable.layer addAnimation:aniScale forKey:@"babyCoin_scale"];
        }
    } completion:^(BOOL finished) {
        
    }];
    
    [UIView animateWithDuration:3.0 animations:^{
        bself.grayView.alpha = 0;
    }];
}
/**
 *  动画结束代理方法
 */
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (anim == [self.babyLable.layer animationForKey:@"babyCoin_scale"]) {
        [self babyCoinFadeAway];
    }
    if (anim == [self.babyLable.layer animationForKey:@"aniMove_aniScale_groupAnimation"]) {
        self.babyLable.hidden = YES;
        self.grayView.alpha = 0.6;
        self.grayView.hidden = YES;
    }
}
/**
 *  金币散开结束后文字下落动画
 */
-(void)babyCoinFadeAway
{
    CGFloat aPPW = [UIScreen mainScreen].bounds.size.width;
    CGFloat aPPH = [UIScreen mainScreen].bounds.size.height;
    CABasicAnimation * aniMove = [CABasicAnimation animationWithKeyPath:@"position"];
    aniMove.fromValue = [NSValue valueWithCGPoint:self.babyLable.layer.position];
    
    aniMove.toValue = [NSValue valueWithCGPoint:CGPointMake(aPPW, aPPH)];
    
    CABasicAnimation * aniScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    aniScale.fromValue = [NSNumber numberWithFloat:3.0];
    aniScale.toValue = [NSNumber numberWithFloat:0.5];
    
    CAAnimationGroup * aniGroup = [CAAnimationGroup animation];
    aniGroup.duration = 1.0;
    aniGroup.repeatCount = 1;
    aniGroup.delegate = self;
    aniGroup.animations = @[aniMove,aniScale];
    aniGroup.removedOnCompletion = NO;
    //    aniGroup.fillMode = kCAFillModeForwards;  //防止动画结束后回到原位
    [self.babyLable.layer removeAllAnimations];
    [self.babyLable.layer addAnimation:aniGroup forKey:@"aniMove_aniScale_groupAnimation"];
    
}

#pragma mark - 查看U币 查看余额
- (void)buttonClick:(UIButton *)btn {
    //100 U币  200 余额
    switch (btn.tag) {
        case 100:
        {
            MyUBVC *mubVC = [MyUBVC new];
            [self.navigationController pushViewController:mubVC animated:YES];
        }
            break;
        case 200:
        {
            MyBalanceVC *mubVC = [MyBalanceVC new];
            [self.navigationController pushViewController:mubVC animated:YES];
        }
            break;
    }
}

#pragma mark - 点击其他分类

- (void)itmeTap:(KMButton *)sender {
    
    NSInteger tag = [sender tag];
    
    if (tag <= 10004) {
        NSDictionary *item;
        for(NSDictionary *temp in _resources){
            if ([[temp objectForKey:@"tag"] integerValue] == tag) {
                item = temp;
            }
        }
        if (item != nil) {
            Class someClass = NSClassFromString([item objectForKey:@"controller"]);
            MyOrderRootVC *obj = [someClass new];
            obj.tagVC = tag - 10000;
            [self.navigationController pushViewController:obj animated:YES];
        }
    }
    else {
        NSDictionary *item;
        for(NSDictionary *temp in _resourcesBottom){
            if ([[temp objectForKey:@"tag"] integerValue] == tag) {
                item = temp;
            }
        }
        if (item != nil) {
            Class someClass = NSClassFromString([item objectForKey:@"controller"]);
            id obj = [someClass new];
            [self.navigationController pushViewController:obj animated:YES];
        }
    }
}

#pragma mark - 触发导航栏右边按钮
- (void)rightBarButtonItemClick {
    //跳转设置页面
    SetUpVC *suVC = [SetUpVC new];
    [self.navigationController pushViewController:suVC animated:YES];
}

#pragma mark - 初始化顶部视图
- (void)initTopView {
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.topBGView];
    [self.topBGView addSubview:self.userPhotoImg];
    [self.topBGView addSubview:self.photoCornerImg];
    [self.topBGView addSubview:self.daKaBtn];
    [self.topBGView addSubview:self.lineLView];
    [self.topBGView addSubview:self.lineRView];
    [self.topBGView addSubview:self.ubView];
    [self.ubView addSubview:self.ubLab];
    [self.ubView addSubview:self.ubIcon];
    [self.topBGView addSubview:self.moneyView];
    [self.moneyView addSubview:self.moneyLab];
    [self.moneyView addSubview:self.moneyIcon];
    [self.topBGView addSubview:self.userInfoView];
    [self.userInfoView addSubview:self.userNameLab];
    [self.userInfoView addSubview:self.userCompanyLab];
    [self.userInfoView addSubview:self.userCategoryLab];
    [self.topBGView addSubview:self.ubBtn];
    [self.topBGView addSubview:self.moneyBtn];
    
    //设置顶部视图自动布局
    self.scrollView.sd_layout
    .widthIs(Width_Screen)
    .heightIs(Height_Screen);
    self.scrollView.contentSize = CGSizeMake(Width_Screen, Width_Screen+298);
    
    self.topBGView.sd_layout.heightIs(190).widthIs(Width_Screen);
    self.userPhotoImg.sd_layout.topSpaceToView(self.topBGView,15).centerXEqualToView(self.topBGView).heightIs(90).widthIs(90);
    self.photoCornerImg.sd_layout.bottomEqualToView(self.userPhotoImg).leftSpaceToView(self.userPhotoImg,-26).heightIs(15).widthIs(15);
    self.daKaBtn.sd_layout.topSpaceToView(self.topBGView,40).rightSpaceToView(self.topBGView,-30).heightIs(35).widthIs(120);
    self.lineLView.sd_layout.leftSpaceToView(self.topBGView,101).bottomSpaceToView(self.topBGView,15).widthIs(1).heightIs(50);
    self.lineRView.sd_layout.rightSpaceToView(self.topBGView,101).bottomSpaceToView(self.topBGView,15).widthIs(1).heightIs(50);
    self.ubView.sd_layout.leftEqualToView(self.topBGView).bottomSpaceToView(self.topBGView,15).heightIs(50).widthIs(100);
    self.ubLab.sd_layout.centerXEqualToView(self.ubView).bottomSpaceToView(self.ubView,4).heightIs(18).widthIs(100);
    
    CGSize ubSize = [Utils sizeForTitle:self.moneyIcon.titleLabel.text withFont:[UIFont systemFontOfSize:12]];
    self.ubIcon.sd_layout.centerXEqualToView(self.ubView).bottomSpaceToView(self.ubLab,2).heightIs(18).widthIs(ubSize.width+24);
    
    self.moneyView.sd_layout.rightEqualToView(self.topBGView).bottomSpaceToView(self.topBGView,15).heightIs(50).widthIs(100);
    self.moneyLab.sd_layout.centerXEqualToView(self.moneyView).bottomSpaceToView(self.moneyView,4).heightIs(18).widthIs(100);
    
    CGSize moneySize = [Utils sizeForTitle:self.moneyIcon.titleLabel.text withFont:[UIFont systemFontOfSize:12]];
    self.moneyIcon.sd_layout.centerXEqualToView(self.moneyView).bottomSpaceToView(self.moneyLab,2).heightIs(18).widthIs(moneySize.width+24);
    
    self.userInfoView.sd_layout.leftSpaceToView(self.lineLView,1).rightSpaceToView(self.lineRView,1).bottomSpaceToView(self.topBGView,13).heightIs(52);
    self.userNameLab.sd_layout.centerXEqualToView(self.userInfoView).leftEqualToView(self.userInfoView).rightEqualToView(self.userInfoView).topSpaceToView(self.userInfoView,0).heightIs(16);
    self.userCompanyLab.sd_layout.centerXEqualToView(self.userInfoView).leftEqualToView(self.userInfoView).rightEqualToView(self.userInfoView).topSpaceToView(self.userNameLab,0).heightIs(16);
    self.userCategoryLab.sd_layout.centerXEqualToView(self.userInfoView).topSpaceToView(self.userCompanyLab,2).heightIs(16).widthIs(55);
    self.ubBtn.sd_layout.leftEqualToView(self.topBGView).bottomSpaceToView(self.topBGView,0).heightIs(65).widthIs(101);
    self.moneyBtn.sd_layout.rightEqualToView(self.topBGView).bottomSpaceToView(self.topBGView,0).heightIs(65).widthIs(101);
}

#pragma mark - 设置其他分类布局
- (void)initOtherView {
    
    int itemColumnNum = 4;
    
    CGFloat itemPadding = 1;
    CGFloat itemWidth = (Width_Screen-itemPadding*(itemColumnNum-1))/itemColumnNum;
    int  countItem = [[NSString stringWithFormat:@"%lu",(unsigned long)[_resources count]] intValue];
    int  countRow = (countItem %itemColumnNum == 0)?(countItem/itemColumnNum):countItem/itemColumnNum+1;
    
    _itemBgView = [UIView new];
    [self.scrollView addSubview:_itemBgView];
    
    _itemBgView.sd_layout.topSpaceToView(self.topBGView,0)
    .leftEqualToView(self.scrollView)
    .rightEqualToView(self.scrollView)
    .heightIs(itemWidth*countRow+itemPadding*(countRow)+ itemPadding - 20);
    
    for (int i = 0; i < (countItem); i++) {
        int rightSubColumn = i%itemColumnNum;
        int rightSubRow = i/itemColumnNum;
        KMButton *rt = KMButton.new;
        rt.kMButtonType = KMButtonCenter;
        [_itemBgView addSubview: rt];
        rt.backgroundColor = [UIColor whiteColor];
        rt.titleLabel.font = [UIFont systemFontOfSize:12];
        rt.spacing  = 5;
        if (i < countItem) {
            NSDictionary *item  =  [_resources objectAtIndex:i];
            if (i == countItem -1) {
                [rt setTitle: [item objectForKey:@"title"] forState: UIControlStateNormal];
            }
            else {
                [rt setTitle: [item objectForKey:@"title"]  forState: UIControlStateNormal];
            }
            [rt setTitleColor:[UIColor blackColor] forState: UIControlStateNormal];
            //[rt setImage: [UIImage imageNamed:@"icon_btn_gift"] forState:UIControlStateHighlighted];
            [rt setImage:[UIImage imageNamed:[item objectForKey:@"icon"]] forState:UIControlStateNormal];
            [rt setBackgroundImage:[UIImage imageWithColor:RGBA(189, 222, 244, .5)] forState:UIControlStateHighlighted];
            [rt setBackgroundImage:[UIImage imageWithColor:RGBA(189, 222, 244, .5)] forState:UIControlStateSelected];
            rt.tag  = [[item objectForKey:@"tag"] integerValue];
            [rt addTarget:self action:(@selector(itmeTap:)) forControlEvents:UIControlEventTouchUpInside];
        }
        rt.sd_layout.leftSpaceToView(_itemBgView,itemPadding*(rightSubColumn) + rightSubColumn*itemWidth)
        .topSpaceToView(_itemBgView,itemPadding*rightSubRow+rightSubRow*itemWidth + itemPadding)
        .widthIs(itemWidth)
        .heightIs(itemWidth - 20);
    }
}
- (void)initOtherBottomView {

    int itemColumnNum = 4;
    
    CGFloat itemPadding = 1;
    CGFloat itemWidth = (Width_Screen-itemPadding*(itemColumnNum-1))/itemColumnNum;
    int  countItem = [[NSString stringWithFormat:@"%lu",(unsigned long)[_resourcesBottom count]] intValue];
    int  countRow = (countItem %itemColumnNum == 0)?(countItem/itemColumnNum):countItem/itemColumnNum+1;
    
    UIView *itemBgViewB = [UIView new];
    [self.scrollView addSubview:itemBgViewB];
    
    itemBgViewB.sd_layout.topSpaceToView(_itemBgView,10)
    .leftEqualToView(self.scrollView)
    .rightEqualToView(self.scrollView)
    .heightIs(itemWidth*countRow+itemPadding*(countRow)+ itemPadding);
    
    for (int i = 0; i < (countItem); i++) {
        int rightSubColumn = i%itemColumnNum;
        int rightSubRow = i/itemColumnNum;
        KMButton *rt = KMButton.new;
        rt.kMButtonType = KMButtonCenter;
        [itemBgViewB addSubview: rt];
        rt.backgroundColor = [UIColor whiteColor];
        rt.titleLabel.font = [UIFont systemFontOfSize:12];
        rt.spacing  = 5;
        if (i < countItem) {
            NSDictionary *item  =  [_resourcesBottom objectAtIndex:i];
            if(i == countItem -1) {
                [rt setTitle: [item objectForKey:@"title"] forState: UIControlStateNormal];
            }
            else {
                [rt setTitle: [item objectForKey:@"title"]  forState: UIControlStateNormal];
            }
            [rt setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
            //[rt setImage: [UIImage imageNamed:@"icon_btn_gift"] forState:UIControlStateHighlighted];
            [rt setImage: [UIImage imageNamed:[item objectForKey:@"icon"]] forState:UIControlStateNormal];
            [rt setBackgroundImage:[UIImage imageWithColor:RGBA(189, 222, 244, .5)] forState:UIControlStateHighlighted];
            [rt setBackgroundImage:[UIImage imageWithColor:RGBA(189, 222, 244, .5)] forState:UIControlStateSelected];
            rt.tag  = [[item objectForKey:@"tag"] integerValue];
            [rt addTarget:self action:(@selector(itmeTap:)) forControlEvents:UIControlEventTouchUpInside];
        }
        rt.sd_layout.leftSpaceToView(itemBgViewB,itemPadding*(rightSubColumn) + rightSubColumn*itemWidth)
        .topSpaceToView(itemBgViewB,itemPadding*rightSubRow+rightSubRow*itemWidth + itemPadding)
        .widthIs(itemWidth)
        .heightIs(itemWidth);
    }
}

#pragma mark 懒加载
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
//        _scrollView.delaysContentTouches = NO;
    }
    return _scrollView;
}
- (UIImageView *)userPhotoImg {
    if (!_userPhotoImg) {
        _userPhotoImg = [UIImageView new];
        _userPhotoImg.backgroundColor = [UIColor whiteColor];
        _userPhotoImg.image = [UIImage imageNamed:@"mtou"];
        _userPhotoImg.userInteractionEnabled = YES;
        _userPhotoImg.clipsToBounds = YES;
        _userPhotoImg.contentMode = UIViewContentModeScaleAspectFill;
        _userPhotoImg.layer.cornerRadius = 45;
    }
    return _userPhotoImg;
}
- (UIImageView *)photoCornerImg {
    if (!_photoCornerImg) {
        _photoCornerImg = [UIImageView new];
//        _photoCornerImg.backgroundColor = [UIColor whiteColor];
//        _photoCornerImg.clipsToBounds = YES;
        _photoCornerImg.image = [UIImage imageNamed:@"doctor-ren"];
//        _photoCornerImg.layer.borderWidth = 0.5;
//        _photoCornerImg.layer.borderColor = [UIColor whiteColor].CGColor;
//        _photoCornerImg.layer.cornerRadius = 10;
    }
    return _photoCornerImg;
}
- (KMButton *)ubIcon {
    if (!_ubIcon) {
        _ubIcon = [KMButton buttonWithType:UIButtonTypeCustom];
        _ubIcon.kMButtonType = KMButtonLeft;
        _ubIcon.margin = 0.00001;
        _ubIcon.titleLabel.font = [UIFont systemFontOfSize:12];
        [_ubIcon setTitle:@"10" forState:UIControlStateNormal];
        [_ubIcon setImage:[UIImage imageNamed:@"jinbi"] forState:UIControlStateNormal];
    }
    return _ubIcon;
}
- (KMButton *)moneyIcon {
    if (!_moneyIcon) {
        _moneyIcon = [KMButton buttonWithType:UIButtonTypeCustom];
        _moneyIcon.kMButtonType = KMButtonLeft;
        _moneyIcon.margin = 0.00001;
        _moneyIcon.titleLabel.font = [UIFont systemFontOfSize:12];
        [_moneyIcon setTitle:@"10" forState:UIControlStateNormal];
        [_moneyIcon setImage:[UIImage imageNamed:@"qiandai"] forState:UIControlStateNormal];
    }
    return _moneyIcon;
}
- (KMButton *)daKaBtn {
    if (!_daKaBtn) {
        _daKaBtn = [KMButton buttonWithType:UIButtonTypeSystem];
        _daKaBtn.backgroundColor = RGBA(255, 255, 255, 0.5);
        _daKaBtn.clipsToBounds = YES;
        _daKaBtn.layer.cornerRadius = 18;
        _daKaBtn.spacing = 5;
        _daKaBtn.margin = 5;
        _daKaBtn.kMButtonType = KMButtonLeft;
        _daKaBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_daKaBtn setTitle:@"签到" forState:UIControlStateNormal];
        [_daKaBtn setImage:[UIImage imageNamed:@"yueduhuizong2"] forState:UIControlStateNormal];
        [_daKaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_daKaBtn setTintColor:RGB(255, 255, 153)];
        [_daKaBtn addTarget:self action:@selector(daKaButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _daKaBtn;
}
- (UIButton *)ubBtn {
    if (!_ubBtn) {
        _ubBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//        [_ubBtn setBackgroundImage:[UIImage imageWithColor:RGBA(189, 222, 244, .5)] forState:UIControlStateHighlighted];
//        [_ubBtn setBackgroundImage:[UIImage imageWithColor:RGBA(189, 222, 244, .5)] forState:UIControlStateSelected];
        _ubBtn.tag = 100;
        [_ubBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ubBtn;
}
- (UIButton *)moneyBtn {
    if (!_moneyBtn) {
        _moneyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _moneyBtn.tag = 200;
        [_moneyBtn addTarget:self action:(@selector(buttonClick:)) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moneyBtn;
}
- (UILabel *)ubLab {
    if (!_ubLab) {
        _ubLab = [UILabel new];
        _ubLab.text = @"我的U币";
        _ubLab.textColor = [UIColor whiteColor];
        _ubLab.font = [UIFont boldSystemFontOfSize:14];
        _ubLab.textAlignment = NSTextAlignmentCenter;
    }
    return _ubLab;
}
- (UILabel *)moneyLab {
    if (!_moneyLab) {
        _moneyLab = [UILabel new];
        _moneyLab.text = @"我的余额";
        _moneyLab.textColor = [UIColor whiteColor];
        _moneyLab.font = [UIFont boldSystemFontOfSize:14];
        _moneyLab.textAlignment = NSTextAlignmentCenter;
    }
    return _moneyLab;
}
- (UILabel *)userNameLab {
    if (!_userNameLab) {
        _userNameLab = [UILabel new];
        _userNameLab.text = @"刘兴利";
        _userNameLab.textColor = [UIColor whiteColor];
        _userNameLab.font = [UIFont boldSystemFontOfSize:14];
        _userNameLab.textAlignment = NSTextAlignmentCenter;
    }
    return _userNameLab;
}
- (UILabel *)userCompanyLab {
    if (!_userCompanyLab) {
        _userCompanyLab = [UILabel new];
        _userCompanyLab.text = @"河南省第一人民医院";
        _userCompanyLab.textColor = [UIColor whiteColor];
        _userCompanyLab.font = [UIFont boldSystemFontOfSize:12];
        _userCompanyLab.textAlignment = NSTextAlignmentCenter;
    }
    return _userCompanyLab;
}
- (UILabel *)userCategoryLab {
    if (!_userCategoryLab) {
        _userCategoryLab = [UILabel new];
        _userCategoryLab.backgroundColor = [UIColor whiteColor];
        _userCategoryLab.text = @"主任医师";
        _userCategoryLab.clipsToBounds = YES;
        _userCategoryLab.layer.cornerRadius = 8;
        _userCategoryLab.textColor = Main_Color;
        _userCategoryLab.font = [UIFont boldSystemFontOfSize:10];
        _userCategoryLab.textAlignment = NSTextAlignmentCenter;
    }
    return _userCategoryLab;
}
- (UIView *)topBGView {
    if (!_topBGView) {
        _topBGView = [UIView new];
        _topBGView.backgroundColor = Main_Color;
    }
    return _topBGView;
}
- (UIView *)lineLView {
    if (!_lineLView) {
        _lineLView = [UIView new];
        _lineLView.backgroundColor = [UIColor whiteColor];
    }
    return _lineLView;
}
- (UIView *)lineRView {
    if (!_lineRView) {
        _lineRView = [UIView new];
        _lineRView.backgroundColor = [UIColor whiteColor];
    }
    return _lineRView;
}
- (UIView *)ubView {
    if (!_ubView) {
        _ubView = [UIView new];
    }
    return _ubView;
}
- (UIView *)moneyView {
    if (!_moneyView) {
        _moneyView = [UIView new];
    }
    return _moneyView;
}
- (UIView *)userInfoView {
    if (!_userInfoView) {
        _userInfoView = [UIView new];
    }
    return _userInfoView;
}

#pragma mark - 获取个人信息
- (void)requestUserInfoData {
    
    NSString *params = @"";
    NSString *url = @"api/Customer/CustomerBasicData";
    
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"获取个人信息 - %@", modelData);
        if (isSuccess) {
            //存储用户信息
            [UserInfo updateUserInfo:modelData[@"JsonData"]];
            
            NSString *IsDoctor = modelData[@"JsonData"][@"IsReg"];
            NSUserDf_Set(IsDoctor, kDoctor);//是否是医师
            
            //更新用户信息
            [self updateUserInfo];
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

#pragma mark - 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
