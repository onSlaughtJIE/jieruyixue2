//
//  CaseLibraryCell.m
//  JRMedical
//
//  Created by a on 16/11/14.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "CaseLibraryCell.h"

@implementation CaseLibraryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initCellView];
    }
    return self;
}

- (void)setModel:(CaseLibraryModel *)model {
    _model = model;
    
    if (model.IsMy == 1) {
        self.seleBtn.hidden = NO;
    }
    else {
        self.seleBtn.hidden = YES;
    }

    [self.pictureImg sd_setImageWithURL:[NSURL URLWithString:model.Image] placeholderImage:[UIImage imageNamed:@"jiazai"]];
    self.titleLab.text = model.CaseTitle;
}

#pragma mark - 初始化视图
- (void)initCellView {
    
    [self.contentView addSubview:self.pictureImg];
    [self.contentView addSubview:self.seleBtn];
    [self.contentView addSubview:self.titleLab];
    
    self.pictureImg.sd_layout.centerYEqualToView(self.contentView).leftSpaceToView(self.contentView,10).widthIs(105).heightIs(76);
    self.seleBtn.sd_layout.centerYEqualToView(self.contentView).rightSpaceToView(self.contentView,10).widthIs(55).heightIs(25);
    self.titleLab.sd_layout.centerYEqualToView(self.contentView).leftSpaceToView(self.pictureImg,10).rightSpaceToView(self.seleBtn,10).heightIs(75);
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
- (UIButton *)seleBtn {
    if (!_seleBtn) {
        _seleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _seleBtn.userInteractionEnabled = YES;
        _seleBtn.layer.borderColor = Main_Color.CGColor;
        _seleBtn.layer.borderWidth = 0.7;
        _seleBtn.clipsToBounds = YES;
        _seleBtn.layer.cornerRadius = 5;
        _seleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_seleBtn setTitleColor:Main_Color forState:UIControlStateNormal];
        [_seleBtn setTitle:@"删除" forState:UIControlStateNormal];
        _seleBtn.hidden = YES;
    }
    return _seleBtn;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
