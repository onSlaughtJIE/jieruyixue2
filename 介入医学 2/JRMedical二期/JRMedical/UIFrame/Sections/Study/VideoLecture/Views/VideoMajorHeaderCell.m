//
//  VideoMajorHeaderCell.m
//  JRMedical
//
//  Created by a on 16/11/16.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "VideoMajorHeaderCell.h"

@implementation VideoMajorHeaderCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.typeLab.text = @"最热";
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
    
    CGSize playNumLabWidth = [Utils sizeForTitle:self.playNumLab.text withFont:[UIFont systemFontOfSize:12.5]];//播放数量lab宽度
    self.playNumLab.sd_layout.topSpaceToView(self.titleLab,10).rightSpaceToView(self,10).widthIs(playNumLabWidth.width).heightIs(13);
    self.playNumImg.sd_layout.topSpaceToView(self.titleLab,10).rightSpaceToView(self.playNumLab,3).widthIs(15).heightIs(15);
    self.sourceLab.sd_layout.topSpaceToView(self.titleLab,10).leftSpaceToView(self,10).rightSpaceToView(self.playNumImg,10).heightIs(13);
}

#pragma mark - 初始化视图
- (void)initCellView {
    
    [self addSubview:self.pictureImg];
    [self.pictureImg addSubview:self.typeLab];
    [self.pictureImg addSubview:self.authorLab];
    [self addSubview:self.titleLab];
    [self addSubview:self.playNumLab];
    [self addSubview:self.playNumImg];
    [self addSubview:self.sourceLab];
    
    self.pictureImg.sd_layout.leftSpaceToView(self,10).rightSpaceToView(self,10).topSpaceToView(self,10).heightIs((Width_Screen-20)/16*9);
    self.typeLab.sd_layout.leftEqualToView(self.pictureImg).topEqualToView(self.pictureImg).heightIs(25).widthIs(60);
    self.authorLab.sd_layout.leftEqualToView(self.pictureImg).rightEqualToView(self.pictureImg).bottomSpaceToView(self.pictureImg,0).heightIs(30);
    self.titleLab.sd_layout.topSpaceToView(self.pictureImg,10).leftSpaceToView(self,10).rightSpaceToView(self,10).heightIs(17);
}

#pragma mark - 懒加载
- (UIImageView *)pictureImg {
    if (!_pictureImg) {
        _pictureImg = [UIImageView new];
        _pictureImg.clipsToBounds = YES;
        _pictureImg.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _pictureImg;
}
- (UILabel *)typeLab {
    if (!_typeLab) {
        _typeLab = [UILabel new];
        _typeLab.backgroundColor = Main_Color;
        _typeLab.textAlignment = NSTextAlignmentCenter;
        _typeLab.textColor = [UIColor whiteColor];
        _typeLab.font = [UIFont boldSystemFontOfSize:14];
    }
    return _typeLab;
}
- (UILabel *)authorLab {
    if (!_authorLab) {
        _authorLab = [UILabel new];
        _authorLab.textColor = [UIColor whiteColor];
        _authorLab.backgroundColor = RGBA(0, 0, 0, 0.5);
        _authorLab.font = [UIFont systemFontOfSize:14];
    }
    return _authorLab;
}
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont systemFontOfSize:16];
    }
    return _titleLab;
}
- (UILabel *)sourceLab {
    if (!_sourceLab) {
        _sourceLab = [UILabel new];
        _sourceLab.font = [UIFont systemFontOfSize:12];
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
        _playNumLab.font = [UIFont systemFontOfSize:12];
        _playNumLab.textAlignment = NSTextAlignmentRight;
        _playNumLab.textColor = Main_Color;
    }
    return _playNumLab;
}

@end
