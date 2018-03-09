//
//  MerchandiseTypeCell.m
//  JRMedical
//
//  Created by a on 16/12/5.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "MerchandiseTypeCell.h"
#import "MerchandiseTypeModel.h"

#define Type_Width (Width_Screen-304)/5

@implementation MerchandiseTypeCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];

        [self.contentView addSubview:self.leftImg];
        [self.contentView addSubview:self.rightImg];
        [self.contentView addSubview:self.horizonScroll];
        
        self.leftImg.sd_layout.leftSpaceToView(self.contentView,10).centerYEqualToView(self.contentView).widthIs(7).heightIs(12);
        self.rightImg.sd_layout.centerYEqualToView(self.contentView).rightSpaceToView(self.contentView,10).widthIs(7).heightIs(12);
        
        self.horizonScroll.sd_layout.leftSpaceToView(self.leftImg,Type_Width).rightSpaceToView(self.rightImg,Type_Width).heightIs(80);
    }
    return self;
}

- (void)setModelAry:(NSMutableArray *)modelAry {
    _modelAry = modelAry;
    
    self.horizonScroll.contentSize = CGSizeMake(modelAry.count * 65, 80);
    
    for(UIView *view in [self.horizonScroll subviews])
    {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i < modelAry.count; i++) {
        
        MerchandiseTypeModel *model = modelAry[i];
        
        _mtypeView  = [MerchandiseTypeView new];
        [self.horizonScroll addSubview:self.mtypeView];
        
        self.mtypeView.frame = CGRectMake(i*65 , 13, 60, 54);
        self.mtypeView.userInteractionEnabled = YES;
        
        [self.mtypeView bk_whenTapped:^{
            [self didSelectMtypeView:i];
        }];
        
        [self.mtypeView.pictureImg sd_setImageWithURL:[NSURL URLWithString:model.ImageUri] placeholderImage:[UIImage imageNamed:@"jiazai"]];
        self.mtypeView.titleLab.text = model.Name;
    }
}

- (void)didSelectMtypeView:(NSInteger)typeNum {
    if (self.delegate != nil) {
        [self.delegate selectTypeView:typeNum];
    }
}

#pragma mark - 懒加载
- (UIScrollView *)horizonScroll {
    if (!_horizonScroll) {
        _horizonScroll = [UIScrollView new];
        _horizonScroll.showsHorizontalScrollIndicator = NO;
    }
    return _horizonScroll;
}
- (UIImageView *)rightImg {
    if (!_rightImg) {
        _rightImg = [UIImageView new];
        _rightImg.image = [UIImage imageNamed:@"rightyou"];
    }
    return _rightImg;
}
- (UIImageView *)leftImg {
    if (!_leftImg) {
        _leftImg = [UIImageView new];
        _leftImg.image = [UIImage imageNamed:@"rightyou"];
        _leftImg.transform = CGAffineTransformMakeRotation(M_PI_2*2);
    }
    return _leftImg;
}

@end
