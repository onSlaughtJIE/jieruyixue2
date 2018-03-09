//
//  MyUBDetailedListCell.h
//  JRMedical
//
//  Created by a on 16/12/20.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyUBDetailedListModel.h"

@interface MyUBDetailedListCell : UITableViewCell

@property (nonatomic, strong) MyUBDetailedListModel *model;

@property (nonatomic, strong) UILabel *yearLab;
@property (nonatomic, strong) UILabel *monthLab;
@property (nonatomic, strong) UILabel *timeLab;

@property (nonatomic, strong) UIView *verticalLine;
@property (nonatomic, strong) UIView *circleView;

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *numLab;

@end
