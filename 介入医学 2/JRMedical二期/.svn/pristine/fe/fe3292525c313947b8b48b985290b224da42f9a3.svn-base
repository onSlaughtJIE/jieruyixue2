//
//  GoodRootViewController.m
//  JRMedical
//
//  Created by ww on 2016/11/16.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "GoodRootViewController.h"
#import "GoodFirstViewController.h"
#import "GoodDetailViewController.h"
#import "GoodCommentViewController.h"
#import "KMButton.h"
#import "FillInOrderVC.h"
#import "MedicalExchangeVC.h"//商品兑换
#import "yuyueView.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import "WLZ_ChangeCountView.h"

@interface GoodRootViewController ()<UIScrollViewDelegate, UITextFieldDelegate>


@property (nonatomic, retain) UIScrollView *bigScrollView;
@property (nonatomic, strong) UIScrollView *topScrollView;

@property (nonatomic, strong) UIImage *shareImage;

@property (nonatomic, strong) NSMutableDictionary *detailDataDic;

@property (nonatomic, strong) NSMutableArray *addressArray;//存当前选中的地址
@property (nonatomic, strong) NSMutableArray *commodityArray;//存当前所有商品信息

// 数量选择
@property (nonatomic, strong) yuyueView *yuView;
@property (nonatomic, strong) WLZ_ChangeCountView *changeView;
@property (nonatomic, assign) NSInteger choosedCount;

@end

@implementation GoodRootViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"goToPingLun" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FillInOrderAddressArray" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BG_Color;
    
    self.commodityArray = [NSMutableArray arrayWithCapacity:0];
    
    //选择分类下的分类后刷新数据的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToPingLunClick) name:@"goToPingLun" object:nil];
    
    //选择地址传过来的数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fillInOrderAddressArrayClick:) name:@"FillInOrderAddressArray" object:nil];
    
    
    _choosedCount = 1;
    // add 购物车数量变化的通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shopCarNumberChanged:) name:kShopCarNumberChanged object:nil];
    
    [self.view addSubview:self.bigScrollView];
    
    [self getMedicalDetailData];//请求详情
    
    // 添加子控制器
    [self addSubController];
    //添加模块导航栏
    [self addTopBarLabel];
    
    CGFloat contentX = self.childViewControllers.count * Width_Screen;
    self.bigScrollView.contentSize = CGSizeMake(contentX, 0);
    self.bigScrollView.pagingEnabled = YES;
    
    //添加默认控制器
    UIViewController *vc = [self.childViewControllers firstObject];
    vc.view.frame = self.bigScrollView.bounds;
    [self.bigScrollView addSubview:vc.view];
    self.navigationItem.titleView = _topScrollView;

    //设置底部工具栏
    if (self.isShowTool == 100) {//购物车跳过来
        //不创建展示工具栏
    }
    else if (self.isShowTool == 200) {//兑换商品过来,修改工具栏
        [self duiHuanConfigBottomToolBar];
    }
    else {
        [self configBottomToolBar];
    }
    
    // 分享
    // fenxianglcv@2x
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fenxianglcv"] style:UIBarButtonItemStylePlain target:self action:@selector(shareGood)];
}

#pragma mark - 去评论页面
- (void)goToPingLunClick {
    NSUInteger currentTag = 102;
    for (UIView *view in self.topScrollView.subviews) {
        UILabel *label = (UILabel *)view.subviews.firstObject;
        UILabel *lineLabel = (UILabel *)view.subviews.lastObject;
        if (view.tag != currentTag) {
            label.textColor = RGB(80, 80, 80);
            lineLabel.hidden = YES;
            
        } else {
            label.textColor = [UIColor whiteColor];
            lineLabel.hidden = NO;
            
        }
    }
    
    CGFloat offsetX = (currentTag - 100) * self.bigScrollView.frame.size.width;
    CGFloat offsetY = self.bigScrollView.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    [self.bigScrollView setContentOffset:offset animated:YES];
}

