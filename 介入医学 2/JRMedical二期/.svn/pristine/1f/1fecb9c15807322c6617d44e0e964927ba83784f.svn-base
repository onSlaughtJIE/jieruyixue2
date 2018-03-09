//
//  OrderFaPiaoCell.m
//  JRMedical
//
//  Created by a on 16/12/23.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import "OrderFaPiaoCell.h"

@implementation OrderFaPiaoCell

- (void)setDataDic:(NSDictionary *)dataDic {
    
    _dataDic = dataDic;
    
    if ([dataDic[@"IsInvoice"] integerValue] == 0) {
        self.faPiaoType.text = @"未开发票";
        self.faPiaoType.textColor = [UIColor lightGrayColor];
    }
    else {
        if ([dataDic[@"InvoiceType"] integerValue] == 0) {
            self.faPiaoType2.text = @"发票类型 : 个人";
        }
        else {
            self.faPiaoType2.text = @"发票类型 : 公司";
        }
        
        self.faPiaoHeader.text = [NSString stringWithFormat:@"发票抬头 : %@",dataDic[@"InvoiceHeader"]];
        self.faPiaoContant.text = [NSString stringWithFormat:@"发票内容 : %@",dataDic[@"InvoiceDetail"]];
    }
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
