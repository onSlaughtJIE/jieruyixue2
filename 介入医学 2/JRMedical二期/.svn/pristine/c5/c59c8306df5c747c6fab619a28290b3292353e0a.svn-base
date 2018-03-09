//
//  VideoDetailOtherInfoView.m
//  JRMedical
//
//  Created by a on 16/11/17.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "VideoDetailOtherInfoView.h"

@implementation VideoDetailOtherInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = BG_Color;
        
        self.layer.shadowColor = RGB(100, 100, 100).CGColor;//阴影颜色
        self.layer.shadowOffset = CGSizeMake(0 , 0);//偏移距离
        self.layer.shadowOpacity = 0.5;//不透明度
        self.layer.shadowRadius = 3.0;//半径
        
        [self initCellView];//初始化视图
    }
    return self;
}

#pragma mark - 初始化视图
- (void)initCellView {
    
    [self addSubview:self.relevantVideoLab];
    [self addSubview:self.commentLab];
    [self addSubview:self.isZhanKai];
    
    self.relevantVideoLab.sd_layout.leftSpaceToView(self,10).topSpaceToView(self,0).widthIs(78).heightIs(45);
    self.commentLab.sd_layout.leftSpaceToView(self.relevantVideoLab,0).topSpaceToView(self,0).widthIs(78).heightIs(45);
    
    self.isZhanKai.sd_layout.rightSpaceToView(self,20).centerYEqualToView(self).widthIs(23).heightIs(45);
}

#pragma mark - 懒加载
- (UILabel *)relevantVideoLab {
    if (!_relevantVideoLab) {
        _relevantVideoLab = [UILabel new];
        _relevantVideoLab.text = @"相关视频";
        _relevantVideoLab.userInteractionEnabled = YES;
        _relevantVideoLab.font = [UIFont boldSystemFontOfSize:14];
        _relevantVideoLab.textAlignment = NSTextAlignmentCenter;
        _relevantVideoLab.textColor = Main_Color;
    }
    return _relevantVideoLab;
}
- (UILabel *)commentLab {
    if (!_commentLab) {
        _commentLab = [UILabel new];
        _commentLab.font = [UIFont boldSystemFontOfSize:14];
        _commentLab.text = @"评论";
        _commentLab.userInteractionEnabled = YES;
        _commentLab.textAlignment = NSTextAlignmentCenter;
        _commentLab.textColor = [UIColor blackColor];
    }
    return _commentLab;
}
- (UIButton *)isZhanKai {
    if (!_isZhanKai) {
        _isZhanKai = [UIButton buttonWithType:UIButtonTypeSystem];
        [_isZhanKai setImage:[UIImage imageNamed:@"xialaxll"] forState:UIControlStateNormal];
        [_isZhanKai setTintColor:Main_Color];
        _isZhanKai.userInteractionEnabled = YES;
    }
    return _isZhanKai;
}

@end
