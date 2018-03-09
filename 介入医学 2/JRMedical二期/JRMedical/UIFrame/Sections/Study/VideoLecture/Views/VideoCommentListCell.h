//
//  VideoCommentListCell.h
//  JRMedical
//
//  Created by a on 16/11/17.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpCommentModel.h"

@interface VideoCommentListCell : UITableViewCell

@property (nonatomic, strong) SpCommentModel *model;

@property (nonatomic, strong) UIImageView *photoImg;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *contentLab;

@end
