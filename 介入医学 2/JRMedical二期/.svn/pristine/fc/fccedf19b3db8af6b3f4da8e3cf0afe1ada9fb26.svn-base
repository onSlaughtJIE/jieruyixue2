//
//  MyOrderCell.m
//  JRMedical
//
//  Created by a on 16/12/22.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "MyOrderCell.h"

@implementation MyOrderCell

- (void)setOrderDic:(NSDictionary *)orderDic {
    _orderDic = orderDic;
    
    [self.pictureImg sd_setImageWithURL:[NSURL URLWithString:orderDic[@"CommodityPic1"]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
    self.titleLab.text = orderDic[@"CommodityName"];
    self.curPriceLab.text = [NSString stringWithFormat:@"¥%.2f",[orderDic[@"PromotionPrice"] floatValue]];
    self.numLab.text = [NSString stringWithFormat:@"x%ld",[orderDic[@"Number"] integerValue]];
    
    NSString *oldStr = [NSString stringWithFormat:@"¥%.2f",[orderDic[@"MoneyPrice"] floatValue]];//原价
    NSDictionary *attribtDic =@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString:oldStr attributes:attribtDic];
    self.oldPriceLab.attributedText = attribtStr;
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
