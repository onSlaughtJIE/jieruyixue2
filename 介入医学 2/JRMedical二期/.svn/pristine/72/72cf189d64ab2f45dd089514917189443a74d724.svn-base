//
//  OrderAddressCell.m
//  JRMedical
//
//  Created by a on 16/12/19.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "OrderAddressCell.h"

@implementation OrderAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initCellView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    self.nameLab.text = dataDic[@"ConsigneeName"];
    self.phoneLab.text = dataDic[@"Consigneephone"];

    if ([dataDic[@"IsDefault"] integerValue] == 1) {
        self.isDefault.hidden = NO;
    }
    else {
        self.isDefault.hidden = YES;
    }
    
    NSString *province = dataDic[@"Province"];
    NSString *city = dataDic[@"City"];
    NSString *county = dataDic[@"County"];
    NSString *detailAddress = dataDic[@"DetailAddress"];
    
    if ([province isEqualToString:city]) {
        self.detailAddressLab.text = [NSString stringWithFormat:@"%@%@%@",province,county,detailAddress];
    }
    else {
        self.detailAddressLab.text = [NSString stringWithFormat:@"%@%@%@%@",province,city,county,detailAddress];
    }
    
    CGSize nameWidth  = [Utils sizeForTitle:dataDic[@"ConsigneeName"] withFont:[UIFont systemFontOfSize:14]];
    CGSize phoneWidth  = [Utils sizeForTitle:dataDic[@"Consigneephone"] withFont:[UIFont systemFontOfSize:14]];
    
    self.nameLab.sd_layout.leftSpaceToView(self.contentView,15).topSpaceToView(self.contentView,15).widthIs(nameWidth.width).heightIs(20);
    self.phoneLab.sd_layout.leftSpaceToView(self.nameLab,15).topSpaceToView(self.contentView,15).widthIs(phoneWidth.width).heightIs(20);
    self.isDefault.sd_layout.leftSpaceToView(self.phoneLab,15).topSpaceToView(self.contentView,15).widthIs(40).heightIs(20);
    self.detailAddressLab.sd_layout.leftSpaceToView(self.contentView,15).rightSpaceToView(self.contentView,15).bottomSpaceToView(self.contentView,15).heightIs(20);
}

#pragma mark - 初始化视图
- (void)initCellView {
    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.phoneLab];
    [self.contentView addSubview:self.isDefault];
    [self.contentView addSubview:self.detailAddressLab];
    [self.contentView addSubview:self.emptyLab];
    
    self.emptyLab.sd_layout.leftSpaceToView(self.contentView,15).rightSpaceToView(self.contentView,15).centerYEqualToView(self.contentView).heightIs(20);
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
- (UILabel *)isDefault {
    if (!_isDefault) {
        _isDefault = [UILabel new];
        _isDefault.font = [UIFont systemFontOfSize:14];
        _isDefault.textColor = [UIColor whiteColor];
        _isDefault.backgroundColor = RGB(232, 78, 64);
        _isDefault.text = @"默认";
        _isDefault.textAlignment = NSTextAlignmentCenter;
    }
    return _isDefault;
}
- (UILabel *)detailAddressLab {
    if (!_detailAddressLab) {
        _detailAddressLab = [UILabel new];
        _detailAddressLab.font = [UIFont systemFontOfSize:14];
        _detailAddressLab.text = @"";
    }
    return _detailAddressLab;
}

- (UILabel *)emptyLab {
    if (!_emptyLab) {
        _emptyLab = [UILabel new];
        _emptyLab.font = [UIFont systemFontOfSize:14];
        _emptyLab.text = @"请添加您的收货地址信息";
        _emptyLab.textColor = [UIColor lightGrayColor];
        _emptyLab.hidden = YES;
        _emptyLab.textAlignment = NSTextAlignmentCenter;
    }
    return _emptyLab;
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
