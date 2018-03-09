//
//  MyAddressModel.h
//  JRMedical
//
//  Created by a on 16/12/16.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyAddressModel : NSObject

@property (nonatomic, copy) NSString *ID;//主键ID
@property (nonatomic, copy) NSString *DetailAddress;//详细地址
@property (nonatomic, copy) NSString *ConsigneeName;//收货人姓名
@property (nonatomic, copy) NSString *Consigneephone;//收货人电话
@property (nonatomic, copy) NSString *OrderIndex;//排序

@property (nonatomic, copy) NSString *Province;//省
@property (nonatomic, copy) NSString *City;//市
@property (nonatomic, copy) NSString *County;//区

@property (nonatomic, assign) BOOL IsDefault;//是否默认1是0否

@end
