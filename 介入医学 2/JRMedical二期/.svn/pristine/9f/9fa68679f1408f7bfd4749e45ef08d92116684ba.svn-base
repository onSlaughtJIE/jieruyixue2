//
//  BottomCollectionViewCell.m
//  JRMedical
//
//  Created by ww on 16/11/15.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "BottomCollectionViewCell.h"

@implementation BottomCollectionViewCell

-(void)setModel:(MerchandiseListModel *)model {
    _model = model;
    
    [self.pictureImg sd_setImageWithURL:[NSURL URLWithString:model.Pic] placeholderImage:[UIImage imageNamed:@"jiazai"]];
    
//    if (model.UPrice == 0) {
//        self.priceUB.hidden = YES;
//        self.ubImg.hidden = YES;
//    }
//    else {
//        self.priceUB.text = [NSString stringWithFormat:@"%ld币",(long)model.UPrice];
//    }
    
    self.priceLab.text = [NSString stringWithFormat:@"¥%.2f",model.PromotionPrice];
    self.titleLab.text = model.Name;
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
}

- (IBAction)gouWuCheCliak:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectRowDelectClick:)]) {
        [self.delegate selectRowDelectClick:self.indexPath];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
