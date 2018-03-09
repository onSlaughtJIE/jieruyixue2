//
//  EquipmentSuppliesCell.h
//  JRMedical
//
//  Created by a on 16/11/15.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EquipmentSuppliesListModel.h"

@interface EquipmentSuppliesCell : UITableViewCell

@property (nonatomic, strong) EquipmentSuppliesListModel *model;

@property (nonatomic, strong) UIImageView *pictureImg;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *contentLab;

@end
