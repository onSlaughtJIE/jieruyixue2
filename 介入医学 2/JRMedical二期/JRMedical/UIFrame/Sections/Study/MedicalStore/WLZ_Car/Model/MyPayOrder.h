//
//  MyPayOrder.h
//  JRMedical
//
//  Created by apple on 16/7/9.
//  Copyright © 2016年 ZC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyPayOrder : NSObject

@property(nonatomic, copy) NSString * partner;
@property(nonatomic, copy) NSString * seller;
@property(nonatomic, copy) NSString * tradeNO;
@property(nonatomic,strong)NSString * privateKey;
@property(nonatomic,strong)NSString * totalMoney;
@property(nonatomic,strong)NSString * resultUrl;

@end
