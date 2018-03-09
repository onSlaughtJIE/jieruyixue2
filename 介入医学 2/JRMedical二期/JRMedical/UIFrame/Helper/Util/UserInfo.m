//
//  UserInfo.m
//  JRMedical
//
//  Created by a on 16/11/4.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "UserInfo.h"
#import <YYKit.h>

@implementation UserInfo

+ (void)updateUserInfo:(NSString*)key value:()value {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *userinfo = [ user objectForKey:@"userinfo"];
    NSMutableDictionary *muserinfo = [[NSMutableDictionary alloc] initWithDictionary:userinfo];
    if ([muserinfo containsObjectForKey:key]) {
        [muserinfo setValue:value forKey:key];
    }
    [user setObject:[NSDictionary dictionaryWithDictionary:muserinfo] forKey:@"userinfo"];
    [user synchronize];
}

+ (void)updateUserInfo:(NSDictionary*)userinfo {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:userinfo forKey:@"userinfo"];
    [user synchronize];
}

+ (NSObject*)getUserInfoValue:(NSString*)key {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *userinfo = [user objectForKey:@"userinfo"];
    if([userinfo containsObjectForKey:key]) {
        return  [userinfo objectForKey:key];
    }
    else {
        return nil;
    }
}

+ (NSDictionary*)gettUserInfoAll {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *userinfo = [ user objectForKey:@"userinfo"];
    return userinfo;
}

+ (void)removeUserInfo {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:@"userinfo"];
    [user synchronize];
}

+ (void)setAccessToken:(NSString *)str {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:str forKey:@"token"];
    [userDefaults synchronize];
}

+ (NSString *)getAccessToken {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *devIdentity = [userDefaults objectForKey:@"token"];
    return devIdentity;
}

+ (void)removeAccessToken {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:@"token"];
    [user synchronize];
}

+ (void)setDevIdentity:(NSString *)str {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:str forKey:@"DevIdentity"];
    [userDefaults synchronize];
}

+ (NSString *)getDevIdentity {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *devIdentity = [userDefaults objectForKey:@"DevIdentity"];
    return devIdentity;
}

+ (void)removeDevIdentity {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:@"DevIdentity"];
    [user synchronize];
}

@end
