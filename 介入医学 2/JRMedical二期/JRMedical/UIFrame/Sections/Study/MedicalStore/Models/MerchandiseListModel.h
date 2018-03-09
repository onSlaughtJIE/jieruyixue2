//
//  MerchandiseListModel.h
//  JRMedical
//
//  Created by a on 16/12/2.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MerchandiseListModel : NSObject

@property (nonatomic, copy) NSString *CommodityID;//商品id
@property (nonatomic, copy) NSString *ExchangeID;//兑换id
@property (nonatomic, copy) NSString *Name;//名称
@property (nonatomic, copy) NSString *Pic;//图片

@property (nonatomic, assign) CGFloat EvaluateCount;//评价数量
@property (nonatomic, assign) CGFloat SaleCount;//销售数量

@property (nonatomic, assign) CGFloat MoneyPrice;//原价
@property (nonatomic, assign) CGFloat PromotionPrice;//优惠价
@property (nonatomic, assign) NSInteger UPrice;//U币价格

@end
