//
//  XBSettingCell.m
//  xiu8iOS
//
//  Created by XB on 15/9/18.
//  Copyright (c) 2015年 xiu8. All rights reserved.
//

#import "XBSettingCell.h"
#import "XBSettingItemModel.h"
#import "UIView+XBExtension.h"
#import "XBConst.h"

@interface XBSettingCell()

@end
@implementation XBSettingCell

- (void)setItem:(XBSettingItemModel *)item
{
    _item = item;
    [self updateUI];
    
}

- (void)updateUI
{
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (self.item.urlImg) {
        [self setupUrlImgView];
    }
    
    //如果有图片
    if (self.item.img) {
        [self setupImgView];
    }
    
    //功能名称
    if (self.item.funcName) {
        [self setupFuncLabel];
    }
    
    //accessoryType
    if (self.item.accessoryType) {
        [self setupAccessoryType];
    }
    //detailView
    if (self.item.detailText) {
        [self setupDetailText];
    }
    if (self.item.detailImage) {
        [self setupDetailImage];
    }
    
    //bottomLine
    _line = [[UIView alloc]initWithFrame:CGRectMake(0,self.contentView.height - 0.7, XBScreenWidth, 0.7)];
    _line.backgroundColor = XBMakeColorWithRGB(234, 234, 234, 1);
    [self.contentView addSubview:_line];
    
}

-(void)setupDetailImage
{
    self.detailImageView = [[UIImageView alloc] initWithImage:self.item.detailImage];
    self.detailImageView.height = 20;
    self.detailImageView.centerY = self.contentView.centerY;
    switch (self.item.accessoryType) {
        case XBSettingAccessoryTypeNone:
            self.detailImageView.x = XBScreenWidth - self.detailImageView.width - XBDetailViewToIndicatorGap - 2;
            break;
        case XBSettingAccessoryTypeDisclosureIndicator:
            self.detailImageView.x = self.indicator.x - self.detailImageView.width - XBDetailViewToIndicatorGap;
            break;
        case XBSettingAccessoryTypeSwitch:
            self.detailImageView.x = self.aswitch.x - self.detailImageView.width - XBDetailViewToIndicatorGap;
            break;
        default:
            break;
    }
    [self.contentView addSubview:self.detailImageView];
}

- (void)setupDetailText
{
    self.detailLabel = [[UILabel alloc]init];
    self.detailLabel.text = self.item.detailText;
    self.detailLabel.textColor = XBMakeColorWithRGB(142, 142, 142, 1);
    self.detailLabel.font = [UIFont systemFontOfSize:XBDetailLabelFont];
    self.detailLabel.size = [self sizeForTitle:self.item.detailText withFont:self.detailLabel.font];
    self.detailLabel.centerY = self.contentView.centerY;
    
    switch (self.item.accessoryType) {
        case XBSettingAccessoryTypeNone:
            self.detailLabel.x = XBScreenWidth - self.detailLabel.width - XBDetailViewToIndicatorGap - 2;
            break;
        case XBSettingAccessoryTypeDisclosureIndicator:
            self.detailLabel.x = self.indicator.x - self.detailLabel.width - XBDetailViewToIndicatorGap;
            break;
        case XBSettingAccessoryTypeSwitch:
            self.detailLabel.x = self.aswitch.x - self.detailLabel.width - XBDetailViewToIndicatorGap;
            break;
        default:
            break;
    }
    
    [self.contentView addSubview:self.detailLabel];
}


- (void)setupAccessoryType
{
    switch (self.item.accessoryType) {
        case XBSettingAccessoryTypeNone:
            break;
        case XBSettingAccessoryTypeDisclosureIndicator:
            [self setupIndicator];
            break;
        case XBSettingAccessoryTypeSwitch:
            [self setupSwitch];
            break;
        default:
            break;
    }
}

- (void)setupSwitch
{
    [self.contentView addSubview:self.aswitch];
}

- (void)setupIndicator
{
    [self.contentView addSubview:self.indicator];
    
}

- (void)setupImgView
{
    self.imgView = [[UIImageView alloc]initWithImage:self.item.img];
    self.imgView.x = XBFuncImgToLeftGap;
    self.imgView.centerY = self.contentView.centerY;
    self.imgView.centerY = self.contentView.centerY;
    [self.contentView addSubview:self.imgView];
}

- (void)setupUrlImgView
{
    self.imgView = [UIImageView new];
    self.imgView.x = XBFuncImgToLeftGap;
    self.imgView.width = 20;
    self.imgView.height = 20;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:self.item.urlImg] placeholderImage:[UIImage imageNamed:@"jiazai"]];
    self.imgView.centerY = self.contentView.centerY;
    self.imgView.centerY = self.contentView.centerY;
    [self.contentView addSubview:self.imgView];
}

- (void)setupFuncLabel
{
    self.funcNameLabel = [[UILabel alloc]init];
    self.funcNameLabel.text = self.item.funcName;
    self.funcNameLabel.textColor = XBMakeColorWithRGB(51, 51, 51, 1);
    self.funcNameLabel.font = [UIFont systemFontOfSize:XBFuncLabelFont];
    self.funcNameLabel.size = [self sizeForTitle:self.item.funcName withFont:self.funcNameLabel.font];
    self.funcNameLabel.centerY = self.contentView.centerY;
    self.funcNameLabel.x = CGRectGetMaxX(self.imgView.frame) + XBFuncLabelToFuncImgGap;
    [self.contentView addSubview:self.funcNameLabel];
}

- (CGSize)sizeForTitle:(NSString *)title withFont:(UIFont *)font
{
    CGRect titleRect = [title boundingRectWithSize:CGSizeMake(FLT_MAX, FLT_MAX)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName : font}
                                           context:nil];
    
    return CGSizeMake(titleRect.size.width,
                      titleRect.size.height);
}

- (UIImageView *)indicator
{
    if (!_indicator) {
        _indicator = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yougengduo"]];
        _indicator.centerY = self.contentView.centerY;
        _indicator.x = XBScreenWidth - _indicator.width - XBIndicatorToRightGap;
    }
    return _indicator;
}

- (UISwitch *)aswitch
{
    if (!_aswitch) {
        _aswitch = [[UISwitch alloc]init];
        _aswitch.centerY = self.contentView.centerY;
        _aswitch.x = XBScreenWidth - _aswitch.width - XBIndicatorToRightGap;
        _aswitch.tintColor = Main_Color;
        _aswitch.onTintColor = Main_Color;
        [_aswitch addTarget:self action:@selector(switchTouched:) forControlEvents:UIControlEventValueChanged];
        _aswitch.on = self.item.switchStatus;
    }
    //
    return _aswitch;
}

- (void)switchTouched:(UISwitch *)sw
{
    __weak typeof(self) weakSelf = self;
    self.item.switchValueChanged(weakSelf.aswitch.isOn);
}

- (void) changeSwitchStatus:(BOOL)status
{
    if(self.item.accessoryType == XBSettingAccessoryTypeSwitch){
        self.aswitch.on = status;
    }
    
}

@end
