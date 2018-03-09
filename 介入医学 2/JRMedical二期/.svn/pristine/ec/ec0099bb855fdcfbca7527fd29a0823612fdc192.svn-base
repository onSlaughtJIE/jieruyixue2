//
//  VideoSpecialTableCell.m
//  JRMedical
//
//  Created by a on 16/11/17.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "VideoSpecialTableCell.h"

@implementation VideoSpecialTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        [self initCellView];//初始化视图
    }
    return self;
}

- (void)setModel:(VideoSpecialListModel *)model {
    
    NSLog(@"%@",model.Title);
    
    _model = model;
    [self.pictureImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.Img]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
    self.titleLab.text = model.Title;
    self.videoNumLab.text = [NSString stringWithFormat:@"  %@个视频",model.VideoCount];
    
    //播放数
    if (model.VideoBrowseCount < 1000) {
        self.playNumLab.text = [NSString stringWithFormat:@"%.0f次",model.VideoBrowseCount];
    }
    else if (model.VideoBrowseCount >= 10000){
        self.playNumLab.text = [NSString stringWithFormat:@"%.1f万次",model.VideoBrowseCount/10000];
    }
    else {
        self.playNumLab.text = [NSString stringWithFormat:@"%.1f千次",model.VideoBrowseCount/1000];
    }
    
    CGSize playNumLabWidth = [Utils sizeForTitle:self.playNumLab.text withFont:[UIFont systemFontOfSize:12.5]];//播放数量lab宽度
    self.playNumLab.sd_layout.topSpaceToView(self.pictureImg,10).rightSpaceToView(self.contentView,10).widthIs(playNumLabWidth.width).heightIs(13);
    self.playNumImg.sd_layout.topSpaceToView(self.pictureImg,10).rightSpaceToView(self.playNumLab,3).widthIs(15).heightIs(15);
    self.titleLab.sd_layout.topSpaceToView(self.pictureImg,10).leftSpaceToView(self.contentView,10).rightSpaceToView(self.playNumImg,10).heightIs(17);
}

#pragma mark - 初始化视图
- (void)initCellView {
    
    [self.contentView addSubview:self.pictureImg];
//    [self.pictureImg addSubview:self.typeLab];
    [self.pictureImg addSubview:self.videoNumLab];
    [self.contentView addSubview:self.titleLab];
//    [self addSubview:self.sourceLab];
//    [self addSubview:self.authorLab];
//    [self addSubview:self.levelLab];
    [self.contentView addSubview:self.playNumLab];
    [self.contentView addSubview:self.playNumImg];
    
    self.pictureImg.sd_layout.leftSpaceToView(self.contentView,10).rightSpaceToView(self.contentView,10).topSpaceToView(self.contentView,10).heightIs((Width_Screen-20)/16*9);
//    self.typeLab.sd_layout.leftEqualToView(self.pictureImg).topEqualToView(self.pictureImg).heightIs(25).widthIs(60);
    self.videoNumLab.sd_layout.leftEqualToView(self.pictureImg).rightEqualToView(self.pictureImg).bottomSpaceToView(self.pictureImg,0).heightIs(30);
//
//    CGFloat rightWidth = playNumLabWidth.width + 18;
//    
//    CGFloat authorLabWidth = self.authorLab.text.length*12.5 + 10;
//    
//    CGFloat levelLabWidth = self.levelLab.text.length*12.5 + 5;
//    
//    CGFloat totalWidth = rightWidth + authorLabWidth + levelLabWidth +10;
//    
//    CGFloat sourceLabWidth = Width_Screen - totalWidth - 20;//医院lab宽度
//    
//    CGFloat sourceLabWidth2 = self.sourceLab.text.length*12.5;//医院lab实际宽度
//    
//    if (sourceLabWidth > sourceLabWidth2) {
//        sourceLabWidth = sourceLabWidth2;
//    }
//    
//    self.sourceLab.sd_layout.topSpaceToView(self.titleLab,10).leftSpaceToView(self,10).widthIs(sourceLabWidth).heightIs(13);
//    self.authorLab.sd_layout.topSpaceToView(self.titleLab,10).leftSpaceToView(self.sourceLab,10).widthIs(self.authorLab.text.length*12.5).heightIs(13);
//    self.levelLab.sd_layout.topSpaceToView(self.titleLab,10).leftSpaceToView(self.authorLab,5).widthIs(self.levelLab.text.length*12.5).heightIs(13);
    
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
//- (UILabel *)typeLab {
//    if (!_typeLab) {
//        _typeLab = [UILabel new];
//        _typeLab.backgroundColor = Main_Color;
//        _typeLab.textAlignment = NSTextAlignmentCenter;
//        _typeLab.textColor = [UIColor whiteColor];
//        _typeLab.font = [UIFont boldSystemFontOfSize:14];
//    }
//    return _typeLab;
//}
- (UILabel *)videoNumLab {
    if (!_videoNumLab) {
        _videoNumLab = [UILabel new];
        _videoNumLab.textColor = [UIColor whiteColor];
        _videoNumLab.backgroundColor = RGBA(0, 0, 0, 0.5);
        _videoNumLab.font = [UIFont systemFontOfSize:14];
    }
    return _videoNumLab;
}
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont systemFontOfSize:16];
    }
    return _titleLab;
}
//- (UILabel *)sourceLab {
//    if (!_sourceLab) {
//        _sourceLab = [UILabel new];
//        _sourceLab.font = [UIFont systemFontOfSize:12];
//        _sourceLab.textColor = HuiText_Color;
//    }
//    return _sourceLab;
//}
//- (UILabel *)authorLab {
//    if (!_authorLab) {
//        _authorLab = [UILabel new];
//        _authorLab.font = [UIFont systemFontOfSize:12];
//        _authorLab.textColor = HuiText_Color;
//    }
//    return _authorLab;
//}
//- (UILabel *)levelLab {
//    if (!_levelLab) {
//        _levelLab = [UILabel new];
//        _levelLab.font = [UIFont systemFontOfSize:12];
//        _levelLab.textColor = HuiText_Color;
//    }
//    return _levelLab;
//}
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
