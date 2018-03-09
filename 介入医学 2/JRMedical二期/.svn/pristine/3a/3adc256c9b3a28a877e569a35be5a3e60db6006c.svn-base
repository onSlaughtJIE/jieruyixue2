//
//  MyCertificationCellHeaderView.m
//  JRMedical
//
//  Created by a on 16/11/10.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "MyCertificationCellHeaderView.h"

@implementation MyCertificationCellHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = Main_Color;
        
        [self setViewAutolayout];
    }
    return self;
}

- (void)setRenZhengDic:(NSDictionary *)renZhengDic {
    _renZhengDic = renZhengDic;
    
    [self.workCertImg  sd_setImageWithURL:[NSURL URLWithString:renZhengDic[@"WorkCard"]] placeholderImage:[UIImage imageNamed:@"gongzuozheng"]];
}

#pragma mark - 设置自动布局
- (void)setViewAutolayout {
    
    [self addSubview:self.workCertImg];
    [self addSubview:self.workCertLab];
    [self addSubview:self.descriptionLab];
    [self addSubview:self.lookImgBtn];
    
    self.workCertImg.sd_layout.topSpaceToView(self,15).centerXEqualToView(self).heightIs(90).widthIs(90);
    self.workCertLab.sd_layout.centerXEqualToView(self).topSpaceToView(self.workCertImg,15).heightIs(16).widthIs(100);
    self.descriptionLab.sd_layout.centerXEqualToView(self).topSpaceToView(self.workCertLab,6).heightIs(13).widthIs(200);
    self.lookImgBtn.sd_layout.centerXEqualToView(self).topSpaceToView(self.descriptionLab,6).heightIs(13).widthIs(200);
}

#pragma mark - 懒加载
- (UIImageView *)workCertImg {
    if (!_workCertImg) {
        _workCertImg = [UIImageView new];
        _workCertImg.image = [UIImage imageNamed:@"gongzuozheng"];
        _workCertImg.userInteractionEnabled = YES;
        _workCertImg.clipsToBounds = YES;
        _workCertImg.contentMode = UIViewContentModeScaleAspectFill;
        _workCertImg.layer.cornerRadius = 5;
    }
    return _workCertImg;
}
- (UILabel *)workCertLab {
    if (!_workCertLab) {
        _workCertLab = [UILabel new];
        _workCertLab.text = @"胸卡工作证";
        _workCertLab.textColor = [UIColor whiteColor];
        _workCertLab.font = [UIFont boldSystemFontOfSize:15];
        _workCertLab.textAlignment = NSTextAlignmentCenter;
    }
    return _workCertLab;
}
- (UILabel *)descriptionLab {
    if (!_descriptionLab) {
        _descriptionLab = [UILabel new];
        _descriptionLab.text = @"上传带有头像的胸卡或工作证";
        _descriptionLab.textColor = [UIColor whiteColor];
        _descriptionLab.font = [UIFont boldSystemFontOfSize:12];
        _descriptionLab.textAlignment = NSTextAlignmentCenter;
    }
    return _descriptionLab;
}
- (UIButton *)lookImgBtn {
    if (!_lookImgBtn) {
        _lookImgBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_lookImgBtn setTitle:@"点击查看大图" forState:UIControlStateNormal];
        [_lookImgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _lookImgBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        _lookImgBtn.userInteractionEnabled = YES;
    }
    return _lookImgBtn;
}

@end
