//
//  GoodListTableViewCell.m
//  JRMedical
//
//  Created by ww on 2016/11/16.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "GoodListTableViewCell.h"

@implementation GoodListTableViewCell

- (void)setModel:(MerchandiseListModel *)model {
    _model = model;
    
    [self.pictureImg sd_setImageWithURL:[NSURL URLWithString:model.Pic] placeholderImage:[UIImage imageNamed:@"jiazai"]];
    self.titleLab.text = model.Name;
    self.priceLab.text = [NSString stringWithFormat:@"¥%.2f",model.PromotionPrice];
    
    //评论条数
    if (model.EvaluateCount < 1000) {
        self.pingJiaLab.text = [NSString stringWithFormat:@"%.0f条评价",model.EvaluateCount];
    }
    else if (model.EvaluateCount >= 10000){
        self.pingJiaLab.text = [NSString stringWithFormat:@"%.1f万评价",model.EvaluateCount/10000];
    }
    else {
        self.pingJiaLab.text = [NSString stringWithFormat:@"%.1f千评价",model.EvaluateCount/1000];
    }
    
    //销售条数
    if (model.SaleCount < 1000) {
        self.liuLanLab.text = [NSString stringWithFormat:@"%.0f销售",model.SaleCount];
    }
    else if (model.SaleCount >= 10000){
        self.liuLanLab.text = [NSString stringWithFormat:@"%.1f万销售",model.SaleCount/10000];
    }
    else {
        self.liuLanLab.text = [NSString stringWithFormat:@"%.1f千销售",model.SaleCount/1000];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
