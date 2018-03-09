//
//  SetMyInfoCellHeaderView.m
//  JRMedical
//
//  Created by a on 16/11/10.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "SetMyInfoCellHeaderView.h"

@implementation SetMyInfoCellHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = Main_Color;
        
        [self setViewAutolayout];  
    }
    return self;
}

#pragma mark - 设置自动布局
- (void)setViewAutolayout {
    
    [self addSubview:self.userPhotoImg];
    [self addSubview:self.userNameLab];
    
    self.userPhotoImg.sd_layout.topSpaceToView(self,15).centerXEqualToView(self).heightIs(90).widthIs(90);
    self.userNameLab.sd_layout.centerXEqualToView(self).topSpaceToView(self.userPhotoImg,15).heightIs(16).widthIs(100);
}

#pragma mark - 懒加载
- (UIImageView *)userPhotoImg {
    if (!_userPhotoImg) {
        _userPhotoImg = [UIImageView new];
        _userPhotoImg.backgroundColor = [UIColor whiteColor];
        _userPhotoImg.image = [UIImage imageNamed:@"mtou"];
        _userPhotoImg.userInteractionEnabled = YES;
        _userPhotoImg.clipsToBounds = YES;
        _userPhotoImg.contentMode = UIViewContentModeScaleAspectFill;
        _userPhotoImg.layer.cornerRadius = 45;
    }
    return _userPhotoImg;
}
- (UILabel *)userNameLab {
    if (!_userNameLab) {
        _userNameLab = [UILabel new];
        _userNameLab.text = @"我的头像";
        _userNameLab.textColor = [UIColor whiteColor];
        _userNameLab.font = [UIFont boldSystemFontOfSize:15];
        _userNameLab.textAlignment = NSTextAlignmentCenter;
    }
    return _userNameLab;
}

@end
