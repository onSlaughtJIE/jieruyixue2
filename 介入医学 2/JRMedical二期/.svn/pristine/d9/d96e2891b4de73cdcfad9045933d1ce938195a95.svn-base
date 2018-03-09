//
//  AFManegerHelp.m
//  AF3.0封装
//
//  Created by syq on 16/2/29.
//  Copyright © 2016年 syq. All rights reserved.
//
#define uploadBaseURLStr @""

#import "AFManegerHelp.h"
#import <AFNetworking.h>

@implementation AFManegerHelp

+(instancetype )shareAFManegerHelp{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


-(void)Get:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObjeck)) success failure:(void (^)(NSError *error)) failure{
    AFHTTPSessionManager *manager = [self AFHTTPSessionManager];
    
    [manager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {//并且code = 正确
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}
-(void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObjeck)) success failure:(void (^)(NSError *error)) failure{
    
    AFHTTPSessionManager *manager = [self AFHTTPSessionManager];
    [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        
    }];
}

//配置AFManager
-(AFHTTPSessionManager *)AFHTTPSessionManager{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
//    [manager.requestSerializer setValue:<#(nullable NSString *)#> forHTTPHeaderField:<#(nonnull NSString *)#>]
    return manager;
}
/**
 *  类方法实现
 */

+(void)Get:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObjeck)) success failure:(void (^)(NSError *error)) failure{
    AFHTTPSessionManager *manager = [self AFHTTPSessionManager];

    [manager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {//并且code = 正确
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];

    
}
//POST请求
+(void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObjeck)) success failure:(void (^)(NSError *error)) failure{
    AFHTTPSessionManager *manager = [self AFHTTPSessionManager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", nil];
    [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        
    }];

    
}
+(AFHTTPSessionManager *)AFHTTPSessionManager{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
//    [manager.requestSerializer setValue:(nullable NSString *) forHTTPHeaderField:<#(nonnull NSString *)#>]

    
    return manager;
}

/**
 *  代理回调实现
 */
-(void)Get:(NSString *)URLString parameters:(id)parameters{
    AFHTTPSessionManager *manager = [self AFHTTPSessionManager];
    
    [manager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(aFManegerHelp:successResponseObject:)]) {//并且code = 正确
            [self.delegate aFManegerHelp:self successResponseObject:responseObject];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(aFManegerHelp:error:)]) {
            [self.delegate aFManegerHelp:self error:error];
        }
    }];

}
//图片上传接口实现
+(void)asyncUploadFileWithData:(NSData *)fileData name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType parameters:(id)parameters success:(SuccessUploadImageBlock)success failture:(FailtureUploadImageBlock)failture{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    
    [manager POST:uploadBaseURLStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //fileName:上传图片名称 fileName.jpg
        /*
        fileName 类型对应下面 mimeType
         
         //例如：png格式对应--	image/png

         */
        
        
        //mimeType:格式 image/jpeg
        [formData appendPartWithFileData:fileData name:name fileName:fileName mimeType:mimeType];
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"---%llu---%llu",uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.localizedDescription);
        if (failture) {
            failture(error);
        }
    }];
}


#pragma mark - MBHUD
+ (void)Hud:(NSString *)showText Delay:(NSTimeInterval)delay{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *HUD = [[MBProgressHUD alloc] init];
    HUD.animationType = MBProgressHUDAnimationZoomOut;
    [window addSubview:HUD];
    HUD.mode = MBProgressHUDModeText;
    HUD.labelText = showText;
    [HUD show:YES];
    [HUD hide:YES afterDelay:delay];
}


/**
 *  判断是不是好友
 */
+(BOOL)isYourFriendsWith:(NSString *)otherid {
    
    EMError *error = nil;
    NSArray *userlist = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
    
    if (!error) {
        NSLog(@"获取成功 -- %@",userlist);
        for (NSString *string in userlist) {
            NSLog(@"%@~~~~%@", string, otherid);
            if ([string isEqualToString:otherid]) {
                
                NSLog(@"-----是好友");
                return YES;
                break;
                
            } else {
                NSLog(@"bushihaoyou");
            }
        }
    }else {
        NSLog(@"获取好友列表失败");
        return NO;
    }
    
    return NO;
    
}

+ (void)getUserMessage {
    
    NSString *token = [UserInfo getAccessToken];
    
    if ([Utils isBlankString:token]) {
        NSLog(@"用户已登出");
        
    } else {
        
        NSString *urlS = [NSString stringWithFormat:@"%@api/IM/GetCustomerInfoByID", Server_Int_Url];
        NSString *dataS = [NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@ZICBDYCID=%@", kPrefixPara, kDevIdentity, kDevSysInfo, kDevTypeInfo, kIMEI,[EMClient sharedClient].currentUsername, nil];
        NSString *dataEncrpyt = [TWDes encryptWithContent:dataS type:kDesType key:kDesKey];
        NSDictionary *paraDic = @{kToken:token, kDatas:dataEncrpyt};
        
        [self POST:urlS parameters:paraDic success:^(id responseObjeck) {
            
            NSLog(@"AFMangerHelp - GetCustomerInfoByID - %@", responseObjeck);
            if ([responseObjeck[@"Success"] integerValue] == 1) {
                
                NSArray *array = responseObjeck[@"JsonData"];
                for (NSDictionary *d in array) {
                    ((AppDelegate *)[UIApplication sharedApplication].delegate).myname =  d[@"CustomerName"];
                    ((AppDelegate *)[UIApplication sharedApplication].delegate).imageurl =  d[@"UserPic"];
                }
                
            } else {
                [self Hud:responseObjeck[@"Msg"] Delay:1];
            }
            
            
        } failure:^(NSError *error) {
            NSLog(@"%@", error.description);
        }];
    }
    
    
}




@end
