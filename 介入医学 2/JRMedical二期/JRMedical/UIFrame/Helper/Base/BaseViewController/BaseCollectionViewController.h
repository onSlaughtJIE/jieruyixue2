//
//  BaseCollectionViewController.h
//  liuzhiyuan
//
//  Created by a on 16/11/3.
//  Copyright © 2016年 刘志远. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh.h>
#import "TableCommon.h"

@interface BaseCollectionViewController : UICollectionViewController

@property(nonatomic, strong) NSMutableArray *dataSource;//数据源
@property (nonatomic, assign)  BOOL isStartRefresh;//是否立即刷新 默认为NO 不立即执行下拉状态刷新
@property (nonatomic, assign) int page;//页数 默认为1
@property (nonatomic, assign) int pageSize;//每页多少条 默认为15
@property (nonatomic, assign) Class modelClass;//所需model类
@property (nonatomic, strong) NSMutableDictionary *params;//请求所需密全部参数的集合
@property (nonatomic, copy) NSString *api;//请求接口非公共部分的URL
@property (nonatomic, copy) NSString *paramsStr;//请求还需的加密参数
@property (nonatomic, assign) BOOL openDebug;//是否开启调试模式

@property (nonatomic, strong) MBProgressHUD *hud;//透明指示层

#pragma mark - 接口请求
/* *
 * 添加某个请求参数到参数集合里(此集合是个字典)
 * key 参数的字段名
 * value 字段对应的值
 */
- (void)setParam:(NSString *)key model:(NSObject *)value;

/* *
 * 表类请求,数据一般为数组形式(有上拉下拉刷新)
 * api 接口Url(除去共用部分)
 * params 接口所需加密参数字符串
 * type 刷新类型 0 = 无上下拉刷新   1 = 只有上拉刷新   2 = 只有下拉刷新   3 = 上下拉刷新都有
 * modelClass 存储数据所需的model类
 */
- (void)loadDataApi:(NSString*)api withParams:(NSString *)params refresh:(RefreshType)type model:(Class)modelClass;

#pragma mark - 检测网络状态
/* *
 * 检测网络状态
 * level = 0 即 AFNetworkReachabilityStatusNotReachable = 无网络连接，请检查您的网络状态
 */
- (void)checkNetwork;

/* *
 * 检测网络状态,可选择那种状态
 * level 网络状态   分为 : -1 = 未知   0 = 无连接   1 = 数据流量   2 = WIFI网络
 */
- (void)checkNetwork:(NSInteger)level;

#pragma mark - 透明指示层
/* *
 * 显示一个自定时间的,上图下文的
 * name 图片名字
 * time 显示时间
 * message 提示文字
 */
- (void)showImage:(NSString *)name time:(NSTimeInterval)time message:(NSString *)message;

/* *
 * 显示一个时间为1.5秒的,纯文字的
 * message 提示文字
 */
- (void)showMessage:(NSString *)message;

/* *
 * 显示一个自定时间的,纯文字的
 * message 提示文字
 * time 显示时间
 */
- (void)showMessage:(NSString *)message time:(NSTimeInterval)time;


/* *
 * 显示一个自定时间的,纯文字的,可自定父视图
 * message 提示文字
 * time 显示时间
 * view 父视图
 */
- (void)showMessage:(NSString *)message time:(NSTimeInterval)time view:(UIView *)view;

/* *
 * 显示一个时间为3秒的,菊花加载样式的,纯文字的,可自定父视图
 * message 提示文字
 */
- (void)showLoadding:(NSString *)message;

/* *
 * 显示一个自定时间的,菊花加载样式的,纯文字的
 * message 提示文字
 * time 显示时间
 */
- (void)showLoadding:(NSString *)message time:(NSTimeInterval)time;

/* *
 * 显示一个自定时间的,菊花加载样式的,纯文字的,可自定父视图
 * message 提示文字
 * time 显示时间
 * view 父视图
 */
- (void)showLoadding:(NSString *)message time:(NSTimeInterval)time view:(UIView *)view;

@end
