//
//  MessageSignInModel.h
//  JRMedical
//
//  Created by a on 16/12/21.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageSignInModel : NSObject

@property (nonatomic, copy) NSString *ID;//ID
@property (nonatomic, copy) NSString *RTypeName;//类型
@property (nonatomic, copy) NSString *UMoney;//U币数量
@property (nonatomic, copy) NSString *HappenTime;//打卡时间

@end
