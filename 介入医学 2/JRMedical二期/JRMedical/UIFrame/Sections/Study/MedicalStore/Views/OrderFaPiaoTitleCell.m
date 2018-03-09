//
//  OrderFaPiaoTitleCell.m
//  JRMedical
//
//  Created by a on 16/12/19.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "OrderFaPiaoTitleCell.h"

@implementation OrderFaPiaoTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.topLab];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.topInfoTF];
        
        self.topLab.sd_layout.topSpaceToView(self.contentView,15).leftSpaceToView(self.contentView,15).rightSpaceToView(self.contentView,15).heightIs(14);
        self.lineView.sd_layout.topSpaceToView(self.topLab,15).leftSpaceToView(self.contentView,10).rightSpaceToView(self.contentView,10).heightIs(0.4);
        self.topInfoTF.sd_layout.topSpaceToView(self.lineView,15).leftSpaceToView(self.contentView,15).rightSpaceToView(self.contentView,15).heightIs(44);
    }
    return self;
}

- (UILabel *)topLab {
    if (!_topLab) {
        _topLab = [UILabel new];
        _topLab.font = [UIFont systemFontOfSize:14];
        _topLab.text = @"发票抬头";
    }
    return _topLab;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = RGB(220, 220, 220);
    }
    return _lineView;
}
- (UITextField *)topInfoTF {
    if (!_topInfoTF) {
        _topInfoTF = [UITextField new];
        _topInfoTF.font = [UIFont systemFontOfSize:14];
        _topInfoTF.borderStyle = UITextBorderStyleRoundedRect;
        _topInfoTF.returnKeyType = UIReturnKeyDone;
        _topInfoTF.placeholder = @"请填写公司名称";
    }
    return _topInfoTF;
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
