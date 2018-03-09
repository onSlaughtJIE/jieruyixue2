//
//  MedicalExchangeCell.m
//  JRMedical
//
//  Created by a on 16/12/19.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "MedicalExchangeCell.h"

@implementation MedicalExchangeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        [self.contentView addSubview:self.nameLab];
        [self.contentView addSubview:self.plaimage];
        [self.contentView addSubview:self.ubIcon];
        [self.contentView addSubview:self.ubNumLab];
        
        self.plaimage.sd_layout.centerYEqualToView(self.contentView).leftSpaceToView(self.contentView,15).widthIs(80).heightIs(90);
        self.nameLab.sd_layout.topSpaceToView(self.contentView,15).leftSpaceToView(self.plaimage,15).rightSpaceToView(self.contentView,15).heightIs(34);
        self.ubIcon.sd_layout.bottomSpaceToView(self.contentView,15).leftSpaceToView(self.plaimage,15).widthIs(20).heightIs(20);
        self.ubNumLab.sd_layout.bottomSpaceToView(self.contentView,15).leftSpaceToView(self.ubIcon,5).rightSpaceToView(self.contentView,15).heightIs(20);
    }
    return self;
}

- (void)setDataAry:(NSMutableArray *)dataAry {
    _dataAry = dataAry;
    
    NSDictionary *dataDic = dataAry[0];
    
    [self.plaimage sd_setImageWithURL:[NSURL URLWithString:dataDic[@"Pic"]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
    self.nameLab.text = dataDic[@"Name"];
    
    self.nameLab.text = dataDic[@"Name"];
    self.ubNumLab.text = [NSString stringWithFormat:@"%@币",dataDic[@"totalPrice"]];
}

- (UILabel *)nameLab {
    if (!_nameLab) {
        _nameLab = [UILabel new];
        _nameLab.font = [UIFont systemFontOfSize:14];
        _nameLab.numberOfLines = 0;
    }
    return _nameLab;
}
- (UIImageView *)ubIcon {
    if (!_ubIcon) {
        _ubIcon = [UIImageView new];
        _ubIcon.image = [UIImage imageNamed:@"ubi"];
    }
    return _ubIcon;
}
- (UILabel *)ubNumLab {
    if (!_ubNumLab) {
        _ubNumLab = [UILabel new];
        _ubNumLab.font = [UIFont systemFontOfSize:12];
        _ubNumLab.textColor = [UIColor lightGrayColor];
    }
    return _ubNumLab;
}

- (UIImageView *)plaimage {
    if (!_plaimage) {
        _plaimage = [UIImageView new];
        _plaimage.clipsToBounds = YES;
        _plaimage.contentMode = UIViewContentModeScaleAspectFill;
        _plaimage.layer.borderColor = RGB(180, 180, 180).CGColor;
        _plaimage.layer.cornerRadius = 3;
        _plaimage.layer.borderWidth = 0.4;
    }
    return _plaimage;
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
