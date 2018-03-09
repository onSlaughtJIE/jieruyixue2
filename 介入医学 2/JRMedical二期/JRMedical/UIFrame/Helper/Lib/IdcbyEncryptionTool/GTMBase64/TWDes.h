//
//  TWDes.h
//  封装DES
//
//  Created by apple on 16/3/9.
//  Copyright © 2016年 河南智巢有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTMBase64.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCrypto.h>
@interface TWDes : NSObject
/* *
 * DES加密
 * 传入一个集合，出来的就是拼接加密后的字符串
 * */
+ (NSString*)encryptWithContent:(NSString*)content type:(CCOperation)type key:(NSString*)aKey;

/* *
 * 获取设备型号
 * */
+ (NSString *)deviceVersion;

@end
