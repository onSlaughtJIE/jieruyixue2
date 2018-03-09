//
//  TopNewsCell.h
//  JRMedical
//
//  Created by a on 16/12/7.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewestPostModel.h"

@interface TopNewsCell : UITableViewCell

@property (nonatomic, strong) NewestPostModel *model;

@property (nonatomic, strong) UILabel *topLab;
@property (nonatomic, strong) UILabel *titleLab;

@end
