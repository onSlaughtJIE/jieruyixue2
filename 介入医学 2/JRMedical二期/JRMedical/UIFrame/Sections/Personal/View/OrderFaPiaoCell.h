//
//  OrderFaPiaoCell.h
//  JRMedical
//
//  Created by a on 16/12/23.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderFaPiaoCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *dataDic;

@property (weak, nonatomic) IBOutlet UILabel *faPiaoInfo;
@property (weak, nonatomic) IBOutlet UILabel *faPiaoType;
@property (weak, nonatomic) IBOutlet UILabel *faPiaoType2;
@property (weak, nonatomic) IBOutlet UILabel *faPiaoHeader;
@property (weak, nonatomic) IBOutlet UILabel *faPiaoContant;

@end
