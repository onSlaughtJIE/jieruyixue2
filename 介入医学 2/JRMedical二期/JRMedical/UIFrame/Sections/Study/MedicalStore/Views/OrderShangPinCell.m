//
//  OrderShangPinCell.m
//  JRMedical
//
//  Created by a on 16/12/19.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "OrderShangPinCell.h"

@implementation OrderShangPinCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        [self.contentView addSubview:self.numLab];
        [self.contentView addSubview:self.numScroll];
    }
    return self;
}

- (void)setDataAry:(NSMutableArray *)dataAry {
    _dataAry = dataAry;
    
    self.numLab.text = [NSString stringWithFormat:@"共%ld件",dataAry.count];
    
    CGSize numLabWidth  = [Utils sizeForTitle:self.numLab.text withFont:[UIFont systemFontOfSize:14]];
    
    self.numLab.sd_layout.centerYEqualToView(self.contentView).rightSpaceToView(self.contentView,15).widthIs(numLabWidth.width).heightIs(14);
    self.numScroll.sd_layout.centerYEqualToView(self.contentView).leftSpaceToView(self.contentView,15).rightSpaceToView(self.numLab,15).heightIs(90);
    
    self.numScroll.contentSize = CGSizeMake(dataAry.count * 85, 90);
    
    for(UIView *view in [self.numScroll subviews])
    {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i < dataAry.count; i++) {
        
        NSDictionary *dataDic = dataAry[i];
        
        UIImageView *image = [UIImageView new];
        image.frame = CGRectMake(i*5+ 80*i, 0, 80, 90);
        
        image.clipsToBounds = YES;
        image.contentMode = UIViewContentModeScaleAspectFill;
        image.layer.borderColor = RGB(180, 180, 180).CGColor;
        image.layer.cornerRadius = 3;
        image.layer.borderWidth = 0.4;
        
        [image sd_setImageWithURL:[NSURL URLWithString:dataDic[@"CommodityPic1"]] placeholderImage:[UIImage imageNamed:@"jiazai"]];
        [self.numScroll addSubview:image];
    }
}

- (UILabel *)numLab {
    if (!_numLab) {
        _numLab = [UILabel new];
        _numLab.textAlignment = NSTextAlignmentCenter;
        _numLab.font = [UIFont systemFontOfSize:14];
    }
    return _numLab;
}

- (UIScrollView *)numScroll {
    if (!_numScroll) {
        _numScroll = [UIScrollView new];
        _numScroll.showsHorizontalScrollIndicator = NO;
        _numScroll.backgroundColor = [UIColor whiteColor];
    }
    return _numScroll;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
