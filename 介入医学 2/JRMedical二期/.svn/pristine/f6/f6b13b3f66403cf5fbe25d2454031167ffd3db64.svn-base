//
//  MerchandiseTypeView.m
//  JRMedical
//
//  Created by a on 16/12/5.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "MerchandiseTypeView.h"

@implementation MerchandiseTypeView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.pictureImg];
        [self addSubview:self.titleLab];
        
        self.pictureImg.sd_layout.centerXEqualToView(self).topEqualToView(self).widthIs(28).heightIs(28);
        self.titleLab.sd_layout.centerXEqualToView(self).topSpaceToView(self.pictureImg,5).widthIs(60).heightIs(14);
    }
    return self;
}

- (UIImageView *)pictureImg {
    if (!_pictureImg) {
        _pictureImg = [UIImageView new];
//        _pictureImg.clipsToBounds = YES;
//        _pictureImg.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _pictureImg;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = [UIFont systemFontOfSize:14];
        _titleLab.textColor = RGB(80, 80, 80);
    }
    return _titleLab;
}

@end
