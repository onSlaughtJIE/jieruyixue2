//
//  OrganizeCollectionCell.m
//  JRMedical
//
//  Created by ww on 2016/12/27.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "OrganizeCollectionCell.h"

@implementation OrganizeCollectionCell

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
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-5);
    }];
    self.imageView.layer.cornerRadius = 30;
    self.imageView.layer.masksToBounds = YES;
    
    
    self.titleLab = [[UILabel alloc] init];
    [self addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 20));
        make.centerX.equalTo(self);
        make.top.equalTo(self.imageView.mas_bottom).offset(5);
    }];
    self.titleLab.font = [UIFont systemFontOfSize:14];
    self.titleLab.textAlignment = NSTextAlignmentCenter;
}

- (void)setOrganizeCollectionCellWithModel:(OrgDetailModel *)model {
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.Pic] placeholderImage:[UIImage imageNamed:@"mtou"]];
    self.titleLab.text = model.CustomerName;
    
    
}



@end
