//
//  AllCategoryHeaderView.m
//  JRMedical
//
//  Created by a on 16/11/14.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "AllCategoryHeaderView.h"

@implementation AllCategoryHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        if (!_titleLab) {
            _titleLab = [UILabel new];
            _titleLab.font = [UIFont boldSystemFontOfSize:17.0];
            _titleLab.textColor = Main_Color;
        }
        [self addSubview:self.titleLab];
        self.titleLab.sd_layout.leftSpaceToView(self,40).widthIs(70).heightIs(30).centerYEqualToView(self);
    }
    return self;
}

@end
