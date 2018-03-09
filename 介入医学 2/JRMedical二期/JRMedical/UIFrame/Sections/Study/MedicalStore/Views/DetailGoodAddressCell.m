//
//  DetailGoodAddressCell.m
//  JRMedical
//
//  Created by ww on 2016/11/21.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "DetailGoodAddressCell.h"

@implementation DetailGoodAddressCell

- (void)setDetailStr:(NSString *)detailStr {
    _detailStr = detailStr;
    self.addressLab.text = _detailStr;
    self.addressLab.textColor = [UIColor blackColor];
    self.addressLab.textAlignment = NSTextAlignmentLeft;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.bianJiBtn.userInteractionEnabled = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
