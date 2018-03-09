//
//  OrderPingJiaCell.m
//  JRMedical
//
//  Created by a on 16/12/23.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "OrderPingJiaCell.h"

@implementation OrderPingJiaCell

- (void)setModel:(OrderPingJiaModel *)model {
    _model = model;
    
    [self.pictureImg sd_setImageWithURL:[NSURL URLWithString:model.CommodityPic] placeholderImage:[UIImage imageNamed:@"jiazai"]];
    self.titleLab.text = model.CommodityName;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.pingJiaoBtn.userInteractionEnabled = YES;
    self.pingJiaoBtn.layer.borderColor = Main_Color.CGColor;
    self.pingJiaoBtn.layer.borderWidth = 0.7;
    self.pingJiaoBtn.clipsToBounds = YES;
    self.pingJiaoBtn.layer.cornerRadius = 5;
    [self.pingJiaoBtn setTitleColor:Main_Color forState:UIControlStateNormal];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
