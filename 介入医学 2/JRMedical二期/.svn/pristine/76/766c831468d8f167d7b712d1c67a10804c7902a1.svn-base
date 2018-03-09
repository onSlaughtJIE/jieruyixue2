//
//  MessageSignInCell.m
//  JRMedical
//
//  Created by a on 16/12/21.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "MessageSignInCell.h"

@implementation MessageSignInCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initCellView];
    }
    return self;
}

- (void)setModel:(MessageSignInModel *)model {
    _model = model;
    
    NSString *yearStr = [model.HappenTime substringWithRange:NSMakeRange(0,4)];
    NSString *monthStr = [model.HappenTime substringWithRange:NSMakeRange(5,5)];
    NSString *timeStr = [model.HappenTime substringWithRange:NSMakeRange(11,5)];
    
    self.yearLab.text = yearStr;
    self.monthLab.text = monthStr;
    self.timeLab.text = timeStr;
    
    self.titleLab.text = model.RTypeName;
    
    self.numLab.text = [NSString stringWithFormat:@"奖励数量 : %@币",model.UMoney];
}

#pragma mark - 初始化视图
- (void)initCellView {
    [self.contentView addSubview:self.yearLab];
    [self.contentView addSubview:self.monthLab];
    [self.contentView addSubview:self.timeLab];
    [self.contentView addSubview:self.verticalLine];
    [self.contentView addSubview:self.circleView];
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.numLab];
    self.yearLab.sd_layout.topSpaceToView(self.contentView,10).leftSpaceToView(self.contentView,10).widthIs(40).heightIs(14);
    self.monthLab.sd_layout.topSpaceToView(self.yearLab,2).leftSpaceToView(self.contentView,10).widthIs(40).heightIs(14);
    self.timeLab.sd_layout.topSpaceToView(self.monthLab,2).leftSpaceToView(self.contentView,10).widthIs(40).heightIs(14);
    self.verticalLine.sd_layout.topSpaceToView(self.contentView,0).bottomSpaceToView(self.contentView,0).leftSpaceToView(self.yearLab,17.65).widthIs(0.7);
    self.circleView.sd_layout.centerYEqualToView(self.contentView).leftSpaceToView(self.yearLab,10).widthIs(16).heightIs(16);
    self.titleLab.sd_layout.topSpaceToView(self.contentView,10).leftSpaceToView(self.circleView,10).rightSpaceToView(self.contentView,10).heightIs(14);
    self.numLab.sd_layout.bottomSpaceToView(self.contentView,10).leftSpaceToView(self.circleView,10).rightSpaceToView(self.contentView,10).heightIs(12);
}

#pragma mark - 懒加载
- (UILabel *)yearLab {
    if (!_yearLab) {
        _yearLab = [UILabel new];
        _yearLab.textColor = Main_Color;
        _yearLab.textAlignment = NSTextAlignmentCenter;
        _yearLab.font = [UIFont systemFontOfSize:14];
    }
    return _yearLab;
}
- (UILabel *)monthLab {
    if (!_monthLab) {
        _monthLab = [UILabel new];
        _monthLab.textColor = HuiText_Color;
        _monthLab.textAlignment = NSTextAlignmentCenter;
        _monthLab.font = [UIFont systemFontOfSize:14];
    }
    return _monthLab;
}
- (UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [UILabel new];
        _timeLab.textColor = Main_Color;
        _timeLab.textAlignment = NSTextAlignmentCenter;
        _timeLab.font = [UIFont systemFontOfSize:14];
    }
    return _timeLab;
}
- (UIView *)verticalLine {
    if (!_verticalLine) {
        _verticalLine = [UIView new];
        _verticalLine.backgroundColor = RGB(200, 200, 200);
    }
    return _verticalLine;
}
- (UIView *)circleView {
    if (!_circleView) {
        _circleView = [UIView new];
        _circleView.backgroundColor = [UIColor whiteColor];
        _circleView.clipsToBounds = YES;
        _circleView.layer.cornerRadius = 8;
        _circleView.layer.borderWidth = 1;
        _circleView.layer.borderColor = Main_Color.CGColor;
    }
    return _circleView;
}
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.font = [UIFont systemFontOfSize:14];
    }
    return _titleLab;
}
- (UILabel *)numLab {
    if (!_numLab) {
        _numLab = [UILabel new];
        _numLab.font = [UIFont systemFontOfSize:12];
        _numLab.textColor = Main_Color;
    }
    return _numLab;
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
