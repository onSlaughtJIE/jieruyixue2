//
//  ChooseAddressTableViewCell.m
//  HongJHome
//
//  Created by 曹柏涵 on 15/8/26.
//  Copyright (c) 2015年 yizhisheng. All rights reserved.
//

#import "ChooseAddressTableViewCell.h"

@implementation ChooseAddressTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
        
        [self initCellView];
    }
    return self;
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
}

- (void)moRenAddBtnClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectRowDelectClick:)]) {
        [self.delegate selectRowDelectClick:self.indexPath];
    }
}

- (void)setModel:(MyAddressModel *)model {
    _model = model;
    
    self.moRenAddBtn.selected = model.IsDefault;
    
    self.nameLab.text = model.ConsigneeName;
    self.phoneLab.text = model.Consigneephone;
    
    if ([model.Province isEqualToString:model.City]) {
        self.contantLab.text = [NSString stringWithFormat:@"%@%@%@",model.Province,model.County,model.DetailAddress];
    }
    else {
        self.contantLab.text = [NSString stringWithFormat:@"%@%@%@%@",model.Province,model.City,model.County,model.DetailAddress];
    }
    
    CGRect contantWidth = [Utils getTextRectWithString:self.contantLab.text withWidth:Width_Screen-20 withFontSize:14];
    
    if (contantWidth.size.height <= 34) {
        contantWidth.size.height = 34;
    }
    
    self.contantLab.sd_resetLayout.leftSpaceToView(self.contentView,15).rightSpaceToView(self.contentView,15).topSpaceToView(self.nameLab,10).heightIs(contantWidth.size.height);
    
    self.lineView.sd_layout.leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0).topSpaceToView(self.contantLab,10).heightIs(0.5);
    
    self.moRenAddBtn.sd_layout.leftSpaceToView(self.contentView,15).topSpaceToView(self.lineView,10).widthIs(75).heightIs(25);
    self.deleBtn.sd_layout.rightSpaceToView(self.contentView,15).topSpaceToView(self.lineView,10).widthIs(52).heightIs(25);
    self.bianJiBtn.sd_layout.rightSpaceToView(self.deleBtn,20).topSpaceToView(self.lineView,10).widthIs(52).heightIs(25);
}

#pragma mark - 初始化视图
- (void)initCellView {

    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.phoneLab];
    [self.contentView addSubview:self.contantLab];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.moRenAddBtn];
    [self.contentView addSubview:self.bianJiBtn];
    [self.contentView addSubview:self.deleBtn];
    
    self.nameLab.sd_layout.leftSpaceToView(self.contentView,15).topSpaceToView(self.contentView,15).widthIs(120).heightIs(14);
    self.phoneLab.sd_layout.leftSpaceToView(self.nameLab,15).rightSpaceToView(self.contentView,15).topSpaceToView(self.contentView,15).heightIs(14);
    
    self.contantLab.sd_layout.leftSpaceToView(self.contentView,15).rightSpaceToView(self.contentView,15).topSpaceToView(self.nameLab,10).heightIs(34);
    
    self.lineView.sd_layout.leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0).topSpaceToView(self.contantLab,10).heightIs(0.5);
    
    self.moRenAddBtn.sd_layout.leftSpaceToView(self.contentView,15).topSpaceToView(self.lineView,10).widthIs(75).heightIs(25);
    self.deleBtn.sd_layout.rightSpaceToView(self.contentView,15).topSpaceToView(self.lineView,10).widthIs(52).heightIs(25);
    self.bianJiBtn.sd_layout.rightSpaceToView(self.deleBtn,20).topSpaceToView(self.lineView,10).widthIs(52).heightIs(25);
}

#pragma mark - 懒加载
- (UILabel *)nameLab {
    if (!_nameLab) {
        _nameLab = [UILabel new];
        _nameLab.font = [UIFont systemFontOfSize:14];
    }
    return _nameLab;
}
- (UILabel *)phoneLab {
    if (!_phoneLab) {
        _phoneLab = [UILabel new];
        _phoneLab.font = [UIFont systemFontOfSize:14];
    }
    return _phoneLab;
}
- (UILabel *)contantLab {
    if (!_contantLab) {
        _contantLab = [UILabel new];
        _contantLab.font = [UIFont systemFontOfSize:14];
        _contantLab.textColor = [UIColor lightGrayColor];
        _contantLab.numberOfLines = 0;
    }
    return _contantLab;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UILabel new];
        _lineView.backgroundColor = BG_Color;
    }
    return _lineView;
}
- (KMButton *)moRenAddBtn {
    if (!_moRenAddBtn) {
        _moRenAddBtn = [KMButton buttonWithType:(UIButtonTypeCustom)];
        _moRenAddBtn.userInteractionEnabled = YES;
        _moRenAddBtn.spacing = 2;
        _moRenAddBtn.margin = 1;
        _moRenAddBtn.kMButtonType = KMButtonLeft;
        [_moRenAddBtn setTitle:@" 默认地址" forState:(UIControlStateNormal)];
        _moRenAddBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_moRenAddBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_moRenAddBtn setImage:[UIImage imageNamed:@"weixuan"] forState:(UIControlStateNormal)];
        [_moRenAddBtn setImage:[UIImage imageNamed:@"duidui"] forState:(UIControlStateSelected)];
        [_moRenAddBtn addTarget:self action:@selector(moRenAddBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moRenAddBtn;
}
- (KMButton *)bianJiBtn {
    if (!_bianJiBtn) {
        _bianJiBtn = [KMButton buttonWithType:UIButtonTypeCustom];
        _bianJiBtn.userInteractionEnabled = YES;
        _bianJiBtn.spacing = 2;
        _bianJiBtn.margin = 1;
        _bianJiBtn.kMButtonType = KMButtonLeft;
        [_bianJiBtn setImage:[UIImage imageNamed:@"bianji"] forState:UIControlStateNormal];
        [_bianJiBtn setTitle:@" 编辑" forState:UIControlStateNormal];
        [_bianJiBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _bianJiBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _bianJiBtn;
}
- (KMButton *)deleBtn {
    if (!_deleBtn) {
        _deleBtn = [KMButton buttonWithType:UIButtonTypeCustom];
        _deleBtn.userInteractionEnabled = YES;
        _deleBtn.spacing = 2;
        _deleBtn.margin = 1;
        _deleBtn.kMButtonType = KMButtonLeft;
        [_deleBtn setImage:[UIImage imageNamed:@"shanchusc"] forState:UIControlStateNormal];
        [_deleBtn setTitle:@" 删除" forState:UIControlStateNormal];
        [_deleBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
         _deleBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _deleBtn;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
