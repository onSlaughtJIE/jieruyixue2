//
//  OrderPriceInfoCell.h
//  JRMedical
//
//  Created by a on 16/12/23.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderPriceInfoCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *dataDic;

@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pricesWidth;


@end
