//
//  OrganizeCollectionCell.h
//  JRMedical
//
//  Created by ww on 2016/12/27.
//  Copyright © 2016年 idcby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrgDetailModel.h"

@interface OrganizeCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLab;

- (void)setOrganizeCollectionCellWithModel:(OrgDetailModel *)model;

@end
