//
//  ChooseAddressTableViewCell.m
//  HongJHome
//
//  Created by 曹柏涵 on 15/8/26.
//  Copyright (c) 2015年 yizhisheng. All rights reserved.
//

#import "ChooseAddressTableViewCell.h"

@implementation ChooseAddressTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    self.backgroundColor = RGB(239, 240, 242);
    _backGroudImage.layer.masksToBounds = YES;
    _backGroudImage.layer.cornerRadius = 6.0f;
    _deleteBtn.layer.masksToBounds = YES;
    _deleteBtn.layer.cornerRadius = 6.0f;
    _changeAddressBtn.layer.masksToBounds = YES;
    _changeAddressBtn.layer.cornerRadius = 6.0f;
    _backGroudImage.layer.cornerRadius = 7;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
