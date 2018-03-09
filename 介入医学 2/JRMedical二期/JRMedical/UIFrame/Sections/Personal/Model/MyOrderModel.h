//
//  MyOrderModel.h
//  JRMedical
//
//  Created by a on 16/12/22.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyOrderModel : NSObject

@property (nonatomic, copy) NSString *OrderID;//主键ID
@property (nonatomic, copy) NSString *PayUAmount;//UB
@property (nonatomic, copy) NSString *OrderNO;//订单号
@property (nonatomic, copy) NSString *PayMoneyAmount;//支付金额
@property (nonatomic, copy) NSString *OrderState;//订单状态
@property (nonatomic, copy) NSString *OrderTime;//订单时间

@property (nonatomic, strong) NSArray *LstOrderDetail;//订单详情

@property (nonatomic, copy) NSString *ExpressUrl;//物流H5

@end
