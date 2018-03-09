//
//  MedicalTypeCollectionCell.m
//  JRMedical
//
//  Created by a on 16/12/15.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "MedicalTypeCollectionCell.h"

@implementation MedicalTypeCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.clipsToBounds = YES;
        self.contentView.layer.borderWidth = 0.5;
        self.contentView.layer.borderColor = RGB(210, 210, 210).CGColor;
        
        self.layer.cornerRadius = 3;
        self.contentView.layer.cornerRadius = 10.0f;
        self.contentView.layer.borderWidth = 0.5f;
        self.contentView.layer.borderColor = [UIColor clearColor].CGColor;
        self.contentView.layer.masksToBounds = YES;
        
        self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowRadius = 3.0f;
        self.layer.shadowOpacity = 0.5f;
        self.layer.masksToBounds = NO;
        
        self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.contentView.layer.cornerRadius].CGPath;
        
        [self.contentView addSubview:self.titleLab];
        self.titleLab.sd_layout.leftSpaceToView(self.contentView,5).rightSpaceToView(self.contentView,5).heightIs(self.contentView.height);
    }
    return self;
}

- (void)setModel:(MerchandiseTypeModel *)model {
    
    self.backgroundColor = [UIColor whiteColor];
    self.titleLab.textColor = [UIColor blackColor];
    
    _model = model;
    
    self.titleLab.text = model.Name;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.text = @"";
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = [UIFont systemFontOfSize:14];
    }
    return _titleLab;
}

@end
