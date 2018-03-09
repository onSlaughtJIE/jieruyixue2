//
//  StudyVideoCell.h
//  JRMedical
//
//  Created by ww on 16/11/12.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicNewsListModel.h"

@interface StudyVideoCell : UITableViewCell

@property (nonatomic, strong) PublicNewsListModel *model;

@property (weak, nonatomic) IBOutlet UILabel *ZhiDingImg;
@property (weak, nonatomic) IBOutlet UIButton *isHotImg;
@property (weak, nonatomic) IBOutlet UILabel *laiYuanLab;
@property (weak, nonatomic) IBOutlet UILabel *pingLunLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *biaoTiLab;
@property (weak, nonatomic) IBOutlet UIImageView *Img;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *zhiDing;

@end
