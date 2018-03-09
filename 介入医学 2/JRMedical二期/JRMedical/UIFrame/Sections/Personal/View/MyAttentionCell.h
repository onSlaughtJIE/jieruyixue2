//
//  MyAttentionCell.h
//  JRMedical
//
//  Created by a on 16/11/11.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyAttentionModel.h"

@interface MyAttentionCell : UITableViewCell

@property (nonatomic, strong) MyAttentionModel *model;

@property (nonatomic, strong) UIImageView *photoImg;
@property (nonatomic, strong) UIImageView *photoCornerImg;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *levelLab;
@property (nonatomic, strong) UILabel *categoryLab;
@property (nonatomic, strong) UILabel *hospitalNameLab;
@property (nonatomic, strong) UILabel *hospitaLevelLab;
@property (nonatomic, strong) UIView *hospitaLevelView;

@end
