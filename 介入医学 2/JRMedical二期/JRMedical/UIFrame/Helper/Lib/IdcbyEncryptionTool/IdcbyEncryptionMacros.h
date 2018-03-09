//
//  IdcbyEncryptionMacros.h
//  TaiJiQuan
//
//  Created by a on 16/10/31.
//  Copyright © 2016年 夏银军. All rights reserved.
//

#ifndef IdcbyEncryptionMacros_h
#define IdcbyEncryptionMacros_h

/* *
 * 苹果客户端
 * APPID : TJQ0000021
 * AppSecret : tjq0000021idcbycn
 * 需要引入系统库 : UIKit.framework
 * */

/**********   头文件   **********/
#import "TWDes.h" // 加密
#import "sys/utsname.h" // 返回设备型号需引入

/**********   加密参数配置   **********/
#define kDesType kCCEncrypt
#define kDesKey @"idcby001"
#define kDatas @"Datas"
#define kToken @"Token"
#define kPrefixPara @"Version=v1.4.6ZICBDYCAppSecret=uvwxyzxyznyxicxmabcZICBDYCAppId=JRYX000002ZICBDYC" // 调接口时固定参数
#define kDevIdentity (NSString *)[UserInfo getDevIdentity]//单点登录值 --- 根据服务器返回存入本地调用
#define kDevSysInfo [NSString stringWithFormat:@"%.1f",[[[UIDevice currentDevice] systemVersion] floatValue]] // iOS系统信息
#define kDevTypeInfo [TWDes deviceVersion] // 设备型号信息
#define kIMEI [[[UIDevice currentDevice] identifierForVendor] UUIDString] // IMEI

#define kTotalEncryptionInfo(OtherParameter) \
            (NSString *)[NSString stringWithFormat:@"%@DevIdentity=%@ZICBDYCDevSysInfo=%@ZICBDYCDevTypeInfo=%@ZICBDYCIMEI=%@%@", \
                                                                              kPrefixPara, \
                                                                              kDevIdentity, \
                                                                              kDevSysInfo, \
                                                                              kDevTypeInfo, \
                                                                              kIMEI, \
                                                                              OtherParameter, nil]//加密参数汇总 --- 只需要调这个宏文件就可以了




/* *
 * 其他还需要拼接的参数和使用方法
 * NSString *paraStr = kTotalEncryptionInfo("此处填请求时需要参与加密的参数(所有加密参数拼接好的字符串)")
 * NSString *DataEncrypt = [TWDes encryptWithContent:paraStr type:kDesType key:kDesKey];
 * NSDictionary *paraDic = @{kDatas:DataEncrypt, @"Token":USER_TOKEN};
 * */

#endif /* IdcbyEncryptionMacros_h */
