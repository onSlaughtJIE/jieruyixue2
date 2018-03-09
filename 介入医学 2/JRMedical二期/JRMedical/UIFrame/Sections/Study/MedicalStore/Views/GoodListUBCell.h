//
//  GoodListUBCell.h
//  JRMedical
//
//  Created by a on 16/12/23.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MerchandiseListModel.h"

@interface GoodListUBCell : UITableViewCell

@property (nonatomic, strong) MerchandiseListModel *model;

@property (weak, nonatomic) IBOutlet UIImageView *pictureImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *ubLab;
@property (weak, nonatomic) IBOutlet UILabel *pingJiaLab;
@property (weak, nonatomic) IBOutlet UILabel *liuLanLab;

@end
