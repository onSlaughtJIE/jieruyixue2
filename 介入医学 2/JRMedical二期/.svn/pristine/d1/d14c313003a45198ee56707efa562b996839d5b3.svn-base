//
//  BaseNetwork.h
//  liuzhiyuan
//
//  Created by a on 16/11/3.
//  Copyright © 2016年 刘志远. All rights reserved.
//

#import <Foundation/Foundation.h>

static BOOL openDebug = NO;//是否开启调试模式
static NSMutableDictionary *baseParams = nil;//请求所需密全部参数的集合

@interface BaseNetwork : NSObject

/* *
 * 添加某个请求参数到参数集合里(此集合是个字典) 使用此方法添加请求参数是不参与加密的
 * key 参数的字段名
 * value 字段对应的值
 */
+ (void)setParam:(NSString *)key model:(NSObject *)value;

/* *
 * Post接口请求
 * api 接口Url(除去共用部分)
 * params 接口所需加密参数字符串
 * block 请求成功后的回调(注 : 返回的参数,可根据具体服务器情况去修改)  若 isSuccess 为0 code为 999 则表示请求不成功 fail : 网络错误
 */
+ (void)postLoadDataApi:(NSString *)api withParams:(NSString *)params block:(void (^)(int code,BOOL isSuccess,NSDictionary *modelData))finishBlock;

/* *
 * Get接口请求
 * api 接口Url(除去共用部分)
 * block 请求成功后的回调(注 : 返回的参数,可根据具体服务器情况去修改)  若 isSuccess 为0 code为 999 则表示请求不成功 fail : 网络错误
 */
+ (void)getLoadDataApi:(NSString *)api block:(void (^)(int code,BOOL isSuccess,NSDictionary *modelData))finishBlock;


@end
