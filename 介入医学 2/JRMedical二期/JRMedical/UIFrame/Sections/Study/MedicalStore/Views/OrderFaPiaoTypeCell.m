//
//  OrderFaPiaoTypeCell.m
//  JRMedical
//
//  Created by a on 16/12/19.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "OrderFaPiaoTypeCell.h"

@implementation OrderFaPiaoTypeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.typeLab];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.geRenBtn];
        [self.contentView addSubview:self.danWeiBtn];
        
        self.typeLab.sd_layout.topSpaceToView(self.contentView,15).leftSpaceToView(self.contentView,15).rightSpaceToView(self.contentView,15).heightIs(14);
        self.lineView.sd_layout.topSpaceToView(self.typeLab,15).leftSpaceToView(self.contentView,10).rightSpaceToView(self.contentView,10).heightIs(0.4);
        self.geRenBtn.sd_layout.topSpaceToView(self.lineView,15).leftSpaceToView(self.contentView,15).widthIs(50).heightIs(44);
        self.danWeiBtn.sd_layout.topSpaceToView(self.lineView,15).leftSpaceToView(self.geRenBtn,30).widthIs(50).heightIs(44);
    }
    return self;
}

- (UILabel *)typeLab {
    if (!_typeLab) {
        _typeLab = [UILabel new];
        _typeLab.font = [UIFont systemFontOfSize:14];
        _typeLab.text = @"发票类型";
    }
    return _typeLab;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = RGB(220, 220, 220);
    }
    return _lineView;
}
- (KMButton *)geRenBtn {
    if (!_geRenBtn) {
        _geRenBtn = [KMButton buttonWithType:UIButtonTypeCustom];
        _geRenBtn.spacing = 5;
        _geRenBtn.margin = 1;
        _geRenBtn.kMButtonType = KMButtonLeft;
        [_geRenBtn setImage:[UIImage imageNamed:@"weixuan"] forState:UIControlStateNormal];
        [_geRenBtn setImage:[UIImage imageNamed:@"duidui"] forState:UIControlStateSelected];
        [_geRenBtn setTitle:@"个人" forState:UIControlStateNormal];
        [_geRenBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _geRenBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _geRenBtn.selected = YES;
        _geRenBtn.userInteractionEnabled = YES;
    }
    return _geRenBtn;
}
- (KMButton *)danWeiBtn {
    if (!_danWeiBtn) {
        _danWeiBtn = [KMButton buttonWithType:UIButtonTypeCustom];
        _danWeiBtn.spacing = 5;
        _danWeiBtn.margin = 1;
        _danWeiBtn.kMButtonType = KMButtonLeft;
        [_danWeiBtn setImage:[UIImage imageNamed:@"weixuan"] forState:UIControlStateNormal];
        [_danWeiBtn setImage:[UIImage imageNamed:@"duidui"] forState:UIControlStateSelected];
        [_danWeiBtn setTitle:@"单位" forState:UIControlStateNormal];
        [_danWeiBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _danWeiBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _danWeiBtn.selected = NO;
        _danWeiBtn.userInteractionEnabled = YES;
    }
    return _danWeiBtn;
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
