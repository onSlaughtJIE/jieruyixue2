//
//  AllCategoryCollectionCell.m
//  JRMedical
//
//  Created by a on 16/11/14.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "AllCategoryCollectionCell.h"

@implementation AllCategoryCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.borderWidth = 0.5;
        self.contentView.layer.borderColor = RGB(210, 210, 210).CGColor;
        
        [self.contentView addSubview:self.titleLab];
        self.titleLab.sd_layout.widthIs(self.contentView.width).heightIs(self.contentView.height);
    }
    return self;
}

- (void)setDataDic:(NSDictionary *)dataDic {
    
    self.backgroundColor = [UIColor whiteColor];
    self.titleLab.textColor = [UIColor blackColor];
    
    _dataDic = dataDic;
    
    NSString *name = dataDic[@"Name"];
    
    if ([name isEqualToString:@""] || name == nil) {
        self.titleLab.text = dataDic[@"LableName"];;
    }
    else {
        self.titleLab.text = name;
    }
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
