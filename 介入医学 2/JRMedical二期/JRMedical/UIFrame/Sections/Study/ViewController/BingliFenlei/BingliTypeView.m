//
//  BingliTypeView.m
//  JRMedical
//
//  Created by ww on 2017/1/16.
//  Copyright © 2017年 idcby. All rights reserved.
//

#import "BingliTypeView.h"

@implementation BingliTypeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews {
    
    self.imageView = [[UIImageView alloc] init];
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-12);
    }];
    
    
    self.titleLab = [[UILabel alloc] init];
    [self addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.centerX.equalTo(self);
        make.top.equalTo(self.imageView.mas_bottom).offset(3);
    }];
    self.titleLab.font = [UIFont boldSystemFontOfSize:15];
    self.titleLab.textAlignment = NSTextAlignmentCenter;
}


@end
