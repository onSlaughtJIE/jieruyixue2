//
//  HomeExchangeCCell.m
//  JRMedical
//
//  Created by a on 16/12/5.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "HomeExchangeCCell.h"
#import "MerchandiseListModel.h"

@implementation HomeExchangeCCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        
        [self.contentView addSubview:self.horizonScroll];
        self.horizonScroll.sd_layout.widthIs(Width_Screen).heightIs(140);
        
    }
    return self;
}

- (void)setModelAry:(NSMutableArray *)modelAry {
    _modelAry = modelAry;
    
    self.horizonScroll.contentSize = CGSizeMake(modelAry.count * 130 + 10, 140);
    
    for(UIView *view in [self.horizonScroll subviews])
    {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i < modelAry.count; i++) {
        
        MerchandiseListModel *model = modelAry[i];
        
        _goodView = [TimeLimitGoodView shareTimeLimitGoodView];
        self.goodView.frame = CGRectMake(modelAry.count*(i+1)+120*i, 0, 120, 140);
        self.goodView.userInteractionEnabled = YES;
        
        [self.goodView bk_whenTapped:^{
            [self didSelectMtypeView:i];
        }];
        
        [self.goodView.pictureImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.Pic]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
        self.goodView.priceUB.text = [NSString stringWithFormat:@"%ld币",(long)model.UPrice];
        
        [self.horizonScroll addSubview:self.goodView];
    }
}

- (void)didSelectMtypeView:(NSInteger)typeNum {
    if (self.delegate != nil) {
        [self.delegate selectExchangeView:typeNum];
    }
}

- (UIScrollView *)horizonScroll {
    if (!_horizonScroll) {
        _horizonScroll = [UIScrollView new];
        _horizonScroll.showsHorizontalScrollIndicator = NO;
        _horizonScroll.backgroundColor = [UIColor whiteColor];
    }
    return _horizonScroll;
}

@end
