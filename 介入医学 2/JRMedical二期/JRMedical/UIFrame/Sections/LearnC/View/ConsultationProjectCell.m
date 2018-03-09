//
//  ConsultationProjectCell.m
//  JRMedical
//
//  Created by a on 16/12/26.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "ConsultationProjectCell.h"

@implementation ConsultationProjectCell

- (void)setDataDic:(NSDictionary *)DataDic {
    _DataDic = DataDic;

    self.tuWenPrice.text = [NSString stringWithFormat:@"¥%.2f/次",[DataDic[@"DocAndPicPrice"] floatValue]];
    self.phonePrice.text = [NSString stringWithFormat:@"¥%.2f/次",[DataDic[@"DocAndPicPrice"] floatValue]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle  = UITableViewCellSelectionStyleNone;
    self.tuWenView.userInteractionEnabled = YES;
    self.PhoneView.userInteractionEnabled = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
