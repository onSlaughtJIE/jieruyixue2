//
//  SCGoodsModel.h
//  JRMedical
//
//  Created by apple on 16/6/18.
//  Copyright © 2016年 ZC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCGoodsModel : NSObject


@property (nonatomic, copy) NSString *ViewUrl;

@property (nonatomic, copy) NSString *Name;

@property (nonatomic, copy) NSString *Pic1;

@property (nonatomic, assign) NSInteger UPrice;

@property (nonatomic, assign) NSInteger CommodityID;

@property (nonatomic, assign) CGFloat PromotionPrice;


@end
