//
//  DetailGoodUBNameCell.h
//  JRMedical
//
//  Created by a on 16/12/23.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailGoodUBNameCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *ubLab;
@property (weak, nonatomic) IBOutlet UIButton *shouChangBtn;
@property (weak, nonatomic) IBOutlet UILabel *shouChangLab;

@property (nonatomic, strong) NSDictionary *dataDic;

@end
