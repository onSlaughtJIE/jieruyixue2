//
//  AuthorInfoView.m
//  JRMedical
//
//  Created by a on 16/11/17.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "AuthorInfoView.h"

@implementation AuthorInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = BG_Color;
        
        [self initCellView];//初始化视图
    }
    return self;
}

- (void)setModel:(PublicNewsListModel *)model {
    _model = model;
    
    [self.authorPhoto sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.VideoDocPic]] placeholderImage:[UIImage imageNamed:@"mtou"]];
    self.nameLab.text = model.VideoDoctor;
    self.hospitalNameLab.text = model.VideoHos;
    self.levelLab.text = model.VideoPost;
    self.categoryLab.text = model.VideoDep;
    
    self.nameLab.sd_layout.topSpaceToView(self,20).leftSpaceToView(self.authorPhoto,10).widthIs(self.nameLab.text.length*14.5).heightIs(14);
    self.followBtn.sd_layout.centerYEqualToView(self).rightSpaceToView(self,10).widthIs(60).heightIs(30);
    self.hospitalNameLab.sd_layout.leftSpaceToView(self.nameLab,5).rightSpaceToView(self.followBtn,10).bottomEqualToView(self.nameLab).heightIs(12);
    
    if ([model.VideoPost isEqualToString:@""] || model.VideoPost == nil) {
        self.levelLab.sd_layout.bottomSpaceToView(self,20).leftSpaceToView(self.authorPhoto,10).widthIs(0).heightIs(16);
    }
    else {
        self.levelLab.sd_layout.bottomSpaceToView(self,20).leftSpaceToView(self.authorPhoto,10).widthIs(self.levelLab.text.length*10.5+20).heightIs(16);
    }
    
    
    
    CGFloat num = Width_Screen - self.levelLab.text.length*10.5 - 170;
    CGFloat num1 = self.categoryLab.text.length*10.5 + 20;
    if ([model.VideoDep isEqualToString:@""] || model.VideoDep == nil) {
        self.categoryLab.sd_layout.bottomSpaceToView(self,20).leftSpaceToView(self.levelLab,5).widthIs(0).heightIs(16);
    }
    else {
        if ([model.VideoPost isEqualToString:@""] || model.VideoPost == nil) {
            if (num > num1) {
                self.categoryLab.sd_layout.bottomSpaceToView(self,20).leftSpaceToView(self.levelLab,0).widthIs(self.categoryLab.text.length*10.5 + 20).heightIs(16);
            }
            else {
                self.categoryLab.sd_layout.bottomSpaceToView(self,20).leftSpaceToView(self.levelLab,0).rightSpaceToView(self.followBtn,10).heightIs(16);
            }
        }
        else {
            if (num > num1) {
                self.categoryLab.sd_layout.bottomSpaceToView(self,20).leftSpaceToView(self.levelLab,5).widthIs(self.categoryLab.text.length*10.5 + 20).heightIs(16);
            }
            else {
                self.categoryLab.sd_layout.bottomSpaceToView(self,20).leftSpaceToView(self.levelLab,5).rightSpaceToView(self.followBtn,10).heightIs(16);
            }
        }
    }
}

#pragma mark - 初始化视图
- (void)initCellView {
    
    [self addSubview:self.authorPhoto];
    [self addSubview:self.nameLab];
    [self addSubview:self.hospitalNameLab];
    [self addSubview:self.levelLab];
    [self addSubview:self.categoryLab];
    [self addSubview:self.lineView];
    [self addSubview:self.lineView2];
    [self addSubview:self.followBtn];
    
    self.authorPhoto.sd_layout.centerYEqualToView(self).leftSpaceToView(self,10).widthIs(50).heightIs(50);
    
    self.lineView.sd_layout.bottomSpaceToView(self,1).leftSpaceToView(self,10).rightSpaceToView(self,10).heightIs(1);
    self.lineView2.sd_layout.bottomSpaceToView(self,0).leftSpaceToView(self,10).rightSpaceToView(self,10).heightIs(1);
}

#pragma mark - 懒加载
- (UIImageView *)authorPhoto {
    if (!_authorPhoto) {
        _authorPhoto = [UIImageView new];
        _authorPhoto.backgroundColor = [UIColor whiteColor];
        _authorPhoto.image = [UIImage imageNamed:@"mtou"];
        _authorPhoto.clipsToBounds = YES;
        _authorPhoto.contentMode = UIViewContentModeScaleAspectFill;
        _authorPhoto.layer.cornerRadius = 25;
    }
    return _authorPhoto;
}
- (UILabel *)nameLab {
    if (!_nameLab) {
        _nameLab = [UILabel new];
        _nameLab.font = [UIFont boldSystemFontOfSize:14];
    }
    return _nameLab;
}
- (UILabel *)hospitalNameLab {
    if (!_hospitalNameLab) {
        _hospitalNameLab = [UILabel new];
        _hospitalNameLab.textColor = HuiText_Color;
        _hospitalNameLab.font = [UIFont boldSystemFontOfSize:12];
    }
    return _hospitalNameLab;
}
- (UILabel *)levelLab {
    if (!_levelLab) {
        _levelLab = [UILabel new];
        _levelLab.textColor = [UIColor whiteColor];
        _levelLab.textAlignment = NSTextAlignmentCenter;
        _levelLab.backgroundColor = Main_Color;
        _levelLab.clipsToBounds = YES;
        _levelLab.layer.cornerRadius = 8;
        _levelLab.font = [UIFont systemFontOfSize:10];
    }
    return _levelLab;
}
- (UILabel *)categoryLab {
    if (!_categoryLab) {
        _categoryLab = [UILabel new];
        _categoryLab.textColor = [UIColor whiteColor];
        _categoryLab.textAlignment = NSTextAlignmentCenter;
        _categoryLab.backgroundColor = Main_Color;
        _categoryLab.clipsToBounds = YES;
        _categoryLab.layer.cornerRadius = 8;
        _categoryLab.font = [UIFont systemFontOfSize:10];
    }
    return _categoryLab;
}
- (UIButton *)followBtn {
    if (!_followBtn) {
        _followBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _followBtn.backgroundColor = RGB(255, 167, 38);
        _followBtn.clipsToBounds = YES;
        _followBtn.userInteractionEnabled = YES;
        _followBtn.layer.cornerRadius = 3;
        _followBtn.hidden = YES;
        [_followBtn setTitle:@"+关注" forState:UIControlStateNormal];
        [_followBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _followBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _followBtn;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = RGB(220, 220, 220);
    }
    return _lineView;
}
- (UIView *)lineView2 {
    if (!_lineView2) {
        _lineView2 = [UIView new];
        _lineView2.backgroundColor = RGB(250, 250, 250);
    }
    return _lineView2;
}

@end
