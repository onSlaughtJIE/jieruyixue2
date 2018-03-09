//
//  DetailGoodNameCell.m
//  JRMedical
//
//  Created by ww on 2016/11/21.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "DetailGoodNameCell.h"

@implementation DetailGoodNameCell

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    self.titleLab.text = dataDic[@"Name"];
    self.priceLab.text = [NSString stringWithFormat:@"¥%.2f",[dataDic[@"PromotionPrice"] floatValue]];//促销价格
    
    NSString *oldStr = [NSString stringWithFormat:@"¥%.2f",[dataDic[@"MoneyPrice"] floatValue]];//原价
    NSDictionary *attribtDic =@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString:oldStr attributes:attribtDic];
    self.oldPriceLab.attributedText = attribtStr;
    
    NSInteger isCollection = [dataDic[@"IsCollection"] integerValue];
    if (isCollection == 0) {
        [self.shouChangBtn setImage:[UIImage imageNamed:@"shoucang_gray"] forState:UIControlStateNormal];
        self.shouChangLab.textColor = [UIColor lightGrayColor];
    }
    else {
        [self.shouChangBtn setImage:[UIImage imageNamed:@"shoucangz"] forState:UIControlStateNormal];
        self.shouChangLab.textColor = RGB(230, 79, 70);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.shouChangBtn.userInteractionEnabled = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
