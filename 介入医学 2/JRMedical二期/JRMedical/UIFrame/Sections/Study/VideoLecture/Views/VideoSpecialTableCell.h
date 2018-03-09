//
//  VideoSpecialTableCell.h
//  JRMedical
//
//  Created by a on 16/11/17.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoSpecialListModel.h"

@interface VideoSpecialTableCell : UITableViewCell

@property (nonatomic, strong) VideoSpecialListModel *model;

@property (nonatomic, strong) UIImageView *pictureImg;
//@property (nonatomic, strong) UILabel *typeLab;
@property (nonatomic, strong) UILabel *videoNumLab;
@property (nonatomic, strong) UILabel *titleLab;
//@property (nonatomic, strong) UILabel *sourceLab;
//@property (nonatomic, strong) UILabel *authorLab;
//@property (nonatomic, strong) UILabel *levelLab;
@property (nonatomic, strong) UIImageView *playNumImg;
@property (nonatomic, strong) UILabel *playNumLab;

@end
