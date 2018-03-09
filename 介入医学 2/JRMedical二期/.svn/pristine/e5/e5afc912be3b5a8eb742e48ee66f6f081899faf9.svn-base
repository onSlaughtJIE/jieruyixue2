//
//  AuthorIntroduceView.m
//  JRMedical
//
//  Created by a on 16/11/21.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "AuthorIntroduceView.h"

@implementation AuthorIntroduceView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = BG_Color;
        
        self.layer.shadowColor = RGB(100, 100, 100).CGColor;//阴影颜色
        self.layer.shadowOffset = CGSizeMake(0 , 0);//偏移距离
        self.layer.shadowOpacity = 0.5;//不透明度
        self.layer.shadowRadius = 3.0;//半径

        [self initCellView];
    }
    return self;
}

- (void)setContentString:(NSString *)contentString {
    _contentString = contentString;
    
    if ([contentString isEqualToString:@""] || contentString == nil) {
        self.contentLab.text = @"暂无简介";
        self.contentLab.textAlignment = NSTextAlignmentCenter;
    }
    else {
        self.contentLab.text = [NSString stringWithFormat:@"        %@",contentString];
        self.contentLab.textAlignment = NSTextAlignmentLeft;
    }
}

#pragma mark - 初始化视图
- (void)initCellView {
    
    [self addSubview:self.contentLab];
    [self addSubview:self.xiaLaImg];
    
    self.xiaLaImg.sd_layout.centerXEqualToView(self).bottomSpaceToView(self,10).widthIs(13).heightIs(15);
    self.contentLab.sd_layout.leftSpaceToView(self,10).rightSpaceToView(self,10).topSpaceToView(self,10).bottomSpaceToView(self.xiaLaImg,10);
}

#pragma mark - 懒加载
- (UILabel *)contentLab {
    if (!_contentLab) {
        _contentLab = [UILabel new];
        _contentLab.font = [UIFont systemFontOfSize:14];
        _contentLab.textColor = RGB(90, 90, 90);
        _contentLab.numberOfLines = 0;
    }
    return _contentLab;
}
- (UIImageView *)xiaLaImg {
    if (!_xiaLaImg) {
        _xiaLaImg = [UIImageView new];
        _xiaLaImg.image = [UIImage imageNamed:@"shuangxia"];
    }
    return _xiaLaImg;
}

@end
