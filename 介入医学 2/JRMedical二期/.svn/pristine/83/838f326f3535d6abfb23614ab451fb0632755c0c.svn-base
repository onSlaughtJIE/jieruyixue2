//
//  ServiceHistoryCell.m
//  JRMedical
//
//  Created by a on 16/12/26.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "ServiceHistoryCell.h"

@implementation ServiceHistoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
        [self initCellView];
        
        self.photoCornerImg.hidden = YES;
    }
    return self;
}

- (void)setModel:(MyAttentionModel *)model {
    _model = model;
    
    if (model.IsRole) {
        self.photoCornerImg.hidden = NO;
    }
    else {
        self.photoCornerImg.hidden = YES;
    }
    
    if (model.IsEvaluation) {
        self.pingJiaBtn.enabled = NO;
        [self.pingJiaBtn setTitle:@"已评价" forState:UIControlStateNormal];
    }
    else {
        self.pingJiaBtn.enabled = YES;
        [_pingJiaBtn setTitle:@"评价" forState:UIControlStateNormal];
    }
    
    [self.photoImg sd_setImageWithURL:[NSURL URLWithString:model.Pic] placeholderImage:[UIImage imageNamed:@"mtou"]];
    
    self.nameLab.text = model.CustomerName;
    self.levelLab.text = model.PostName;
    self.categoryLab.text = model.DepartmentName;
    self.hospitalNameLab.text = model.HospitalName;
    self.hospitaLevelLab.text = model.CLevel;
    
    CGSize nameWidth = [Utils sizeForTitle:self.nameLab.text withFont:[UIFont boldSystemFontOfSize:16]];
    
    self.nameLab.sd_resetLayout.leftSpaceToView(self.photoImg,10).topSpaceToView(self.contentView,18).heightIs(17).widthIs(nameWidth.width);
    self.levelLab.sd_resetLayout.leftSpaceToView(self.nameLab,5).bottomEqualToView(self.nameLab).heightIs(13).widthIs(self.levelLab.text.length*12.5);
    self.categoryLab.sd_resetLayout.leftSpaceToView(self.levelLab,5).bottomEqualToView(self.nameLab).heightIs(13).widthIs(self.categoryLab.text.length*12.5);
    
    if ([model.CLevel isEqualToString:@""] || model.CLevel == nil) {
        
        self.hospitalNameLab.sd_resetLayout.leftSpaceToView(self.photoImg,10).bottomSpaceToView(self.contentView,18).heightIs(13).rightSpaceToView(self.contentView,10);
        
        self.hospitaLevelView.hidden = YES;
        
    }
    else {
        
        self.hospitaLevelView.hidden = NO;
        
        CGFloat hospitalNameWidth = self.hospitalNameLab.text.length*12.5;
        if (hospitalNameWidth > 125) {
            hospitalNameWidth = 125;
        }
        self.hospitalNameLab.sd_resetLayout.leftSpaceToView(self.photoImg,10).bottomSpaceToView(self.contentView,18).heightIs(13).widthIs(hospitalNameWidth);
        
        CGFloat rightWidth = Width_Screen - (85 + hospitalNameWidth);
        CGFloat hospitaLevelViewWidth = self.hospitaLevelLab.text.length*10.5+12;
        CGFloat rightSpace = rightWidth-hospitaLevelViewWidth;
        if (rightSpace <= 0) {
            rightSpace = 5;
        }
        self.hospitaLevelView.sd_resetLayout.leftSpaceToView(self.hospitalNameLab,5).centerYEqualToView(self.hospitalNameLab).heightIs(16).rightSpaceToView(self.contentView,rightSpace);
        
        self.hospitaLevelLab.sd_resetLayout.centerYEqualToView(self.hospitaLevelView).leftSpaceToView(self.hospitaLevelView,6).rightSpaceToView(self.hospitaLevelView,6).centerXEqualToView(self.hospitaLevelView).heightIs(11);
    }
}

