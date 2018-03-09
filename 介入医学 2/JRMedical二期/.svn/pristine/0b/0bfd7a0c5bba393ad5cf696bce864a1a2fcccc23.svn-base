//
//  SearchTableViewCell.m
//  JRMedical
//
//  Created by a on 16/11/24.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "SearchTableViewCell.h"

@implementation SearchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = BG_Color;
        
        [self initCellView];
    }
    return self;
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    self.titleLab.text = dataDic[@"KeyWord"];
}

#pragma mark - 初始化视图
- (void)initCellView {
    
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.liShiImg];
    [self.contentView addSubview:self.deleBtn];
    
    self.liShiImg.sd_layout.centerYEqualToView(self.contentView).leftSpaceToView(self.contentView,15).widthIs(16).heightIs(16);
    self.deleBtn.sd_layout.centerYEqualToView(self.contentView).rightSpaceToView(self.contentView,15).widthIs(12).heightIs(12);
    self.titleLab.sd_layout.centerYEqualToView(self.contentView).leftSpaceToView(self.liShiImg,15).rightSpaceToView(self.deleBtn,15).heightIs(14);
}

#pragma mark - 懒加载
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.textColor = RGB(140, 140, 140);
        _titleLab.font = [UIFont systemFontOfSize:14];
    }
    return _titleLab;
}
- (UIImageView *)liShiImg {
    if (!_liShiImg) {
        _liShiImg = [UIImageView new];
        _liShiImg.image = [UIImage imageNamed:@"lishi"];
    }
    return _liShiImg;
}
- (UIButton *)deleBtn {
    if (!_deleBtn) {
        _deleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_deleBtn setImage:[UIImage imageNamed:@"closez"] forState:UIControlStateNormal];
        [_deleBtn setTintColor:RGB(160, 160, 160)];
        _deleBtn.hidden = YES;
    }
    return _deleBtn;
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
