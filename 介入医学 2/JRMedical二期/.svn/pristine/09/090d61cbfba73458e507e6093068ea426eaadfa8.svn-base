//
//  OrderPriceInfoCell.m
//  JRMedical
//
//  Created by a on 16/12/23.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "OrderPriceInfoCell.h"

@implementation OrderPriceInfoCell

- (void)setDataDic:(NSDictionary *)dataDic {
    
    _dataDic = dataDic;
    
    if ([self.dataDic[@"PayTypeName"] isEqualToString:@"U币兑换"]) {
        self.priceLab.text = [NSString stringWithFormat:@"%ldU币",[dataDic[@"PayUAmount"] integerValue]];
    }
    else {
        self.priceLab.text = [NSString stringWithFormat:@"¥%@",dataDic[@"PayMoneyAmount"]];
    }
    
    CGSize size = [Utils sizeForTitle:self.priceLab.text withFont:[UIFont boldSystemFontOfSize:16]];
    self.pricesWidth.constant = size.width+10;
    
    self.timeLab.text = [NSString stringWithFormat:@"下单时间 : %@",dataDic[@"OrderTime"]];
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