#pragma mark - 接受选取地址后的通知
- (void)fillInOrderAddressArrayClick:(NSNotification *)sender {
    self.addressArray = sender.userInfo[@"AddressArray"];
}

#pragma mark - 正常工具栏
- (void)configBottomToolBar {
    
    UIView *endView = [[UIView alloc] initWithFrame:(CGRectMake(0, Height_Screen-44-64, Width_Screen, 44))];
    endView.layer.shadowColor = RGB(100, 100, 100).CGColor;//阴影颜色
    endView.layer.shadowOffset = CGSizeMake(0 , 1);//偏移距离
    endView.layer.shadowOpacity = 0.5;//不透明度
    endView.layer.shadowRadius = 3.0;//半径
    [self.view addSubview:endView];
   
    KMButton *chebt = [KMButton buttonWithType:(UIButtonTypeCustom)];
    chebt.frame = CGRectMake(0, 0, Width_Screen/2, 44);
    chebt.spacing = 5;
    chebt.margin = (Width_Screen/2-105)/2;
    chebt.kMButtonType = KMButtonLeft;
    [chebt setImage:[UIImage imageNamed:@"iconwuch"] forState:(UIControlStateNormal)];
    [chebt setTitle:@"加入购物车" forState:(UIControlStateNormal)];
    [chebt.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [chebt setBackgroundColor: RGB(253, 166, 57)];
    [chebt addTarget:self action:@selector(goodAdded:) forControlEvents:(UIControlEventTouchUpInside)];
    [endView addSubview:chebt];
    
    KMButton *buybt = [KMButton buttonWithType:(UIButtonTypeCustom)];
    buybt.frame = CGRectMake(Width_Screen/2, 0, Width_Screen/2, 44);
    buybt.spacing = 5;
    buybt.margin = (Width_Screen/2-89)/2;
    [buybt setImage:[UIImage imageNamed:@"qiandaijiesuan"] forState:(UIControlStateNormal)];
    [buybt setTitle:@"立即购买" forState:(UIControlStateNormal)];
    [buybt.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [buybt setBackgroundColor: RGB(239, 79, 70)];
    [buybt addTarget:self action:@selector(goodBuy:) forControlEvents:(UIControlEventTouchUpInside)];
    [endView addSubview:buybt];
}

#pragma mark - 兑换商品工具栏
- (void)duiHuanConfigBottomToolBar {
    
    UIView *endView = [[UIView alloc] initWithFrame:(CGRectMake(0, Height_Screen-44-64, Width_Screen, 44))];
    endView.layer.shadowColor = RGB(100, 100, 100).CGColor;//阴影颜色
    endView.layer.shadowOffset = CGSizeMake(0 , 1);//偏移距离
    endView.layer.shadowOpacity = 0.5;//不透明度
    endView.layer.shadowRadius = 3.0;//半径
    [self.view addSubview:endView];
    
    KMButton *buybt = [KMButton buttonWithType:(UIButtonTypeCustom)];
    buybt.frame = CGRectMake(0, 0, Width_Screen, 44);
    buybt.spacing = 5;
    buybt.margin = (Width_Screen-89)/2;
    [buybt setImage:[UIImage imageNamed:@"qiandaijiesuan"] forState:(UIControlStateNormal)];
    [buybt setTitle:@"立即兑换" forState:(UIControlStateNormal)];
    [buybt.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [buybt setBackgroundColor: RGB(239, 79, 70)];
    [buybt addTarget:self action:@selector(goodBuy:) forControlEvents:(UIControlEventTouchUpInside)];
    [endView addSubview:buybt];
}

- (void)shareGood {
    
    NSLog(@"分享--%@",self.detailDataDic);
    
    //1、创建分享参数
    NSArray* imageArray = @[self.detailDataDic[@"Pic"]];
    // （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    
    // 压缩图片 太大的话 微信分享不出去
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.detailDataDic[@"Pic"]]]];
        NSData *fData = UIImageJPEGRepresentation(_shareImage, 0.1);
        if (fData != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _shareImage = [UIImage imageWithData:fData];
            });
        }
    });
    
    if (imageArray) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:self.detailDataDic[@"Name"]
                                         images:imageArray
                                            url:[NSURL URLWithString:self.detailDataDic[@"DescribeHtml"]]
                                          title:[NSString stringWithFormat:@"%@",self.detailDataDic[@"Name"]]
                                           type:SSDKContentTypeAuto];
        //2、分享
        [SSUIShareActionSheetStyle setShareActionSheetStyle:ShareActionSheetStyleSimple]; //设置简单分享菜单样式
        SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:nil
                                                                         items:nil
                                                                   shareParams:shareParams
                                                           onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                                                               
                                                               switch (state) {
                                                                   case SSDKResponseStateSuccess:
                                                                   {
                                                                       if (platformType == SSDKPlatformTypeCopy) {
                                                                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"拷贝成功"
                                                                                                                               message:nil
                                                                                                                              delegate:nil
                                                                                                                     cancelButtonTitle:@"确定"
                                                                                                                     otherButtonTitles:nil];
                                                                           [alertView show];
                                                                           
                                                                       }else {
                                                                           
                                                                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                                                               message:nil
                                                                                                                              delegate:nil
                                                                                                                     cancelButtonTitle:@"确定"
                                                                                                                     otherButtonTitles:nil];
                                                                           [alertView show];
                                                                       }
                                                                       
                                                                       break;
                                                                   }
                                                                   case SSDKResponseStateFail:
                                                                   {
                                                                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                                                       message:[NSString stringWithFormat:@"%@",error]
                                                                                                                      delegate:nil
                                                                                                             cancelButtonTitle:@"OK"
                                                                                                             otherButtonTitles:nil, nil];
                                                                       [alert show];
                                                                       break;
                                                                   }
                                                                   default:
                                                                       break;
                                                               }
                                                           }];
        
        // SSDKPlatformTypeCopy 点击拷贝不再弹出编辑界面
        [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeCopy)]; //（加了这个方法之后可以不跳分享编辑界面，直接点击分享菜单里的选项，直接分享）
    }
}

