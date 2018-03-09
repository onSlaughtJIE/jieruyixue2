//
//  DetailGoodUBNameCell.m
//  JRMedical
//
//  Created by a on 16/12/23.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "DetailGoodUBNameCell.h"

@implementation DetailGoodUBNameCell

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    self.titleLab.text = dataDic[@"Name"];
    
    NSInteger ubNum = [dataDic[@"UPrice"] integerValue];
    
    self.ubLab.text = [NSString stringWithFormat:@"%ld币",(long)ubNum];
    
    NSInteger isCollection = [dataDic[@"IsCollection"] integerValue];
    if (isCollection == 0) {
        [self.shouChangBtn setImage:[UIImage imageNamed:@"shoucang_gray"] forState:UIControlStateNormal];
        self.shouChangLab.textColor = [UIColor lightGrayColor];
    }
    else {
        [self.shouChangBtn setImage:[UIImage imageNamed:@"shoucangz"] forState:UIControlStateNormal];
        self.shouChangLab.textColor = RGB(230, 79, 70);;
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
