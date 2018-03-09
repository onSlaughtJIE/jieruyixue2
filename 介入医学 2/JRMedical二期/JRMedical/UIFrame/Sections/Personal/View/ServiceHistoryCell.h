//
//  ServiceHistoryCell.h
//  JRMedical
//
//  Created by a on 16/12/26.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyAttentionModel.h"

@interface ServiceHistoryCell : UITableViewCell

@property (nonatomic, strong) MyAttentionModel *model;

@property (nonatomic, strong) UIImageView *photoImg;
@property (nonatomic, strong) UIImageView *photoCornerImg;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *levelLab;
@property (nonatomic, strong) UILabel *categoryLab;
@property (nonatomic, strong) UILabel *hospitalNameLab;
@property (nonatomic, strong) UILabel *hospitaLevelLab;
@property (nonatomic, strong) UIView *hospitaLevelView;

@property (nonatomic, strong) UIButton *pingJiaBtn;

@end