//
//- (void)shopCarNumberChanged:(NSNotification *)sender {
//    
//    NSLog(@"%@", sender.userInfo);
//    _commodityNumber = [sender.userInfo[@"number"] integerValue];
//}

#pragma mark - 添加到购物车
- (void)goodAdded:(UIButton *)sender {
    
    
    UIView *backView = [[UIView alloc] initWithFrame:self.view.bounds];
    backView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:backView];
    backView.alpha = 0;
    
    self.yuView = [yuyueView yuyueView];
    _yuView.frame = CGRectMake(0, Height_Screen, Width_Screen, 200);
    [self.view addSubview:_yuView];
    
    _changeView = [[WLZ_ChangeCountView alloc] initWithFrame:CGRectMake(Width_Screen-130, 10, 180, 40) chooseCount:1 totalCount: 10001];
    [_changeView.subButton addTarget:self action:@selector(subButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_changeView.addButton addTarget:self action:@selector(addButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    _changeView.numberFD.delegate = self;
    [_yuView.countView addSubview:_changeView];
    
    _yuView.oldLab.hidden = YES;
    [_yuView.picImageView sd_setImageWithURL:[NSURL URLWithString:self.detailDataDic[@"Pic"]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
    _yuView.priceLab.text = [NSString stringWithFormat:@"¥%@", self.detailDataDic[@"PromotionPrice"]];
    
    
    [UIView animateWithDuration:0.8 animations:^{
        
        backView.alpha = 0.6;
        _yuView.frame = CGRectMake(0, Height_Screen-200-64 , Width_Screen, 200);
        
    } completion:^(BOOL finished) {
        
        
    }];
    
    
    // cancle
    WeakSelf;
    _yuView.cancle = ^() {
        
        [UIView animateWithDuration:0.8 animations:^{
            
            backView.alpha = 0;
            wself.yuView.frame = CGRectMake(0, Height_Screen, Width_Screen, 200);
            
        } completion:^(BOOL finished) {
            
            [backView removeFromSuperview];
            [wself.yuView removeFromSuperview];
        }];
        
        
    };
    
    // 确定
    _yuView.makesure = ^() {
        
        [UIView animateWithDuration:0.5 animations:^{
            wself.yuView.frame = CGRectMake(0, Height_Screen, Width_Screen, 200);
            
        } completion:^(BOOL finished) {
            
            [wself.yuView removeFromSuperview];
            [backView removeFromSuperview];
            // 调接口 添加购物车
            [wself addShoppingCar];
            
        }];
        
        
    };
    
    
    
    
    
    
    
    
}

#pragma mark - 立即购买
- (void)goodBuy:(UIButton *)sender {
    
    NSString *numStr = [NSString stringWithFormat:@"%ld", (long)_choosedCount];
    
    //设置底部工具栏
    if (self.from == 2000) {//兑换商品
        [self.commodityArray removeAllObjects];
        
        if (self.detailDataDic.count == 0) {
            return;
        }
        
        CGFloat uPrice = [self.detailDataDic[@"UPrice"] floatValue];
        NSString *totalUPrice = [NSString stringWithFormat:@"%.2f", _choosedCount * uPrice];
        NSDictionary *commodityDic = @{@"ExchangeID":self.detailDataDic[@"ExchangeID"],
                                       @"Name":self.detailDataDic[@"Name"],
                                       @"Pic":self.detailDataDic[@"Pic"],
                                       @"totalPrice":totalUPrice,
                                       @"Num":numStr};
        
        [self.commodityArray addObject:commodityDic];
        
        MedicalExchangeVC *orderVC = [MedicalExchangeVC new];
        orderVC.addressAry = self.addressArray;
        orderVC.commodityAry = self.commodityArray;
        [self.navigationController pushViewController:orderVC animated:YES];
    }
    else {
        [self.commodityArray removeAllObjects];
        
        if (self.detailDataDic.count == 0) {
            return;
        }
        
        CGFloat Price = [self.detailDataDic[@"PromotionPrice"] floatValue];
        NSString *totalPrice = [NSString stringWithFormat:@"%.2f", _choosedCount * Price];
        NSDictionary *commodityDic = @{@"CommodityID":self.detailDataDic[@"CommodityID"],
                                       @"Name":self.detailDataDic[@"Name"],
                                       @"Pic":self.detailDataDic[@"Pic"],
                                       @"totalPrice":totalPrice,
                                       @"Num":numStr};
        
        [self.commodityArray addObject:commodityDic];
        
        FillInOrderVC *orderVC = [FillInOrderVC new];
        orderVC.addressAry = self.addressArray;
        orderVC.commodityAry = self.commodityArray;
        orderVC.from = @"商品详情";
        [self.navigationController pushViewController:orderVC animated:YES];
    }
}

- (UIScrollView *)topScrollView {
    if (!_topScrollView) {
        self.topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 4, 180, 40)];
        self.topScrollView.backgroundColor = Main_Color;
        self.topScrollView.showsHorizontalScrollIndicator = NO;
        self.topScrollView.showsVerticalScrollIndicator = NO;
        _topScrollView.scrollEnabled = NO;
    }
    return _topScrollView;
}

- (UIScrollView *)bigScrollView {
    if (!_bigScrollView) {
        self.bigScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        self.bigScrollView.delegate = self;
        self.bigScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _bigScrollView;
}

- (void)addTopBarLabel {
    
    for (int i = 0; i < 3; i++) {
        
        UIView *view = [[UIView alloc] initWithFrame:(CGRectMake(60 * i, 0, 60, 40))];
        view.tag = 100 + i;
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)]];
        
        UILabel *label = [[UILabel alloc] initWithFrame:(CGRectMake(0, 0, 60, 35))];
        UIViewController *vc = self.childViewControllers[i];
        label.text = vc.title;
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
        
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:(CGRectMake(5, 35, 50, 4))];
        lineLabel.backgroundColor = [UIColor whiteColor];
        [view addSubview:lineLabel];
        if (i == 0) {
            label.textColor = [UIColor whiteColor];
            lineLabel.hidden = NO;
        }
        else {
            label.textColor = RGB(80, 80, 80);
            lineLabel.hidden = YES;
        }
        
        [self.topScrollView addSubview:view];
        
    }
    self.topScrollView.contentSize = CGSizeMake(180, 0);
}

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    
    NSLog(@"%ld",sender.view.tag);
    
    NSUInteger currentTag = sender.view.tag;
    for (UIView *view in self.topScrollView.subviews) {
        UILabel *label = (UILabel *)view.subviews.firstObject;
        UILabel *lineLabel = (UILabel *)view.subviews.lastObject;
        if (view.tag != currentTag) {
            label.textColor = RGB(80, 80, 80);
            lineLabel.hidden = YES;
            
        } else {
            label.textColor = [UIColor whiteColor];
            lineLabel.hidden = NO;
            
        }
    }
    
    CGFloat offsetX = (currentTag - 100) * self.bigScrollView.frame.size.width;
    CGFloat offsetY = self.bigScrollView.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    [self.bigScrollView setContentOffset:offset animated:YES];
}

