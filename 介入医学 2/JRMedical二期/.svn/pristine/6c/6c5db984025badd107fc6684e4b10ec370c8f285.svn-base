//
//  VideoMajorCell.m
//  JRMedical
//
//  Created by a on 16/11/16.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "VideoMajorCell.h"

@implementation VideoMajorCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self initCellView];//初始化视图
    }
    return self;
}

- (void)setModel:(PublicNewsListModel *)model {
    _model = model;

    [self.pictureImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.TuPian]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
    self.authorLab.text = [NSString stringWithFormat:@"  %@  %@",model.VideoDoctor,model.VideoPost];
    self.titleLab.text = model.BiaoTi;
    self.sourceLab.text = model.VideoHos;
    
    //播放数
    if (model.LiuLanJiLu < 1000) {
        self.playNumLab.text = [NSString stringWithFormat:@"%.0f次",model.LiuLanJiLu];
    }
    else if (model.LiuLanJiLu >= 10000){
        self.playNumLab.text = [NSString stringWithFormat:@"%.1f万次",model.LiuLanJiLu/10000];
    }
    else {
        self.playNumLab.text = [NSString stringWithFormat:@"%.1f千次",model.LiuLanJiLu/1000];
    }
    
    CGSize playNumLabWidth = [Utils sizeForTitle:self.playNumLab.text withFont:[UIFont systemFontOfSize:10.5]];//播放数量lab宽度
    self.playNumLab.sd_layout.topSpaceToView(self.titleLab,5).rightSpaceToView(self.contentView,10).widthIs(playNumLabWidth.width).heightIs(12);
    self.playNumImg.sd_layout.topSpaceToView(self.titleLab,5).rightSpaceToView(self.playNumLab,2).widthIs(12).heightIs(12);
    self.sourceLab.sd_layout.topSpaceToView(self.titleLab,5).leftSpaceToView(self.contentView,10).rightSpaceToView(self.playNumImg,5).heightIs(11);
}

#pragma mark - 初始化视图
- (void)initCellView {
    
    [self.contentView addSubview:self.pictureImg];
    [self.pictureImg addSubview:self.authorLab];
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.playNumLab];
    [self.contentView addSubview:self.playNumImg];
    [self.contentView addSubview:self.sourceLab];
    
    self.pictureImg.sd_layout.leftSpaceToView(self.contentView,10).rightSpaceToView(self.contentView,10).topSpaceToView(self.contentView,10).heightIs((((Width_Screen-15)/2)-20)/16*9+10);
    self.authorLab.sd_layout.leftEqualToView(self.pictureImg).rightEqualToView(self.pictureImg).bottomSpaceToView(self.pictureImg,0).heightIs(26);
    self.titleLab.sd_layout.topSpaceToView(self.pictureImg,5).leftSpaceToView(self.contentView,10).rightSpaceToView(self.contentView,10).heightIs(35);
}

#pragma mark - 懒加载
- (UIImageView *)pictureImg {
    if (!_pictureImg) {
        _pictureImg = [UIImageView new];
        _pictureImg.clipsToBounds = YES;
        _pictureImg.contentMode = UIViewContentModeScaleAspectFill;
        _pictureImg.backgroundColor = RGB(100, 100, 100);
    }
    return _pictureImg;
}
- (UILabel *)authorLab {
    if (!_authorLab) {
        _authorLab = [UILabel new];
        _authorLab.textColor = [UIColor whiteColor];
        _authorLab.backgroundColor = RGBA(0, 0, 0,0.5);
        _authorLab.font = [UIFont systemFontOfSize:12];
    }
    return _authorLab;
}
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont systemFontOfSize:14];
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
- (UIImageView *)playNumImg {
    if (!_playNumImg) {
        _playNumImg = [UIImageView new];
        _playNumImg.image = [UIImage imageNamed:@"bofangs"];
    }
    return _playNumImg;
}
- (UILabel *)playNumLab {
    if (!_playNumLab) {
        _playNumLab = [UILabel new];
        _playNumLab.font = [UIFont systemFontOfSize:10];
        _playNumLab.textColor = Main_Color;
    }
    return _playNumLab;
}

@end
