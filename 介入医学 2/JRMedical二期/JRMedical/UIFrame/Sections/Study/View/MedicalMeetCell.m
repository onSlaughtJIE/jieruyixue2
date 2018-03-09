//
//  MedicalMeetCell.m
//  JRMedical
//
//  Created by a on 16/11/15.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "MedicalMeetCell.h"

@implementation MedicalMeetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
        self.backgroundColor  = BG_Color;
        [self initCellView];
    }
    return self;
}

- (void)setModel:(PublicNewsListModel *)model {
    _model = model;

    NSString *timeStr  = [Utils formatTimeStamp:@"dd" withTime:model.TimeStamp];//日
    NSString *firstStr = [timeStr substringWithRange:NSMakeRange(0, 1)];
    NSString *timeStr2 = nil;
    if ([firstStr isEqualToString:@"0"]) {
        timeStr2 = [timeStr substringWithRange:NSMakeRange(1, 1)];
    }
    else {
        timeStr2 = timeStr;
    }
    self.dayLab.text = timeStr2;
    
    self.titleLab.text = model.BiaoTi;
    self.timeLab.text = [NSString stringWithFormat:@"%@-%@",model.KaiShiShiJian,model.JieShuShiJian];
    self.typeLab.text = model.LeiBieMingCheng;
    self.addressLab.text = model.ZhaoKaiChengShi;
    [self.pictureImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.TuPian]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
    
    self.typeLab.sd_layout.leftSpaceToView(self.typeIcon,5).bottomSpaceToView(self.rightView,20).widthIs(self.typeLab.text.length*12.5).heightIs(12);
    self.addressImg.sd_layout.leftSpaceToView(self.typeLab,10).bottomSpaceToView(self.rightView,20).widthIs(14).heightIs(14);
    self.addressLab.sd_layout.leftSpaceToView(self.addressImg,5).bottomSpaceToView(self.rightView,20).rightSpaceToView(self.rightView,10).heightIs(12);
}

#pragma mark - 初始化视图
- (void)initCellView {

    [self.contentView addSubview:self.leftLineView];
    [self.contentView addSubview:self.rightView];
    [self.contentView addSubview:self.yuanQuanView];
    [self.contentView addSubview:self.dayLab];
    [self.rightView addSubview:self.pictureImg];
    [self.rightView addSubview:self.titleLab];
    [self.rightView addSubview:self.timeIcon];
    [self.rightView addSubview:self.typeIcon];
    [self.rightView addSubview:self.timeLab];
    [self.rightView addSubview:self.typeLab];
    [self.rightView addSubview:self.addressImg];
    [self.rightView addSubview:self.addressLab];
    
    self.leftLineView.sd_layout.leftSpaceToView(self.contentView,29.5).topEqualToView(self.contentView).bottomEqualToView(self.contentView).widthIs(1);
    self.rightView.sd_layout.leftSpaceToView(self.contentView,30.5).rightSpaceToView(self.contentView,10).centerYEqualToView(self.contentView).topSpaceToView(self.contentView,10).bottomSpaceToView(self.contentView,10);
    self.yuanQuanView.sd_layout.leftSpaceToView(self.contentView,17).topSpaceToView(self.contentView,30).widthIs(26).heightIs(26);
    self.dayLab.sd_layout.centerXEqualToView(self.yuanQuanView).centerYEqualToView(self.yuanQuanView).heightIs(26).widthIs(26);
    self.pictureImg.sd_layout.leftSpaceToView(self.rightView,20).centerYEqualToView(self.rightView).topSpaceToView(self.rightView,20).bottomSpaceToView(self.rightView,20).widthIs((130-70)*1.5);
    self.titleLab.sd_layout.leftSpaceToView(self.pictureImg,10).topSpaceToView(self.rightView,20).rightSpaceToView(self.rightView,10).heightIs(15);
    self.timeIcon.sd_layout.leftSpaceToView(self.pictureImg,10).centerYEqualToView(self.rightView).widthIs(15).heightIs(15);
    self.timeLab.sd_layout.leftSpaceToView(self.timeIcon,5).centerYEqualToView(self.rightView).rightSpaceToView(self.rightView,10).heightIs(15);
    self.typeIcon.sd_layout.leftSpaceToView(self.pictureImg,10).bottomSpaceToView(self.rightView,20).widthIs(14).heightIs(14);
}

#pragma mark - 懒加载
- (UIView *)leftLineView {
    if (!_leftLineView) {
        _leftLineView = [UIView new];
        _leftLineView.backgroundColor = RGB(29, 186, 156);
    }
    return _leftLineView;
}
- (UIView *)rightView {
    if (!_rightView) {
        _rightView = [UIView new];
        _rightView.backgroundColor = [UIColor whiteColor];
        _rightView.layer.cornerRadius = 2;
        _rightView.layer.shadowColor = RGB(100, 100, 100).CGColor;//阴影颜色
        _rightView.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
        _rightView.layer.shadowOpacity = 0.5;//不透明度
        _rightView.layer.shadowRadius = 5.0;//半径
    }
    return _rightView;
}
- (UIView *)yuanQuanView {
    if (!_yuanQuanView) {
        _yuanQuanView = [UIView new];
        _yuanQuanView.backgroundColor = BG_Color;
        _yuanQuanView.clipsToBounds = YES;
        _yuanQuanView.layer.cornerRadius = 13;
        _yuanQuanView.layer.borderWidth = 1;
        _yuanQuanView.layer.borderColor = RGB(29, 186, 156).CGColor;
    }
    return _yuanQuanView;
}
- (UILabel *)dayLab {
    if (!_dayLab) {
        _dayLab = [UILabel new];
        _dayLab.textColor = RGB(29, 186, 156);
        _dayLab.textAlignment = NSTextAlignmentCenter;
        _dayLab.font = [UIFont systemFontOfSize:12];
    }
    return _dayLab;
}
- (UIImageView *)pictureImg {
    if (!_pictureImg) {
        _pictureImg = [UIImageView new];
        _pictureImg.clipsToBounds = YES;
        _pictureImg.contentMode = UIViewContentModeScaleAspectFill;
        _pictureImg.layer.cornerRadius = 3;
    }
    return _pictureImg;
}
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont systemFontOfSize:15];
    }
    return _titleLab;
}
- (UIImageView *)timeIcon {
    if (!_timeIcon) {
        _timeIcon = [UIImageView new];
        _timeIcon.image = [UIImage imageNamed:@"lishi"];
    }
    return _timeIcon;
}
- (UIImageView *)typeIcon {
    if (!_typeIcon) {
        _typeIcon = [UIImageView new];
        _typeIcon.image = [UIImage imageNamed:@"zhibox"];
    }
    return _typeIcon;
}
- (UIImageView *)addressImg {
    if (!_addressImg) {
        _addressImg = [UIImageView new];
        _addressImg.image = [UIImage imageNamed:@"ordinaryjingxiaoshang"];
    }
    return _addressImg;
}
- (UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [UILabel new];
        _timeLab.font = [UIFont systemFontOfSize:12];
        _timeLab.textColor = HuiText_Color;
    }
    return _timeLab;
}
- (UILabel *)typeLab {
    if (!_typeLab) {
        _typeLab = [UILabel new];
        _typeLab.font = [UIFont systemFontOfSize:12];
        _typeLab.textColor = Main_Color;
    }
    return _typeLab;
}
- (UILabel *)addressLab {
    if (!_addressLab) {
        _addressLab = [UILabel new];
        _addressLab.font = [UIFont systemFontOfSize:12];
        _addressLab.textColor = RGB(220, 20, 60);
    }
    return _addressLab;
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
