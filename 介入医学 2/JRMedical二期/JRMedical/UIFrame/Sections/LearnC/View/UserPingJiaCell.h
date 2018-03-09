//
//  UserPingJiaCell.h
//  JRMedical
//
//  Created by a on 16/12/26.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpertPingJiaModel.h"

@interface UserPingJiaCell : UITableViewCell

@property (nonatomic, strong) ExpertPingJiaModel *model;

@property (nonatomic, strong) UIImageView *headerPhoto;
@property (nonatomic, strong) UIImageView *isRenZhengImg;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *laiYuanLab;
@property (nonatomic, strong) UILabel *xingHaoLab;
@property (nonatomic, strong) UILabel *contactLab;

@property (nonatomic, strong) NSIndexPath *indexPath;

@end
