//
//  DoctorTopicCell.m
//  JRMedical
//
//  Created by a on 16/12/26.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "DoctorTopicCell.h"

@implementation DoctorTopicCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //        self.contentView.backgroundColor = BG_Color;
        
        [self initJiChuAutoLayout];
        
    }
    return self;
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
}

- (void)setPicUrlArray:(NSArray *)picUrlArray {//缩略图
    _picUrlArray = picUrlArray;
}

- (void)setPicOriArray:(NSArray *)picOriArray {//高清图
    _picOriArray = picOriArray;
}

- (void)setRTypeArray:(NSArray *)rTypeArray {//图片类型
    _rTypeArray = rTypeArray;
}

- (void)setModel:(ReplyPostModel *)model {
    _model = model;
    
    if (model.IsRole) {
        self.isRenZhengImg.hidden = NO;
    }
    else {
        self.isRenZhengImg.hidden = YES;
    }
    
    //固态高度值   95
    //动态高度值为  内容 和  九宫格图片
    
    [self.headerPhoto sd_setImageWithURL:[NSURL URLWithString:model.CreUserPic] placeholderImage:[UIImage imageNamed:@"mtou"]];
    self.nameLab.text = model.CUserName;
    self.timeLab.text = model.CTime;
    self.xingHaoLab.text = model.EvaluateDevice;
    self.contactLab.text = model.Content;
    
    [self.picContainerView setIsReply:1000];//回帖类型
    [self.picContainerView setPicOriArray:self.picOriArray];//高清图
    [self.picContainerView setPicUrlArray:self.picUrlArray];//缩略图
    [self.picContainerView setRTypeArray:self.rTypeArray];//图片类型
    
    CGSize timeWidth = [Utils sizeForTitle:self.timeLab.text withFont:[UIFont systemFontOfSize:12]];
    CGRect contantWidth = [Utils getTextRectWithString:self.contactLab.text withWidth:Width_Screen-84 withFontSize:16];
    
    self.timeLab.sd_resetLayout.topSpaceToView(self.nameLab,10).leftSpaceToView(self.headerPhoto,10).widthIs(timeWidth.width).heightIs(12);
    self.contactLab.sd_resetLayout.topSpaceToView(self.headerPhoto,10).leftSpaceToView(self.headerPhoto,10).rightSpaceToView(self.contentView,10).heightIs(contantWidth.size.height);
}


#pragma mark - 初始化基础视图
- (void)initJiChuAutoLayout {
    
    [self.contentView addSubview:self.headerPhoto];
    [self.contentView addSubview:self.isRenZhengImg];
    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.timeLab];
    [self.contentView addSubview:self.laiYuanLab];
    [self.contentView addSubview:self.xingHaoLab];
    [self.contentView addSubview:self.contactLab];
    [self.contentView addSubview:self.picContainerView];
    
    self.headerPhoto.sd_layout.topSpaceToView(self.contentView,10).leftSpaceToView(self.contentView,10).widthIs(54).heightIs(54);
    self.isRenZhengImg.sd_layout.bottomEqualToView(self.headerPhoto).leftSpaceToView(self.headerPhoto,-15).heightIs(12).widthIs(12);
    self.nameLab.sd_layout.topSpaceToView(self.contentView,20).leftSpaceToView(self.headerPhoto,10).rightSpaceToView(self.contentView,10).heightIs(16);
    self.timeLab.sd_layout.topSpaceToView(self.nameLab,10).leftSpaceToView(self.headerPhoto,10).widthIs(50).heightIs(12);
    self.laiYuanLab.sd_layout.topSpaceToView(self.nameLab,10).leftSpaceToView(self.timeLab,10).widthIs(25).heightIs(12);
    self.xingHaoLab.sd_layout.topSpaceToView(self.nameLab,10).leftSpaceToView(self.laiYuanLab,2).rightSpaceToView(self.contentView,20).heightIs(12);
    self.contactLab.sd_layout.topSpaceToView(self.headerPhoto,10).leftSpaceToView(self.headerPhoto,10).rightSpaceToView(self.contentView,10).heightIs(35);
    
    __weak typeof(self)weakSelf = self;
    [self.picContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.contentView).offset(-10);
        make.left.equalTo(weakSelf.contentView).offset(74);
        make.height.mas_equalTo(0);
        make.right.mas_greaterThanOrEqualTo(weakSelf.contentView).offset(-10);
    }];
    
    [self.picContainerView setContentHuggingPriority:249 forAxis:UILayoutConstraintAxisVertical];
    [self.picContainerView setContentCompressionResistancePriority:749 forAxis:UILayoutConstraintAxisVertical];
}

#pragma mark - 懒加载
- (UIImageView *)headerPhoto {
    if (!_headerPhoto) {
        _headerPhoto = [UIImageView new];
        _headerPhoto.backgroundColor = [UIColor whiteColor];
        _headerPhoto.image = [UIImage imageNamed:@"mtou"];
        _headerPhoto.userInteractionEnabled = YES;
        _headerPhoto.clipsToBounds = YES;
        _headerPhoto.contentMode = UIViewContentModeScaleAspectFill;
        _headerPhoto.layer.cornerRadius = 27;
    }
    return _headerPhoto;
}
- (UIImageView *)isRenZhengImg {
    if (!_isRenZhengImg) {
        _isRenZhengImg = [UIImageView new];
        _isRenZhengImg.image = [UIImage imageNamed:@"doctor-ren"];
    }
    return _isRenZhengImg;
}
- (UILabel *)nameLab {
    if (!_nameLab) {
        _nameLab = [UILabel new];
        _nameLab.font = [UIFont boldSystemFontOfSize:16];
        _nameLab.textColor = Main_Color;
    }
    return _nameLab;
}
- (UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [UILabel new];
        _timeLab.textColor = HuiText_Color;
        _timeLab.font = [UIFont systemFontOfSize:12];
    }
    return _timeLab;
}
- (UILabel *)laiYuanLab {
    if (!_laiYuanLab) {
        _laiYuanLab = [UILabel new];
        _laiYuanLab.textColor = HuiText_Color;
        _laiYuanLab.font = [UIFont systemFontOfSize:12];
        _laiYuanLab.text = @"来自";
    }
    return _laiYuanLab;
}
- (UILabel *)xingHaoLab {
    if (!_xingHaoLab) {
        _xingHaoLab = [UILabel new];
        _xingHaoLab.textColor = RGB(31, 188, 210);
        _xingHaoLab.font = [UIFont systemFontOfSize:12];
    }
    return _xingHaoLab;
}
- (UILabel *)contactLab {
    if (!_contactLab) {
        _contactLab = [UILabel new];
        _contactLab.font = [UIFont systemFontOfSize:16];
        _contactLab.numberOfLines = 0;
        _contactLab.textColor = RGB(120, 120, 120);
    }
    return _contactLab;
}
- (YHWorkGroupPhotoContainer *)picContainerView {
    if (!_picContainerView) {
        _picContainerView = [[YHWorkGroupPhotoContainer alloc] initWithWidth:Width_Screen-84];
    }
    return _picContainerView;
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
