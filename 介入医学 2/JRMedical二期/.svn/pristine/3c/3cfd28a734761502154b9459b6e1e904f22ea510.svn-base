//
//  BaseNetwork.m
//  liuzhiyuan
//
//  Created by a on 16/11/3.
//  Copyright © 2016年 刘志远. All rights reserved.
// 

#import "BaseNetwork.h"

@implementation BaseNetwork

+ (void)setParam:(NSString *)key model:(NSObject *)value {
    if (baseParams == nil) {
        baseParams = [[NSMutableDictionary alloc] init];
    }
    [baseParams setObject:value forKey:key];
}

+ (void)postLoadDataApi:(NSString *)api withParams:(NSString *)params block:(void (^)(int code,BOOL isSuccess,NSDictionary *modelData))finishBlock {

    if (api == nil) {
        return;
    }
    
    NSString *paraStr = kTotalEncryptionInfo(params);
    NSString *Datas = [TWDes encryptWithContent:paraStr type:kDesType key:kDesKey];
    
    NSString *token = [UserInfo getAccessToken];
    if (token != nil) {
        [self setParam:@"Token" model:token];
    }
    
    [self setParam:kDatas model:Datas];
    
    if (openDebug) {
        [HYBNetworking enableInterfaceDebug:YES];
    }
    
    [HYBNetworking updateBaseUrl:Server_Int_Url];
    [HYBNetworking configRequestType:kHYBRequestTypePlainText];
    [HYBNetworking postWithUrl:api
                        params:baseParams
                       success:^(id response) {
                           
                           [baseParams removeAllObjects];
                           
                           int code = [[response objectForKey:@"Code"] intValue];
                           BOOL isSuccess = [[response objectForKey:@"Success"] boolValue];
                           NSDictionary *dataDic = response;
                           
                           if (finishBlock != nil) {
                               finishBlock(code,isSuccess,dataDic);
                           }
                       }
                          fail:^(NSError *error) {
                              [baseParams removeAllObjects];
                              if (finishBlock != nil) {
                                  finishBlock(999,0,nil);
                              }
                          }];
}

+ (void)getLoadDataApi:(NSString *)api block:(void (^)(int code,BOOL isSuccess,NSDictionary *modelData))finishBlock {
    
    if (api == nil) {
        return;
    }
    
    if (openDebug) {
        [HYBNetworking enableInterfaceDebug:YES];
    }
    
    [HYBNetworking updateBaseUrl:Server_Int_Url];
    [HYBNetworking getWithUrl:api
                      success:^(id response) {
                          
                          int code = [[response objectForKey:@"Code"] intValue];
                          BOOL isSuccess = [[response objectForKey:@"Success"] boolValue];
                          NSDictionary *dataDic = response;
                          
                          if (finishBlock != nil) {
                              finishBlock(code,isSuccess,dataDic);
                          }
                          
                      } fail:^(NSError *error) {
                          if (finishBlock != nil) {
                              finishBlock(999,0,nil);
                          }
                      }];
}



@end
