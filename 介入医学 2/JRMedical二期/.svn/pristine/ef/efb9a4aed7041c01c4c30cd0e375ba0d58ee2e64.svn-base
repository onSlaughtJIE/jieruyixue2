//
//  VideoCommentListCell.m
//  JRMedical
//
//  Created by a on 16/11/17.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "VideoCommentListCell.h"

@implementation VideoCommentListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = BG_Color;
        
        [self initCellView];
    }
    return self;
}

- (void)setModel:(SpCommentModel *)model {
    _model = model;
    
    [self.photoImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.CustomerPic]] placeholder:[UIImage imageNamed:@"mtou"]];
    self.nameLab.text = model.CustomerName;
    self.timeLab.text = model.Time;
    self.contentLab.text = model.ResourcesContent;
    
    CGRect contentHeight = [Utils getTextRectWithString:self.contentLab.text withWidth:Width_Screen-80 withFontSize:14.5];
    self.contentLab.sd_layout.leftSpaceToView(self.photoImg,10).rightSpaceToView(self.contentView,10).topSpaceToView(self.timeLab,5).heightIs(contentHeight.size.height);
}

#pragma mark - 初始化视图
- (void)initCellView {
    
    [self.contentView addSubview:self.photoImg];
    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.timeLab];
    [self.contentView addSubview:self.contentLab];

    self.photoImg.sd_layout.leftSpaceToView(self.contentView,10).topSpaceToView(self.contentView,10).heightIs(50).widthIs(50);
    self.nameLab.sd_layout.leftSpaceToView(self.photoImg,10).topSpaceToView(self.contentView,10).widthIs(150).heightIs(14);

    self.timeLab.sd_layout.leftSpaceToView(self.nameLab,10).bottomEqualToView(self.nameLab).heightIs(12).rightSpaceToView(self.contentView,10);
}

#pragma mark - 懒加载
- (UIImageView *)photoImg {
    if (!_photoImg) {
        _photoImg = [UIImageView new];
        _photoImg.backgroundColor = [UIColor whiteColor];
        _photoImg.image = [UIImage imageNamed:@"mtou"];
        _photoImg.clipsToBounds = YES;
        _photoImg.contentMode = UIViewContentModeScaleAspectFill;
        _photoImg.layer.cornerRadius = 25;
    }
    return _photoImg;
}
- (UILabel *)nameLab {
    if (!_nameLab) {
        _nameLab = [UILabel new];
        _nameLab.textColor = RGB(90, 90, 90);
        _nameLab.font = [UIFont systemFontOfSize:14];
    }
    return _nameLab;
}
- (UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [UILabel new];
        _timeLab.textColor = HuiText_Color;
        _timeLab.font = [UIFont systemFontOfSize:12];
        _timeLab.textAlignment = NSTextAlignmentRight;
    }
    return _timeLab;
}
- (UILabel *)contentLab {
    if (!_contentLab) {
        _contentLab = [UILabel new];
        _contentLab.textColor = RGB(90, 90, 90);
        _contentLab.font = [UIFont systemFontOfSize:14];
        _contentLab.numberOfLines = 0;
    }
    return _contentLab;
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
