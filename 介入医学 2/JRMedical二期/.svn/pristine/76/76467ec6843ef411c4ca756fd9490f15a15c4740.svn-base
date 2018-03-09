//
//  EquipmentSuppliesCell.m
//  JRMedical
//
//  Created by a on 16/11/15.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "EquipmentSuppliesCell.h"

@implementation EquipmentSuppliesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initCellView];
    }
    return self;
}

- (void)setModel:(EquipmentSuppliesListModel *)model {
    _model = model;
    
    self.titleLab.text = model.CompanyName;
    self.contentLab.text = model.Describe;
    [self.pictureImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.Pic]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
}

#pragma mark - 初始化视图
- (void)initCellView {
    
    [self.contentView addSubview:self.pictureImg];
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.contentLab];
    
    self.pictureImg.sd_layout.centerYEqualToView(self.contentView).leftSpaceToView(self.contentView,10).widthIs(105).heightIs(76);
    
    self.titleLab.sd_layout.topSpaceToView(self.contentView,15).leftSpaceToView(self.pictureImg,10).rightSpaceToView(self.contentView,10).heightIs(40);

    self.contentLab.sd_layout.topSpaceToView(self.titleLab,0).bottomSpaceToView(self.contentView,15).leftSpaceToView(self.pictureImg,10).rightSpaceToView(self.contentView,10);
}

#pragma mark - 懒加载
- (UIImageView *)pictureImg {
    if (!_pictureImg) {
        _pictureImg = [UIImageView new];
        _pictureImg.backgroundColor = [UIColor whiteColor];
        _pictureImg.layer.cornerRadius = 5;
        _pictureImg.layer.shadowRadius = 2;
        _pictureImg.layer.shadowOpacity = 0.4;
        _pictureImg.layer.shadowOffset = CGSizeMake(1, 1);
    }
    return _pictureImg;
}
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont systemFontOfSize:16];
        _titleLab.numberOfLines = 0;
    }
    return _titleLab;
}
- (UILabel *)contentLab {
    if (!_contentLab) {
        _contentLab = [UILabel new];
        _contentLab.font = [UIFont systemFontOfSize:12];
        _contentLab.numberOfLines = 0;
        _contentLab.textColor = HuiText_Color;
    }
    return _contentLab;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


@end
