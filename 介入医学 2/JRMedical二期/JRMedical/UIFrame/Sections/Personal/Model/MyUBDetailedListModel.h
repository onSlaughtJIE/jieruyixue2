//
//  MyUBDetailedListModel.h
//  JRMedical
//
//  Created by a on 16/12/20.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyUBDetailedListModel : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *RTypeName;//消费类型
@property (nonatomic, copy) NSString *UMoney;//支付U币
@property (nonatomic, copy) NSString *HappenTime;//消费时间

@end
