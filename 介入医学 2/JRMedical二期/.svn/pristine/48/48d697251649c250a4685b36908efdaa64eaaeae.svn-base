//
//  GroupTypeView.m
//  JRMedical
//
//  Created by ww on 2016/12/13.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "GroupTypeView.h"

@interface GroupTypeView ()



@end

@implementation GroupTypeView

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
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-5);
    }];
    
    
    self.titleLab = [[UILabel alloc] init];
    [self addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 15));
        make.centerX.equalTo(self);
        make.top.equalTo(self.imageView.mas_bottom).offset(5);
    }];
    self.titleLab.font = [UIFont systemFontOfSize:13];
    self.titleLab.textAlignment = NSTextAlignmentCenter;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
