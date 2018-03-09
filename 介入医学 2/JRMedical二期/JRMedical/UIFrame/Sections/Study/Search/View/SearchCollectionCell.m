//
//  SearchCollectionCell.m
//  JRMedical
//
//  Created by a on 16/11/24.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "SearchCollectionCell.h"

@implementation SearchCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = KMRC;
        [self.contentView addSubview:self.titleLab];
    }
    return self;
}

- (void)setDataDic:(NSDictionary *)dataDic {
    
    self.layer.cornerRadius = 3;
    self.contentView.layer.cornerRadius = 10.0f;
    self.contentView.layer.borderWidth = 0.5f;
    self.contentView.layer.borderColor = [UIColor clearColor].CGColor;
    self.contentView.layer.masksToBounds = YES;
    
    self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowRadius = 4.0f;
    self.layer.shadowOpacity = 0.5f;
    self.layer.masksToBounds = NO;
    
    self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.contentView.layer.cornerRadius].CGPath;
    
    _dataDic = dataDic;
    self.titleLab.text = dataDic[@"KeyWord"];
    self.titleLab.sd_layout.centerYEqualToView(self.contentView).leftSpaceToView(self.contentView,10).rightSpaceToView(self.contentView,10).heightIs(12);
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = [UIFont systemFontOfSize:12];
    }
    return _titleLab;
}

@end
