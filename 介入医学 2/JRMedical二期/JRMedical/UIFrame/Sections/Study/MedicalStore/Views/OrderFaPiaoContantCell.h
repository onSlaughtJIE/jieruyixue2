//
//  OrderFaPiaoContantCell.h
//  JRMedical
//
//  Created by a on 16/12/19.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMButton.h"

@protocol OrderFaPiaoContantCellDelegate <NSObject>

- (void)selectFoPiaoContantClick:(NSString *)invoiceDetail;

@end

@interface OrderFaPiaoContantCell : UITableViewCell

@property (nonatomic, assign) id<OrderFaPiaoContantCellDelegate> delegate;

@property (nonatomic, strong) NSArray *dataAry;

@property (nonatomic, strong) UILabel *typeLab;
@property (nonatomic, strong) UIView *orderFaPiaoView;
@property (nonatomic, strong) UIView *contantView;

@end
