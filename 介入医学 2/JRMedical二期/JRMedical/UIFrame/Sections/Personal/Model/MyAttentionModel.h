//
//  MyAttentionModel.h
//  JRMedical
//
//  Created by a on 16/12/21.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyAttentionModel : NSObject

@property (nonatomic, copy) NSString *FollowID;//关注ID
@property (nonatomic, copy) NSString *CustomerID;//会员ID
@property (nonatomic, copy) NSString *CustomerName;//会员姓名
@property (nonatomic, copy) NSString *HospitalName;//会员隶属医院

@property (nonatomic, copy) NSString *CLevel;//医院等级
@property (nonatomic, copy) NSString *DepartmentName;//会员科室
@property (nonatomic, copy) NSString *PostName;//会员职称
@property (nonatomic, copy) NSString *Pic;//会员头像

// 名院名医
@property (nonatomic, assign) BOOL IsRole; // 认证
@property (nonatomic, copy) NSString *SpecialtyMsg; // 擅长
@property (nonatomic, copy) NSString *Star; // 星级
@property (nonatomic, copy) NSString *DocAndPicPrice; // 服务价格

//评价
@property (nonatomic, copy) NSString *ServiceID;//服务ID
@property (nonatomic, assign) BOOL IsEvaluation;//是否评价

@end
