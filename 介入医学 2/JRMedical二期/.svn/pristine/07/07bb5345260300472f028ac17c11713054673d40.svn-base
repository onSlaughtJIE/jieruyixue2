//
//  UserInfo.h
//  JRMedical
//
//  Created by a on 16/11/4.
//  Copyright © 2016年 idcby. All rights reserved.
//

// 处理用户信息类

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

/**
 * 更新单个用户信息
 */
+ (void)updateUserInfo:(NSString*)key value:()value;

/**
 * 存储更新全部用户信息
 */
+ (void)updateUserInfo:(NSDictionary*)userinfo;

/**
 * 获取单个用户信息
 */
+(NSObject*)getUserInfoValue:(NSString*)key;

/**
 * 获取全部用户信息
 */
+(NSDictionary*)gettUserInfoAll;

/**
 * 删除全部用户信息
 */
+ (void)removeUserInfo;

/**
 * 存储token
 */
+ (void)setAccessToken:(NSString *)str;

/**
 * 获取token
 */
+ (NSString *)getAccessToken;

/**
 * 移除token
 */
+ (void)removeAccessToken;

/**
 * 存储单点登录
 */
+ (void)setDevIdentity:(NSString *)str;

/**
 * 获取单点登录
 */
+ (NSString *)getDevIdentity;

/**
 * 移除单点登录
 */
+ (void)removeDevIdentity;

@end
