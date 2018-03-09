//
//  ToolMacros.h
//  JRMedical
//
//  Created by a on 16/11/4.
//  Copyright © 2016年 idcby. All rights reserved.
//

#ifndef ToolMacros_h
#define ToolMacros_h

#define APPDELEGETE   ((AppDelegate*)[[UIApplication sharedApplication] delegate])
#define MAIN_WIN         [UIApplication sharedApplication].windows[0];

// 判断是否为iOS7
#define IOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
#define IOS_VERSIONS [[[UIDevice currentDevice] systemVersion] floatValue]
// 是否为4inch
#define fourInch ([UIScreen mainScreen].bounds.size.height == 568)

//  重新设定view的Y值
#define setFrameY(view, newY) view.frame = CGRectMake(view.frame.origin.x, newY, view.frame.size.width, view.frame.size.height)
#define setFrameX(view, newX) view.frame = CGRectMake(newX, view.frame.origin.y, view.frame.size.width, view.frame.size.height)
#define setFrameH(view, newH) view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, newH)

//  取view的坐标及长宽
#define W(view)    view.frame.size.width
#define H(view)    view.frame.size.height
#define X(view)    view.frame.origin.x
#define Y(view)    view.frame.origin.y

//高度相对于宽度为16:9
#define Height_SixteenToNine (Width_Screen/16)*9

/********** 颜色 **************/
//  随机数
#define kRandom(a,b)        (arc4random() % a / b)
// RGB颜色设置
#define RGBCA(c,a)          [UIColor colorWithRed:((c>>16)&0xFF)/256.0  green:((c>>8)&0xFF)/256.0   blue:((c)&0xFF)/256.0   alpha:a]
#define RGBA(r, g, b, a)    [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r, g, b)          RGBA(r, g, b, 1.0f)
// 随机颜色
#define KMRC              [UIColor colorWithHue:kRandom(256,256.0) saturation:kRandom(128,256.0)  + 0.5 brightness:kRandom(128,256.0)  + 0.5 alpha:1]

//整体绿色主色调
#define Main_Color   RGB(0, 187, 156)
//整体灰色背景色
#define BG_Color  RGB(240, 240, 240)
//灰色字体
#define HuiText_Color RGB(150, 150, 150)

//block self
#define WeakSelf        __weak __typeof(self) wself = self;

/********** 各种系统界面的高度大小 **************/
#pragma mark - Frame
#define Width_Screen                [UIScreen mainScreen].bounds.size.width
#define Height_Screen               [UIScreen mainScreen].bounds.size.height
#define Height_Statusbar          20
#define Height_Tabbar              49
#define Height_Navbar              44

#ifndef UIColorHex
#define UIColorHex(_hex_)   [UIColor colorWithHexString:((__bridge NSString *)CFSTR(#_hex_))]
#endif

/********** 本地存储 **************/
#define NSUserDf_Set(Value,Key) {[[NSUserDefaults standardUserDefaults] setObject:Value forKey:Key]; [[NSUserDefaults standardUserDefaults] synchronize];}
#define NSUserDf_Remove(Key) [[NSUserDefaults standardUserDefaults] removeObjectForKey:Key]
#define NSUserDf_Get(Key) [[NSUserDefaults standardUserDefaults] objectForKey:Key]

//block self
#define WeakSelf        __weak __typeof(self) wself = self;

//登录状态
#define JRIsLogin @"JRIsLogin"
#define kYesLogin @"yes"
#define kNoLogin @"no"

//系统定位信息
#define kProvince @"provinceName"
#define kCity @"cityName"

//成功/失败  透明层图标
#define SUCCESS_ICON   @"success_icon"
#define FAIL_ICON           @"fail_icon"

//用户信息
#define kUserPic @"UserPic"//环信密码
#define kDoctor @"IsDoctor"//是否是医师
#define kHXName @"HXName"//环信用户名
#define kHXPwd @"HXPwd"//环信密码

//支付回调通知
#define kWeixin_pay_result_success @"weixin_pay_result_success"
#define kAliPayCallBackInfo @"AliPayCallBack"

//购物车数量变化
//#define kShopCarNumberChanged @"ShopCarNumberChanged"

// 极光推送
#define kJPushWithAdd @"JPushWithAdd"

/*********  接口  ********/
// 测试地址
//#define     Server_Web_Url                      @"http://123.56.158.181:6061/"//Web接口地址
//#define     Server_Int_Url                      @"http://123.56.158.181:6060/"//IP接口地址

// 正式地址
#define     Server_Web_Url                      @"http://www.jieruyixue.com:80/"  //Web接口地址
#define     Server_Int_Url                      @"http://www.jieruyixue.com:7023/"//IP接口地址


#endif /* ToolMacros_h */
