//
//  HeaderCollectionReusableView.m
//  JRMedical
//
//  Created by ww on 16/11/15.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "HeaderCollectionReusableView.h"

@implementation HeaderCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.seperatorLab];
        [self addSubview:self.xianshiView];
    }
    return self;
}

- (UIImageView *)xianshiView {
    
    if (!_xianshiView) {
        self.xianshiView = [[UIImageView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(_seperatorLab.frame)+5, 100, 25)];
        _xianshiView.backgroundColor = [UIColor whiteColor];
        _xianshiView.image = [UIImage imageNamed:@"xianshiduihuan"];
    }
    return _xianshiView ;
}

- (UILabel *)seperatorLab {
    
    if (!_seperatorLab) {
        self.seperatorLab = [[UILabel alloc] initWithFrame:(CGRectMake(0, 0, self.bounds.size.width, 10))];
        self.seperatorLab.backgroundColor = BG_Color;
    }
    return _seperatorLab;
}

@end
