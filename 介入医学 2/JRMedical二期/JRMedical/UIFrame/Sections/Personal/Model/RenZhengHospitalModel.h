//
//  RenZhengHospitalModel.h
//  JRMedical
//
//  Created by apple on 16/6/14.
//  Copyright © 2016年 ZC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RenZhengHospitalModel : NSObject

@property (nonatomic, copy) NSString *ID; // 医院ID主键，在获取医院详情时需要向后台传递此参数

@property (nonatomic, copy) NSString *Address; // 医院地址

@property (nonatomic, copy) NSString *Name; // 医院名称

@property (nonatomic, copy) NSString *CLevel; // 医生等级

@property (nonatomic, assign) NSInteger OrderIndex; // 医院排序号,无需处理

@property (nonatomic, copy) NSString *Pic; // 医院简介图片

@end
