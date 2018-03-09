//
//  StandardGuideCell.m
//  JRMedical
//
//  Created by a on 16/11/15.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "StandardGuideCell.h"

@implementation StandardGuideCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initCellView];
    }
    return self;
}

- (void)setModel:(PublicNewsListModel *)model {
    _model = model;
    
    self.titleLab.text = model.BiaoTi;
    self.sourceLab.text = model.LaiYuan;
    self.timeLab.text = model.FaBiaoShiJian;
    [self.pictureImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.TuPian]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
    
    //收藏条数
    if (model.ShouCangJiLu < 1000) {
        self.collectionNumLab.text = [NSString stringWithFormat:@"%.0f收藏",model.ShouCangJiLu];
    }
    else if (model.ShouCangJiLu >= 10000){
        self.collectionNumLab.text = [NSString stringWithFormat:@"%.1f万收藏",model.ShouCangJiLu/10000];
    }
    else {
        self.collectionNumLab.text = [NSString stringWithFormat:@"%.1f千收藏",model.ShouCangJiLu/1000];
    }
    
    CGSize sourceWidth = [Utils sizeForTitle:self.sourceLab.text withFont:[UIFont systemFontOfSize:10]];
    if (sourceWidth.width > 105) {
        sourceWidth.width = 105;
    }
    self.sourceLab.sd_layout.bottomSpaceToView(self.contentView,15).leftSpaceToView(self.pictureImg,10).heightIs(13).widthIs(sourceWidth.width);
    CGSize collectionWidth = [Utils sizeForTitle:self.collectionNumLab.text withFont:[UIFont systemFontOfSize:10]];
    self.collectionNumLab.sd_layout.bottomSpaceToView(self.contentView,15).leftSpaceToView(self.sourceLab,5).heightIs(13).widthIs(collectionWidth.width);
    self.timeLab.sd_layout.bottomSpaceToView(self.contentView,15).leftSpaceToView(self.collectionNumLab,5).heightIs(13).rightSpaceToView(self.contentView,5);
    
    //self.authorLab.text = @"胡红耀";
    //self.authorLab.sd_layout.bottomSpaceToView(self.contentView,15).leftSpaceToView(self.sourceLab,5).heightIs(13).widthIs(self.authorLab.text.length*10.5);
}

#pragma mark - 初始化视图
- (void)initCellView {
    
    [self.contentView addSubview:self.pictureImg];
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.sourceLab];
    //    [self.contentView addSubview:self.authorLab];
    [self.contentView addSubview:self.collectionNumLab];
    [self.contentView addSubview:self.timeLab];
    
    self.pictureImg.sd_layout.centerYEqualToView(self.contentView).leftSpaceToView(self.contentView,10).widthIs(105).heightIs(76);
    
    self.titleLab.sd_layout.topSpaceToView(self.contentView,15).leftSpaceToView(self.pictureImg,10).rightSpaceToView(self.contentView,10).heightIs(40);
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
- (UILabel *)sourceLab {
    if (!_sourceLab) {
        _sourceLab = [UILabel new];
        _sourceLab.font = [UIFont systemFontOfSize:10];
        _sourceLab.textColor = HuiText_Color;
    }
    return _sourceLab;
}
//- (UILabel *)authorLab {
//    if (!_authorLab) {
//        _authorLab = [UILabel new];
//        _authorLab.font = [UIFont systemFontOfSize:10];
//        _authorLab.textColor = HuiText_Color;
//    }
//    return _authorLab;
//}
- (UILabel *)collectionNumLab {
    if (!_collectionNumLab) {
        _collectionNumLab = [UILabel new];
        _collectionNumLab.font = [UIFont systemFontOfSize:10];
        _collectionNumLab.textColor = HuiText_Color;
    }
    return _collectionNumLab;
}
- (UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [UILabel new];
        _timeLab.font = [UIFont systemFontOfSize:10];
        _timeLab.textColor = HuiText_Color;
    }
    return _timeLab;
}


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
