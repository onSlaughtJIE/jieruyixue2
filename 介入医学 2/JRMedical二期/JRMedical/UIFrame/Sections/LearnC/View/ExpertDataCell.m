//
//  ExpertDataCell.m
//  JRMedical
//
//  Created by a on 16/12/26.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "ExpertDataCell.h"

@implementation ExpertDataCell

- (void)setDataDic:(NSDictionary *)DataDic {
    _DataDic = DataDic;
    
    self.fenShiNum.text = [NSString stringWithFormat:@"%ld",[DataDic[@"FollowCount"] integerValue]];
    self.fuWuNum.text = [NSString stringWithFormat:@"%ld",[DataDic[@"ServiceCount"] integerValue]];
    self.xinYiNum.text = [NSString stringWithFormat:@"%ld",[DataDic[@"HeartCount"] integerValue]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle  = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