- (void)addSubController {
    for (int i = 0; i < 3; i++) {
        if (0 == i) {
            GoodFirstViewController *vc = [[GoodFirstViewController alloc] init];
            vc.title = @"商品";
            vc.exchangeID = self.exchangeID;
            vc.commodityID = self.commodityID;
            vc.from = self.from;
            vc.isShowTool = self.isShowTool;
            [self addChildViewController:vc];
            
        } else if (1 == i) {
            GoodDetailViewController *vc = [[GoodDetailViewController alloc] init];
            vc.title = @"详情";
            vc.exchangeID = self.exchangeID;
            vc.commodityID = self.commodityID;
            vc.from = self.from;
            vc.isShowTool = self.isShowTool;
            [self addChildViewController:vc];
            
        } else {
            GoodCommentViewController *vc = [[GoodCommentViewController alloc] init];
            vc.title = @"评价";
            vc.exchangeID = self.exchangeID;
            vc.commodityID = self.commodityID;
            vc.from = self.from;
            vc.isShowTool = self.isShowTool;
            [self addChildViewController:vc];
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    NSUInteger index = scrollView.contentOffset.x / self.bigScrollView.frame.size.width;
    UIView *view = self.topScrollView.subviews[index];
    NSUInteger currentTag = view.tag;
    
    for (UIView *view in self.topScrollView.subviews) {
        UILabel *label = (UILabel *)view.subviews.firstObject;
        UILabel *lineLabel = (UILabel *)view.subviews.lastObject;
        if (view.tag != currentTag) {
            label.textColor = RGB(80, 80, 80);
            lineLabel.hidden = YES;
            
        } else {
            label.textColor = [UIColor whiteColor];
            lineLabel.hidden = NO;
        }
    }
    
    CGFloat offsetX = view.center.x - self.topScrollView.frame.size.width * 0.5;
    CGFloat offsetMax = self.topScrollView.contentSize.width - self.topScrollView.frame.size.width;
    if (offsetX < 0) {
        offsetX = 0;
    } else if (offsetX > offsetMax) {
        offsetX = offsetMax;
    }
    CGPoint offset = CGPointMake(offsetX, self.topScrollView.contentOffset.y);
    [self.topScrollView setContentOffset:offset animated:YES];
    UIViewController *vc = self.childViewControllers[index];
    
    if (vc.view.superview) {
        return;
    }
    vc.view.frame = scrollView.bounds;
    [self.bigScrollView addSubview:vc.view];
}

//滚动结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

#pragma mark - 获取商品详情数据数据
- (void)getMedicalDetailData {
    
    NSString *params = [NSString stringWithFormat:@"ZICBDYCExchangeID=%@ZICBDYCCommodityID=%@",self.exchangeID,self.commodityID];
    NSString *url = @"api/CommodityInfo/CommodityInfoByID";
    
    [self showLoadding:@"正在加载" time:20];
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"获取商品详情数据数据 - %@", modelData);
        if (isSuccess) {
            self.detailDataDic = modelData[@"JsonData"];
            
            NSMutableDictionary *allInfoDic = [[NSMutableDictionary alloc] init];
            [allInfoDic setObject:self.detailDataDic forKey:@"DetailDataDic"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"detailDataDicNotification" object:nil userInfo:allInfoDic];
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

#pragma mark - 加入购物车
- (void)addShoppingCar {
    
    NSString *numStr = [NSString stringWithFormat:@"%ld", (long)_choosedCount];
    NSString *params = [NSString stringWithFormat:@"ZICBDYCCommodityID=%@ZICBDYCNumber=%@",self.commodityID, numStr];
    NSString *url = @"api/MallsInfo/AddShoppingCart";
    
    [self showLoadding:@"" time:20];
    [self loadDataApi:url withParams:params block:^(int code, BOOL isSuccess, NSDictionary *modelData) {
        NSLog(@"加入购物车 - %@", modelData);
        if (isSuccess) {
            [self showMessage:@"添加购物车成功" time:0.7];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"fromShoppingCome" object:nil userInfo:nil];
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



#pragma mark - 数量加减

//加
- (void)addButtonPressed:(id)sender
{
    NSLog(@"+");
    
    if (self.choosedCount > 0) {
        _changeView.subButton.enabled=YES;
    }
    
    
    if(self.choosedCount>=10000)
    {
        self.choosedCount = 10000;
        _changeView.addButton.enabled = NO;
        return;
    }
    
    ++self.choosedCount;
    _changeView.numberFD.text=[NSString stringWithFormat:@"%zi",self.choosedCount];
    
    
    
}
//减
- (void)subButtonPressed:(id)sender
{
    NSLog(@"-");
    if (self.choosedCount == 1) {
        self.choosedCount = 1;
        _changeView.subButton.enabled = NO;
        return;
    }
    else
    {
        _changeView.addButton.enabled = YES;
    }
    
    -- self.choosedCount;
    _changeView.numberFD.text=[NSString stringWithFormat:@"%zi",self.choosedCount];

    
}

// 数量编辑
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _changeView.numberFD = textField;
    if ([self isPureInt:_changeView.numberFD.text]) {
        if ([_changeView.numberFD.text integerValue]<0) {
            _changeView.numberFD.text = @"1";
        }
    }
    else
    {
        _changeView.numberFD.text = @"1";
    }
    
    if ([_changeView.numberFD.text isEqualToString:@""] || [_changeView.numberFD.text isEqualToString:@"0"]) {
        self.choosedCount = 1;
        _changeView.numberFD.text = @"1";
    }
    NSString *numText = _changeView.numberFD.text;
    
    if ([numText intValue] >10000) {
        [SVProgressHUD showErrorWithStatus:@"最多支持购买10000个"];
        _changeView.numberFD.text = @"10000";
    }
    
    _changeView.addButton.enabled = YES;
    _changeView.subButton.enabled = YES;
    
    self.choosedCount = [_changeView.numberFD.text integerValue];
    _changeView.numberFD.text=[NSString stringWithFormat:@"%zi",self.choosedCount];
    NSLog(@"self.choosedCount - %ld", (long)self.choosedCount);
    
    
    
    
}

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