#pragma mark - 初始化视图
- (void)initCellView {
    
    [self.contentView addSubview:self.photoImg];
    [self.contentView addSubview:self.photoCornerImg];
    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.levelLab];
    [self.contentView addSubview:self.categoryLab];
    [self.contentView addSubview:self.hospitalNameLab];
    [self.contentView addSubview:self.hospitaLevelView];
    [self.hospitaLevelView addSubview:self.hospitaLevelLab];
    [self.contentView addSubview:self.pingJiaBtn];
    
    self.photoImg.sd_layout.leftSpaceToView(self.contentView,10).centerYEqualToView(self.contentView).heightIs(60).widthIs(60);
    self.photoCornerImg.sd_layout.bottomEqualToView(self.photoImg).leftSpaceToView(self.photoImg,-16).heightIs(12).widthIs(12);
    self.nameLab.sd_layout.leftSpaceToView(self.photoImg,10).topSpaceToView(self.contentView,18).heightIs(17).widthIs(self.nameLab.text.length*16.5);
    self.levelLab.sd_layout.leftSpaceToView(self.nameLab,5).bottomEqualToView(self.nameLab).heightIs(13).widthIs(self.levelLab.text.length*12.5);
    self.categoryLab.sd_layout.leftSpaceToView(self.levelLab,5).bottomEqualToView(self.nameLab).heightIs(13).widthIs(self.categoryLab.text.length*12.5);
    self.pingJiaBtn.sd_layout.centerYEqualToView(self.contentView).rightSpaceToView(self.contentView,10).widthIs(55).heightIs(25);
    
    CGFloat hospitalNameWidth = self.hospitalNameLab.text.length*12.5;
    if (hospitalNameWidth > 125) {
        hospitalNameWidth = 125;
    }
    self.hospitalNameLab.sd_layout.leftSpaceToView(self.photoImg,10).bottomSpaceToView(self.contentView,18).heightIs(13).widthIs(hospitalNameWidth);
    
    CGFloat rightWidth = Width_Screen - (85 + hospitalNameWidth);
    CGFloat hospitaLevelViewWidth = self.hospitaLevelLab.text.length*10.5+12;
    CGFloat rightSpace = rightWidth-hospitaLevelViewWidth;
    if (rightSpace <= 0) {
        rightSpace = 5;
    }
    self.hospitaLevelView.sd_layout.leftSpaceToView(self.hospitalNameLab,5).centerYEqualToView(self.hospitalNameLab).heightIs(16).rightSpaceToView(self.pingJiaBtn,5);
    
    self.hospitaLevelLab.sd_layout.centerYEqualToView(self.hospitaLevelView).leftSpaceToView(self.hospitaLevelView,6).rightSpaceToView(self.hospitaLevelView,6).centerXEqualToView(self.hospitaLevelView).heightIs(11);
}

#pragma mark - 懒加载
- (UIImageView *)photoImg {
    if (!_photoImg) {
        _photoImg = [UIImageView new];
        _photoImg.backgroundColor = [UIColor whiteColor];
        _photoImg.image = [UIImage imageNamed:@"mtou"];
        _photoImg.clipsToBounds = YES;
        _photoImg.contentMode = UIViewContentModeScaleAspectFill;
        _photoImg.layer.cornerRadius = 30;
    }
    return _photoImg;
}
- (UIImageView *)photoCornerImg {
    if (!_photoCornerImg) {
        _photoCornerImg = [UIImageView new];
        //        _photoCornerImg.backgroundColor = [UIColor whiteColor];
        //        _photoCornerImg.clipsToBounds = YES;
        _photoCornerImg.image = [UIImage imageNamed:@"doctor-ren"];
        //        _photoCornerImg.layer.borderWidth = 0.5;
        //        _photoCornerImg.layer.borderColor = [UIColor whiteColor].CGColor;
        //        _photoCornerImg.layer.cornerRadius = 10;
    }
    return _photoCornerImg;
}
- (UILabel *)nameLab {
    if (!_nameLab) {
        _nameLab = [UILabel new];
        _nameLab.textColor = Main_Color;
        _nameLab.font = [UIFont boldSystemFontOfSize:16];
    }
    return _nameLab;
}
- (UILabel *)levelLab {
    if (!_levelLab) {
        _levelLab = [UILabel new];
        _levelLab.textColor = RGB(0, 149, 135);
        _levelLab.font = [UIFont systemFontOfSize:12];
    }
    return _levelLab;
}
- (UILabel *)categoryLab {
    if (!_categoryLab) {
        _categoryLab = [UILabel new];
        _categoryLab.textColor = RGB(0, 149, 135);
        _categoryLab.font = [UIFont systemFontOfSize:12];
    }
    return _categoryLab;
}
- (UILabel *)hospitalNameLab {
    if (!_hospitalNameLab) {
        _hospitalNameLab = [UILabel new];
        _hospitalNameLab.textColor = [UIColor blackColor];
        _hospitalNameLab.font = [UIFont boldSystemFontOfSize:12];
    }
    return _hospitalNameLab;
}
- (UILabel *)hospitaLevelLab {
    if (!_hospitaLevelLab) {
        _hospitaLevelLab = [UILabel new];
        _hospitaLevelLab.textColor = [UIColor whiteColor];
        _hospitaLevelLab.textAlignment = NSTextAlignmentCenter;
        _hospitaLevelLab.font = [UIFont systemFontOfSize:10];
    }
    return _hospitaLevelLab;
}
- (UIView *)hospitaLevelView {
    if (!_hospitaLevelView) {
        _hospitaLevelView = [UIView new];
        _hospitaLevelView.backgroundColor = Main_Color;
        _hospitaLevelView.clipsToBounds = YES;
        _hospitaLevelView.layer.cornerRadius = 8;
    }
    return _hospitaLevelView;
}
- (UIButton *)pingJiaBtn {
    if (!_pingJiaBtn) {
        _pingJiaBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _pingJiaBtn.userInteractionEnabled = YES;
        _pingJiaBtn.layer.borderColor = Main_Color.CGColor;
        _pingJiaBtn.layer.borderWidth = 0.7;
        _pingJiaBtn.clipsToBounds = YES;
        _pingJiaBtn.layer.cornerRadius = 5;
        _pingJiaBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_pingJiaBtn setTitleColor:Main_Color forState:UIControlStateNormal];
        [_pingJiaBtn setTitle:@"评价" forState:UIControlStateNormal];
    }
    return _pingJiaBtn;
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
