//
//  ExpertXinYiModel.h
//  JRMedical
//
//  Created by a on 16/12/29.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExpertXinYiModel : NSObject

@property (nonatomic, copy) NSString *CustomerPic;//赠送人头像
@property (nonatomic, assign) BOOL IsRole;//是否认证
@property (nonatomic, copy) NSString *CustomerName;//赠送人名称
@property (nonatomic, copy) NSString *UMoney;//赠送U币
@property (nonatomic, copy) NSString *CustomerID;//赠送人ID
@property (nonatomic, copy) NSString *HearInfo;//祝福语
@property (nonatomic, copy) NSString *CTime;//时间
@property (nonatomic, copy) NSString *DeviceInfo;//设备名称

@end
