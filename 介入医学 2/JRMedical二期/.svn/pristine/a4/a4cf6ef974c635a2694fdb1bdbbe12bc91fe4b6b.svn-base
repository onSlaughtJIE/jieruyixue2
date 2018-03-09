//
//  OrderUBCell.m
//  JRMedical
//
//  Created by a on 16/12/23.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "OrderUBCell.h"

@implementation OrderUBCell

- (void)setOrderDic:(NSDictionary *)orderDic {
    _orderDic = orderDic;
    
    [self.picImg sd_setImageWithURL:[NSURL URLWithString:orderDic[@"CommodityPic1"]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
    self.titleLab.text = orderDic[@"CommodityName"];
    
    self.ubLab.text = [NSString stringWithFormat:@"%ld",[orderDic[@"UPrice"] integerValue]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
